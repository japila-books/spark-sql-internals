---
title: View
---

# View Unary Logical Operator

[[children]]
`View` is a <<spark-sql-LogicalPlan.md#, logical operator>> with a single <<child, child>> logical operator.

`View` is <<creating-instance, created>> exclusively when `SessionCatalog` is requested to [find a relation in the catalogs](../SessionCatalog.md#lookupRelation) (e.g. when `DescribeTableCommand` logical command is <<DescribeTableCommand.md#run, executed>> and the table type is `VIEW`).

[source, scala]
----
// Let's create a view first
// Using SQL directly to manage views is so much nicer
val name = "demo_view"
sql(s"CREATE OR REPLACE VIEW $name COMMENT 'demo view' AS VALUES 1,2")
assert(spark.catalog.tableExists(name))

val q = sql(s"DESC EXTENDED $name")

val allRowsIncluded = 100
scala> q.show(numRows = allRowsIncluded)
+--------------------+--------------------+-------+
|            col_name|           data_type|comment|
+--------------------+--------------------+-------+
|                col1|                 int|   null|
|                    |                    |       |
|# Detailed Table ...|                    |       |
|            Database|             default|       |
|               Table|           demo_view|       |
|               Owner|               jacek|       |
|        Created Time|Thu Aug 30 08:55:...|       |
|         Last Access|Thu Jan 01 01:00:...|       |
|          Created By|         Spark 2.3.1|       |
|                Type|                VIEW|       |
|             Comment|           demo view|       |
|           View Text|          VALUES 1,2|       |
|View Default Data...|             default|       |
|View Query Output...|              [col1]|       |
|    Table Properties|[transient_lastDd...|       |
|       Serde Library|org.apache.hadoop...|       |
|         InputFormat|org.apache.hadoop...|       |
|        OutputFormat|org.apache.hadoop...|       |
|  Storage Properties|[serialization.fo...|       |
+--------------------+--------------------+-------+
----

[[newInstance]]
`View` is a [MultiInstanceRelation](MultiInstanceRelation.md) so a <<newInstance, new instance will be created>> to appear multiple times in a physical query plan. When requested for a new instance, `View` <<spark-sql-Expression-Attribute.md#newInstance, creates new instances>> of the <<output, output attributes>>.

[[resolved]]
`View` is considered <<spark-sql-LogicalPlan.md#resolved, resolved>> only when the <<child, child>> is.

[[simpleString]]
`View` has the following <<catalyst/QueryPlan.md#simpleString, simple description (with state prefix)>>:

```
View ([identifier], [output])
```

[source, scala]
----
val name = "demo_view"
sql(s"CREATE OR REPLACE VIEW $name COMMENT 'demo view' AS VALUES 1,2")
assert(spark.catalog.tableExists(name))

val q = spark.table(name)
val qe = q.queryExecution

val logicalPlan = qe.logical
scala> println(logicalPlan.simpleString)
'UnresolvedRelation `demo_view`

val analyzedPlan = qe.analyzed
scala> println(analyzedPlan.numberedTreeString)
00 SubqueryAlias demo_view
01 +- View (`default`.`demo_view`, [col1#33])
02    +- Project [cast(col1#34 as int) AS col1#33]
03       +- LocalRelation [col1#34]

// Skip SubqueryAlias
scala> println(analyzedPlan.children.head.simpleString)
View (`default`.`demo_view`, [col1#33])
----

NOTE: `View` is resolved by [ResolveRelations](../logical-analysis-rules/ResolveRelations.md)logical resolution.

NOTE: [AliasViewChild](../logical-analysis-rules/AliasViewChild.md) logical analysis rule makes sure that the <<output, output>> of a `View` matches the output of the <<child, child>> logical operator.

NOTE: <<EliminateView.md#, EliminateView>> logical optimization removes (eliminates) `View` operators from a logical query plan.

NOTE: <<InsertIntoTable.md#inserting-into-view-not-allowed, Inserting into a view is not allowed>>.

## Creating Instance

`View` takes the following when created:

* [[desc]] [CatalogTable](../CatalogTable.md)
* [[output]] [Output schema attributes](../catalyst/QueryPlan.md#output) (as `Seq[Attribute]`)
* [[child]] Child [logical operator](../logical-operators/LogicalPlan.md)
