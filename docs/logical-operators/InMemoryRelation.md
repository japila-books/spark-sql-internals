# InMemoryRelation Leaf Logical Operator

`InMemoryRelation` is a [leaf logical operator](LeafNode.md) that represents a structured query that is cached in memory (when `CacheManager` is requested to [cache it](../CacheManager.md#cacheQuery)).

`InMemoryRelation` uses [spark.sql.cache.serializer](../configuration-properties.md#spark.sql.cache.serializer) configuration property to [create a CachedBatchSerializer](#getSerializer).

## Creating Instance

`InMemoryRelation` takes the following to be created:

* <span id="output"> Output ([Attribute](../expressions/Attribute.md)s)
* [CachedRDDBuilder](#cacheBuilder)
* <span id="outputOrdering"> Output [Ordering](../expressions/SortOrder.md) (`Seq[SortOrder]`)

`InMemoryRelation` is created using [apply](#apply) factory methods.

### <span id="cacheBuilder"> CachedRDDBuilder

`InMemoryRelation` can be given a [CachedRDDBuilder](../cache-serialization/CachedRDDBuilder.md) when [created](#creating-instance) (using [apply](#apply)).

`InMemoryRelation` is `@transient` (so it won't be preseved when this operator has been serialized).

The `CachedRDDBuilder` is used by the following:

* [CacheManager](../CacheManager.md)
* [InMemoryTableScanExec](../physical-operators/InMemoryTableScanExec.md) physical operator

The `CachedRDDBuilder` is used to access [storageLevel](../cache-serialization/CachedRDDBuilder.md#storageLevel) when (when the `Dataset` is [cached](../CacheManager.md#lookupCachedData)):

* [Dataset.storageLevel](../Dataset.md#storageLevel) operator is used
* `AlterTableRenameCommand` is executed
* `DataSourceV2Strategy` execution planning strategy is requested to [invalidateTableCache](../execution-planning-strategies/DataSourceV2Strategy.md#invalidateTableCache) (to plan a `RenameTable` unary logical command)
* [PartitionPruning](../logical-optimizations/PartitionPruning.md) logical optimization is executed (and [calculatePlanOverhead](../logical-optimizations/PartitionPruning.md#calculatePlanOverhead))

## Demo

```text
// Cache sample table range5 using pure SQL
// That registers range5 to contain the output of range(5) function
spark.sql("CACHE TABLE range5 AS SELECT * FROM range(5)")
val q1 = spark.sql("SELECT * FROM range5")
scala> q1.explain
== Physical Plan ==
InMemoryTableScan [id#0L]
   +- InMemoryRelation [id#0L], true, 10000, StorageLevel(disk, memory, deserialized, 1 replicas), `range5`
         +- *Range (0, 5, step=1, splits=8)

// you could also use optimizedPlan to see InMemoryRelation
scala> println(q1.queryExecution.optimizedPlan.numberedTreeString)
00 InMemoryRelation [id#0L], true, 10000, StorageLevel(disk, memory, deserialized, 1 replicas), `range5`
01    +- *Range (0, 5, step=1, splits=8)

// Use Dataset's cache
val q2 = spark.range(10).groupBy('id % 5).count.cache
scala> println(q2.queryExecution.optimizedPlan.numberedTreeString)
00 InMemoryRelation [(id % 5)#84L, count#83L], true, 10000, StorageLevel(disk, memory, deserialized, 1 replicas)
01    +- *HashAggregate(keys=[(id#77L % 5)#88L], functions=[count(1)], output=[(id % 5)#84L, count#83L])
02       +- Exchange hashpartitioning((id#77L % 5)#88L, 200)
03          +- *HashAggregate(keys=[(id#77L % 5) AS (id#77L % 5)#88L], functions=[partial_count(1)], output=[(id#77L % 5)#88L, count#90L])
04             +- *Range (0, 10, step=1, splits=8)
```

## MultiInstanceRelation

`InMemoryRelation` is a [MultiInstanceRelation](MultiInstanceRelation.md) so a [new instance will be created](#newInstance) to appear multiple times in a physical query plan.

```text
val q = spark.range(10).cache

// Make sure that q Dataset is cached
val cache = spark.sharedState.cacheManager
scala> cache.lookupCachedData(q.queryExecution.logical).isDefined
res0: Boolean = true

scala> q.explain
== Physical Plan ==
InMemoryTableScan [id#122L]
   +- InMemoryRelation [id#122L], true, 10000, StorageLevel(disk, memory, deserialized, 1 replicas)
         +- *Range (0, 10, step=1, splits=8)

val qCrossJoined = q.crossJoin(q)
scala> println(qCrossJoined.queryExecution.optimizedPlan.numberedTreeString)
00 Join Cross
01 :- InMemoryRelation [id#122L], true, 10000, StorageLevel(disk, memory, deserialized, 1 replicas)
02 :     +- *Range (0, 10, step=1, splits=8)
03 +- InMemoryRelation [id#170L], true, 10000, StorageLevel(disk, memory, deserialized, 1 replicas)
04       +- *Range (0, 10, step=1, splits=8)

// Use sameResult for comparison
// since the plans use different output attributes
// and have to be canonicalized internally
import org.apache.spark.sql.execution.columnar.InMemoryRelation
val optimizedPlan = qCrossJoined.queryExecution.optimizedPlan
scala> optimizedPlan.children(0).sameResult(optimizedPlan.children(1))
res1: Boolean = true
```

## <span id="simpleString"> Simple Text Representation

The [simple text representation](../catalyst/QueryPlan.md#simpleString) of an `InMemoryRelation` (aka `simpleString`) uses the [output](#output) and the [CachedRDDBuilder](#cacheBuilder)):

```text
InMemoryRelation [output], [storageLevel]
```

```text
val q = spark.range(1).cache
val logicalPlan = q.queryExecution.withCachedData
scala> println(logicalPlan.simpleString)
InMemoryRelation [id#40L], StorageLevel(disk, memory, deserialized, 1 replicas)
```

## Query Planning and InMemoryTableScanExec Physical Operator

`InMemoryRelation` is resolved to [InMemoryTableScanExec](../physical-operators/InMemoryTableScanExec.md) leaf physical operator when [InMemoryScans](../execution-planning-strategies/InMemoryScans.md) execution planning strategy is executed.

## <span id="apply"> Creating InMemoryRelation

```scala
apply(
  serializer: CachedBatchSerializer,
  storageLevel: StorageLevel,
  child: SparkPlan,
  tableName: Option[String],
  optimizedPlan: LogicalPlan): InMemoryRelation // (1)!
apply(
  cacheBuilder: CachedRDDBuilder,
  qe: QueryExecution): InMemoryRelation
apply(
  output: Seq[Attribute],
  cacheBuilder: CachedRDDBuilder,
  outputOrdering: Seq[SortOrder],
  statsOfPlanToCache: Statistics): InMemoryRelation
apply(
  storageLevel: StorageLevel,
  qe: QueryExecution,
  tableName: Option[String]): InMemoryRelation
```

1. Intended and used only in tests

`apply` creates an [InMemoryRelation](#creating-instance) logical operator with the following:

Property | Value
---------|------
 [output](#output) | The [output](../catalyst/QueryPlan.md#output) of the [executedPlan physical query plan](../QueryExecution.md#executedPlan) (possibly [convertToColumnarIfPossible](#convertToColumnarIfPossible) if the `CachedBatchSerializer` [supportsColumnarInput](#supportsColumnarInput))
 [CachedRDDBuilder](#cacheBuilder) | A new [CachedRDDBuilder](../cache-serialization/CachedRDDBuilder.md)
 [outputOrdering](#outputOrdering) | The [outputOrdering](../catalyst/QueryPlan.md#outputOrdering) of the [optimized logical query plan](../QueryExecution.md#optimizedPlan)
 [statsOfPlanToCache](#statsOfPlanToCache) | The [Statistics](../cost-based-optimization/LogicalPlanStats.md#statsOfPlanToCache) of the [optimized logical query plan](../QueryExecution.md#optimizedPlan)

---

`apply` is used when:

* `CacheManager` is requested to [cache](../CacheManager.md#cacheQuery) and [re-cache](../CacheManager.md#recacheByCondition) a structured query, and [useCachedData](../CacheManager.md#useCachedData)
* `InMemoryRelation` is requested to [withOutput](#withOutput) and [newInstance](#newInstance)

### <span id="getSerializer"> Looking Up CachedBatchSerializer

```scala
getSerializer(
  sqlConf: SQLConf): CachedBatchSerializer
```

`getSerializer` uses [spark.sql.cache.serializer](../configuration-properties.md#spark.sql.cache.serializer) configuration property to create a [CachedBatchSerializer](../cache-serialization/CachedBatchSerializer.md).

### <span id="convertToColumnarIfPossible"> convertToColumnarIfPossible

```scala
convertToColumnarIfPossible(
  plan: SparkPlan): SparkPlan
```

`convertToColumnarIfPossible`...FIXME

## <span id="partitionStatistics"> PartitionStatistics

`PartitionStatistics` for the [output](#output) schema

Used when [InMemoryTableScanExec](../physical-operators/InMemoryTableScanExec.md) physical operator is created (and initializes [stats](../physical-operators/InMemoryTableScanExec.md#stats) internal property).
