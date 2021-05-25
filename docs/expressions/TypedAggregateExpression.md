# TypedAggregateExpression Expression

`TypedAggregateExpression` is the <<contract, contract>> for spark-sql-Expression-AggregateFunction.md[AggregateFunction] expressions that...FIXME

[[contract]]
[source, scala]
----
package org.apache.spark.sql.execution.aggregate

trait TypedAggregateExpression extends AggregateFunction {
  // only required methods that have no implementation
  def aggregator: Aggregator[Any, Any, Any]
  def inputClass: Option[Class[_]]
  def inputDeserializer: Option[Expression]
  def inputSchema: Option[StructType]
  def withInputInfo(deser: Expression, cls: Class[_], schema: StructType): TypedAggregateExpression
}
----

`TypedAggregateExpression` is used when:

* `TypedColumn` is requested to [withInputType](../TypedColumn.md#withInputType) (for [Dataset.select](../spark-sql-dataset-operators.md#select), [KeyValueGroupedDataset.agg](../KeyValueGroupedDataset.md#agg) and [RelationalGroupedDataset.agg](../RelationalGroupedDataset.md#agg) operators)

* `Column` is requested to [generateAlias](../Column.md#generateAlias) and [named](../Column.md#named) (for [Dataset.select](../spark-sql-dataset-operators.md#select) and [KeyValueGroupedDataset.agg](../KeyValueGroupedDataset.md#agg) operators)

* `RelationalGroupedDataset` is requested to [alias](../RelationalGroupedDataset.md#alias) (when `RelationalGroupedDataset` is requested to [create a DataFrame from aggregate expressions](../RelationalGroupedDataset.md#toDF))

.TypedAggregateExpression Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| [[aggregator]] `aggregator`
| [Aggregator](Aggregator.md)

| [[inputClass]] `inputClass`
| Used when...FIXME

| [[inputDeserializer]] `inputDeserializer`
| Used when...FIXME

| [[inputSchema]] `inputSchema`
| Used when...FIXME

| [[withInputInfo]] `withInputInfo`
| Used when...FIXME
|===

[[implementations]]
.TypedAggregateExpressions
[cols="1,2",options="header",width="100%"]
|===
| Aggregator
| Description

| [[ComplexTypedAggregateExpression]] spark-sql-Expression-ComplexTypedAggregateExpression.md[ComplexTypedAggregateExpression]
|

| [[SimpleTypedAggregateExpression]] spark-sql-Expression-SimpleTypedAggregateExpression.md[SimpleTypedAggregateExpression]
|
|===

=== [[apply]] Creating TypedAggregateExpression -- `apply` Factory Method

[source, scala]
----
apply[BUF : Encoder, OUT : Encoder](
  aggregator: Aggregator[_, BUF, OUT]): TypedAggregateExpression
----

`apply`...FIXME

`apply` is used when `Aggregator` is requested to [convert itself to a TypedColumn](Aggregator.md#toColumn).
