title: DeclarativeAggregate

# DeclarativeAggregate -- Unevaluable Aggregate Function Expressions

`DeclarativeAggregate` is an <<contract, extension>> of the <<spark-sql-Expression-AggregateFunction.md#, AggregateFunction Contract>> for <<implementations, aggregate function expressions>> that are [unevaluable](Unevaluable.md) and use expressions for evaluation.

[[contract]]
.DeclarativeAggregate Contract
[cols="1m,2",options="header",width="100%"]
|===
| Property
| Description

| evaluateExpression
a| [[evaluateExpression]]

[source, scala]
----
evaluateExpression: Expression
----

The <<Expression.md#, expression>> that returns the final value for the aggregate function

Used when:

* `AggregationIterator` is requested for the [generateResultProjection](../spark-sql-AggregationIterator.md#generateResultProjection)

* `HashAggregateExec` physical operator is requested to [doProduceWithoutKeys](../physical-operators/HashAggregateExec.md#doProduceWithoutKeys) and [generateResultFunction](../physical-operators/HashAggregateExec.md#generateResultFunction)

* `AggregateProcessor` is [created](../physical-operators/AggregateProcessor.md#apply) (when `WindowExec` physical operator is <<WindowExec.md#, executed>>)

| initialValues
a| [[initialValues]]

[source, scala]
----
initialValues: Seq[Expression]
----

| mergeExpressions
a| [[mergeExpressions]]

[source, scala]
----
mergeExpressions: Seq[Expression]
----

| updateExpressions
a| [[updateExpressions]]

[source, scala]
----
updateExpressions: Seq[Expression]
----

|===

[[extensions]]
.DeclarativeAggregates (Direct Implementations)
[cols="1,2",options="header",width="100%"]
|===
| DeclarativeAggregate
| Description

| <<spark-sql-Expression-AggregateWindowFunction.md#, AggregateWindowFunction>>
| [[AggregateWindowFunction]] Contract for declarative window aggregate function expressions

| Average
| [[Average]]

| CentralMomentAgg
| [[CentralMomentAgg]]

| Corr
| [[Corr]]

| Count
| [[Count]]

| Covariance
| [[Covariance]]

| <<spark-sql-Expression-First.md#, First>>
| [[First]]

| Last
| [[Last]]

| Max
| [[Max]]

| Min
| [[Min]]

| <<spark-sql-Expression-SimpleTypedAggregateExpression.md#, SimpleTypedAggregateExpression>>
| [[SimpleTypedAggregateExpression]]

| Sum
| [[Sum]]
|===
