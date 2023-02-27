# DynamicPruningExpression Unary Expression

`DynamicPruningExpression` is a [UnaryExpression](UnaryExpression.md) and a `DynamicPruning` predicate expression.

`DynamicPruningExpression` delegates [interpreted](UnaryExpression.md#eval) and [code-generated](Expression.md#doGenCode) expression evaluation to the [child](#child) expression.

## Creating Instance

`DynamicPruningExpression` takes the following to be created:

* <span id="child"> Child [expression](Expression.md)

`DynamicPruningExpression` is created when the following physical optimizations are executed:

* [PlanAdaptiveDynamicPruningFilters](../physical-optimizations/PlanAdaptiveDynamicPruningFilters.md)
* [PlanAdaptiveSubqueries](../physical-optimizations/PlanAdaptiveSubqueries.md)
* [PlanDynamicPruningFilters](../physical-optimizations/PlanDynamicPruningFilters.md)

## <span id="nodePatterns"> Node Patterns

??? note "Signature"

    ```scala
    nodePatterns: Seq[TreePattern]
    ```

    `nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.

`nodePatterns` is [DYNAMIC_PRUNING_EXPRESSION](../catalyst/TreePattern.md#DYNAMIC_PRUNING_EXPRESSION).

## Query Planning

* [PlanAdaptiveDynamicPruningFilters](../physical-optimizations/PlanAdaptiveDynamicPruningFilters.md)