title: TypedAggregateExpression

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

* `TypedColumn` is requested to spark-sql-TypedColumn.md#withInputType[withInputType] (for spark-sql-dataset-operators.md#select[Dataset.select], spark-sql-KeyValueGroupedDataset.md#agg[KeyValueGroupedDataset.agg] and spark-sql-RelationalGroupedDataset.md#agg[RelationalGroupedDataset.agg] operators)

* `Column` is requested to spark-sql-Column.md#generateAlias[generateAlias] and spark-sql-Column.md#named[named] (for spark-sql-dataset-operators.md#select[Dataset.select] and spark-sql-KeyValueGroupedDataset.md#agg[KeyValueGroupedDataset.agg] operators)

* `RelationalGroupedDataset` is requested to spark-sql-RelationalGroupedDataset.md#alias[alias] (when `RelationalGroupedDataset` is requested to spark-sql-RelationalGroupedDataset.md#toDF[create a DataFrame from aggregate expressions])

.TypedAggregateExpression Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| [[aggregator]] `aggregator`
| spark-sql-Aggregator.md[Aggregator]

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

NOTE: `apply` is used exclusively when `Aggregator` is requested to spark-sql-Aggregator.md#toColumn[convert itself to a TypedColumn].
