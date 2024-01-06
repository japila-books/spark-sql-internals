---
title: PrunedFilteredScan
---

# PrunedFilteredScan &mdash; Relations with Column Pruning and Filter Pushdown

`PrunedFilteredScan` is an [abstraction](#contract) of [BaseRelations](#implementations) that support [column pruning](#buildScan) (_eliminating unneeded columns_) and [filter pushdown](#buildScan) (_filtering using selected predicates only_).

## Contract

### Building Distributed Scan { #buildScan }

```scala
buildScan(
  requiredColumns: Array[String],
  filters: Array[Filter]): RDD[Row]
```

Builds a distributed data scan (`RDD[Row]`) with column pruning and filter pushdown

!!! note
    `PrunedFilteredScan` is a "lighter" and stable version of the `CatalystScan` abstraction.

See:

* [JDBCRelation](jdbc/JDBCRelation.md#buildScan)
* `DeltaCDFRelation` ([Delta Lake]({{ book.delta }}/change-data-feed/DeltaCDFRelation/#buildScan))

Used when:

* `DataSourceStrategy` execution planning strategy is requested to [plan a LogicalRelation over a PrunedFilteredScan](execution-planning-strategies/DataSourceStrategy.md#apply)

## Implementations

* [JDBCRelation](jdbc/JDBCRelation.md)
* `DeltaCDFRelation` ([Delta Lake]({{ book.delta }}/change-data-feed/DeltaCDFRelation/))

## Example

```scala
// Use :paste to define MyBaseRelation case class
// BEGIN
import org.apache.spark.sql.sources.PrunedFilteredScan
import org.apache.spark.sql.sources.BaseRelation
import org.apache.spark.sql.types.{StructField, StructType, StringType}
import org.apache.spark.sql.SQLContext
import org.apache.spark.sql.sources.Filter
import org.apache.spark.rdd.RDD
import org.apache.spark.sql.Row
case class MyBaseRelation(sqlContext: SQLContext) extends BaseRelation with PrunedFilteredScan {
  override def schema: StructType = StructType(StructField("a", StringType) :: Nil)
  def buildScan(requiredColumns: Array[String], filters: Array[Filter]): RDD[Row] = {
    println(s">>> [buildScan] requiredColumns = ${requiredColumns.mkString(",")}")
    println(s">>> [buildScan] filters = ${filters.mkString(",")}")
    import sqlContext.implicits._
    (0 to 4).toDF.rdd
  }
}
// END
```

```scala
val scan = MyBaseRelation(spark.sqlContext)

import org.apache.spark.sql.catalyst.plans.logical.LogicalPlan
import org.apache.spark.sql.execution.datasources.LogicalRelation
val plan: LogicalPlan = LogicalRelation(scan)
```

```text
scala> println(plan.numberedTreeString)
00 Relation[a#1] MyBaseRelation(org.apache.spark.sql.SQLContext@4a57ad67)
```

```scala
import org.apache.spark.sql.execution.datasources.DataSourceStrategy
val strategy = DataSourceStrategy(spark.sessionState.conf)

val sparkPlan = strategy(plan).head
```

```text
// >>> [buildScan] requiredColumns = a
// >>> [buildScan] filters =
```

```text
scala> println(sparkPlan.numberedTreeString)
00 Scan MyBaseRelation(org.apache.spark.sql.SQLContext@4a57ad67) [a#8] PushedFilters: [], ReadSchema: struct<a:string>
```
