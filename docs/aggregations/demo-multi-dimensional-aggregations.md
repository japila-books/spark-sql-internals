# Demo: Mult-Dimensional Aggregations

## GROUPING SETS { #grouping-sets }

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

## Rollup

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

## Cube

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
