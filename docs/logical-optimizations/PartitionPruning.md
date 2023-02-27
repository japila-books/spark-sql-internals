# PartitionPruning Logical Optimization

`PartitionPruning` is a logical optimization for [Dynamic Partition Pruning](../dynamic-partition-pruning/index.md).

`PartitionPruning` is a `Rule[LogicalPlan]` (a [Catalyst Rule](../catalyst/Rule.md) for [logical operators](../logical-operators/LogicalPlan.md)).

`PartitionPruning` is part of the [PartitionPruning](../SparkOptimizer.md#PartitionPruning) batch of the [SparkOptimizer](../SparkOptimizer.md#defaultBatches).

## <span id="apply"> Executing Rule

??? note "Signature"

    ```scala
    apply(
      plan: LogicalPlan): LogicalPlan
    ```

    `apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

!!! note "A no-op"
    `apply` is a _noop_ (does nothing and returns the given [LogicalPlan](../logical-operators/LogicalPlan.md)) when executed with one of the following:

    * `Subquery` operators that are `correlated`
    * [spark.sql.optimizer.dynamicPartitionPruning.enabled](../configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.enabled) configuration property is disabled

`apply` [prunes](#prune) the given [LogicalPlan](../logical-operators/LogicalPlan.md).

## <span id="prune"> Pruning

```scala
prune(
  plan: LogicalPlan): LogicalPlan
```

`prune` transforms up all logical operators in the given [logical query plan](../logical-operators/LogicalPlan.md).

`prune` skips [Join](../logical-operators/Join.md) logical operators (leaves unmodified) when either left or right child operators are `Filter`s with [DynamicPruningSubquery](../expressions/DynamicPruningSubquery.md) condition.

`prune` transforms [Join](../logical-operators/Join.md) operators with [EqualTo](../expressions/EqualTo.md) join conditions.

??? note "FIXME More Work Needed"
    `prune` needs more love and would benefit from more insight on how it works.

## <span id="getFilterableTableScan"> getFilterableTableScan

```scala
getFilterableTableScan(
  a: Expression,
  plan: LogicalPlan): Option[LogicalPlan]
```

`getFilterableTableScan` [findExpressionAndTrackLineageDown](#findExpressionAndTrackLineageDown) (that finds a [LeafNode](../logical-operators/LeafNode.md) with the [output](../catalyst/QueryPlan.md#output) schema that includes all the [Attribute](../expressions/Attribute.md) references of the given [Expression](../expressions/Expression.md)).

!!! note "Leaf Nodes"
    `getFilterableTableScan` is only interested in the following [leaf logical operators](../logical-operators/LeafNode.md):

    * [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md) over `SupportsRuntimeFiltering` scans
    * [HiveTableRelation](../hive/HiveTableRelation.md)
    * [LogicalRelation](../logical-operators/LogicalRelation.md) over [HadoopFsRelation](../datasources/HadoopFsRelation.md)

`getFilterableTableScan`...FIXME

### <span id="getFilterableTableScan-LogicalRelation"> LogicalRelation over (Partitioned) HadoopFsRelation

For [LogicalRelation](../logical-operators/LogicalRelation.md) with (the [relation](../logical-operators/LogicalRelation.md#relation) that is) a partitioned [HadoopFsRelation](../datasources/HadoopFsRelation.md), `getFilterableTableScan` checks if the [references](../expressions/Expression.md#references) (of the given [Expression](../expressions/Expression.md)) are all among the [partition columns](../datasources/HadoopFsRelation.md#partitionSchema).

If so, `getFilterableTableScan` returns the `LogicalRelation` with the partitioned `HadoopFsRelation`.

## <span id="hasPartitionPruningFilter"> hasPartitionPruningFilter

```scala
hasPartitionPruningFilter(
  plan: LogicalPlan): Boolean
```

!!! note
    `hasPartitionPruningFilter` is [hasSelectivePredicate](#hasSelectivePredicate) with a [streaming check](../logical-operators/LogicalPlan.md#isStreaming) to make sure it disregards streaming queries.

`hasPartitionPruningFilter` is `true` when all of the following hold true:

1. The given [LogicalPlan](../logical-operators/LogicalPlan.md) is not [streaming](../logical-operators/LogicalPlan.md#isStreaming)
1. [hasSelectivePredicate](#hasSelectivePredicate)

## <span id="hasSelectivePredicate"> hasSelectivePredicate

```scala
hasSelectivePredicate(
  plan: LogicalPlan): Boolean
```

`hasSelectivePredicate` is `true` when there is a `Filter` logical operator with a [likely-selective](../PredicateHelper.md#isLikelySelective) filter condition.

## <span id="insertPredicate"> Inserting Predicate with DynamicPruningSubquery Expression

```scala
insertPredicate(
  pruningKey: Expression,
  pruningPlan: LogicalPlan,
  filteringKey: Expression,
  filteringPlan: LogicalPlan,
  joinKeys: Seq[Expression],
  partScan: LogicalPlan): LogicalPlan
```

With [spark.sql.exchange.reuse](../configuration-properties.md#spark.sql.exchange.reuse) enabled and [pruningHasBenefit](#pruningHasBenefit), `insertPredicate` creates (_inserts into the given pruning plan_) a `Filter` logical operator with a [DynamicPruningSubquery](../expressions/DynamicPruningSubquery.md) expression (with [onlyInBroadcast](../expressions/DynamicPruningSubquery.md#onlyInBroadcast) flag based on [spark.sql.optimizer.dynamicPartitionPruning.reuseBroadcastOnly](../configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.reuseBroadcastOnly) and [pruningHasBenefit](#pruningHasBenefit)).

Otherwise, `insertPredicate` returns the given `pruningPlan` logical query plan unchanged.

!!! note "Configuration Properties"
    `insertPredicate` is configured using the following:

    * [spark.sql.exchange.reuse](../configuration-properties.md#spark.sql.exchange.reuse)
    * [spark.sql.optimizer.dynamicPartitionPruning.reuseBroadcastOnly](../configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.reuseBroadcastOnly)

## <span id="pruningHasBenefit"> pruningHasBenefit

```scala
pruningHasBenefit(
  partExpr: Expression,
  partPlan: LogicalPlan,
  otherExpr: Expression,
  otherPlan: LogicalPlan): Boolean
```

!!! note "Column Statistics"
    `pruningHasBenefit` uses [Column Statistics](../cost-based-optimization/Statistics.md#attributeStats) (for the [number of distinct values](../cost-based-optimization/ColumnStat.md#distinctCount)), if available and [spark.sql.optimizer.dynamicPartitionPruning.useStats](../configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.useStats) is enabled.

`pruningHasBenefit` computes a filtering ratio based on the columns (references) in the given `partExpr` and `otherExpr` expressions.

!!! note "One Column Reference Only"
    `pruningHasBenefit` supports one column reference only in the given `partExpr` and `otherExpr` expressions.

With [spark.sql.optimizer.dynamicPartitionPruning.useStats](../configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.useStats) enabled, `pruningHasBenefit` uses the [Distinct Count](../cost-based-optimization/ColumnStat.md#distinctCount) statistic ([CBO stats](../cost-based-optimization/Statistics.md)) for each attribute (in the join condition).

The filtering ratio is the ratio of [Distinct Count](../cost-based-optimization/ColumnStat.md#distinctCount) of `rightAttr` to [Distinct Count](../cost-based-optimization/ColumnStat.md#distinctCount) of `leftAttr` (_remaining of 1_) unless:

1. [Distinct Count](../cost-based-optimization/ColumnStat.md#distinctCount) are not available or `leftAttr`'s `Distinct Count` is `0` or negative
1. [Distinct Count](../cost-based-optimization/ColumnStat.md#distinctCount) of `leftAttr` is the same or lower than of `otherDistinctCount`
1. There are more than one attribute in `partExpr` or `otherExpr` expressions

For such cases, the filtering ratio is [spark.sql.optimizer.dynamicPartitionPruning.fallbackFilterRatio](../configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.fallbackFilterRatio).

`pruningHasBenefit` calculates `estimatePruningSideSize` as the filtering ratio of [sizeInBytes](../cost-based-optimization/Statistics.md#sizeInBytes) statistic of the given `partPlan`.

`pruningHasBenefit` is enabled (`true`) when `estimatePruningSideSize` is greater than [calculatePlanOverhead](#calculatePlanOverhead) of the given `otherPlan` logical plan.

## Demo

```text
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 3.4.0
      /_/

Using Scala version 2.13.8 (OpenJDK 64-Bit Server VM, Java 17.0.6)
```

### Create Partitioned Tables

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

### Schema

```text
scala> facts.printSchema()
root
 |-- id: long (nullable = true)
 |-- value: double (nullable = true)
 |-- part_id: long (nullable = true)
```

```text
scala> dims.printSchema()
root
 |-- id: long (nullable = true)
 |-- name: string (nullable = true)
```

### Selective Join Query

```scala
val q = facts.join(dims)
  .where(facts("part_id") === dims("id"))
  .where(dims("id") isin (0, 1))

q.write.format("noop").mode("overwrite").save
```

### Filters in Query Plan

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
