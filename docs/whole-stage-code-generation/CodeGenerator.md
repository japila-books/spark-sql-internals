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

* `ExpressionEncoder` for [UnsafeProjection](../ExpressionEncoder.md#extractProjection) (for serialization)

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

## <span id="newCodeGenContext"> Creating CodegenContext

```scala
newCodeGenContext(): CodegenContext
```

`newCodeGenContext` simply creates a new [CodegenContext](CodegenContext.md).

`newCodeGenContext` is used when:

* `GenerateMutableProjection` is requested to [create a MutableProjection](GenerateMutableProjection.md#create)

* `GenerateOrdering` is requested to [create a BaseOrdering](GenerateOrdering.md#create)

* `GeneratePredicate` is requested to [create a Predicate](GeneratePredicate.md#create)

* `GenerateSafeProjection` is requested to [create a Projection](GenerateSafeProjection.md#create)

* `GenerateUnsafeProjection` is requested to [create a UnsafeProjection](GenerateUnsafeProjection.md#create)

* `GenerateColumnAccessor` is requested to [create a ColumnarIterator](GenerateColumnAccessor.md#create)
