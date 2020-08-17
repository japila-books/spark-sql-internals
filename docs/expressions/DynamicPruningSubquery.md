# DynamicPruningSubquery Unevaluable Subquery Expression

`DynamicPruningSubquery` is a [SubqueryExpression](SubqueryExpression.md) and a `DynamicPruning` predicate expression.

`DynamicPruningSubquery` is an [unevaluable expression](Unevaluable.md).

`DynamicPruningSubquery` is used by `PlanDynamicPruningFilters` physical optimization.

## Creating Instance

`DynamicPruningSubquery` takes the following to be created:

* <span id="pruningKey"> Pruning Key [Expression](Expression.md)
* <span id="buildQuery"> Build Query [LogicalPlan](../logical-operators/LogicalPlan.md)
* <span id="buildKeys"> Build Keys [Expression](Expression.md)s
* <span id="broadcastKeyIndex"> Broadcast Key Index
* <span id="onlyInBroadcast"> `onlyInBroadcast` Flag
* <span id="exprId"> `ExprId` (default: `NamedExpression.newExprId`)

`DynamicPruningSubquery` is created when [PartitionPruning](../logical-optimizations/PartitionPruning.md) logical optimization is executed.

## <span id="toString"> Textual Representation

```scala
toString: String
```

`toString` uses the [exprId](#exprId) and [conditionString](PlanExpression.md#conditionString) to build a textual representation:

```text
dynamicpruning#[exprId] [conditionString]
```
