# AdaptiveRulesHolder

`AdaptiveRulesHolder` holds the user-defined adaptive query rules for a [SessionState](../SessionState.md#adaptiveRulesHolder).

The user-defined AQE rules are defined using [SparkSessionExtensions](../SparkSessionExtensions.md) injections:

* [injectQueryStagePrepRule](../SparkSessionExtensions.md#injectQueryStagePrepRule)
* [injectRuntimeOptimizerRule](../SparkSessionExtensions.md#injectRuntimeOptimizerRule)
* [injectQueryStageOptimizerRule](../SparkSessionExtensions.md#injectQueryStageOptimizerRule)
* [injectQueryPostPlannerStrategyRule](../SparkSessionExtensions.md#injectQueryPostPlannerStrategyRule)

## Creating Instance

`AdaptiveRulesHolder` takes the following to be created:

* <span id="queryStagePrepRules"> Adaptive Query Stage Preparation [Rule](../catalyst/Rule.md)s
* <span id="runtimeOptimizerRules"> Adaptive Query Execution Runtime Optimizer [Rule](../catalyst/Rule.md)s
* <span id="queryStageOptimizerRules"> Adaptive Query Stage Optimizer [Rule](../catalyst/Rule.md)s
* <span id="queryPostPlannerStrategyRules"> Adaptive Query Post Planner Strategy [Rule](../catalyst/Rule.md)s

`AdaptiveRulesHolder` is created when:

* `BaseSessionStateBuilder` is requested for the [adaptive rules](../BaseSessionStateBuilder.md#adaptiveRulesHolder)
