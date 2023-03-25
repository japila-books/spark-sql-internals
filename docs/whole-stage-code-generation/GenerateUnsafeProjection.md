# GenerateUnsafeProjection

`GenerateUnsafeProjection` is a [CodeGenerator](CodeGenerator.md) to [generate the bytecode for creating an UnsafeProjection from the given Expressions](#create) (i.e. `CodeGenerator[Seq[Expression], UnsafeProjection]`).

```scala
GenerateUnsafeProjection: Seq[Expression] => UnsafeProjection
```

## <span id="bind"> Binding Expressions to Schema

```scala
bind(
  in: Seq[Expression],
  inputSchema: Seq[Attribute]): Seq[Expression]
```

`bind` [binds](#bindReferences) the given `in` expressions to the given `inputSchema`.

`bind` is part of the [CodeGenerator](CodeGenerator.md#bind) abstraction.

## <span id="create"> Creating UnsafeProjection (for Expressions)

```scala
create(
  references: Seq[Expression]): UnsafeProjection // (1)!
create(
  expressions: Seq[Expression],
  subexpressionEliminationEnabled: Boolean): UnsafeProjection
```

1. `subexpressionEliminationEnabled` flag is `false`

`create` [creates a new CodegenContext](CodeGenerator.md#newCodeGenContext).

`create`...FIXME

`create` is part of the [CodeGenerator](CodeGenerator.md#create) abstraction.

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.catalyst.expressions.codegen.GenerateUnsafeProjection` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
log4j.logger.org.apache.spark.sql.catalyst.expressions.codegen.GenerateUnsafeProjection=ALL
```

Refer to [Logging](../spark-logging.md).

## Review Me

=== [[generate]] Generating UnsafeProjection -- `generate` Method

[source, scala]
----
generate(
  expressions: Seq[Expression],
  subexpressionEliminationEnabled: Boolean): UnsafeProjection
----

`generate` <<canonicalize, canonicalize>> the input `expressions` followed by <<create, generating a JVM bytecode for a UnsafeProjection>> for the expressions.

`generate` is used when:

* `UnsafeProjection` factory object is requested for a [UnsafeProjection](../expressions/UnsafeProjection.md#create)

* `ExpressionEncoder` is requested to [initialize the internal UnsafeProjection](../ExpressionEncoder.md#extractProjection)

* `FileFormat` is requested to [build a data reader with partition column values appended](../datasources/FileFormat.md#buildReaderWithPartitionValues)

* `OrcFileFormat` is requested to `buildReaderWithPartitionValues`

* `ParquetFileFormat` is requested to [build a data reader with partition column values appended](../datasources/parquet/ParquetFileFormat.md#buildReaderWithPartitionValues)

* `GroupedIterator` is requested for `keyProjection`

* `ObjectOperator` is requested to `serializeObjectToRow`

* (Spark MLlib) `LibSVMFileFormat` is requested to `buildReader`

* (Spark Structured Streaming) `StateStoreRestoreExec`, `StateStoreSaveExec` and `StreamingDeduplicateExec` are requested to execute

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

`create` first creates a [CodegenContext](CodeGenerator.md#newCodeGenContext) and an <<createCode, Java source code>> for the input `expressions`.

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

`create` creates a `CodeAndComment` with the code body and [comment placeholders](CodegenContext.md#placeHolderToComments).

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

See [CodeGenerator](CodeGenerator.md#logging).
====

`create` requests `CodeGenerator` to [compile the Java source code to JVM bytecode (using Janino)](CodeGenerator.md#compile).

`create` requests `CodegenContext` for [references](CodegenContext.md#references) and requests the compiled class to create a `SpecificUnsafeProjection` for the input references that in the end is the final [UnsafeProjection](../expressions/UnsafeProjection.md).

(Single-argument) `create` is part of the [CodeGenerator](CodeGenerator.md#create) abstraction.

=== [[createCode]] Creating ExprCode for Expressions (With Optional Subexpression Elimination) -- `createCode` Method

[source, scala]
----
createCode(
  ctx: CodegenContext,
  expressions: Seq[Expression],
  useSubexprElimination: Boolean = false): ExprCode
----

`createCode` requests the input `CodegenContext` to [generate a Java source code for code-generated evaluation](CodegenContext.md#generateExpressions) of every expression in the input `expressions`.

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

`createCode` is used when:

* `CreateNamedStructUnsafe` is requested to generate a Java source code

* `GenerateUnsafeProjection` is requested to [create a UnsafeProjection](#create)

* `CodegenSupport` is requested to [prepareRowVar](../physical-operators/CodegenSupport.md#prepareRowVar) (to [generate a Java source code to consume generated columns or row from a physical operator](../physical-operators/CodegenSupport.md#consume))

* `HashAggregateExec` is requested to [doProduceWithKeys](../physical-operators/HashAggregateExec.md#doProduceWithKeys) and [doConsumeWithKeys](../physical-operators/HashAggregateExec.md#doConsumeWithKeys)

* `BroadcastHashJoinExec` is requested to [genStreamSideJoinKey](../physical-operators/BroadcastHashJoinExec.md#genStreamSideJoinKey) (when generating the Java source code for joins)
