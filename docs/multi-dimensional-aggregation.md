# Multi-Dimensional Aggregation

**Multi-dimensional aggregate operators** are enhanced variants of [groupBy](basic-aggregation.md#groupBy) operator to create queries for subtotals, grand totals and superset of subtotals in one go.

It is _assumed_ that using one of the operators is usually more efficient (than `union` and `groupBy`) as it gives more freedom for query optimization.

Beside [Dataset.cube](#cube) and [Dataset.rollup](#rollup) operators, Spark SQL supports [GROUPING SETS](#grouping-sets) clause in SQL mode only.

Support for multi-dimensional aggregate operators was added in [[SPARK-6356] Support the ROLLUP/CUBE/GROUPING SETS/grouping() in SQLContext](https://issues.apache.org/jira/browse/SPARK-6356).

## Operators

### <span id="cube"> cube

```scala
cube(
  cols: Column*): RelationalGroupedDataset
cube(
  col1: String,
  cols: String*): RelationalGroupedDataset
```

```sql
GROUP BY expressions WITH CUBE
GROUP BY CUBE(expressions)
```

`cube` multi-dimensional aggregate operator returns a [RelationalGroupedDataset](RelationalGroupedDataset.md) to calculate subtotals and a grand total for every permutation of the columns specified.

`cube` is an extension of [groupBy](basic-aggregation.md#groupBy) operator that allows calculating subtotals and a grand total across all combinations of specified group of `n + 1` dimensions (with `n` being the number of columns as `cols` and `col1` and `1` for where values become `null`, i.e. undefined).

`cube` returns [RelationalGroupedDataset](RelationalGroupedDataset.md) that you can use to execute aggregate function or operator.

!!! note "cube vs rollup"
    `cube` is more than [rollup](#rollup) operator, i.e. `cube` does `rollup` with aggregation over all the missing combinations given the columns.

### <span id="rollup"> rollup

```scala
rollup(
  cols: Column*): RelationalGroupedDataset
rollup(
  col1: String,
  cols: String*): RelationalGroupedDataset
```

```sql
GROUP BY expressions WITH ROLLUP
GROUP BY ROLLUP(expressions)
```

`rollup` gives a [RelationalGroupedDataset](RelationalGroupedDataset.md) to calculate subtotals and a grand total over (ordered) combination of groups.

`rollup` is an extension of [groupBy](basic-aggregation.md#groupBy) operator that calculates subtotals and a grand total across specified group of `n + 1` dimensions (with `n` being the number of columns as `cols` and `col1` and `1` for where values become `null`, i.e. undefined).

!!! note
    `rollup` operator is commonly used for analysis over hierarchical data; e.g. total salary by department, division, and company-wide total.

    See PostgreSQL's https://www.postgresql.org/docs/current/static/queries-table-expressions.html#QUERIES-GROUPING-SETS[7.2.4. GROUPING SETS, CUBE, and ROLLUP]

!!! note
    `rollup` operator is equivalent to `GROUP BY \... WITH ROLLUP` in SQL (which in turn is equivalent to `GROUP BY \... GROUPING SETS \((a,b,c),(a,b),(a),())` when used with 3 columns: `a`, `b`, and `c`).

From [Using GROUP BY with ROLLUP, CUBE, and GROUPING SETS](https://technet.microsoft.com/en-us/library/bb522495(v=sql.105).aspx) in Microsoft's TechNet:

> The ROLLUP, CUBE, and GROUPING SETS operators are extensions of the GROUP BY clause. The ROLLUP, CUBE, or GROUPING SETS operators can generate the same result set as when you use UNION ALL to combine single grouping queries; however, using one of the GROUP BY operators is usually more efficient.

From PostgreSQL's [7.2.4. GROUPING SETS, CUBE, and ROLLUP](https://www.postgresql.org/docs/current/static/queries-table-expressions.html#QUERIES-GROUPING-SETS):

> References to the grouping columns or expressions are replaced by null values in result rows for grouping sets in which those columns do not appear.

From [Summarizing Data Using ROLLUP](https://technet.microsoft.com/en-us/library/ms189305(v=sql.90).aspx) in Microsoft's TechNet:

> The ROLLUP operator is useful in generating reports that contain subtotals and totals. (...)
> ROLLUP generates a result set that shows aggregates for a hierarchy of values in the selected columns.

```text
// Borrowed from Microsoft's "Summarizing Data Using ROLLUP" article
val inventory = Seq(
  ("table", "blue", 124),
  ("table", "red", 223),
  ("chair", "blue", 101),
  ("chair", "red", 210)).toDF("item", "color", "quantity")

scala> inventory.show
+-----+-----+--------+
| item|color|quantity|
+-----+-----+--------+
|chair| blue|     101|
|chair|  red|     210|
|table| blue|     124|
|table|  red|     223|
+-----+-----+--------+

// ordering and empty rows done manually for demo purposes
scala> inventory.rollup("item", "color").sum().show
+-----+-----+-------------+
| item|color|sum(quantity)|
+-----+-----+-------------+
|chair| blue|          101|
|chair|  red|          210|
|chair| null|          311|
|     |     |             |
|table| blue|          124|
|table|  red|          223|
|table| null|          347|
|     |     |             |
| null| null|          658|
+-----+-----+-------------+
```

From Hive's [Cubes and Rollups](https://cwiki.apache.org/confluence/display/Hive/Enhanced+Aggregation,+Cube,+Grouping+and+Rollup#EnhancedAggregation,Cube,GroupingandRollup-CubesandRollups):

> WITH ROLLUP is used with the GROUP BY only. ROLLUP clause is used with GROUP BY to compute the aggregate at the hierarchy levels of a dimension.
>
> GROUP BY a, b, c with ROLLUP assumes that the hierarchy is "a" drilling down to "b" drilling down to "c".
>
> GROUP BY a, b, c, WITH ROLLUP is equivalent to GROUP BY a, b, c GROUPING SETS ( (a, b, c), (a, b), (a), ( )).

!!! note
    Read up on ROLLUP in Hive's LanguageManual in [Grouping Sets, Cubes, Rollups, and the GROUPING__ID Function](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+GroupBy#LanguageManualGroupBy-GroupingSets,Cubes,Rollups,andtheGROUPING__IDFunction).

```text
// Borrowed from http://stackoverflow.com/a/27222655/1305344
val quarterlyScores = Seq(
  ("winter2014", "Agata", 99),
  ("winter2014", "Jacek", 97),
  ("summer2015", "Agata", 100),
  ("summer2015", "Jacek", 63),
  ("winter2015", "Agata", 97),
  ("winter2015", "Jacek", 55),
  ("summer2016", "Agata", 98),
  ("summer2016", "Jacek", 97)).toDF("period", "student", "score")

scala> quarterlyScores.show
+----------+-------+-----+
|    period|student|score|
+----------+-------+-----+
|winter2014|  Agata|   99|
|winter2014|  Jacek|   97|
|summer2015|  Agata|  100|
|summer2015|  Jacek|   63|
|winter2015|  Agata|   97|
|winter2015|  Jacek|   55|
|summer2016|  Agata|   98|
|summer2016|  Jacek|   97|
+----------+-------+-----+

// ordering and empty rows done manually for demo purposes
scala> quarterlyScores.rollup("period", "student").sum("score").show
+----------+-------+----------+
|    period|student|sum(score)|
+----------+-------+----------+
|winter2014|  Agata|        99|
|winter2014|  Jacek|        97|
|winter2014|   null|       196|
|          |       |          |
|summer2015|  Agata|       100|
|summer2015|  Jacek|        63|
|summer2015|   null|       163|
|          |       |          |
|winter2015|  Agata|        97|
|winter2015|  Jacek|        55|
|winter2015|   null|       152|
|          |       |          |
|summer2016|  Agata|        98|
|summer2016|  Jacek|        97|
|summer2016|   null|       195|
|          |       |          |
|      null|   null|       706|
+----------+-------+----------+
```

From PostgreSQL's [7.2.4. GROUPING SETS, CUBE, and ROLLUP](https://www.postgresql.org/docs/current/static/queries-table-expressions.html#QUERIES-GROUPING-SETS):

> The individual elements of a CUBE or ROLLUP clause may be either individual expressions, or sublists of elements in parentheses. In the latter case, the sublists are treated as single units for the purposes of generating the individual grouping sets.

```text
// using struct function
scala> inventory.rollup(struct("item", "color") as "(item,color)").sum().show
+------------+-------------+
|(item,color)|sum(quantity)|
+------------+-------------+
| [table,red]|          223|
|[chair,blue]|          101|
|        null|          658|
| [chair,red]|          210|
|[table,blue]|          124|
+------------+-------------+
```

```text
// using expr function
scala> inventory.rollup(expr("(item, color)") as "(item, color)").sum().show
+-------------+-------------+
|(item, color)|sum(quantity)|
+-------------+-------------+
|  [table,red]|          223|
| [chair,blue]|          101|
|         null|          658|
|  [chair,red]|          210|
| [table,blue]|          124|
+-------------+-------------+
```

Internally, `rollup` [converts the Dataset into a DataFrame](spark-sql-dataset-operators.md#toDF) and then creates a [RelationalGroupedDataset](RelationalGroupedDataset.md) (with `RollupType` group type).

!!! tip
    Read up on `rollup` in [Deeper into Postgres 9.5 - New Group By Options for Aggregation](https://www.compose.com/articles/deeper-into-postgres-9-5-new-group-by-options-for-aggregation/).

## <span id="grouping-sets"> GROUPING SETS SQL Clause

```sql
GROUP BY (expressions) GROUPING SETS (expressions)
GROUP BY GROUPING SETS (expressions)
```

!!! note
    SQL's `GROUPING SETS` is the most general aggregate "operator" and can generate the same dataset as using a simple [groupBy](basic-aggregation.md#groupBy), [cube](#cube) and [rollup](#rollup) operators.

```text
import java.time.LocalDate
import java.sql.Date
val expenses = Seq(
  ((2012, Month.DECEMBER, 12), 5),
  ((2016, Month.AUGUST, 13), 10),
  ((2017, Month.MAY, 27), 15))
  .map { case ((yy, mm, dd), a) => (LocalDate.of(yy, mm, dd), a) }
  .map { case (d, a) => (d.toString, a) }
  .map { case (d, a) => (Date.valueOf(d), a) }
  .toDF("date", "amount")
scala> expenses.show
+----------+------+
|      date|amount|
+----------+------+
|2012-12-12|     5|
|2016-08-13|    10|
|2017-05-27|    15|
+----------+------+

// rollup time!
val q = expenses
  .rollup(year($"date") as "year", month($"date") as "month")
  .agg(sum("amount") as "amount")
  .sort($"year".asc_nulls_last, $"month".asc_nulls_last)
scala> q.show
+----+-----+------+
|year|month|amount|
+----+-----+------+
|2012|   12|     5|
|2012| null|     5|
|2016|    8|    10|
|2016| null|    10|
|2017|    5|    15|
|2017| null|    15|
|null| null|    30|
+----+-----+------+
```

`GROUPING SETS` clause generates a dataset that is equivalent to `union` operator of multiple [groupBy](basic-aggregation.md#groupBy) operators.

```text
val sales = Seq(
  ("Warsaw", 2016, 100),
  ("Warsaw", 2017, 200),
  ("Boston", 2015, 50),
  ("Boston", 2016, 150),
  ("Toronto", 2017, 50)
).toDF("city", "year", "amount")
sales.createOrReplaceTempView("sales")

// equivalent to rollup("city", "year")
val q = sql("""
  SELECT city, year, sum(amount) as amount
  FROM sales
  GROUP BY city, year
  GROUPING SETS ((city, year), (city), ())
  ORDER BY city DESC NULLS LAST, year ASC NULLS LAST
  """)
scala> q.show
+-------+----+------+
|   city|year|amount|
+-------+----+------+
| Warsaw|2016|   100|
| Warsaw|2017|   200|
| Warsaw|null|   300|
|Toronto|2017|    50|
|Toronto|null|    50|
| Boston|2015|    50|
| Boston|2016|   150|
| Boston|null|   200|
|   null|null|   550|  <-- grand total across all cities and years
+-------+----+------+

// equivalent to cube("city", "year")
// note the additional (year) grouping set
val q = sql("""
  SELECT city, year, sum(amount) as amount
  FROM sales
  GROUP BY city, year
  GROUPING SETS ((city, year), (city), (year), ())
  ORDER BY city DESC NULLS LAST, year ASC NULLS LAST
  """)
scala> q.show
+-------+----+------+
|   city|year|amount|
+-------+----+------+
| Warsaw|2016|   100|
| Warsaw|2017|   200|
| Warsaw|null|   300|
|Toronto|2017|    50|
|Toronto|null|    50|
| Boston|2015|    50|
| Boston|2016|   150|
| Boston|null|   200|
|   null|2015|    50|  <-- total across all cities in 2015
|   null|2016|   250|  <-- total across all cities in 2016
|   null|2017|   250|  <-- total across all cities in 2017
|   null|null|   550|
+-------+----+------+
```

`GROUPING SETS` clause is parsed in [withAggregation](sql/AstBuilder.md#withAggregation) parsing handler (in `AstBuilder`) and becomes a [GroupingSets](logical-operators/GroupingSets.md) logical operator internally.

## Demo

### <span id="grouping-sets-demo"> GROUPING SETS

```text
val sales = Seq(
  ("Warsaw", 2016, 100),
  ("Warsaw", 2017, 200),
  ("Boston", 2015, 50),
  ("Boston", 2016, 150),
  ("Toronto", 2017, 50)
).toDF("city", "year", "amount")
```

```text
// very labor-intense
// groupBy's unioned
val groupByCityAndYear = sales
  .groupBy("city", "year")  // <-- subtotals (city, year)
  .agg(sum("amount") as "amount")
val groupByCityOnly = sales
  .groupBy("city")          // <-- subtotals (city)
  .agg(sum("amount") as "amount")
  .select($"city", lit(null) as "year", $"amount")  // <-- year is null
val withUnion = groupByCityAndYear
  .union(groupByCityOnly)
  .sort($"city".desc_nulls_last, $"year".asc_nulls_last)
```

```text
scala> withUnion.show
+-------+----+------+
|   city|year|amount|
+-------+----+------+
| Warsaw|2016|   100|
| Warsaw|2017|   200|
| Warsaw|null|   300|
|Toronto|2017|    50|
|Toronto|null|    50|
| Boston|2015|    50|
| Boston|2016|   150|
| Boston|null|   200|
+-------+----+------+
```

Multi-dimensional aggregate operators are semantically equivalent to `union` operator (or SQL's `UNION ALL`) to combine single grouping queries.

```scala
// Roll up your sleeves!
val withRollup = sales
  .rollup("city", "year")
  .agg(sum("amount") as "amount", grouping_id() as "gid")
  .sort($"city".desc_nulls_last, $"year".asc_nulls_last)
  .filter(grouping_id() =!= 3)
  .select("city", "year", "amount")
```

```text
scala> withRollup.show
+-------+----+------+
|   city|year|amount|
+-------+----+------+
| Warsaw|2016|   100|
| Warsaw|2017|   200|
| Warsaw|null|   300|
|Toronto|2017|    50|
|Toronto|null|    50|
| Boston|2015|    50|
| Boston|2016|   150|
| Boston|null|   200|
+-------+----+------+
```

```text
// Be even more smarter?
// SQL only, alas.
sales.createOrReplaceTempView("sales")
val withGroupingSets = sql("""
  SELECT city, year, SUM(amount) as amount
  FROM sales
  GROUP BY city, year
  GROUPING SETS ((city, year), (city))
  ORDER BY city DESC NULLS LAST, year ASC NULLS LAST
  """)
scala> withGroupingSets.show
+-------+----+------+
|   city|year|amount|
+-------+----+------+
| Warsaw|2016|   100|
| Warsaw|2017|   200|
| Warsaw|null|   300|
|Toronto|2017|    50|
|Toronto|null|    50|
| Boston|2015|    50|
| Boston|2016|   150|
| Boston|null|   200|
+-------+----+------+
```

### <span id="rollup-demo"> Rollup

```text
val sales = Seq(
  ("Warsaw", 2016, 100),
  ("Warsaw", 2017, 200),
  ("Boston", 2015, 50),
  ("Boston", 2016, 150),
  ("Toronto", 2017, 50)
).toDF("city", "year", "amount")

val q = sales
  .rollup("city", "year")
  .agg(sum("amount") as "amount")
  .sort($"city".desc_nulls_last, $"year".asc_nulls_last)
scala> q.show
+-------+----+------+
|   city|year|amount|
+-------+----+------+
| Warsaw|2016|   100| <-- subtotal for Warsaw in 2016
| Warsaw|2017|   200|
| Warsaw|null|   300| <-- subtotal for Warsaw (across years)
|Toronto|2017|    50|
|Toronto|null|    50|
| Boston|2015|    50|
| Boston|2016|   150|
| Boston|null|   200|
|   null|null|   550| <-- grand total
+-------+----+------+

// The above query is semantically equivalent to the following
val q1 = sales
  .groupBy("city", "year")  // <-- subtotals (city, year)
  .agg(sum("amount") as "amount")
val q2 = sales
  .groupBy("city")          // <-- subtotals (city)
  .agg(sum("amount") as "amount")
  .select($"city", lit(null) as "year", $"amount")  // <-- year is null
val q3 = sales
  .groupBy()                // <-- grand total
  .agg(sum("amount") as "amount")
  .select(lit(null) as "city", lit(null) as "year", $"amount")  // <-- city and year are null
val qq = q1
  .union(q2)
  .union(q3)
  .sort($"city".desc_nulls_last, $"year".asc_nulls_last)
scala> qq.show
+-------+----+------+
|   city|year|amount|
+-------+----+------+
| Warsaw|2016|   100|
| Warsaw|2017|   200|
| Warsaw|null|   300|
|Toronto|2017|    50|
|Toronto|null|    50|
| Boston|2015|    50|
| Boston|2016|   150|
| Boston|null|   200|
|   null|null|   550|
+-------+----+------+
```

### <span id="cube-demo"> Cube

```text
val sales = Seq(
  ("Warsaw", 2016, 100),
  ("Warsaw", 2017, 200),
  ("Boston", 2015, 50),
  ("Boston", 2016, 150),
  ("Toronto", 2017, 50)
).toDF("city", "year", "amount")

val q = sales.cube("city", "year")
  .agg(sum("amount") as "amount")
  .sort($"city".desc_nulls_last, $"year".asc_nulls_last)
scala> q.show
+-------+----+------+
|   city|year|amount|
+-------+----+------+
| Warsaw|2016|   100|  <-- total in Warsaw in 2016
| Warsaw|2017|   200|  <-- total in Warsaw in 2017
| Warsaw|null|   300|  <-- total in Warsaw (across all years)
|Toronto|2017|    50|
|Toronto|null|    50|
| Boston|2015|    50|
| Boston|2016|   150|
| Boston|null|   200|
|   null|2015|    50|  <-- total in 2015 (across all cities)
|   null|2016|   250|
|   null|2017|   250|
|   null|null|   550|  <-- grand total (across cities and years)
+-------+----+------+
```
