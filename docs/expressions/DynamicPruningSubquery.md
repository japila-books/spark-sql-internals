# DynamicPruningSubquery Unevaluable Subquery Unary Expression

`DynamicPruningSubquery` is a [SubqueryExpression](SubqueryExpression.md) and a `DynamicPruning` predicate expression.

`DynamicPruningSubquery` is an [Unevaluable](Unevaluable.md) expression.

`DynamicPruningSubquery` is used in the following logical and physical optimizations:

* [InjectRuntimeFilter](../logical-optimizations/InjectRuntimeFilter.md#hasDynamicPruningSubquery) logical optimization
* [InsertAdaptiveSparkPlan](../physical-optimizations/InsertAdaptiveSparkPlan.md#buildSubqueryMap) physical optimization
* [PlanDynamicPruningFilters](../physical-optimizations/PlanDynamicPruningFilters.md#buildSubqueryMap) physical optimization

## Creating Instance

`DynamicPruningSubquery` takes the following to be created:

* <span id="pruningKey"> Pruning Key [Expression](Expression.md)
* <span id="buildQuery"> Build Query [LogicalPlan](../logical-operators/LogicalPlan.md)
* <span id="buildKeys"> Build Keys [Expression](Expression.md)s
* <span id="broadcastKeyIndex"> Broadcast Key Index
* <span id="onlyInBroadcast"> `onlyInBroadcast` Flag
* <span id="exprId"> `ExprId` (default: `NamedExpression.newExprId`)

`DynamicPruningSubquery` is created when:

* [PartitionPruning](../logical-optimizations/PartitionPruning.md) logical optimization is [executed](../logical-optimizations/PartitionPruning.md#insertPredicate)

## Adaptive Query Planning

`DynamicPruningSubquery` is planned as [DynamicPruningExpression](DynamicPruningExpression.md) (with [InSubqueryExec](InSubqueryExec.md) child expression) in [PlanAdaptiveSubqueries](../physical-optimizations/PlanAdaptiveSubqueries.md) physical optimization.

## <span id="toString"> Textual Representation

```scala
toString: String
```

`toString` uses the [exprId](#exprId) and [conditionString](PlanExpression.md#conditionString) to build a textual representation:

```text
dynamicpruning#[exprId] [conditionString]
```
