title: Generator

# Generator -- Expressions to Generate Zero Or More Rows (aka Lateral Views)

`Generator` is a <<contract, contract>> for expressions/Expression.md[Catalyst expressions] that can <<eval, produce>> zero or more rows given a single input row.

NOTE: `Generator` corresponds to SQL's spark-sql-AstBuilder.md#withGenerate[LATERAL VIEW].

[[dataType]]
`dataType` in `Generator` is simply an spark-sql-DataType.md#ArrayType[ArrayType] of <<elementSchema, elementSchema>>.

[[foldable]]
[[nullable]]
`Generator` is not expressions/Expression.md#foldable[foldable] and not expressions/Expression.md#nullable[nullable] by default.

[[supportCodegen]]
`Generator` supports spark-sql-whole-stage-codegen.md[Java code generation] (aka _whole-stage codegen_) conditionally, i.e. only when a physical operator is not marked as expressions/Expression.md#CodegenFallback[CodegenFallback].

[[terminate]]
`Generator` uses `terminate` to inform that there are no more rows to process, clean up code, and additional rows can be made here.

[source, scala]
----
terminate(): TraversableOnce[InternalRow] = Nil
----

[[generator-implementations]]
.Generators
[width="100%",cols="1,2",options="header"]
|===
| Name
| Description

| [[CollectionGenerator]] spark-sql-Expression-CollectionGenerator.md[CollectionGenerator]
|

| [[ExplodeBase]] spark-sql-Expression-ExplodeBase.md[ExplodeBase]
|

| [[Explode]] spark-sql-Expression-ExplodeBase.md#Explode[Explode]
|

| [[GeneratorOuter]] `GeneratorOuter`
|

| [[HiveGenericUDTF]] `HiveGenericUDTF`
|

| [[Inline]] spark-sql-Expression-Inline.md[Inline]
| Corresponds to `inline` and `inline_outer` functions.

| [[JsonTuple]] spark-sql-Expression-JsonTuple.md[JsonTuple]
|

| [[PosExplode]] spark-sql-Expression-ExplodeBase.md#PosExplode[PosExplode]
|

| [[Stack]] spark-sql-Expression-Stack.md[Stack]
|

| [[UnresolvedGenerator]] spark-sql-Expression-UnresolvedGenerator.md[UnresolvedGenerator]
a| Represents an unresolved <<Generator, generator>>.

Created when `AstBuilder` spark-sql-AstBuilder.md#withGenerate[creates] `Generate` unary logical operator for `LATERAL VIEW` that corresponds to the following:

```
LATERAL VIEW (OUTER)?
generatorFunctionName (arg1, arg2, ...)
tblName
AS? col1, col2, ...
```

NOTE: `UnresolvedGenerator` is spark-sql-Analyzer.md#ResolveFunctions[resolved] to `Generator` by spark-sql-Analyzer.md#ResolveFunctions[ResolveFunctions] logical evaluation rule.

| [[UserDefinedGenerator]] `UserDefinedGenerator`
| Used exclusively in the deprecated `explode` operator
|===

[[lateral-view]]
[NOTE]
====
You can only have one generator per select clause that is enforced by spark-sql-Analyzer.md#ExtractGenerator[ExtractGenerator] logical evaluation rule, e.g.

```
scala> xys.select(explode($"xs"), explode($"ys")).show
org.apache.spark.sql.AnalysisException: Only one generator allowed per select clause but found 2: explode(xs), explode(ys);
  at org.apache.spark.sql.catalyst.analysis.Analyzer$ExtractGenerator$$anonfun$apply$20.applyOrElse(Analyzer.scala:1670)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$ExtractGenerator$$anonfun$apply$20.applyOrElse(Analyzer.scala:1662)
  at org.apache.spark.sql.catalyst.plans.logical.LogicalPlan$$anonfun$resolveOperators$1.apply(LogicalPlan.scala:62)
```

If you want to have more than one generator in a structured query you should use `LATERAL VIEW` which is supported in SQL only, e.g.

[source, scala]
----
val arrayTuple = (Array(1,2,3), Array("a","b","c"))
val ncs = Seq(arrayTuple).toDF("ns", "cs")

scala> ncs.show
+---------+---------+
|       ns|       cs|
+---------+---------+
|[1, 2, 3]|[a, b, c]|
+---------+---------+

scala> ncs.createOrReplaceTempView("ncs")

val q = """
  SELECT n, c FROM ncs
  LATERAL VIEW explode(ns) nsExpl AS n
  LATERAL VIEW explode(cs) csExpl AS c
"""

scala> sql(q).show
+---+---+
|  n|  c|
+---+---+
|  1|  a|
|  1|  b|
|  1|  c|
|  2|  a|
|  2|  b|
|  2|  c|
|  3|  a|
|  3|  b|
|  3|  c|
+---+---+
----
====

=== [[contract]] Generator Contract

[source, scala]
----
package org.apache.spark.sql.catalyst.expressions

trait Generator extends Expression {
  // only required methods that have no implementation
  def elementSchema: StructType
  def eval(input: InternalRow): TraversableOnce[InternalRow]
}
----

.(Subset of) Generator Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| [[elementSchema]] `elementSchema`
| spark-sql-StructType.md[Schema] of the elements to be generated

| [[eval]] `eval`
|
|===
