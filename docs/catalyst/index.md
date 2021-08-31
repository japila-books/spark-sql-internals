# Catalyst Tree Manipulation Framework

**Catalyst** is an execution-agnostic framework to represent and manipulate a **dataflow graph** as [trees](TreeNode.md) of [relational operators](QueryPlan.md) and [expressions](../expressions/Expression.md).

The Catalyst framework was introduced in [[SPARK-1251] Support for optimizing and executing structured queries](https://issues.apache.org/jira/browse/SPARK-1251).

Spark SQL uses the Catalyst framework to build an extensible [Optimizer](Optimizer.md) with a number of built-in [logical query plan optimizations](Optimizer.md#defaultBatches).

Catalyst supports both rule-based and cost-based optimizations.
