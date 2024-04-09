# AggregateExpression

`AggregateExpression` is an [unevaluable expression](Unevaluable.md) that acts as a container (_wrapper_) for an [AggregateFunction](#aggregateFunction).

## Creating Instance

`AggregateExpression` takes the following to be created:

* <span id="aggregateFunction"> [AggregateFunction](AggregateFunction.md)
* [AggregateMode](#mode)
* <span id="isDistinct"> `isDistinct` flag
* [Aggregate Filter Expression](#filter)
* <span id="resultId"> Result `ExprId`

`AggregateExpression` is created using [apply](#apply) utility.

### Aggregate Filter Expression { #filter }

`AggregateExpression` can be given an [Expression](Expression.md) for an aggregate filter.

The filter is assumed undefined by default when `AggregateExpression` is [created](#apply).

A filter is used in [Partial](#Partial) and [Complete](#Complete) modes only (cf. [AggUtils](../aggregations/AggUtils.md#mayRemoveAggFilters)).

`AggregationIterator` initializes predicates with `AggregateExpression`s with filters when requested to [generateProcessRow](../aggregations/AggregationIterator.md#generateProcessRow).

## AggregateMode { #mode }

`AggregateExpression` is given an `AggregateMode` when [created](#creating-instance).

* For `PartialMerge` or `Final` modes, the input to the [AggregateFunction](#aggregateFunction) is [immutable input aggregation buffers](AggregateFunction.md#inputAggBufferAttributes), and the actual children of the `AggregateFunction` are not used

* [AggregateExpression](../aggregations/AggregationIterator.md#aggregateExpressions)s of an [AggregationIterator](../aggregations/AggregationIterator.md) cannot have more than 2 distinct modes nor the modes be among `Partial` and `PartialMerge` or `Final` and `Complete` mode pairs

* `Partial` and `Complete` or `PartialMerge` and `Final` pairs are supported

### Complete { #Complete }

No prefix (in [toString](#toString))

Used when:

* `ObjectAggregationIterator` is requested for the [mergeAggregationBuffers](../aggregations/ObjectAggregationIterator.md#mergeAggregationBuffers)
* `TungstenAggregationIterator` is requested for the [switchToSortBasedAggregation](../aggregations/TungstenAggregationIterator.md#switchToSortBasedAggregation)
* _others_

### Final { #Final }

No prefix (in [toString](#toString))

### Partial { #Partial }

* Partial aggregation
* `partial_` prefix (in [toString](#toString))

### PartialMerge { #PartialMerge }

* `merge_` prefix (in [toString](#toString))

## Creating AggregateExpression { #apply }

```scala
apply(
  aggregateFunction: AggregateFunction,
  mode: AggregateMode,
  isDistinct: Boolean,
  filter: Option[Expression] = None): AggregateExpression
```

`apply` creates an [AggregateExpression](#creating-instance) with an auto-generated `ExprId`.

---

`apply` is used when:

* `AggregateFunction` is requested to [toAggregateExpression](AggregateFunction.md#toAggregateExpression)
* `AggUtils` is requested to [planAggregateWithOneDistinct](../aggregations/AggUtils.md#planAggregateWithOneDistinct)

## Human-Friendly Textual Representation { #toString }

```scala
toString: String
```

`toString` returns the following text:

```text
[prefix][name]([args]) FILTER (WHERE [predicate])
```

`toString` converts the [mode](#mode) to a prefix.

mode | prefix
-----|----------
 [Partial](#Partial) | `partial_`
 [PartialMerge](#PartialMerge) | `merge_`
 [Final](#Final) or [Complete](#Complete) | (empty)

`toString` requests the [AggregateFunction](#aggregateFunction) for the [toAggString](AggregateFunction.md#toAggString) (with the [isDistinct](#isDistinct) flag).

In the end, `toString` adds `FILTER (WHERE [predicate])` based on the optional [filter](#filter) expression.

<!---
## Review Me

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
-->
