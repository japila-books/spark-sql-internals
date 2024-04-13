# TreePattern

`TreePattern`s are part of [TreeNode](TreeNode.md#node-patterns)s.

## CTE { #CTE }

Used as a [node pattern](TreeNode.md#nodePatterns):

* [CTERelationDef](../logical-operators/CTERelationDef.md)
* [CTERelationRef](../logical-operators/CTERelationRef.md)
* [WithCTE](../logical-operators/WithCTE.md)

## DYNAMIC_PRUNING_EXPRESSION { #DYNAMIC_PRUNING_EXPRESSION }

Used as a [node pattern](TreeNode.md#nodePatterns):

* [DynamicPruningExpression](../expressions/DynamicPruningExpression.md)

Used to transform query plans in the following rules:

* [PlanAdaptiveDynamicPruningFilters](../physical-optimizations/PlanAdaptiveDynamicPruningFilters.md)
* [CleanupDynamicPruningFilters](../logical-optimizations/CleanupDynamicPruningFilters.md)

## EXCHANGE { #EXCHANGE }

Used as a [node pattern](TreeNode.md#nodePatterns):

* [Exchange](../physical-operators/Exchange.md)

Used to transform query plans in the following rules:

* [ReuseExchangeAndSubquery](../physical-optimizations/ReuseExchangeAndSubquery.md)

## PARAMETERIZED_QUERY { #PARAMETERIZED_QUERY }

Used as a [node pattern](TreeNode.md#nodePatterns):

* [ParameterizedQuery](../logical-operators/ParameterizedQuery.md)

Used in the following rules:

* [BindParameters](../logical-analysis-rules/BindParameters.md)

## PLAN_EXPRESSION { #PLAN_EXPRESSION }

Used as a [node pattern](TreeNode.md#nodePatterns):

* [PlanExpression](../expressions/PlanExpression.md)

## UNRESOLVED_HINT { #UNRESOLVED_HINT }

Used as a [node pattern](TreeNode.md#nodePatterns):

* [UnresolvedHint](../logical-operators/UnresolvedHint.md#nodePatterns)

## UNRESOLVED_TABLE_VALUED_FUNCTION { #UNRESOLVED_TABLE_VALUED_FUNCTION }

Used as a [node pattern](TreeNode.md#nodePatterns) by the following logical operators:

* [UnresolvedTableValuedFunction](../logical-operators/UnresolvedTableValuedFunction.md#nodePatterns)

Used in the following rules:

* [ResolveFunctions](../logical-analysis-rules/ResolveFunctions.md) logical analysis rule
