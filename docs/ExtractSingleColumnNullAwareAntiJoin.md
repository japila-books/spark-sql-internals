# ExtractSingleColumnNullAwareAntiJoin Scala Extractor

`ExtractSingleColumnNullAwareAntiJoin` is a Scala extractor to [destructure a Join logical operator](#unapply) into a tuple of the following elements:

1. Streamed Side Keys ([Catalyst expression](expressions/Expression.md)s)
1. Build Side Keys ([Catalyst expression](expressions/Expression.md)s)

`ExtractSingleColumnNullAwareAntiJoin` is used to support single-column NULL-aware anti joins (described in the [VLDB paper](http://www.vldb.org/pvldb/vol2/vldb09-423.pdf)) that will almost certainly be planned as a very time-consuming [Broadcast Nested Loop join](physical-operators/BroadcastNestedLoopJoinExec.md) (`O(M*N)` calculation). If it's a single column case this expensive calculation could be optimized into `O(M)` using hash lookup instead of loop lookup. Refer to [SPARK-32290](https://issues.apache.org/jira/browse/SPARK-32290).

## <span id="spark.sql.optimizeNullAwareAntiJoin"> spark.sql.optimizeNullAwareAntiJoin

`ExtractSingleColumnNullAwareAntiJoin` uses the [spark.sql.optimizeNullAwareAntiJoin](configuration-properties.md#spark.sql.optimizeNullAwareAntiJoin) configuration property.

## <span id="unapply"> Destructuring Join Logical Plan

```scala
type ReturnType =
// streamedSideKeys, buildSideKeys
  (Seq[Expression], Seq[Expression])

unapply(
  join: Join): Option[ReturnType]
```

`unapply` matches [Join](logical-operators/Join.md) logical operators with [LeftAnti](joins.md#joinType) join type and the following condition:

```text
Or(EqualTo(a=b), IsNull(EqualTo(a=b)))
```

`unapply`...FIXME

`unapply` is used when:

* [EliminateJoinToEmptyRelation](adaptive-query-execution/EliminateJoinToEmptyRelation.md) logical optimization is executed
* `JoinSelection` execution planning strategy is [executed](execution-planning-strategies/JoinSelection.md#ExtractSingleColumnNullAwareAntiJoin)
* `LogicalQueryStageStrategy` execution planning strategy is [executed](execution-planning-strategies/LogicalQueryStageStrategy.md#ExtractSingleColumnNullAwareAntiJoin)
