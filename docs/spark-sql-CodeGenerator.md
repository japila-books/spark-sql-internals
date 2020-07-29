# CodeGenerator

`CodeGenerator` is a base class for generators of JVM bytecode for expression evaluation.

[[internal-properties]]
.CodeGenerator's Internal Properties
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| [[cache]] `cache`
| Guava's https://google.github.io/guava/releases/19.0/api/docs/com/google/common/cache/LoadingCache.html[LoadingCache] with at most 100 pairs of `CodeAndComment` and `GeneratedClass`.

| [[genericMutableRowType]] `genericMutableRowType`
|
|===

[[logging]]
[TIP]
====
Enable `INFO` or `DEBUG` logging level for `org.apache.spark.sql.catalyst.expressions.codegen.CodeGenerator` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.catalyst.expressions.codegen.CodeGenerator=DEBUG
```

Refer to spark-logging.md[Logging].
====

=== [[contract]] CodeGenerator Contract

[source, scala]
----
package org.apache.spark.sql.catalyst.expressions.codegen

abstract class CodeGenerator[InType, OutType] {
  def create(in: InType): OutType
  def canonicalize(in: InType): InType
  def bind(in: InType, inputSchema: Seq[Attribute]): InType
  def generate(expressions: InType, inputSchema: Seq[Attribute]): OutType
  def generate(expressions: InType): OutType
}
----

.CodeGenerator Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| [[generate]] `generate`
a| Generates an evaluator for expression(s) that may (optionally) have expression(s) bound to a schema (i.e. a collection of spark-sql-Expression-Attribute.md[Attribute]).

Used in:

* `ExpressionEncoder` for spark-sql-ExpressionEncoder.md#extractProjection[UnsafeProjection] (for serialization)

|===

=== [[doCompile]] Compiling Java Source Code using Janino -- `doCompile` Internal Method

CAUTION: FIXME

=== [[compile]] Finding or Compiling Java Source Code -- `compile` Method

CAUTION: FIXME

=== [[create]] `create` Method

[source, scala]
----
create(references: Seq[Expression]): UnsafeProjection
----

CAUTION: FIXME

[NOTE]
====
`create` is used when:

* `CodeGenerator` <<generate, generates an expression evaluator>>
* `GenerateOrdering` creates a code gen ordering for `SortOrder` expressions
====

=== [[newCodeGenContext]] Creating CodegenContext -- `newCodeGenContext` Method

[source, scala]
----
newCodeGenContext(): CodegenContext
----

`newCodeGenContext` simply creates a new spark-sql-CodegenContext.md#creating-instance[CodegenContext].

[NOTE]
====
`newCodeGenContext` is used when:

* `GenerateMutableProjection` is requested to spark-sql-GenerateMutableProjection.md#create[create a MutableProjection]

* `GenerateOrdering` is requested to spark-sql-GenerateOrdering.md#create[create a BaseOrdering]

* `GeneratePredicate` is requested to spark-sql-GeneratePredicate.md#create[create a Predicate]

* `GenerateSafeProjection` is requested to spark-sql-GenerateSafeProjection.md#create[create a Projection]

* `GenerateUnsafeProjection` is requested to spark-sql-GenerateUnsafeProjection.md#create[create a UnsafeProjection]

* `GenerateColumnAccessor` is requested to spark-sql-GenerateColumnAccessor.md#create[create a ColumnarIterator]
====
