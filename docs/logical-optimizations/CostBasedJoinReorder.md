# CostBasedJoinReorder Logical Optimization -- Join Reordering in Cost-Based Optimization

`CostBasedJoinReorder` is a [base logical optimization](../catalyst/Optimizer.md#batches) that [reorders joins](#apply) in [Cost-Based Optimization](../cost-based-optimization/index.md).

`ReorderJoin` is part of the [Join Reorder](../catalyst/Optimizer.md#Join_Reorder) once-executed batch in the standard batches of the [Logical Optimizer](../catalyst/Optimizer.md).

`ReorderJoin` is simply a [Catalyst rule](../catalyst/Rule.md) for transforming [LogicalPlan](../logical-operators/LogicalPlan.md)s, i.e. `Rule[LogicalPlan]`.

`CostBasedJoinReorder` [applies](#apply) the join optimizations on a logical plan with 2 or more [consecutive inner or cross joins](#extractInnerJoins) (possibly separated by `Project` operators) when [spark.sql.cbo.enabled](../configuration-properties.md#spark.sql.cbo.enabled) and [spark.sql.cbo.joinReorder.enabled](../configuration-properties.md#spark.sql.cbo.joinReorder.enabled) configuration properties are both enabled.

```text
// Use shortcuts to read the values of the properties
scala> spark.sessionState.conf.cboEnabled
res0: Boolean = true

scala> spark.sessionState.conf.joinReorderEnabled
res1: Boolean = true
```

`CostBasedJoinReorder` uses [row count](../cost-based-optimization/index.md#row-count-stat) statistic that is computed using [ANALYZE TABLE COMPUTE STATISTICS](../cost-based-optimization/index.md#ANALYZE-TABLE) SQL command with no `NOSCAN` option.

```text
// Create tables and compute their row count statistics
// There have to be at least 2 joins
// Make the example reproducible
val tableNames = Seq("t1", "t2", "tiny")
import org.apache.spark.sql.catalyst.TableIdentifier
val tableIds = tableNames.map(TableIdentifier.apply)
val sessionCatalog = spark.sessionState.catalog
tableIds.foreach { tableId =>
  sessionCatalog.dropTable(tableId, ignoreIfNotExists = true, purge = true)
}

val belowBroadcastJoinThreshold = spark.sessionState.conf.autoBroadcastJoinThreshold - 1
spark.range(belowBroadcastJoinThreshold).write.saveAsTable("t1")
// t2 is twice as big as t1
spark.range(2 * belowBroadcastJoinThreshold).write.saveAsTable("t2")
spark.range(5).write.saveAsTable("tiny")

// Compute row count statistics
tableNames.foreach { t =>
  sql(s"ANALYZE TABLE $t COMPUTE STATISTICS")
}

// Load the tables
val t1 = spark.table("t1")
val t2 = spark.table("t2")
val tiny = spark.table("tiny")

// Example: Inner join with join condition
val q = t1.join(t2, Seq("id")).join(tiny, Seq("id"))
val plan = q.queryExecution.analyzed
scala> println(plan.numberedTreeString)
00 Project [id#51L]
01 +- Join Inner, (id#51L = id#57L)
02    :- Project [id#51L]
03    :  +- Join Inner, (id#51L = id#54L)
04    :     :- SubqueryAlias t1
05    :     :  +- Relation[id#51L] parquet
06    :     +- SubqueryAlias t2
07    :        +- Relation[id#54L] parquet
08    +- SubqueryAlias tiny
09       +- Relation[id#57L] parquet

// Eliminate SubqueryAlias logical operators as they no longer needed
// And "confuse" CostBasedJoinReorder
// CostBasedJoinReorder cares about how deep Joins are and reorders consecutive joins only
import org.apache.spark.sql.catalyst.analysis.EliminateSubqueryAliases
val noAliasesPlan = EliminateSubqueryAliases(plan)
scala> println(noAliasesPlan.numberedTreeString)
00 Project [id#51L]
01 +- Join Inner, (id#51L = id#57L)
02    :- Project [id#51L]
03    :  +- Join Inner, (id#51L = id#54L)
04    :     :- Relation[id#51L] parquet
05    :     +- Relation[id#54L] parquet
06    +- Relation[id#57L] parquet

// Let's go pro and create a custom RuleExecutor (i.e. an Optimizer)
import org.apache.spark.sql.catalyst.rules.RuleExecutor
import org.apache.spark.sql.catalyst.plans.logical.LogicalPlan
import org.apache.spark.sql.catalyst.analysis.EliminateSubqueryAliases
import org.apache.spark.sql.catalyst.optimizer.CostBasedJoinReorder
object Optimize extends RuleExecutor[LogicalPlan] {
  val batches =
    Batch("EliminateSubqueryAliases", Once, EliminateSubqueryAliases) ::
    Batch("Join Reorder", Once, CostBasedJoinReorder) :: Nil
}

val joinsReordered = Optimize.execute(plan)
scala> println(joinsReordered.numberedTreeString)
00 Project [id#51L]
01 +- Join Inner, (id#51L = id#54L)
02    :- Project [id#51L]
03    :  +- Join Inner, (id#51L = id#57L)
04    :     :- Relation[id#51L] parquet
05    :     +- Relation[id#57L] parquet
06    +- Relation[id#54L] parquet

// Execute the plans
// Compare the plans as diagrams in web UI @ http://localhost:4040/SQL
// We'd have to use too many internals so let's turn CBO on and off
// Moreover, please remember that the query "phases" are cached
// That's why we copy and paste the entire query for execution
import org.apache.spark.sql.internal.SQLConf
val cc = SQLConf.get
cc.setConf(SQLConf.CBO_ENABLED, false)
val q = t1.join(t2, Seq("id")).join(tiny, Seq("id"))
q.collect.foreach(_ => ())

cc.setConf(SQLConf.CBO_ENABLED, true)
val q = t1.join(t2, Seq("id")).join(tiny, Seq("id"))
q.collect.foreach(_ => ())
```

<!---
[CAUTION]
====
FIXME Examples of other join queries

* Cross join with join condition
* Project with attributes only and Inner join with join condition
* Project with attributes only and Cross join with join condition
====

[[logging]]
[TIP]
====
Enable `DEBUG` logging level for `org.apache.spark.sql.catalyst.optimizer.JoinReorderDP` logger to see the join reordering duration.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.catalyst.optimizer.JoinReorderDP=DEBUG
```

Refer to spark-logging.md[Logging].
====

## <span id="apply"> Executing Rule

```scala
apply(plan: LogicalPlan): LogicalPlan
```

`apply` traverses the input spark-sql-LogicalPlan.md[logical plan] down and tries to <<reorder, reorder>> the following logical operators:

* Join.md[Join] for `CROSS` or `INNER` joins with a join condition

* Project.md[Project] with the above Join.md[Join] child operator and the project list of spark-sql-Expression-Attribute.md[Attribute] leaf expressions only

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

=== [[extractInnerJoins]] Extracting Consecutive Join Operators -- `extractInnerJoins` Internal Method

[source, scala]
----
extractInnerJoins(plan: LogicalPlan): (Seq[LogicalPlan], Set[Expression])
----

`extractInnerJoins` finds consecutive Join.md[Join] logical operators (inner or cross) with join conditions or Project.md[Project] logical operators with `Join` logical operator and the project list of spark-sql-Expression-Attribute.md[Attribute] leaf expressions only.

For `Project` operators `extractInnerJoins` calls itself recursively with the `Join` operator inside.

In the end, `extractInnerJoins` gives the collection of logical plans under the consecutive `Join` logical operators (possibly separated by `Project` operators only) and their join conditions (for which `And` expressions have been split).

NOTE: `extractInnerJoins` is used recursively when `CostBasedJoinReorder` is <<reorder, reordering>> a logical plan.
-->
