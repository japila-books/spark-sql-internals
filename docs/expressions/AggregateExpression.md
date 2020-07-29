title: AggregateExpression

# AggregateExpression -- Unevaluable Expression Container for AggregateFunction

`AggregateExpression` is an expressions/Expression.md#Unevaluable[unevaluable expression] (i.e. with no support for `eval` and `doGenCode` methods) that acts as a container for an <<aggregateFunction, AggregateFunction>>.

`AggregateExpression` contains the following:

* [[aggregateFunction]] <<spark-sql-Expression-AggregateFunction.md#, AggregateFunction>>
* [[mode]] `AggregateMode`
* [[isDistinct]] `isDistinct` flag indicating whether this aggregation is distinct or not (e.g. whether SQL's `DISTINCT` keyword was used for the <<aggregateFunction, aggregate function>>)
* [[resultId]] `ExprId`

`AggregateExpression` is created when:

* `Analyzer` is requested to [resolve AggregateFunctions](../Analyzer.md#ResolveFunctions) (and creates an `AggregateExpression` with `Complete` aggregate mode for the functions)

* `UserDefinedAggregateFunction` is created with `isDistinct` flag spark-sql-UserDefinedAggregateFunction.md#apply[disabled] or spark-sql-UserDefinedAggregateFunction.md#distinct[enabled]

* `AggUtils` is requested to <<spark-sql-AggUtils.md#planAggregateWithOneDistinct, planAggregateWithOneDistinct>> (and creates `AggregateExpressions` with `Partial` and `Final` aggregate modes for the functions)

* `Aggregator` is requested for a spark-sql-TypedColumn.md[TypedColumn] (using `Aggregator.toColumn`)

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
| spark-sql-DataType.md[DataType] of <<aggregateFunction, AggregateFunction>> expression

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

link:spark-sql-Expression-Attribute.md[Attribute] that is:

* `AttributeReference` when <<aggregateFunction, AggregateFunction>> is itself resolved

* `UnresolvedAttribute` otherwise

| `sql`
| Requests <<aggregateFunction, AggregateFunction>> to generate SQL output (with <<isDistinct, isDistinct>> flag).

| `toString`
| <<toString-prefixes, Prefix per AggregateMode>> followed by <<aggregateFunction, AggregateFunction>>'s `toAggString` (with <<isDistinct, isDistinct>> flag).
|===
