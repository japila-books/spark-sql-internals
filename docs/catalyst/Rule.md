# Rule -- Named Transformation of TreeNodes

`Rule` is a <<ruleName, named>> transformation that can be <<apply, applied>> to (i.e. _executed on_ or _transform_) a [TreeNode](TreeNode.md) to produce a new `TreeNode`.

[[apply]]
[[contract]]
[source, scala]
----
package org.apache.spark.sql.catalyst.rules

abstract class Rule[TreeType <: TreeNode[_]] {
  // only required properties (vals and methods) that have no implementation
  // the others follow
  def apply(plan: TreeType): TreeType
}
----

[[TreeType]]
NOTE: `TreeType` is the type of the [TreeNode](TreeNode.md#implementations) implementation that a `Rule` can be <<apply, applied>> to, i.e. <<spark-sql-LogicalPlan.md#, LogicalPlan>>, [SparkPlan](../physical-operators/SparkPlan.md) or <<expressions/Expression.md#, Expression>> or a combination thereof.

[[ruleName]]
`Rule` has a *rule name* (that is the class name of a rule).

[source, scala]
----
ruleName: String
----

`Rule` is mainly used to create a <<catalyst/RuleExecutor.md#Batch, batch of rules>> for a <<catalyst/RuleExecutor.md#batches, RuleExecutor>>.

The other notable use cases of `Rule` are as follows:

* [SparkSessionExtensions](../SparkSessionExtensions.md)

* When `ExperimentalMethods` is requested for <<spark-sql-ExperimentalMethods.md#extraOptimizations, extraOptimizations>>

* When `BaseSessionStateBuilder` is requested for <<BaseSessionStateBuilder.md#customResolutionRules, customResolutionRules>>, <<BaseSessionStateBuilder.md#customPostHocResolutionRules, customPostHocResolutionRules>>, <<BaseSessionStateBuilder.md#customOperatorOptimizationRules, customOperatorOptimizationRules>>, and the <<BaseSessionStateBuilder.md#optimizer, Optimizer>>

* When `Analyzer` is requested for [extendedResolutionRules](../Analyzer.md#extendedResolutionRules) and [postHocResolutionRules](../Analyzer.md#postHocResolutionRules) (see [BaseSessionStateBuilder](../BaseSessionStateBuilder.md#analyzer) and [HiveSessionStateBuilder](../hive/HiveSessionStateBuilder.md#analyzer))

* When `Optimizer` is requested for [extendedOperatorOptimizationRules](Optimizer.md#extendedOperatorOptimizationRules)

* When `QueryExecution` is requested for [preparations](../QueryExecution.md#preparations)
