---
title: Dynamic Partition Pruning
hide:
  - navigation
---

# Demo: Dynamic Partition Pruning

This demo shows [Dynamic Partition Pruning](../dynamic-partition-pruning/index.md) in action.

```text
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 3.4.0
      /_/

Using Scala version 2.13.8 (OpenJDK 64-Bit Server VM, Java 17.0.6)
```

## Before you begin

Enable the following loggers:

* [DataSourceStrategy](../execution-planning-strategies/DataSourceStrategy.md#logging)

## Create Partitioned Tables

```scala
import org.apache.spark.sql.functions._
spark.range(4000)
  .withColumn("part_id", 'id % 4)
  .withColumn("value", rand() * 100)
  .write
  .partitionBy("part_id")
  .saveAsTable("dpp_facts_large")
```

```scala
import org.apache.spark.sql.functions._
spark.range(4)
  .withColumn("name", concat(lit("name_"), 'id))
  .write
  .saveAsTable("dpp_dims_small")
```

```scala
val facts = spark.table("dpp_facts_large")
val dims = spark.table("dpp_dims_small")
```

=== "Scala"

    ```scala
    facts.printSchema()
    ```

=== "SQL (FIXME)"
    FIXME

```text
root
 |-- id: long (nullable = true)
 |-- value: double (nullable = true)
 |-- part_id: long (nullable = true)
```

=== "Scala"

    ```scala
    dims.printSchema()
    ```

=== "SQL (FIXME)"
    FIXME

```text
root
|-- id: long (nullable = true)
|-- name: string (nullable = true)
```

## Selective Join Query

```scala
val q = facts.join(dims)
  .where(facts("part_id") === dims("id"))
  .where(dims("id") isin (0, 1))
```

Execute the query (using [Noop Data Source](../datasources/noop/index.md)).

```scala
q.write.format("noop").mode("overwrite").save
```

[DataSourceStrategy](../execution-planning-strategies/DataSourceStrategy.md) should print out the following INFO messages to the logs:

```text
Pruning directories with: part_id#2L IN (0,1),isnotnull(part_id#2L),dynamicpruning#22 [part_id#2L]
Pruning directories with: part_id#2L IN (0,1),isnotnull(part_id#2L),dynamicpruning#22 [part_id#2L]
```

=== "Scala"

    ```scala
    q.explain()
    ```

```text
== Physical Plan ==
AdaptiveSparkPlan isFinalPlan=false
+- BroadcastHashJoin [part_id#27L], [id#31L], Inner, BuildRight, false
   :- FileScan parquet spark_catalog.default.dpp_facts_large[id#25L,value#26,part_id#27L] Batched: true, DataFilters: [], Format: Parquet, Location: InMemoryFileIndex(2 paths)[file:/Users/jacek/dev/oss/spark/spark-warehouse/dpp_facts_large/part_i..., PartitionFilters: [part_id#27L IN (0,1), isnotnull(part_id#27L), dynamicpruningexpression(part_id#27L IN dynamicpru..., PushedFilters: [], ReadSchema: struct<id:bigint,value:double>
   :     +- SubqueryAdaptiveBroadcast dynamicpruning#49, 0, true, Filter (id#31L IN (0,1) AND isnotnull(id#31L)), [id#31L]
   :        +- AdaptiveSparkPlan isFinalPlan=false
   :           +- Filter (id#31L IN (0,1) AND isnotnull(id#31L))
   :              +- FileScan parquet spark_catalog.default.dpp_dims_small[id#31L,name#32] Batched: true, DataFilters: [id#31L IN (0,1), isnotnull(id#31L)], Format: Parquet, Location: InMemoryFileIndex(1 paths)[file:/Users/jacek/dev/oss/spark/spark-warehouse/dpp_dims_small], PartitionFilters: [], PushedFilters: [In(id, [0,1]), IsNotNull(id)], ReadSchema: struct<id:bigint,name:string>
   +- BroadcastExchange HashedRelationBroadcastMode(List(input[0, bigint, false]),false), [plan_id=175]
      +- Filter (id#31L IN (0,1) AND isnotnull(id#31L))
         +- FileScan parquet spark_catalog.default.dpp_dims_small[id#31L,name#32] Batched: true, DataFilters: [id#31L IN (0,1), isnotnull(id#31L)], Format: Parquet, Location: InMemoryFileIndex(1 paths)[file:/Users/jacek/dev/oss/spark/spark-warehouse/dpp_dims_small], PartitionFilters: [], PushedFilters: [In(id, [0,1]), IsNotNull(id)], ReadSchema: struct<id:bigint,name:string>
```

Note the value of the [isFinalPlan](../physical-operators/AdaptiveSparkPlanExec.md#isFinalPlan) flag being `false`.

## Filters in Query Plan

`PartitionFilters` in the `Scan` operator over `dpp_facts_large` table should include `dims("id") isin (0, 1)` predicate.

``` text hl_lines="5"
(1) Scan parquet spark_catalog.default.dpp_facts_large
Output [3]: [id#25L, value#26, part_id#27L]
Batched: true
Location: InMemoryFileIndex [file:/Users/jacek/dev/oss/spark/spark-warehouse/dpp_facts_large/part_id=0, ... 1 entries]
PartitionFilters: [part_id#27L IN (0,1), isnotnull(part_id#27L), dynamicpruningexpression(part_id#27L IN dynamicpruning#47)]
ReadSchema: struct<id:bigint,value:double>
```

`PushedFilters` in the `Scan` operator over `dpp_dims_small` table should include `In(id, [0,1])` predicate.

``` text hl_lines="5"
(3) Scan parquet spark_catalog.default.dpp_dims_small
Output [2]: [id#31L, name#32]
Batched: true
Location: InMemoryFileIndex [file:/Users/jacek/dev/oss/spark/spark-warehouse/dpp_dims_small]
PushedFilters: [In(id, [0,1]), IsNotNull(id)]
ReadSchema: struct<id:bigint,name:string>
```
