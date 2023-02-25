# Statistics

`Statistics` holds the following estimates of a logical operator:

* <span id="sizeInBytes"> Total (output) size (in bytes)
* [Estimated number of rows](#rowCount)
* <span id="attributeStats"> [Column Statistics](../cost-based-optimization/ColumnStat.md) (_column (equi-height) histograms_)

!!! note
    **Cost statistics**, **plan statistics** or **query statistics** are synonyms and used interchangeably.

`Statistics` is created when:

* `CatalogStatistics` is requested to [convert metastore statistics](../CatalogStatistics.md#toPlanStats)
* [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md), [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md), [ExternalRDD](../logical-operators/ExternalRDD.md), [LocalRelation](../logical-operators/LocalRelation.md), [LogicalRDD](../logical-operators/LogicalRDD.md), [LogicalRelation](../logical-operators/LogicalRelation.md), `Range`, `OneRowRelation` logical operators are requested to `computeStats`
* `AggregateEstimation` and [JoinEstimation](../cost-based-optimization/JoinEstimation.md) are requested to `estimate`
* [SizeInBytesOnlyStatsPlanVisitor](SizeInBytesOnlyStatsPlanVisitor.md) is executed
* [QueryStageExec](../physical-operators/QueryStageExec.md) physical operator is requested to `computeStats`
* [DetermineTableStats](../hive/DetermineTableStats.md) logical resolution rule is executed

## <span id="rowCount"> Row Count

**Row Count** estimate is used in [CostBasedJoinReorder](../logical-optimizations/CostBasedJoinReorder.md) logical optimization for [Cost-Based Optimization](index.md).

## Statistics and CatalogStatistics

[CatalogStatistics](../CatalogStatistics.md) is a "subset" of all possible `Statistics` (as there are no concepts of [attributes](#attributeStats) in [metastore](../ExternalCatalog.md)).

`CatalogStatistics` are statistics stored in an external catalog (usually a Hive metastore) and are often referred as **Hive statistics** while `Statistics` represents the **Spark statistics**.

## Accessing Statistics of Logical Operator

Statistics of a logical plan are available using [stats](../cost-based-optimization/LogicalPlanStats.md#stats) property.

```text
val q = spark.range(5).hint("broadcast").join(spark.range(1), "id")
val plan = q.queryExecution.optimizedPlan
val stats = plan.stats

scala> :type stats
org.apache.spark.sql.catalyst.plans.logical.Statistics

scala> println(stats.simpleString)
sizeInBytes=213.0 B, hints=none
```

!!! note
    Use [ANALYZE TABLE COMPUTE STATISTICS](../cost-based-optimization/index.md#ANALYZE-TABLE) SQL command to compute [total size](#sizeInBytes) and [row count](#rowCount) statistics of a table.

!!! note
    Use [ANALYZE TABLE COMPUTE STATISTICS FOR COLUMNS](../cost-based-optimization/index.md#ANALYZE-TABLE) SQL Command to generate [column (equi-height) histograms](#attributeStats) of a table.

## <span id="simpleString"><span id="toString"> Textual Representation

```scala
toString: String
```

`toString` gives **textual representation** of the `Statistics`.

```text
import org.apache.spark.sql.catalyst.plans.logical.Statistics
import org.apache.spark.sql.catalyst.plans.logical.HintInfo
val stats = Statistics(sizeInBytes = 10, rowCount = Some(20))

scala> println(stats)
Statistics(sizeInBytes=10.0 B, rowCount=20)
```
