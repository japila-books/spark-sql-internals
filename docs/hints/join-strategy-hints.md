# Join Strategy Hints

**Join Strategy Hints** extend the existing BROADCAST join hint with other join strategy hints for shuffle-hash, sort-merge, cartesian-product.

Join Strategy Hints were introduced to Apache Spark 3.0.0 as [SPARK-27225](https://issues.apache.org/jira/browse/SPARK-27225).

Main abstractions:

* [JoinStrategyHint](JoinStrategyHint.md)
* [ResolveJoinStrategyHints](../logical-analysis-rules/ResolveJoinStrategyHints.md) logical resolution rule
