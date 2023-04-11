---
tags:
  - DeveloperApi
---

# RelationalGroupedDataset

`RelationalGroupedDataset` is a high-level API for **Untyped (Row-based) Grouping** (part of [Basic Aggregation](aggregations/index.md)) to calculate aggregates over groups of rows in a [DataFrame](DataFrame.md).

!!! note
    [KeyValueGroupedDataset](KeyValueGroupedDataset.md) is used for typed aggregates over groups of custom Scala objects (not [Row](Row.md)s).

`RelationalGroupedDataset` is a result of executing the following grouping operators:

* [groupBy](aggregations/index.md#groupBy)
* [rollup](aggregations/index.md#rollup)
* [cube](aggregations/index.md#cube)
* [pivot](#pivot)

<!---
## Review Me

!!! note
    [spark.sql.retainGroupColumns](../configuration-properties.md#spark.sql.retainGroupColumns) configuration property controls whether to retain columns used for aggregation or not (../in `RelationalGroupedDataset` operators).

=== [[agg]] Computing Aggregates Using Aggregate Column Expressions or Function Names -- `agg` Operator

`agg` creates a [DataFrame](../DataFrame.md) with the rows being the result of executing grouping expressions (../specified using [Column](../Column.md)s or names) over row groups.

!!! NOTE
    There are [untyped](../Column.md) and [typed](../TypedColumn.md) column expressions.

```scala
val countsAndSums = spark
  .range(10)
  .withColumn("group", 'id % 2)
  .groupBy("group")
  .agg(count("id") as "count", sum("id") as "sum")
```

Internally, `agg` [creates a DataFrame](#toDF) with `Aggregate` or `Pivot` logical operators.

```text
// groupBy above
scala> println(countsAndSums.queryExecution.logical.numberedTreeString)
00 'Aggregate [group#179L], [group#179L, count('id) AS count#188, sum('id) AS sum#190]
01 +- Project [id#176L, (id#176L % cast(2 as bigint)) AS group#179L]
02    +- Range (0, 10, step=1, splits=Some(8))

// rollup operator
val rollupQ = spark.range(2).rollup('id).agg(count('id))
scala> println(rollupQ.queryExecution.logical.numberedTreeString)
00 'Aggregate [rollup('id)], [unresolvedalias('id, None), count('id) AS count(id)#267]
01 +- Range (0, 2, step=1, splits=Some(8))

// cube operator
val cubeQ = spark.range(2).cube('id).agg(count('id))
scala> println(cubeQ.queryExecution.logical.numberedTreeString)
00 'Aggregate [cube('id)], [unresolvedalias('id, None), count('id) AS count(id)#280]
01 +- Range (0, 2, step=1, splits=Some(8))

// pivot operator
val pivotQ = spark.
  range(10).
  withColumn("group", 'id % 2).
  groupBy("group").
  pivot("group").
  agg(count("id"))
scala> println(pivotQ.queryExecution.logical.numberedTreeString)
00 'Pivot [group#296L], group#296: bigint, [0, 1], [count('id)]
01 +- Project [id#293L, (id#293L % cast(2 as bigint)) AS group#296L]
02    +- Range (0, 10, step=1, splits=Some(8))
```

=== [[creating-instance]] Creating RelationalGroupedDataset Instance

`RelationalGroupedDataset` takes the following when created:

* [[df]] [DataFrame](../DataFrame.md)
* [[groupingExprs]] Grouping expressions/Expression.md[expressions]
* [[groupType]] Group type (to indicate the "source" operator)

** `GroupByType` for [groupBy](index.md#groupBy)

** `CubeType`

** `RollupType`

** `PivotType`

=== [[pivot-internals]] `pivot` Operator

[source, scala]
----
pivot(pivotColumn: String): RelationalGroupedDataset // <1>
pivot(pivotColumn: String, values: Seq[Any]): RelationalGroupedDataset // <2>
pivot(pivotColumn: Column): RelationalGroupedDataset // <3>
pivot(pivotColumn: Column, values: Seq[Any]): RelationalGroupedDataset // <3>
----
<1> Selects distinct and sorted values on `pivotColumn` and calls the other `pivot` (that results in 3 extra "scanning" jobs)
<2> Preferred as more efficient because the unique values are aleady provided
<3> *New in 2.4.0*

`pivot` pivots on a `pivotColumn` column, i.e. adds new columns per distinct values in `pivotColumn`.

NOTE: `pivot` is only supported after [groupBy](index.md#groupBy) operation.

NOTE: Only one `pivot` operation is supported on a `RelationalGroupedDataset`.

```text
val visits = Seq(../
  (../0, "Warsaw", 2015),
  (../1, "Warsaw", 2016),
  (../2, "Boston", 2017)
).toDF(../"id", "city", "year")

val q = visits
  .groupBy(../"city")  // <-- rows in pivot table
  .pivot(../"year")    // <-- columns (../unique values queried)
  .count(../)          // <-- values in cells
scala> q.show
+------+----+----+----+
|  city|2015|2016|2017|
+------+----+----+----+
|Warsaw|   1|   1|null|
|Boston|null|null|   1|
+------+----+----+----+

scala> q.explain
== Physical Plan ==
HashAggregate(../keys=[city#8], functions=[pivotfirst(../year#9, count(../1) AS `count`#222L, 2015, 2016, 2017, 0, 0)])
+- Exchange hashpartitioning(../city#8, 200)
   +- HashAggregate(../keys=[city#8], functions=[partial_pivotfirst(../year#9, count(../1) AS `count`#222L, 2015, 2016, 2017, 0, 0)])
      +- *HashAggregate(../keys=[city#8, year#9], functions=[count(../1)])
         +- Exchange hashpartitioning(../city#8, year#9, 200)
            +- *HashAggregate(../keys=[city#8, year#9], functions=[partial_count(../1)])
               +- LocalTableScan [city#8, year#9]

scala> visits
  .groupBy(../'city)
  .pivot(../"year", Seq(../"2015")) // <-- one column in pivot table
  .count
  .show
+------+----+
|  city|2015|
+------+----+
|Warsaw|   1|
|Boston|null|
+------+----+
```

IMPORTANT: Use `pivot` with a list of distinct values to pivot on so Spark does not have to compute the list itself (and run three extra "scanning" jobs).

![pivot in web UI (../Distinct Values Defined Explicitly)](../images/spark-sql-pivot-webui.png)

![pivot in web UI -- Three Extra Scanning Jobs Due to Unspecified Distinct Values](../images/spark-sql-pivot-webui-scanning-jobs.png)

!!! note
    [spark.sql.pivotMaxValues](../configuration-properties.md#spark.sql.pivotMaxValues) controls the maximum number of (distinct) values that will be collected without error (when doing `pivot` without specifying the values for the pivot column).

Internally, `pivot` creates a `RelationalGroupedDataset` with `PivotType` group type and `pivotColumn` resolved using the DataFrame's columns with `values` as `Literal` expressions.

!!! note
    <<toDF, toDF>> internal method maps `PivotType` group type to a `DataFrame` with Pivot.md[Pivot] unary logical operator.

    ```text
    scala> q.queryExecution.logical
    res0: org.apache.spark.sql.catalyst.plans.logical.LogicalPlan =
    Pivot [city#8], year#9: int, [2015, 2016, 2017], [count(../1) AS count#24L]
    +- Project [_1#3 AS id#7, _2#4 AS city#8, _3#5 AS year#9]
      +- LocalRelation [_1#3, _2#4, _3#5]
    ```
-->
