# TreePattern

`TreePattern`s are part of [TreeNode](TreeNode.md#node-patterns)s.

## <span id="CTE"> CTE

Used as a [node pattern](TreeNode.md#nodePatterns):

* [CTERelationDef](../logical-operators/CTERelationDef.md)
* [CTERelationRef](../logical-operators/CTERelationRef.md)
* [WithCTE](../logical-operators/WithCTE.md)

## <span id="DYNAMIC_PRUNING_EXPRESSION"> DYNAMIC_PRUNING_EXPRESSION

Used as a [node pattern](TreeNode.md#nodePatterns):

* [DynamicPruningExpression](../expressions/DynamicPruningExpression.md)

Used to transform query plans in the following rules:

* [PlanAdaptiveDynamicPruningFilters](../physical-optimizations/PlanAdaptiveDynamicPruningFilters.md)
* [CleanupDynamicPruningFilters](../logical-optimizations/CleanupDynamicPruningFilters.md)

## <span id="EXCHANGE"> EXCHANGE

Used as a [node pattern](TreeNode.md#nodePatterns):

* [Exchange](../physical-operators/Exchange.md)

Used to transform query plans in the following rules:

* [ReuseExchangeAndSubquery](../physical-optimizations/ReuseExchangeAndSubquery.md)

## <span id="PLAN_EXPRESSION"> PLAN_EXPRESSION

Used as a [node pattern](TreeNode.md#nodePatterns):

* [PlanExpression](../expressions/PlanExpression.md)

## <span id="UNRESOLVED_HINT"> UNRESOLVED_HINT

Used as a [node pattern](TreeNode.md#nodePatterns):

* [UnresolvedHint](../logical-operators/UnresolvedHint.md#nodePatterns)
