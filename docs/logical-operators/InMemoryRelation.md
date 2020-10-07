# InMemoryRelation Leaf Logical Operator

`InMemoryRelation` is a [leaf logical operator](LeafNode.md) that represents a structured query that is cached in memory (when `CacheManager` is requested to [cache it](../CacheManager.md#cacheQuery)).

## Creating Instance

`InMemoryRelation` takes the following to be created:

* <span id="output"> Output Schema [Attributes](../expressions/Attribute.md) (`Seq[Attribute]`)
* <span id="cacheBuilder"> [CachedRDDBuilder](../CachedRDDBuilder.md)
* <span id="outputOrdering"> Output [Ordering](../expressions/SortOrder.md) (`Seq[SortOrder]`)

`InMemoryRelation` is created using [apply](#apply) factory methods.

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

`InMemoryRelation` is a [MultiInstanceRelation](../spark-sql-MultiInstanceRelation.md) so a [new instance will be created](#newInstance) to appear multiple times in a physical query plan.

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
  useCompression: Boolean,
  batchSize: Int,
  storageLevel: StorageLevel,
  child: SparkPlan,
  tableName: Option[String],
  optimizedPlan: LogicalPlan): InMemoryRelation
apply(
  cacheBuilder: CachedRDDBuilder,
  optimizedPlan: LogicalPlan): InMemoryRelation
apply(
  output: Seq[Attribute],
  cacheBuilder: CachedRDDBuilder,
  outputOrdering: Seq[SortOrder],
  statsOfPlanToCache: Statistics): InMemoryRelation
```

`apply` creates an `InMemoryRelation` logical operator.

`apply` is used when `CacheManager` is requested to [cache](../CacheManager.md#cacheQuery) and [re-cache](../CacheManager.md#recacheByCondition) a structured query, and [useCachedData](../CacheManager.md#useCachedData).

## <span id="partitionStatistics"> PartitionStatistics

`PartitionStatistics` for the [output](#output) schema

Used when [InMemoryTableScanExec](../physical-operators/InMemoryTableScanExec.md) physical operator is created (and initializes [stats](../physical-operators/InMemoryTableScanExec.md#stats) internal property).
