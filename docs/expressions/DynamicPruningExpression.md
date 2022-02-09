# DynamicPruningExpression Unary Expression

`DynamicPruningExpression` is a [UnaryExpression](UnaryExpression.md) and a `DynamicPruning` predicate expression.

`DynamicPruningExpression` delegates [interpreted](UnaryExpression.md#eval) and [code-generated](Expression.md#doGenCode) expression evaluation to the [child](#child) expression.

## Creating Instance

`DynamicPruningExpression` takes the following to be created:

* <span id="child"> Child [expression](Expression.md)

`DynamicPruningExpression` is created when:

* [PlanAdaptiveDynamicPruningFilters](../physical-optimizations/PlanAdaptiveDynamicPruningFilters.md) physical optimization is executed
* [PlanAdaptiveSubqueries](../physical-optimizations/PlanAdaptiveSubqueries.md) physical optimization is executed
* [PlanDynamicPruningFilters](../physical-optimizations/PlanDynamicPruningFilters.md) physical optimization is executed

## <span id="nodePatterns"> Node Patterns

```scala
nodePatterns: Seq[TreePattern]
```

`nodePatterns` is [DYNAMIC_PRUNING_EXPRESSION](../catalyst/TreePattern.md#DYNAMIC_PRUNING_EXPRESSION).

`nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.

## Query Planning

* [PlanAdaptiveDynamicPruningFilters](../physical-optimizations/PlanAdaptiveDynamicPruningFilters.md)