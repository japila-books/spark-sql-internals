# AggregateExpression &mdash; Unevaluable Expression Container for AggregateFunction

`AggregateExpression` is an [unevaluable expression](Unevaluable.md) that acts as a container for an [AggregateFunction](#aggregateFunction).

`AggregateExpression` contains the following:

* [[aggregateFunction]] [AggregateFunction](AggregateFunction.md)
* [[mode]] `AggregateMode`
* [[isDistinct]] `isDistinct` flag indicating whether this aggregation is distinct or not (e.g. whether SQL's `DISTINCT` keyword was used for the [aggregate function](#aggregateFunction))
* [[resultId]] `ExprId`

`AggregateExpression` is created when:

* `Analyzer` is requested to [resolve AggregateFunctions](../Analyzer.md#ResolveFunctions) (and creates an `AggregateExpression` with `Complete` aggregate mode for the functions)

* `UserDefinedAggregateFunction` is created with `isDistinct` flag [disabled](../UserDefinedAggregateFunction.md#apply) or [enabled](../UserDefinedAggregateFunction.md#distinct)

* `AggUtils` is requested to [planAggregateWithOneDistinct](../AggUtils.md#planAggregateWithOneDistinct) (and creates `AggregateExpressions` with `Partial` and `Final` aggregate modes for the functions)

* `Aggregator` is requested for a [TypedColumn](../TypedColumn.md) (using `Aggregator.toColumn`)

* `AggregateFunction` is spark-sql-Expression-AggregateFunction.md#toAggregateExpression[wrapped in a AggregateExpression]

[[toString-prefixes]]
.toString's Prefixes per AggregateMode
[cols="1,2",options="header",width="100%"]
|===
| Prefix
| AggregateMode

| `partial_`
| `Partial`

| `merge_`
| `PartialMerge`

| (empty)
| `Final` or `Complete`
|===

[[properties]]
.AggregateExpression's Properties
[width="100%",cols="1,2",options="header"]
|===
| Name
| Description

| `canonicalized`
| `AggregateExpression` with <<aggregateFunction, AggregateFunction>> expression `canonicalized` with the special `ExprId` as `0`.

| `children`
| <<aggregateFunction, AggregateFunction>> expression (for which `AggregateExpression` was created).

| `dataType`
| [DataType](../types/DataType.md) of [AggregateFunction](#aggregateFunction) expression

| `foldable`
| Disabled (i.e. `false`)

| `nullable`
| Whether or not <<aggregateFunction, AggregateFunction>> expression is nullable.

| [[references]] `references`
a| `AttributeSet` with the following:

* `references` of <<aggregateFunction, AggregateFunction>> when <<mode, AggregateMode>> is `Partial` or `Complete`

* spark-sql-Expression-AggregateFunction.md#aggBufferAttributes[aggBufferAttributes] of <<aggregateFunction, AggregateFunction>> when `PartialMerge` or `Final`

| `resultAttribute`
a|

spark-sql-Expression-Attribute.md[Attribute] that is:

* `AttributeReference` when <<aggregateFunction, AggregateFunction>> is itself resolved

* `UnresolvedAttribute` otherwise

| `sql`
| Requests <<aggregateFunction, AggregateFunction>> to generate SQL output (with <<isDistinct, isDistinct>> flag).

| `toString`
| <<toString-prefixes, Prefix per AggregateMode>> followed by <<aggregateFunction, AggregateFunction>>'s `toAggString` (with <<isDistinct, isDistinct>> flag).
|===
