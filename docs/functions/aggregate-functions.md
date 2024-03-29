# Standard Aggregate Functions

## <span id="collect_set"> collect_set

```scala
collect_set(
  e: Column): Column
collect_set(
  columnName: String): Column
```

`collect_set` creates a [CollectSet](../expressions/CollectSet.md) expression (for the [expr](../Column.md#expr) of the given [Column](../Column.md)) and requests it to [toAggregateExpression](../expressions/AggregateFunction.md#toAggregateExpression).

In the end, `collect_set` wraps the [AggregateExpression](../expressions/AggregateExpression.md) up in a [Column](../Column.md).

<!---
## Review Me

=== [[grouping]] `grouping` Aggregate Function

[source, scala]
----
grouping(e: Column): Column
grouping(columnName: String): Column  // <1>
----
<1> Calls the first `grouping` with `columnName` as a `Column`

`grouping` is an aggregate function that indicates whether a specified column is aggregated or not and:

* returns `1` if the column is in a subtotal and is `NULL`
* returns `0` if the underlying value is `NULL` or any other value

NOTE: `grouping` can only be used with [cube](../aggregations/index.md#cube), [rollup](../aggregations/index.md#rollup) or `GROUPING SETS` multi-dimensional aggregate operators (and is verified when CheckAnalysis.md#Grouping[`Analyzer` does check analysis]).

From [Hive's documentation about Grouping__ID function](https://cwiki.apache.org/confluence/display/Hive/Enhanced&#43;Aggregation%2C&#43;Cube%2C&#43;Grouping&#43;and&#43;Rollup#EnhancedAggregation,Cube,GroupingandRollup-Grouping\_\_IDfunction) (that can somehow help to understand `grouping`):

> When aggregates are displayed for a column its value is `null`. This may conflict in case the column itself has some `null` values. There needs to be some way to identify `NULL` in column, which means aggregate and `NULL` in column, which means value. `GROUPING__ID` function is the solution to that.

```text
val tmpWorkshops = Seq(
  ("Warsaw", 2016, 2),
  ("Toronto", 2016, 4),
  ("Toronto", 2017, 1)).toDF("city", "year", "count")

// there seems to be a bug with nulls
// and so the need for the following union
val cityNull = Seq(
  (null.asInstanceOf[String], 2016, 2)).toDF("city", "year", "count")

val workshops = tmpWorkshops union cityNull

scala> workshops.show
+-------+----+-----+
|   city|year|count|
+-------+----+-----+
| Warsaw|2016|    2|
|Toronto|2016|    4|
|Toronto|2017|    1|
|   null|2016|    2|
+-------+----+-----+

val q = workshops
  .cube("city", "year")
  .agg(grouping("city"), grouping("year")) // <-- grouping here
  .sort($"city".desc_nulls_last, $"year".desc_nulls_last)

scala> q.show
+-------+----+--------------+--------------+
|   city|year|grouping(city)|grouping(year)|
+-------+----+--------------+--------------+
| Warsaw|2016|             0|             0|
| Warsaw|null|             0|             1|
|Toronto|2017|             0|             0|
|Toronto|2016|             0|             0|
|Toronto|null|             0|             1|
|   null|2017|             1|             0|
|   null|2016|             1|             0|
|   null|2016|             0|             0|  <-- null is city
|   null|null|             0|             1|  <-- null is city
|   null|null|             1|             1|
+-------+----+--------------+--------------+
```

Internally, `grouping` creates a [Column](Column.md) with `Grouping` expression.

```text
val q = workshops.cube("city", "year").agg(grouping("city"))
scala> println(q.queryExecution.logical)
'Aggregate [cube(city#182, year#183)], [city#182, year#183, grouping('city) AS grouping(city)#705]
+- Union
   :- Project [_1#178 AS city#182, _2#179 AS year#183, _3#180 AS count#184]
   :  +- LocalRelation [_1#178, _2#179, _3#180]
   +- Project [_1#192 AS city#196, _2#193 AS year#197, _3#194 AS count#198]
      +- LocalRelation [_1#192, _2#193, _3#194]

scala> println(q.queryExecution.analyzed)
Aggregate [city#724, year#725, spark_grouping_id#721], [city#724, year#725, cast((shiftright(spark_grouping_id#721, 1) & 1) as tinyint) AS grouping(city)#720]
+- Expand [List(city#182, year#183, count#184, city#722, year#723, 0), List(city#182, year#183, count#184, city#722, null, 1), List(city#182, year#183, count#184, null, year#723, 2), List(city#182, year#183, count#184, null, null, 3)], [city#182, year#183, count#184, city#724, year#725, spark_grouping_id#721]
   +- Project [city#182, year#183, count#184, city#182 AS city#722, year#183 AS year#723]
      +- Union
         :- Project [_1#178 AS city#182, _2#179 AS year#183, _3#180 AS count#184]
         :  +- LocalRelation [_1#178, _2#179, _3#180]
         +- Project [_1#192 AS city#196, _2#193 AS year#197, _3#194 AS count#198]
            +- LocalRelation [_1#192, _2#193, _3#194]
```

NOTE: `grouping` was added to Spark SQL in https://issues.apache.org/jira/browse/SPARK-12706[[SPARK-12706\] support grouping/grouping_id function together group set].

=== [[grouping_id]] `grouping_id` Aggregate Function

[source, scala]
----
grouping_id(cols: Column*): Column
grouping_id(colName: String, colNames: String*): Column // <1>
----
<1> Calls the first `grouping_id` with `colName` and `colNames` as objects of type `Column`

`grouping_id` is an aggregate function that computes the level of grouping:

* `0` for combinations of each column
* `1` for subtotals of column 1
* `2` for subtotals of column 2
* And so on&hellip;

[source, scala]
----
val tmpWorkshops = Seq(
  ("Warsaw", 2016, 2),
  ("Toronto", 2016, 4),
  ("Toronto", 2017, 1)).toDF("city", "year", "count")

// there seems to be a bug with nulls
// and so the need for the following union
val cityNull = Seq(
  (null.asInstanceOf[String], 2016, 2)).toDF("city", "year", "count")

val workshops = tmpWorkshops union cityNull

scala> workshops.show
+-------+----+-----+
|   city|year|count|
+-------+----+-----+
| Warsaw|2016|    2|
|Toronto|2016|    4|
|Toronto|2017|    1|
|   null|2016|    2|
+-------+----+-----+

val query = workshops
  .cube("city", "year")
  .agg(grouping_id()) // <-- all grouping columns used
  .sort($"city".desc_nulls_last, $"year".desc_nulls_last)
scala> query.show
+-------+----+-------------+
|   city|year|grouping_id()|
+-------+----+-------------+
| Warsaw|2016|            0|
| Warsaw|null|            1|
|Toronto|2017|            0|
|Toronto|2016|            0|
|Toronto|null|            1|
|   null|2017|            2|
|   null|2016|            2|
|   null|2016|            0|
|   null|null|            1|
|   null|null|            3|
+-------+----+-------------+

scala> spark.catalog.listFunctions.filter(_.name.contains("grouping_id")).show(false)
+-----------+--------+-----------+----------------------------------------------------+-----------+
|name       |database|description|className                                           |isTemporary|
+-----------+--------+-----------+----------------------------------------------------+-----------+
|grouping_id|null    |null       |org.apache.spark.sql.catalyst.expressions.GroupingID|true       |
+-----------+--------+-----------+----------------------------------------------------+-----------+

// bin function gives the string representation of the binary value of the given long column
scala> query.withColumn("bitmask", bin($"grouping_id()")).show
+-------+----+-------------+-------+
|   city|year|grouping_id()|bitmask|
+-------+----+-------------+-------+
| Warsaw|2016|            0|      0|
| Warsaw|null|            1|      1|
|Toronto|2017|            0|      0|
|Toronto|2016|            0|      0|
|Toronto|null|            1|      1|
|   null|2017|            2|     10|
|   null|2016|            2|     10|
|   null|2016|            0|      0|  <-- null is city
|   null|null|            3|     11|
|   null|null|            1|      1|
+-------+----+-------------+-------+
----

The list of columns of `grouping_id` should match grouping columns (in `cube` or `rollup`) exactly, or empty which means all the grouping columns (which is exactly what the function expects).

NOTE: `grouping_id` can only be used with [cube](../aggregations/index.md#cube), [rollup](../aggregations/index.md#rollup) or `GROUPING SETS` multi-dimensional aggregate operators (and is verified when CheckAnalysis.md#GroupingID[`Analyzer` does check analysis]).

NOTE: Spark SQL's `grouping_id` function is known as `grouping__id` in Hive.

From [Hive's documentation about Grouping__ID function](https://cwiki.apache.org/confluence/display/Hive/Enhanced&#43;Aggregation%2C&#43;Cube%2C&#43;Grouping&#43;and&#43;Rollup#EnhancedAggregation,Cube,GroupingandRollup-Grouping\_\_IDfunction):

> When aggregates are displayed for a column its value is `null`. This may conflict in case the column itself has some `null` values. There needs to be some way to identify `NULL` in column, which means aggregate and `NULL` in column, which means value. `GROUPING__ID` function is the solution to that.

Internally, `grouping_id()` creates a [Column](Column.md) with `GroupingID` unevaluable expression.

```text
// workshops dataset was defined earlier
val q = workshops
  .cube("city", "year")
  .agg(grouping_id())

// grouping_id function is spark_grouping_id virtual column internally
// that is resolved during analysis - see Analyzed Logical Plan
scala> q.explain(true)
== Parsed Logical Plan ==
'Aggregate [cube(city#182, year#183)], [city#182, year#183, grouping_id() AS grouping_id()#742]
+- Union
   :- Project [_1#178 AS city#182, _2#179 AS year#183, _3#180 AS count#184]
   :  +- LocalRelation [_1#178, _2#179, _3#180]
   +- Project [_1#192 AS city#196, _2#193 AS year#197, _3#194 AS count#198]
      +- LocalRelation [_1#192, _2#193, _3#194]

== Analyzed Logical Plan ==
city: string, year: int, grouping_id(): int
Aggregate [city#757, year#758, spark_grouping_id#754], [city#757, year#758, spark_grouping_id#754 AS grouping_id()#742]
+- Expand [List(city#182, year#183, count#184, city#755, year#756, 0), List(city#182, year#183, count#184, city#755, null, 1), List(city#182, year#183, count#184, null, year#756, 2), List(city#182, year#183, count#184, null, null, 3)], [city#182, year#183, count#184, city#757, year#758, spark_grouping_id#754]
   +- Project [city#182, year#183, count#184, city#182 AS city#755, year#183 AS year#756]
      +- Union
         :- Project [_1#178 AS city#182, _2#179 AS year#183, _3#180 AS count#184]
         :  +- LocalRelation [_1#178, _2#179, _3#180]
         +- Project [_1#192 AS city#196, _2#193 AS year#197, _3#194 AS count#198]
            +- LocalRelation [_1#192, _2#193, _3#194]

== Optimized Logical Plan ==
Aggregate [city#757, year#758, spark_grouping_id#754], [city#757, year#758, spark_grouping_id#754 AS grouping_id()#742]
+- Expand [List(city#755, year#756, 0), List(city#755, null, 1), List(null, year#756, 2), List(null, null, 3)], [city#757, year#758, spark_grouping_id#754]
   +- Union
      :- LocalRelation [city#755, year#756]
      +- LocalRelation [city#755, year#756]

== Physical Plan ==
*HashAggregate(keys=[city#757, year#758, spark_grouping_id#754], functions=[], output=[city#757, year#758, grouping_id()#742])
+- Exchange hashpartitioning(city#757, year#758, spark_grouping_id#754, 200)
   +- *HashAggregate(keys=[city#757, year#758, spark_grouping_id#754], functions=[], output=[city#757, year#758, spark_grouping_id#754])
      +- *Expand [List(city#755, year#756, 0), List(city#755, null, 1), List(null, year#756, 2), List(null, null, 3)], [city#757, year#758, spark_grouping_id#754]
         +- Union
            :- LocalTableScan [city#755, year#756]
            +- LocalTableScan [city#755, year#756]
```

NOTE: `grouping_id` was added to Spark SQL in https://issues.apache.org/jira/browse/SPARK-12706[[SPARK-12706\] support grouping/grouping_id function together group set].
-->
