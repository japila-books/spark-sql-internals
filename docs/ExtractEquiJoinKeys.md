# ExtractEquiJoinKeys

`ExtractEquiJoinKeys` is a Scala extractor to [destructure a Join logical operator](#unapply) into a tuple of the following elements:

1. [Join type](spark-sql-joins.md#join-types)

1. Left and right keys (for non-empty join keys in the [condition](logical-operators/Join.md#condition) of the `Join` operator)

1. Optional join condition (a [Catalyst expression](expressions/Expression.md)) that could be used as a new join condition

1. The [left](logical-operators/Join.md#left) and the [right](logical-operators/Join.md#right) logical operators

1. `JoinHint`

`unapply` gives `None` (aka _nothing_) when no join keys were found or the logical plan is not a [Join](logical-operators/Join.md) logical operator.

## Demo

```scala
val left = Seq((0, 1, "zero"), (1, 2, "one")).toDF("k1", "k2", "name")
val right = Seq((0, 0, "0"), (1, 1, "1")).toDF("k1", "k2", "name")
```

The following join query gives no data result but is enough for demo purposes.

```scala
val q = left
  .join(right, Seq("k1", "k2", "name"))
  .where(left("k1") > 3)
```

```scala
import org.apache.spark.sql.catalyst.plans.logical.Join
val plan = q.queryExecution.analyzed
```

```scala
val join = plan.collectFirst { case j: Join => j }.get
assert(join.condition.isDefined)
```

Enable DEBUG logging level

```text
import org.apache.log4j.{Level, Logger}
Logger.getLogger("org.apache.spark.sql.catalyst.planning.ExtractEquiJoinKeys").setLevel(Level.DEBUG)
```

```scala
import org.apache.spark.sql.catalyst.planning.ExtractEquiJoinKeys
val joinParts = ExtractEquiJoinKeys.unapply(join)
```

```text
21/05/03 19:16:07 DEBUG ExtractEquiJoinKeys: Considering join on: Some((((k1#10 = k1#39) AND (k2#11 = k2#40)) AND (name#12 = name#41)))
21/05/03 19:16:07 DEBUG ExtractEquiJoinKeys: leftKeys:List(k1#10, k2#11, name#12) | rightKeys:List(k1#39, k2#40, name#41)
joinParts: Option[org.apache.spark.sql.catalyst.planning.ExtractEquiJoinKeys.ReturnType] =
Some((Inner,List(k1#10, k2#11, name#12),List(k1#39, k2#40, name#41),None,Project [_1#3 AS k1#10, _2#4 AS k2#11, _3#5 AS name#12]
+- LocalRelation [_1#3, _2#4, _3#5]
,Project [_1#32 AS k1#39, _2#33 AS k2#40, _3#34 AS name#41]
+- LocalRelation [_1#32, _2#33, _3#34]
,))
```

## <span id="unapply"> Destructuring Join Logical Plan

```scala
type ReturnType =
  (JoinType,
   Seq[Expression],
   Seq[Expression],
   Option[Expression],
   LogicalPlan,
   LogicalPlan,
   JoinHint)

unapply(
  join: Join): Option[ReturnType]
```

`unapply` prints out the following DEBUG message to the logs:

```text
Considering join on: [condition]
```

`unapply` then splits `condition` at `And` expression points (if there are any) to have a list of predicate expressions.

`unapply` finds [EqualTo](expressions/EqualTo.md) and [EqualNullSafe](expressions/EqualNullSafe.md) binary predicates to collect the join keys (for the left and right side).

`unapply` takes the expressions that...FIXME...to build `otherPredicates`.

In the end, `unapply` splits the pairs of join keys into collections of left and right join keys. `unapply` prints out the following DEBUG message to the logs:

```text
leftKeys:[leftKeys] | rightKeys:[rightKeys]
```

`unapply` is used when:

* `JoinEstimation` is requested to [estimateInnerOuterJoin](logical-operators/JoinEstimation.md#estimateInnerOuterJoin)
* [JoinSelection](execution-planning-strategies/JoinSelection.md) and [LogicalQueryStageStrategy](execution-planning-strategies/LogicalQueryStageStrategy.md) execution planning strategies are executed
* `NormalizeFloatingNumbers` and [PartitionPruning](logical-optimizations/PartitionPruning.md) logical optimizations are executed

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.catalyst.planning.ExtractEquiJoinKeys` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.catalyst.planning.ExtractEquiJoinKeys=ALL
```

Refer to [Logging](spark-logging.md).
