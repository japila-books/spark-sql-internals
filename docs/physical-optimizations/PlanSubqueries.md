# PlanSubqueries Physical Optimization

`PlanSubqueries` is a *physical query optimization* (aka _physical query preparation rule_ or simply _preparation rule_) that <<apply, plans ScalarSubquery (SubqueryExpression) expressions>> (as `ScalarSubquery ExecSubqueryExpression` expressions).

[source, scala]
----
import org.apache.spark.sql.SparkSession
val spark: SparkSession = ...

import org.apache.spark.sql.execution.PlanSubqueries
val planSubqueries = PlanSubqueries(spark)

Seq(
  (0, 0),
  (1, 0),
  (2, 1)
).toDF("id", "gid").createOrReplaceTempView("t")

Seq(
  (0, 3),
  (1, 20)
).toDF("gid", "lvl").createOrReplaceTempView("v")

val sql = """
  select * from t where gid > (select max(gid) from v)
"""
val q = spark.sql(sql)

val sparkPlan = q.queryExecution.sparkPlan
scala> println(sparkPlan.numberedTreeString)
00 Project [_1#49 AS id#52, _2#50 AS gid#53]
01 +- Filter (_2#50 > scalar-subquery#128 [])
02    :  +- Aggregate [max(gid#61) AS max(gid)#130]
03    :     +- LocalRelation [gid#61]
04    +- LocalTableScan [_1#49, _2#50]

val optimizedPlan = planSubqueries(sparkPlan)
scala> println(optimizedPlan.numberedTreeString)
00 Project [_1#49 AS id#52, _2#50 AS gid#53]
01 +- Filter (_2#50 > Subquery subquery128)
02    :  +- Subquery subquery128
03    :     +- *(2) HashAggregate(keys=[], functions=[max(gid#61)], output=[max(gid)#130])
04    :        +- Exchange SinglePartition
05    :           +- *(1) HashAggregate(keys=[], functions=[partial_max(gid#61)], output=[max#134])
06    :              +- LocalTableScan [gid#61]
07    +- LocalTableScan [_1#49, _2#50]
----

`PlanSubqueries` is part of [preparations](../QueryExecution.md#preparations) batch of physical query plan rules and is executed when `QueryExecution` is requested for the [optimized physical query plan](../QueryExecution.md#executedPlan) (i.e. in *executedPlan* phase of a query execution).

`PlanSubqueries` is a [Catalyst rule](../catalyst/Rule.md) for transforming [physical query plans](../physical-operators/SparkPlan.md) (`Rule[SparkPlan]`).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: SparkPlan): SparkPlan
```

For every [ScalarSubquery](../expressions/ScalarSubquery.md) expression in the input SparkPlan.md[physical plan], `apply` does the following:

. Builds the [optimized physical plan](../QueryExecution.md#executedPlan) (aka `executedPlan`) of the [subquery logical plan](../expressions/ScalarSubquery.md#plan), i.e. creates a [QueryExecution](../QueryExecution.md) for the subquery logical plan and requests the optimized physical plan.

. Plans the scalar subquery, i.e. creates a spark-sql-Expression-ExecSubqueryExpression-ScalarSubquery.md[ScalarSubquery (ExecSubqueryExpression)] expression with a new spark-sql-SparkPlan-SubqueryExec.md#creating-instance[SubqueryExec] physical operator (with the name *subquery[id]* and the optimized physical plan) and the ScalarSubquery.md#exprId[ExprId].

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
