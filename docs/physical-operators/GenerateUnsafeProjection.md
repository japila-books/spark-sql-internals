# GenerateUnsafeProjection

`GenerateUnsafeProjection` is a spark-sql-CodeGenerator.md[CodeGenerator] that <<create, generates the bytecode for a UnsafeProjection for given expressions>> (i.e. `CodeGenerator[Seq[Expression], UnsafeProjection]`).

[source, scala]
----
GenerateUnsafeProjection: Seq[Expression] => UnsafeProjection
----

[TIP]
====
Enable `DEBUG` logging level for `org.apache.spark.sql.catalyst.expressions.codegen.GenerateUnsafeProjection` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.catalyst.expressions.codegen.GenerateUnsafeProjection=DEBUG
```

Refer to spark-logging.md[Logging].
====

=== [[generate]] Generating UnsafeProjection -- `generate` Method

[source, scala]
----
generate(
  expressions: Seq[Expression],
  subexpressionEliminationEnabled: Boolean): UnsafeProjection
----

`generate` <<canonicalize, canonicalize>> the input `expressions` followed by <<create, generating a JVM bytecode for a UnsafeProjection>> for the expressions.

[NOTE]
====
`generate` is used when:

* `UnsafeProjection` factory object is requested for a spark-sql-UnsafeProjection.md#create[UnsafeProjection]

* `ExpressionEncoder` is requested to spark-sql-ExpressionEncoder.md#extractProjection[initialize the internal UnsafeProjection]

* `FileFormat` is requested to [build a data reader with partition column values appended](../FileFormat.md#buildReaderWithPartitionValues)

* `OrcFileFormat` is requested to [build a data reader with partition column values appended](../OrcFileFormat.md#buildReaderWithPartitionValues)

* `ParquetFileFormat` is requested to [build a data reader with partition column values appended](../ParquetFileFormat.md#buildReaderWithPartitionValues)

* `GroupedIterator` is requested for `keyProjection`

* `ObjectOperator` is requested to `serializeObjectToRow`

* (Spark MLlib) `LibSVMFileFormat` is requested to `buildReader`

* (Spark Structured Streaming) `StateStoreRestoreExec`, `StateStoreSaveExec` and `StreamingDeduplicateExec` are requested to execute
====

=== [[canonicalize]] `canonicalize` Method

[source, scala]
----
canonicalize(in: Seq[Expression]): Seq[Expression]
----

`canonicalize` removes unnecessary `Alias` expressions.

Internally, `canonicalize` uses `ExpressionCanonicalizer` rule executor (that in turn uses just one `CleanExpressions` expression rule).

=== [[create]] Generating JVM Bytecode For UnsafeProjection For Given Expressions (With Optional Subexpression Elimination) -- `create` Method

[source, scala]
----
create(
  expressions: Seq[Expression],
  subexpressionEliminationEnabled: Boolean): UnsafeProjection
create(references: Seq[Expression]): UnsafeProjection // <1>
----
<1> Calls the former `create` with `subexpressionEliminationEnabled` flag off

`create` first creates a spark-sql-CodeGenerator.md#newCodeGenContext[CodegenContext] and an <<createCode, Java source code>> for the input `expressions`.

`create` creates a code body with `public java.lang.Object generate(Object[] references)` method that creates a `SpecificUnsafeProjection`.

[source, java]
----
public java.lang.Object generate(Object[] references) {
  return new SpecificUnsafeProjection(references);
}

class SpecificUnsafeProjection extends UnsafeProjection {
  ...
}
----

`create` creates a `CodeAndComment` with the code body and spark-sql-CodegenContext.md#placeHolderToComments[comment placeholders].

You should see the following DEBUG message in the logs:

```
DEBUG GenerateUnsafeProjection: code for [expressions]:
[code]
```

[TIP]
====
Enable `DEBUG` logging level for `org.apache.spark.sql.catalyst.expressions.codegen.CodeGenerator` logger to see the message above.

```
log4j.logger.org.apache.spark.sql.catalyst.expressions.codegen.CodeGenerator=DEBUG
```

See spark-sql-CodeGenerator.md#logging[CodeGenerator].
====

`create` requests `CodeGenerator` to spark-sql-CodeGenerator.md#compile[compile the Java source code to JVM bytecode (using Janino)].

`create` requests `CodegenContext` for spark-sql-CodegenContext.md#references[references] and requests the compiled class to create a `SpecificUnsafeProjection` for the input references that in the end is the final spark-sql-UnsafeProjection.md[UnsafeProjection].

NOTE: (Single-argument) `create` is part of spark-sql-CodeGenerator.md#create[CodeGenerator Contract].

=== [[createCode]] Creating ExprCode for Expressions (With Optional Subexpression Elimination) -- `createCode` Method

[source, scala]
----
createCode(
  ctx: CodegenContext,
  expressions: Seq[Expression],
  useSubexprElimination: Boolean = false): ExprCode
----

`createCode` requests the input `CodegenContext` to spark-sql-CodegenContext.md#generateExpressions[generate a Java source code for code-generated evaluation] of every expression in the input `expressions`.

`createCode`...FIXME

[source, scala]
----
import org.apache.spark.sql.catalyst.expressions.codegen.CodegenContext
val ctx = new CodegenContext

// Use Catalyst DSL
import org.apache.spark.sql.catalyst.dsl.expressions._
val expressions = "hello".expr.as("world") :: "hello".expr.as("world") :: Nil

import org.apache.spark.sql.catalyst.expressions.codegen.GenerateUnsafeProjection
val eval = GenerateUnsafeProjection.createCode(ctx, expressions, useSubexprElimination = true)

scala> println(eval.code)

        mutableStateArray1[0].reset();

        mutableStateArray2[0].write(0, ((UTF8String) references[0] /* literal */));


            mutableStateArray2[0].write(1, ((UTF8String) references[1] /* literal */));
        mutableStateArray[0].setTotalSize(mutableStateArray1[0].totalSize());


scala> println(eval.value)
mutableStateArray[0]
----

[NOTE]
====
`createCode` is used when:

* `CreateNamedStructUnsafe` is requested to spark-sql-Expression-CreateNamedStructUnsafe.md#doGenCode[generate a Java source code]

* `GenerateUnsafeProjection` is requested to <<create, create a UnsafeProjection>>

* `CodegenSupport` is requested to [prepareRowVar](CodegenSupport.md#prepareRowVar) (to [generate a Java source code to consume generated columns or row from a physical operator](CodegenSupport.md#consume))

* `HashAggregateExec` is requested to spark-sql-SparkPlan-HashAggregateExec.md#doProduceWithKeys[doProduceWithKeys] and spark-sql-SparkPlan-HashAggregateExec.md#doConsumeWithKeys[doConsumeWithKeys]

* `BroadcastHashJoinExec` is requested to spark-sql-SparkPlan-BroadcastHashJoinExec.md#genStreamSideJoinKey[genStreamSideJoinKey] (when generating the Java source code for joins)
====
