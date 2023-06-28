# Hints (SQL)

Structured queries can be optimized using **hints**.

Hints annotate a query and give a hint to the query optimizer how to optimize logical plans. This can be very useful when the query optimizer cannot make optimal decision (e.g., with respect to join methods due to conservativeness or the lack of proper statistics).

Since SQL has no sense of partitioning (e.g., using `DataFrame.repartition`), the hints let express this "need" declaratively in SQL.

Spark SQL supports [COALESCE and REPARTITION](#coalesce-repartition-hints) and [BROADCAST](#broadcast-hints) hints.

All unresolved hints are removed from a query plan at [analysis](#spark-analyzer).

## ResolveCoalesceHints { #ResolveCoalesceHints }

[ResolveCoalesceHints](../logical-analysis-rules/ResolveCoalesceHints.md) logical resolution rule is responsible for resolving the following hint names:

Hint Name | Arguments | Logical Operator
----------|-----------|-----------------
 `COALESCE` | Number of partitions | [Repartition](../logical-operators/RepartitionOperation.md#Repartition) (with `shuffle` off / `false`)
 `REBALANCE` | | [RebalancePartitions](../logical-operators/RebalancePartitions.md)
 `REPARTITION` | Number of partitions alone or like `REPARTITION_BY_RANGE` | [Repartition](../logical-operators/RepartitionOperation.md#Repartition) (with `shuffle` on / `true`)
 `REPARTITION_BY_RANGE` | Column names with an optional number of partitions (default: [spark.sql.shuffle.partitions](../configuration-properties.md#spark.sql.shuffle.partitions) configuration property) | [RepartitionByExpression](../logical-operators/RepartitionByExpression.md)

```sql
SELECT c1, count(1)
FROM (
  SELECT /*+ REBALANCE(c1, n) */ c1, 1 as n FROM v
  ) t
GROUP BY c1
```

## Specifying Query Hints

Hints are defined using [Dataset.hint](../spark-sql-dataset-operators.md#hint) operator or [SQL hints](#sql-hints).

### Dataset API

=== "Scala"

    ```scala
    val q = spark.range(1).hint(name = "myHint", 100, true)
    val plan = q.queryExecution.logical
    println(plan.numberedTreeString)
    ```

    ```text
    00 'UnresolvedHint myHint, [100, true]
    01 +- Range (0, 1, step=1, splits=Some(8))
    ```

=== "SQL"

    ```scala
    val q = sql("SELECT /*+ myHint (100, true) */ 1")
    val plan = q.queryExecution.logical
    scala> println(plan.numberedTreeString)
    ```

    ```text
    00 'UnresolvedHint myHint, [100, true]
    01 +- 'Project [unresolvedalias(1, None)]
    02    +- OneRowRelation
    ```

## Hints in SELECT Statements { #sql-hints }

`SELECT` SQL statement supports query hints as comments in SQL query that Spark SQL [translates](../sql/AstBuilder.md#withHints) into a [UnresolvedHint](../logical-operators/UnresolvedHint.md) unary logical operator.

### <span id="coalesce-repartition-hints"> COALESCE and REPARTITION Hints

Spark SQL 2.4 added support for **COALESCE** and **REPARTITION** hints (using [SQL comments](#sql-hints)):

* `SELECT /*+ COALESCE(5) */ ...`

* `SELECT /*+ REPARTITION(3) */ ...`

### <span id="broadcast-hints"> Broadcast Hints

Spark SQL 2.2 supports **BROADCAST** hints using [broadcast](#broadcast-function) standard function or [SQL comments](#sql-hints):

* `SELECT /*+ MAPJOIN(b) */ ...`

* `SELECT /*+ BROADCASTJOIN(b) */ ...`

* `SELECT /*+ BROADCAST(b) */ ...`

### <span id="broadcast-function"> broadcast Standard Function

While `hint` operator allows for attaching any hint to a logical plan [broadcast](../functions/index.md#broadcast) standard function attaches the broadcast hint only (that actually makes it a special case of `hint` operator).

`broadcast` standard function is used for [broadcast joins (aka map-side joins)](../spark-sql-joins-broadcast.md) (and to hint the Spark planner to broadcast a dataset regardless of the size).

```text
val small = spark.range(1)
val large = spark.range(100)

// Let's use broadcast standard function first
val q = large.join(broadcast(small), "id")
val plan = q.queryExecution.logical
scala> println(plan.numberedTreeString)
00 'Join UsingJoin(Inner,List(id))
01 :- Range (0, 100, step=1, splits=Some(8))
02 +- ResolvedHint (broadcast)
03    +- Range (0, 1, step=1, splits=Some(8))

// Please note that broadcast standard function uses ResolvedHint not UnresolvedHint

// Let's "replicate" standard function using hint operator
// Any of the names would work (case-insensitive)
// "BROADCAST", "BROADCASTJOIN", "MAPJOIN"
val smallHinted = small.hint("broadcast")
val plan = smallHinted.queryExecution.logical
scala> println(plan.numberedTreeString)
00 'UnresolvedHint broadcast
01 +- Range (0, 1, step=1, splits=Some(8))

// join is "clever"
// i.e. resolves UnresolvedHint into ResolvedHint immediately
val q = large.join(smallHinted, "id")
val plan = q.queryExecution.logical
scala> println(plan.numberedTreeString)
00 'Join UsingJoin(Inner,List(id))
01 :- Range (0, 100, step=1, splits=Some(8))
02 +- ResolvedHint (broadcast)
03    +- Range (0, 1, step=1, splits=Some(8))
```

### Spark Analyzer

[Logical Analyzer](../Analyzer.md) uses the following logical rules to resolve [UnresolvedHint](../logical-operators/UnresolvedHint.md) logical operators:

* [ResolveJoinStrategyHints](../logical-analysis-rules/ResolveJoinStrategyHints.md)
* [ResolveCoalesceHints](../logical-analysis-rules/ResolveCoalesceHints.md)
* `RemoveAllHints` (to remove all `UnresolvedHint` operators left unresolved)

The order of executing the above rules matters.

```text
// Let's hint the query twice
// The order of hints matters as every hint operator executes Spark analyzer
// That will resolve all but the last hint
val q = spark.range(100).
  hint("broadcast").
  hint("myHint", 100, true)
val plan = q.queryExecution.logical
scala> println(plan.numberedTreeString)
00 'UnresolvedHint myHint, [100, true]
01 +- ResolvedHint (broadcast)
02    +- Range (0, 100, step=1, splits=Some(8))

// Let's resolve unresolved hints
import org.apache.spark.sql.catalyst.rules.RuleExecutor
import org.apache.spark.sql.catalyst.plans.logical.LogicalPlan
import org.apache.spark.sql.catalyst.analysis.ResolveHints
import org.apache.spark.sql.internal.SQLConf
object HintResolver extends RuleExecutor[LogicalPlan] {
  lazy val batches =
    Batch("Hints", FixedPoint(maxIterations = 100),
      new ResolveHints.ResolveBroadcastHints(SQLConf.get),
      ResolveHints.RemoveAllHints) :: Nil
}
val resolvedPlan = HintResolver.execute(plan)
scala> println(resolvedPlan.numberedTreeString)
00 ResolvedHint (broadcast)
01 +- Range (0, 100, step=1, splits=Some(8))
```

## <span id="hint-catalyst-dsl"> Hint Operator in Catalyst DSL

[hint](../catalyst-dsl/index.md#hint) operator in [Catalyst DSL](../catalyst-dsl/index.md) allows to create a [UnresolvedHint](../logical-operators/UnresolvedHint.md) logical operator.

```text
// Create a logical plan to add hint to
import org.apache.spark.sql.catalyst.plans.logical.LocalRelation
val r1 = LocalRelation('a.int, 'b.timestamp, 'c.boolean)
scala> println(r1.numberedTreeString)
00 LocalRelation <empty>, [a#0, b#1, c#2]

// Attach hint to the plan
import org.apache.spark.sql.catalyst.dsl.plans._
val plan = r1.hint(name = "myHint", 100, true)
scala> println(plan.numberedTreeString)
00 'UnresolvedHint myHint, [100, true]
01 +- LocalRelation <empty>, [a#0, b#1, c#2]
```

## Learn More

* [SPARK-20857](https://issues.apache.org/jira/browse/SPARK-20857)
