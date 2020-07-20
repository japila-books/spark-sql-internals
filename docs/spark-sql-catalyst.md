# Catalyst Tree Manipulation Framework

**Catalyst** is an execution-agnostic framework to represent and manipulate a **dataflow graph** as trees of [relational operators](spark-sql-catalyst-QueryPlan.md) and [expressions](expressions/Expression.md).

!!! note
    The Catalyst framework were first introduced in [SPARK-1251 Support for optimizing and executing structured queries](https://issues.apache.org/jira/browse/SPARK-1251) and became part of Apache Spark on 20/Mar/14 19:12.

The main abstraction in Catalyst is [TreeNode](catalyst/TreeNode.md) that is then used to build trees of [Expressions](expressions/Expression.md) or [QueryPlans](spark-sql-catalyst-QueryPlan.md).

Spark 2.0 uses the Catalyst tree manipulation framework to build an extensible **query plan optimizer** with a number of query optimizations.

Catalyst supports both rule-based and cost-based optimizations.
