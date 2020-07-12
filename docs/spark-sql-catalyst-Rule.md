# Rule -- Named Transformation of TreeNodes

`Rule` is a <<ruleName, named>> transformation that can be <<apply, applied>> to (i.e. _executed on_ or _transform_) a <<spark-sql-catalyst-TreeNode.adoc#, TreeNode>> to produce a new `TreeNode`.

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
NOTE: `TreeType` is the type of the <<spark-sql-catalyst-TreeNode.adoc#implementations, TreeNode implementation>> that a `Rule` can be <<apply, applied>> to, i.e. <<spark-sql-LogicalPlan.adoc#, LogicalPlan>>, [SparkPlan](physical-operators/SparkPlan.md) or <<spark-sql-Expression.adoc#, Expression>> or a combination thereof.

[[ruleName]]
`Rule` has a *rule name* (that is the class name of a rule).

[source, scala]
----
ruleName: String
----

`Rule` is mainly used to create a <<spark-sql-catalyst-RuleExecutor.adoc#Batch, batch of rules>> for a <<spark-sql-catalyst-RuleExecutor.adoc#batches, RuleExecutor>>.

The other notable use cases of `Rule` are as follows:

* [SparkSessionExtensions](SparkSessionExtensions.md)

* When `ExperimentalMethods` is requested for <<spark-sql-ExperimentalMethods.adoc#extraOptimizations, extraOptimizations>>

* When `BaseSessionStateBuilder` is requested for <<BaseSessionStateBuilder.md#customResolutionRules, customResolutionRules>>, <<BaseSessionStateBuilder.md#customPostHocResolutionRules, customPostHocResolutionRules>>, <<BaseSessionStateBuilder.md#customOperatorOptimizationRules, customOperatorOptimizationRules>>, and the <<BaseSessionStateBuilder.md#optimizer, Optimizer>>

* When `Analyzer` is requested for <<spark-sql-Analyzer.adoc#extendedResolutionRules, extendedResolutionRules>> and <<spark-sql-Analyzer.adoc#postHocResolutionRules, postHocResolutionRules>> (see <<BaseSessionStateBuilder.md#analyzer, BaseSessionStateBuilder>> and link:hive/HiveSessionStateBuilder.adoc#analyzer[HiveSessionStateBuilder])

* When `Optimizer` is requested for <<spark-sql-Optimizer.adoc#extendedOperatorOptimizationRules, extendedOperatorOptimizationRules>>

* When `QueryExecution` is requested for <<spark-sql-QueryExecution.adoc#preparations, preparations>>
