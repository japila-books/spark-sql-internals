# Rule

`Rule` is an [abstraction](#contract) of [named transformations](#ruleName) of [TreeNode](TreeNode.md)s.

`Rule` can be [executed](#apply) on a `TreeNode` to produce a new `TreeNode`.

`Rule` is primarily used to create a [batch of rules](RuleExecutor.md#Batch) for a [RuleExecutor](RuleExecutor.md#batches).

## TreeType

`Rule` is a Scala abstract class constructor (_generic class_) with `TreeType` type that is a subtype of [TreeNode](TreeNode.md) (e.g. [LogicalPlan](../logical-operators/LogicalPlan.md), [SparkPlan](../physical-operators/SparkPlan.md), [Expression](../expressions/Expression.md)).

```scala
abstract class Rule[TreeType <: TreeNode[_]]
```

## Contract

### <span id="apply"> Executing Rule

```scala
apply(
  plan: TreeType): TreeType
```

Applies the rule to a [TreeType](#treetype)

Used when:

* `QueryExecution` utility is used to [prepareForExecution](../QueryExecution.md#prepareForExecution)
* `AdaptiveSparkPlanExec` utility is used to [applyPhysicalRules](../physical-operators/AdaptiveSparkPlanExec.md#applyPhysicalRules)

## <span id="ruleName"> Name

```scala
ruleName: String
```

`ruleName` is the name of a rule that is a class name with no ending `$` (that Scala generates for objects).

## Notable Use Cases

The other notable use cases of `Rule` are as follows:

* [SparkSessionExtensions](../SparkSessionExtensions.md)

* When `ExperimentalMethods` is requested for [extraOptimizations](../ExperimentalMethods.md#extraOptimizations)

* When `BaseSessionStateBuilder` is requested for [customResolutionRules](../BaseSessionStateBuilder.md#customResolutionRules), [customPostHocResolutionRules](../BaseSessionStateBuilder.md#customPostHocResolutionRules), [customOperatorOptimizationRules](../BaseSessionStateBuilder.md#customOperatorOptimizationRules), and the [Optimizer](../BaseSessionStateBuilder.md#optimizer)

* When `Analyzer` is requested for [extendedResolutionRules](../Analyzer.md#extendedResolutionRules) and [postHocResolutionRules](../Analyzer.md#postHocResolutionRules) (see [BaseSessionStateBuilder](../BaseSessionStateBuilder.md#analyzer) and [HiveSessionStateBuilder](../hive/HiveSessionStateBuilder.md#analyzer))

* When `Optimizer` is requested for [extendedOperatorOptimizationRules](Optimizer.md#extendedOperatorOptimizationRules)

* When `QueryExecution` is requested for [preparations](../QueryExecution.md#preparations)
