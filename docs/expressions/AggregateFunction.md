title: AggregateFunction

# AggregateFunction -- Aggregate Function Expressions

`AggregateFunction` is the <<contract, contract>> for [Catalyst expressions](Expression.md) that represent *aggregate functions*.

`AggregateFunction` is used wrapped inside a [AggregateExpression](AggregateExpression.md) (using <<toAggregateExpression, toAggregateExpression>> method) when:

* `Analyzer` link:spark-sql-Analyzer.adoc#ResolveFunctions[resolves functions] (for link:SparkSession.md#sql[SQL mode])

* ...FIXME: Anywhere else?

[source, scala]
----
import org.apache.spark.sql.functions.collect_list
scala> val fn = collect_list("gid")
fn: org.apache.spark.sql.Column = collect_list(gid)

import org.apache.spark.sql.catalyst.expressions.aggregate.AggregateExpression
scala> val aggFn = fn.expr.asInstanceOf[AggregateExpression].aggregateFunction
aggFn: org.apache.spark.sql.catalyst.expressions.aggregate.AggregateFunction = collect_list('gid, 0, 0)

scala> println(aggFn.numberedTreeString)
00 collect_list('gid, 0, 0)
01 +- 'gid
----

NOTE: Aggregate functions are not [foldable](Expression.md#foldable), i.e. FIXME

[[top-level-expressions]]
.AggregateFunction Top-Level Catalyst Expressions
[cols="1,1,2",options="header",width="100%"]
|===
| Name
| Behaviour
| Examples

| [[DeclarativeAggregate]] link:spark-sql-Expression-DeclarativeAggregate.adoc[DeclarativeAggregate]
|
|

| [[ImperativeAggregate]] link:spark-sql-Expression-ImperativeAggregate.adoc[ImperativeAggregate]
|
|

| [[TypedAggregateExpression]] link:spark-sql-Expression-TypedAggregateExpression.adoc[TypedAggregateExpression]
|
|
|===

=== [[contract]] AggregateFunction Contract

[source, scala]
----
abstract class AggregateFunction extends Expression {
  def aggBufferSchema: StructType
  def aggBufferAttributes: Seq[AttributeReference]
  def inputAggBufferAttributes: Seq[AttributeReference]
  def defaultResult: Option[Literal] = None
}
----

.AggregateFunction Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| [[aggBufferSchema]] `aggBufferSchema`
| link:spark-sql-StructType.adoc[Schema] of an aggregation buffer to hold partial aggregate results.

Used mostly in link:spark-sql-Expression-ScalaUDAF.adoc[ScalaUDAF] and link:spark-sql-AggregationIterator.adoc#initializeAggregateFunctions[AggregationIterator]

| [[aggBufferAttributes]] `aggBufferAttributes`
a| <<spark-sql-Expression-AttributeReference.adoc#, AttributeReferences>> of an aggregation buffer to hold partial aggregate results.

Used in:

* `AggregateExpression` for [references](AggregateExpression.md#references)
* ``Expression``-based aggregate's `bufferSchema` in link:spark-sql-Expression-DeclarativeAggregate.adoc[DeclarativeAggregate]
* ...

| [[inputAggBufferAttributes]] `inputAggBufferAttributes`
|

| [[defaultResult]] `defaultResult`
| Defaults to `None`.

|===

=== [[toAggregateExpression]] Creating AggregateExpression for AggregateFunction -- `toAggregateExpression` Method

```scala
toAggregateExpression(): AggregateExpression  // <1>
toAggregateExpression(isDistinct: Boolean): AggregateExpression
```
<1> Calls the other `toAggregateExpression` with `isDistinct` disabled (i.e. `false`)

`toAggregateExpression` creates a [AggregateExpression](AggregateExpression.md) for the current `AggregateFunction` with `Complete` aggregate mode.

`toAggregateExpression` is used in:

* `functions` object's `withAggregateFunction` block to create a link:spark-sql-Column.adoc[Column] with [AggregateExpression](AggregateExpression.md) for a `AggregateFunction`
* FIXME
