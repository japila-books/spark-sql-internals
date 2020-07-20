# Catalyst Tree Manipulation Framework

**Catalyst** is an execution-agnostic framework to represent and manipulate a **dataflow graph** as [trees](TreeNode.md) of [relational operators](QueryPlan.md) and [expressions](../expressions/Expression.md).

!!! note
    The Catalyst framework was introduced in [[SPARK-1251] Support for optimizing and executing structured queries](https://issues.apache.org/jira/browse/SPARK-1251) (and became part of Apache Spark on 20/Mar/14).

Spark 2.0 uses the Catalyst tree manipulation framework to build an extensible **query plan optimizer** with a number of query optimizations.

Catalyst supports both rule-based and cost-based optimizations.
