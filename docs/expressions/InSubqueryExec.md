# InSubqueryExec Expression

`InSubqueryExec` is a [ExecSubqueryExpression](ExecSubqueryExpression.md) that represents [InSubquery](InSubquery.md) and [DynamicPruningSubquery](DynamicPruningSubquery.md) expressions at execution time.

## Creating Instance

`InSubqueryExec` takes the following to be created:

* <span id="child"> Child [Expression](Expression.md)
* <span id="plan"> [BaseSubqueryExec](../physical-operators/BaseSubqueryExec.md) physical operator
* <span id="exprId"> Expression ID
* [Broadcast Variable](#resultBroadcast)

`InSubqueryExec` is created when:

* [PlanSubqueries](../physical-optimizations/PlanSubqueries.md) physical optimization is executed (and plans [InSubquery](InSubquery.md) expressions)
* [PlanAdaptiveSubqueries](../physical-optimizations/PlanAdaptiveSubqueries.md) physical optimization is executed (and plans [InSubquery](InSubquery.md) expressions)
* [PlanDynamicPruningFilters](../physical-optimizations/PlanDynamicPruningFilters.md) physical optimization is executed (and plans [DynamicPruningSubquery](DynamicPruningSubquery.md) expressions)

## Broadcasted Result

<span id="resultBroadcast">
```scala
resultBroadcast: Broadcast[Array[Any]]
```

`InSubqueryExec` is given a broadcast variable when [created](#creating-instance). It is uninitialized (`null`).

`resultBroadcast` is updated when `InSubqueryExec` is requested to [update the collected result](#updateResult).

## Interpreted Expression Evaluation

<span id="eval">
```scala
eval(
  input: InternalRow): Any
```

`eval` [prepareResult](#prepareResult).

`eval` requests the [child](#child) expression to [evaluate](Expression.md#eval) for the given [InternalRow](../spark-sql-InternalRow.md).

`eval` returns:

* `null` for `null` evaluation result
* `true` when the [result](#result) contains the evaluation result or `false`

`eval` is part of the [Expression](Expression.md#eval) abstraction.

## Code-Generated Expression Evaluation

<span id="doGenCode">
```scala
doGenCode(
  ctx: CodegenContext,
  ev: ExprCode): ExprCode
```

`doGenCode` [prepareResult](#prepareResult).

`doGenCode` creates a [InSet](InSet.md) expression (with the [child](#child) expression and [result](#result)) and requests it to [doGenCode](Expression.md#doGenCode).

`doGenCode` is part of the [Expression](Expression.md#doGenCode) abstraction.

## Updating Result

<span id="updateResult">
```scala
updateResult(): Unit
```

`updateResult` requests the [BaseSubqueryExec](#plan) to [executeCollect](../physical-operators/SparkPlan.md#executeCollect).

`updateResult` uses the collected result to update the [result](#result) and [resultBroadcast](#resultBroadcast) registries.

`updateResult` is part of the [ExecSubqueryExpression](ExecSubqueryExpression.md#updateResult) abstraction.

## result Internal Registry

<span id="result">
```scala
result: Array[Any]
```

`result`...FIXME

## prepareResult Internal Method

<span id="prepareResult">
```scala
prepareResult(): Unit
```

`prepareResult` simply requests the [resultBroadcast](#resultBroadcast) broadcast variable for the broadcasted value when [result](#result) is undefined (`null`). Otherwise, `prepareResult` does nothing.

`prepareResult` throws an `IllegalArgumentException` when [resultBroadcast](#resultBroadcast) is undefined (`null`):

```text
[this] has not finished
```

`prepareResult` is used when `InSubqueryExec` expression is evaluated ([interpreted](#eval) or [code-generated](#doGenCode)).
