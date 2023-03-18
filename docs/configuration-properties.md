# Configuration Properties

**Configuration properties** (aka **settings**) allow you to fine-tune a Spark SQL application.

Configuration properties are configured in a [SparkSession](SparkSession.md) while creating a new instance using [config](SparkSession-Builder.md#config) method (e.g. [spark.sql.warehouse.dir](StaticSQLConf.md#spark.sql.warehouse.dir)).

```scala
import org.apache.spark.sql.SparkSession
val spark: SparkSession = SparkSession.builder
  .master("local[*]")
  .appName("My Spark Application")
  .config("spark.sql.warehouse.dir", "c:/Temp") // (1)!
  .getOrCreate
```

1. Sets [spark.sql.warehouse.dir](#spark.sql.warehouse.dir)

You can also set a property using SQL `SET` command.

```text
assert(spark.conf.getOption("spark.sql.hive.metastore.version").isEmpty)

scala> spark.sql("SET spark.sql.hive.metastore.version=2.3.2").show(truncate = false)
+--------------------------------+-----+
|key                             |value|
+--------------------------------+-----+
|spark.sql.hive.metastore.version|2.3.2|
+--------------------------------+-----+

assert(spark.conf.get("spark.sql.hive.metastore.version") == "2.3.2")
```

## <span id="spark.sql.adaptive.autoBroadcastJoinThreshold"> adaptive.autoBroadcastJoinThreshold

**spark.sql.adaptive.autoBroadcastJoinThreshold**

The maximum size (in bytes) of a table to be broadcast when performing a join. `-1` turns broadcasting off. The default value is same as [spark.sql.autoBroadcastJoinThreshold](#spark.sql.autoBroadcastJoinThreshold).

Used only in [Adaptive Query Execution](adaptive-query-execution/index.md)

Default: (undefined)

Available as [SQLConf.ADAPTIVE_AUTO_BROADCASTJOIN_THRESHOLD](SQLConf.md#ADAPTIVE_AUTO_BROADCASTJOIN_THRESHOLD) value.

## <span id="spark.sql.adaptive.customCostEvaluatorClass"> adaptive.customCostEvaluatorClass

**spark.sql.adaptive.customCostEvaluatorClass**

The fully-qualified class name of the [CostEvaluator](adaptive-query-execution/CostEvaluator.md) in [Adaptive Query Execution](adaptive-query-execution/index.md)

Default: [SimpleCostEvaluator](adaptive-query-execution/SimpleCostEvaluator.md)

Use [SQLConf.ADAPTIVE_CUSTOM_COST_EVALUATOR_CLASS](SQLConf.md#ADAPTIVE_CUSTOM_COST_EVALUATOR_CLASS) method to access the property (in a type-safe way).

Used when:

* `AdaptiveSparkPlanExec` physical operator is requested for the [AQE cost evaluator](physical-operators/AdaptiveSparkPlanExec.md#costEvaluator)

## <span id="spark.sql.adaptive.forceOptimizeSkewedJoin"> adaptive.forceOptimizeSkewedJoin

**spark.sql.adaptive.forceOptimizeSkewedJoin**

Enables [OptimizeSkewedJoin](physical-optimizations/OptimizeSkewedJoin.md) physical optimization to be executed even if it introduces extra shuffle

Default: `false`

Requires [spark.sql.adaptive.skewJoin.enabled](#spark.sql.adaptive.skewJoin.enabled) to be enabled

Use [SQLConf.ADAPTIVE_FORCE_OPTIMIZE_SKEWED_JOIN](SQLConf.md#ADAPTIVE_FORCE_OPTIMIZE_SKEWED_JOIN) to access the property (in a type-safe way).

Used when:

* `AdaptiveSparkPlanExec` physical operator is requested for the [AQE cost evaluator](physical-operators/AdaptiveSparkPlanExec.md#costEvaluator) (and creates a [SimpleCostEvaluator](physical-operators/AdaptiveSparkPlanExec.md#costEvaluator))
* [OptimizeSkewedJoin](physical-optimizations/OptimizeSkewedJoin.md) physical optimization is executed

## <span id="spark.sql.adaptive.optimizer.excludedRules"><span id="ADAPTIVE_OPTIMIZER_EXCLUDED_RULES"> adaptive.optimizer.excludedRules

**spark.sql.adaptive.optimizer.excludedRules**

A comma-separated list of rules (names) to be disabled (_excluded_) in the [AQE Logical Optimizer](adaptive-query-execution/AQEOptimizer.md)

Default: undefined

Use [SQLConf.ADAPTIVE_OPTIMIZER_EXCLUDED_RULES](SQLConf.md#ADAPTIVE_OPTIMIZER_EXCLUDED_RULES) to reference the property.

Used when:

* `AQEOptimizer` is requested for the [batches](adaptive-query-execution/AQEOptimizer.md#batches)

## <span id="spark.sql.autoBroadcastJoinThreshold"><span id="AUTO_BROADCASTJOIN_THRESHOLD"> autoBroadcastJoinThreshold

**spark.sql.autoBroadcastJoinThreshold**

Maximum size (in bytes) for a table that can be broadcast (to all worker nodes) in a join

Default: `10M`

`-1` (or any negative value) disables broadcasting

Use [SQLConf.autoBroadcastJoinThreshold](SQLConf.md#autoBroadcastJoinThreshold) method to access the current value.

## <span id="spark.sql.cache.serializer"><span id="SPARK_CACHE_SERIALIZER"> cache.serializer

**spark.sql.cache.serializer**

The name of [CachedBatchSerializer](cache-serialization/CachedBatchSerializer.md) implementation to translate SQL data into a format that can more efficiently be cached.

Default: [org.apache.spark.sql.execution.columnar.DefaultCachedBatchSerializer](cache-serialization/DefaultCachedBatchSerializer.md)

`spark.sql.cache.serializer` is a [StaticSQLConf](StaticSQLConf.md#SPARK_CACHE_SERIALIZER)

Use [SQLConf.SPARK_CACHE_SERIALIZER](StaticSQLConf.md#SPARK_CACHE_SERIALIZER) for the name

Used when:

* `InMemoryRelation` is requested for the [CachedBatchSerializer](logical-operators/InMemoryRelation.md#getSerializer)

## <span id="spark.sql.codegen.hugeMethodLimit"> codegen.hugeMethodLimit

**spark.sql.codegen.hugeMethodLimit**

**(internal)** The maximum bytecode size of a single compiled Java function generated by whole-stage codegen.
When the compiled code has a function that exceeds this threshold, the whole-stage codegen is deactivated for this subtree of the query plan.

Default: `65535`

The default value `65535` is the largest bytecode size possible for a valid Java method. When running on HotSpot, it may be preferable to set the value to `8000` (which is the value of `HugeMethodLimit` in the OpenJDK JVM settings)

Use [SQLConf.hugeMethodLimit](SQLConf.md#hugeMethodLimit) method to access the current value.

Used when:

* `WholeStageCodegenExec` physical operator is [executed](physical-operators/WholeStageCodegenExec.md#doExecute)

## <span id="spark.sql.codegen.fallback"> codegen.fallback

**spark.sql.codegen.fallback**

**(internal)** Whether the whole-stage codegen could be temporary disabled for the part of a query that has failed to compile generated code (`true`) or not (`false`).

Default: `true`

Use [SQLConf.wholeStageFallback](SQLConf.md#wholeStageFallback) method to access the current value.

Used when:

* `WholeStageCodegenExec` physical operator is [executed](physical-operators/WholeStageCodegenExec.md#doExecute)

## <span id="spark.sql.codegen.join.fullOuterShuffledHashJoin.enabled"> codegen.join.fullOuterShuffledHashJoin.enabled

**spark.sql.codegen.join.fullOuterShuffledHashJoin.enabled**

**(internal)** Enables [Whole-Stage Code Generation](whole-stage-code-generation/index.md) for FULL OUTER [shuffled hash join](physical-operators/ShuffledHashJoinExec.md#supportCodegen)

Default: `true`

Use [SQLConf.ENABLE_FULL_OUTER_SHUFFLED_HASH_JOIN_CODEGEN](SQLConf.md#ENABLE_FULL_OUTER_SHUFFLED_HASH_JOIN_CODEGEN) to access the property

## <span id="spark.sql.columnVector.offheap.enabled"> columnVector.offheap.enabled

**spark.sql.columnVector.offheap.enabled**

**(internal)** Enables [OffHeapColumnVector](vectorized-decoding/OffHeapColumnVector.md) (`true`) or [OnHeapColumnVector](vectorized-decoding/OnHeapColumnVector.md) (`false`) in [ColumnarBatch](vectorized-query-execution/ColumnarBatch.md)

Default: `false`

Use [SQLConf.offHeapColumnVectorEnabled](SQLConf.md#offHeapColumnVectorEnabled) for the current value

Used when:

* `RowToColumnarExec` physical operator is requested to [doExecuteColumnar](physical-operators/RowToColumnarExec.md#doExecuteColumnar)
* `DefaultCachedBatchSerializer` is requested to `vectorTypes` and `convertCachedBatchToColumnarBatch`
* `ParquetFileFormat` is requested to [vectorTypes](datasources/parquet/ParquetFileFormat.md#vectorTypes) and [buildReaderWithPartitionValues](datasources/parquet/ParquetFileFormat.md#buildReaderWithPartitionValues)
* `ParquetPartitionReaderFactory` is [created](datasources/parquet/ParquetPartitionReaderFactory.md#enableOffHeapColumnVector)

## <span id="spark.sql.exchange.reuse"> exchange.reuse

**spark.sql.exchange.reuse**

**(internal)** When enabled (`true`), the [Spark planner](SparkPlanner.md) will find duplicated exchanges and subqueries and re-use them.

When disabled (`false`), [ReuseExchange](physical-optimizations/ReuseExchange.md) and [ReuseSubquery](physical-optimizations/ReuseSubquery.md) physical optimizations (that the Spark planner uses for physical query plan optimization) do nothing.

Default: `true`

Use [SQLConf.exchangeReuseEnabled](SQLConf.md#exchangeReuseEnabled) for the current value

## <span id="spark.sql.files.maxPartitionBytes"><span id="FILES_MAX_PARTITION_BYTES"> files.maxPartitionBytes

**spark.sql.files.maxPartitionBytes**

Maximum number of bytes to pack into a single partition when reading files for file-based data sources (e.g., [Parquet](datasources/parquet/index.md))

Default: `128MB` (like `parquet.block.size`)

Use [SQLConf.filesMaxPartitionBytes](SQLConf.md#filesMaxPartitionBytes) for the current value

Used when:

* `FilePartition` is requested for [maxSplitBytes](datasources/FilePartition.md#maxSplitBytes)

## <span id="spark.sql.files.minPartitionNum"><span id="FILES_MIN_PARTITION_NUM"> files.minPartitionNum

**spark.sql.files.minPartitionNum**

Hint about the minimum number of partitions for file-based data sources (e.g., [Parquet](datasources/parquet/index.md))

Default: [spark.sql.leafNodeDefaultParallelism](SparkSession.md#leafNodeDefaultParallelism)

Use [SQLConf.filesMinPartitionNum](SQLConf.md#filesMinPartitionNum) for the current value

Used when:

* `FilePartition` is requested for [maxSplitBytes](datasources/FilePartition.md#maxSplitBytes)

## <span id="spark.sql.files.openCostInBytes"><span id="FILES_OPEN_COST_IN_BYTES"> files.openCostInBytes

**spark.sql.files.openCostInBytes**

**(internal)** The estimated cost to open a file, measured by the number of bytes could be scanned at the same time (to include multiple files into a partition).
Effective only for file-based sources such as Parquet, JSON and ORC.

Default: `4MB`

It's better to over-estimate it, then the partitions with small files will be faster than partitions with bigger files (which is scheduled first).

Use [SQLConf.filesOpenCostInBytes](SQLConf.md#filesOpenCostInBytes) for the current value

Used when:

* `FileSourceScanExec` physical operator is requested to [create an RDD for a non-bucketed read](physical-operators/FileSourceScanExec.md#createReadRDD)
* `FilePartition` is requested to [getFilePartitions](datasources/FilePartition.md#getFilePartitions) and [maxSplitBytes](datasources/FilePartition.md#maxSplitBytes)

## <span id="spark.sql.hive.filesourcePartitionFileCacheSize"> hive.filesourcePartitionFileCacheSize

**spark.sql.hive.filesourcePartitionFileCacheSize**

When greater than `0`, enables caching of partition file metadata in memory (using [SharedInMemoryCache](datasources/SharedInMemoryCache.md)).
All tables share a cache that can use up to specified num bytes for file metadata.

Requires [spark.sql.hive.manageFilesourcePartitions](#spark.sql.hive.manageFilesourcePartitions) to be enabled

Default: `250 * 1024 * 1024`

Use [SQLConf.filesourcePartitionFileCacheSize](SQLConf.md#filesourcePartitionFileCacheSize) for the current value

Used when:

* `FileStatusCache` is requested to [look up the system-wide FileStatusCache](datasources/FileStatusCache.md#getOrCreate)

## <span id="spark.sql.hive.manageFilesourcePartitions"> hive.manageFilesourcePartitions

**spark.sql.hive.manageFilesourcePartitions**

Enables metastore partition management for file source tables.

This includes both datasource and Hive tables. When partition management is enabled, datasource tables store partition in the Hive metastore, and use the metastore to prune partitions during query planning when [spark.sql.hive.metastorePartitionPruning](#spark.sql.hive.metastorePartitionPruning) is enabled

Default: `true`

Use [SQLConf.manageFilesourcePartitions](SQLConf.md#manageFilesourcePartitions) for the current value

Used when:

* `HiveMetastoreCatalog` is requested to [convert a HiveTableRelation to a LogicalRelation over a HadoopFsRelation](hive/HiveMetastoreCatalog.md#convertToLogicalRelation)
* [CreateDataSourceTableCommand](logical-operators/CreateDataSourceTableCommand.md), [CreateDataSourceTableAsSelectCommand](logical-operators/CreateDataSourceTableAsSelectCommand.md) and [InsertIntoHadoopFsRelationCommand](logical-operators/InsertIntoHadoopFsRelationCommand.md) logical commands are executed
* `DDLUtils` utility is used to `verifyPartitionProviderIsHive`
* `DataSource` is requested to [resolve a BaseRelation](DataSource.md#resolveRelation) (for file-based data source tables and creates a `HadoopFsRelation`)
* `FileStatusCache` is [created](datasources/FileStatusCache.md#getOrCreate)
* `V2SessionCatalog` is requested to [create a table](V2SessionCatalog.md#createTable) (_deprecated_)

## <span id="spark.sql.inMemoryColumnarStorage.partitionPruning"> inMemoryColumnarStorage.partitionPruning

**spark.sql.inMemoryColumnarStorage.partitionPruning**

**(internal)** Enables partition pruning for in-memory columnar tables

Default: `true`

Use [SQLConf.inMemoryPartitionPruning](SQLConf.md#inMemoryPartitionPruning) for the current value

Used when:

* `InMemoryTableScanExec` physical operator is requested to [filter cached column batches](physical-operators/InMemoryTableScanExec.md#filteredCachedBatches)

## <span id="spark.sql.optimizer.canChangeCachedPlanOutputPartitioning"> optimizer.canChangeCachedPlanOutputPartitioning

**spark.sql.optimizer.canChangeCachedPlanOutputPartitioning**

**(internal)** Whether to forcibly enable some optimization rules that can change the output partitioning of a cached query when executing it for caching. If it is set to true, queries may need an extra shuffle to read the cached data. This configuration is disabled by default. Currently, the optimization rules enabled by this configuration are [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) and [spark.sql.sources.bucketing.autoBucketedScan.enabled](#spark.sql.sources.bucketing.autoBucketedScan.enabled).

Default: `false`

Use [SQLConf.CAN_CHANGE_CACHED_PLAN_OUTPUT_PARTITIONING](SQLConf.md#CAN_CHANGE_CACHED_PLAN_OUTPUT_PARTITIONING) to access the property

## <span id="spark.sql.optimizer.decorrelateInnerQuery.enabled"> optimizer.decorrelateInnerQuery.enabled

**spark.sql.optimizer.decorrelateInnerQuery.enabled**

**(internal)** Decorrelates inner queries by eliminating correlated references and build domain joins

Default: `true`

Use [SQLConf.decorrelateInnerQueryEnabled](SQLConf.md#decorrelateInnerQueryEnabled) for the current value

## <span id="spark.sql.optimizer.dynamicPartitionPruning.fallbackFilterRatio"> optimizer.dynamicPartitionPruning.fallbackFilterRatio

**spark.sql.optimizer.dynamicPartitionPruning.fallbackFilterRatio**

**(internal)** When statistics are not available or configured not to be used, this config will be used as the fallback filter ratio for computing the data size of the partitioned table after dynamic partition pruning, in order to evaluate if it is worth adding an extra subquery as the pruning filter if broadcast reuse is not applicable.

Default: `0.5`

Use [SQLConf.dynamicPartitionPruningFallbackFilterRatio](SQLConf.md#dynamicPartitionPruningFallbackFilterRatio) method to access the current value.

## <span id="spark.sql.optimizer.dynamicPartitionPruning.pruningSideExtraFilterRatio"> optimizer.dynamicPartitionPruning.pruningSideExtraFilterRatio

**spark.sql.optimizer.dynamicPartitionPruning.pruningSideExtraFilterRatio**

**(internal)** When filtering side doesn't support broadcast by join type, and doing DPP means running an extra query that may have significant overhead. This config will be used as the extra filter ratio for computing the data size of the pruning side after DPP, in order to evaluate if it is worth adding an extra subquery as the pruning filter.

Must be a double between `0.0` and `1.0`

Default: `0.04`

Use [SQLConf.dynamicPartitionPruningPruningSideExtraFilterRatio](SQLConf.md#dynamicPartitionPruningPruningSideExtraFilterRatio) to access the current value.

## <span id="spark.sql.optimizer.dynamicPartitionPruning.useStats"> optimizer.dynamicPartitionPruning.useStats

**spark.sql.optimizer.dynamicPartitionPruning.useStats**

**(internal)** When true, distinct count statistics will be used for computing the data size of the partitioned table after dynamic partition pruning, in order to evaluate if it is worth adding an extra subquery as the pruning filter if broadcast reuse is not applicable.

Default: `true`

Use [SQLConf.dynamicPartitionPruningUseStats](SQLConf.md#dynamicPartitionPruningUseStats) for the current value

Used when:

* [PartitionPruning](logical-optimizations/PartitionPruning.md) logical optimization rule is [executed](logical-optimizations/PartitionPruning.md#pruningHasBenefit)

## <span id="spark.sql.optimizer.dynamicPartitionPruning.enabled"> optimizer.dynamicPartitionPruning.enabled

**spark.sql.optimizer.dynamicPartitionPruning.enabled**

Enables generating predicates for partition columns used as join keys

Default: `true`

Use [SQLConf.dynamicPartitionPruningEnabled](SQLConf.md#dynamicPartitionPruningEnabled) for the current value

Used to control whether to execute the following optimizations or skip them altogether:

* [CleanupDynamicPruningFilters](logical-optimizations/CleanupDynamicPruningFilters.md) logical optimization
* [PartitionPruning](logical-optimizations/PartitionPruning.md) logical optimization
* [PlanAdaptiveDynamicPruningFilters](physical-optimizations/PlanAdaptiveDynamicPruningFilters.md) physical optimization
* [PlanDynamicPruningFilters](physical-optimizations/PlanDynamicPruningFilters.md) physical optimization

## <span id="spark.sql.optimizer.dynamicPartitionPruning.reuseBroadcastOnly"> optimizer.dynamicPartitionPruning.reuseBroadcastOnly

**spark.sql.optimizer.dynamicPartitionPruning.reuseBroadcastOnly**

**(internal)** When `true`, dynamic partition pruning will only apply when the broadcast exchange of a broadcast hash join operation can be reused as the dynamic pruning filter.

Default: `true`

Use [SQLConf.dynamicPartitionPruningReuseBroadcastOnly](SQLConf.md#dynamicPartitionPruningReuseBroadcastOnly) for the current value

Used when:

* [PartitionPruning](logical-optimizations/PartitionPruning.md) logical optimization is executed (and requested to [insertPredicate](logical-optimizations/PartitionPruning.md#insertPredicate))

## <span id="spark.sql.optimizer.enableCsvExpressionOptimization"> optimizer.enableCsvExpressionOptimization

**spark.sql.optimizer.enableCsvExpressionOptimization**

Whether to optimize CSV expressions in SQL optimizer. It includes pruning unnecessary columns from `from_csv`.

Default: `true`

Use [SQLConf.csvExpressionOptimization](SQLConf.md#csvExpressionOptimization) for the current value

## <span id="spark.sql.optimizer.excludedRules"> optimizer.excludedRules

**spark.sql.optimizer.excludedRules**

Comma-separated list of fully-qualified class names of the optimization rules that should be disabled (excluded) from [logical query optimization](catalyst/Optimizer.md#spark.sql.optimizer.excludedRules).

Default: `(empty)`

Use [SQLConf.optimizerExcludedRules](SQLConf.md#optimizerExcludedRules) method to access the current value.

!!! important
    It is not guaranteed that all the rules to be excluded will eventually be excluded, as some rules are [non-excludable](catalyst/Optimizer.md#nonExcludableRules).

## <span id="spark.sql.optimizer.expression.nestedPruning.enabled"> optimizer.expression.nestedPruning.enabled

**spark.sql.optimizer.expression.nestedPruning.enabled**

**(internal)** Prune nested fields from expressions in an operator which are unnecessary in satisfying a query. Note that this optimization doesn't prune nested fields from physical data source scanning. For pruning nested fields from scanning, please use [spark.sql.optimizer.nestedSchemaPruning.enabled](#spark.sql.optimizer.nestedSchemaPruning.enabled) config.

Default: `true`

## <span id="spark.sql.optimizer.inSetConversionThreshold"> optimizer.inSetConversionThreshold

**spark.sql.optimizer.inSetConversionThreshold**

**(internal)** The threshold of set size for `InSet` conversion.

Default: `10`

Use [SQLConf.optimizerInSetConversionThreshold](SQLConf.md#optimizerInSetConversionThreshold) method to access the current value.

## <span id="spark.sql.optimizer.inSetSwitchThreshold"> optimizer.inSetSwitchThreshold

**spark.sql.optimizer.inSetSwitchThreshold**

**(internal)** Configures the max set size in InSet for which Spark will generate code with switch statements. This is applicable only to bytes, shorts, ints, dates.

Must be non-negative and less than or equal to 600.

Default: `400`

## <span id="spark.sql.optimizer.maxIterations"> optimizer.maxIterations

**spark.sql.optimizer.maxIterations**

Maximum number of iterations for [Analyzer](Analyzer.md#fixedPoint) and [Logical Optimizer](catalyst/Optimizer.md#fixedPoint).

Default: `100`

## <span id="spark.sql.optimizer.nestedSchemaPruning.enabled"> optimizer.nestedSchemaPruning.enabled

**spark.sql.optimizer.nestedSchemaPruning.enabled**

**(internal)** Prune nested fields from the output of a logical relation that are not necessary in satisfying a query. This optimization allows columnar file format readers to avoid reading unnecessary nested column data.

Default: `true`

Use [SQLConf.nestedSchemaPruningEnabled](SQLConf.md#nestedSchemaPruningEnabled) method to access the current value.

## <span id="spark.sql.optimizer.nestedPredicatePushdown.supportedFileSources"> optimizer.nestedPredicatePushdown.supportedFileSources

**spark.sql.optimizer.nestedPredicatePushdown.supportedFileSources**

**(internal)** A comma-separated list of data source short names or fully qualified data source implementation class names for which Spark tries to push down predicates for nested columns and/or names containing `dots` to data sources. This configuration is only effective with file-based data source in DSv1. Currently, Parquet implements both optimizations while ORC only supports predicates for names containing `dots`. The other data sources don't support this feature yet.

Default: `parquet,orc`

## <span id="spark.sql.optimizer.optimizeOneRowRelationSubquery"> optimizer.optimizeOneRowRelationSubquery

**spark.sql.optimizer.optimizeOneRowRelationSubquery**

**(internal)** When `true`, the optimizer will inline subqueries with `OneRowRelation` leaf nodes

Default: `true`

Use [SQLConf.OPTIMIZE_ONE_ROW_RELATION_SUBQUERY](SQLConf.md#OPTIMIZE_ONE_ROW_RELATION_SUBQUERY) method to access the property (in a type-safe way)

## <span id="spark.sql.optimizer.planChangeLog.batches"> optimizer.planChangeLog.batches

**spark.sql.optimizer.planChangeLog.batches**

**(internal)** Configures a list of batches to be logged in the optimizer, in which the batches are specified by their batch names and separated by comma.

Default: `(undefined)`

## <span id="spark.sql.optimizer.planChangeLog.level"> optimizer.planChangeLog.level

**spark.sql.optimizer.planChangeLog.level**

**(internal)** Configures the log level for logging the change from the original plan to the new plan after a rule or batch is applied. The value can be `TRACE`, `DEBUG`, `INFO`, `WARN` or `ERROR`.

Default: `TRACE`

## <span id="spark.sql.optimizer.planChangeLog.rules"> optimizer.planChangeLog.rules

**spark.sql.optimizer.planChangeLog.rules**

**(internal)** Configures a list of rules to be logged in the optimizer, in which the rules are specified by their rule names and separated by comma.

Default: `(undefined)`

## <span id="spark.sql.optimizer.replaceExceptWithFilter"> optimizer.replaceExceptWithFilter

**spark.sql.optimizer.replaceExceptWithFilter**

**(internal)** When `true`, the apply function of the rule verifies whether the right node of the except operation is of type Filter or Project followed by Filter. If yes, the rule further verifies 1) Excluding the filter operations from the right (as well as the left node, if any) on the top, whether both the nodes evaluates to a same result. 2) The left and right nodes don't contain any SubqueryExpressions. 3) The output column names of the left node are distinct. If all the conditions are met, the rule will replace the except operation with a Filter by flipping the filter condition(s) of the right node.

Default: `true`

## <span id="spark.sql.optimizer.runtime.bloomFilter.enabled"> optimizer.runtime.bloomFilter.enabled

**spark.sql.optimizer.runtime.bloomFilter.enabled**

Enables a bloom filter on one side of a shuffle join if the other side has a selective predicate (to reduce the amount of shuffle data)

Default: `false`

Use [SQLConf.runtimeFilterBloomFilterEnabled](SQLConf.md#runtimeFilterBloomFilterEnabled) for the current value

Used when:

* [InjectRuntimeFilter](logical-optimizations/InjectRuntimeFilter.md) logical optimization is executed

## <span id="spark.sql.optimizer.runtime.bloomFilter.expectedNumItems"> optimizer.runtime.bloomFilter.expectedNumItems

**spark.sql.optimizer.runtime.bloomFilter.expectedNumItems**

The default number of expected items for the runtime bloomfilter

Default: `1000000L`

[SQLConf.RUNTIME_BLOOM_FILTER_EXPECTED_NUM_ITEMS](SQLConf.md#RUNTIME_BLOOM_FILTER_EXPECTED_NUM_ITEMS)

Used when:

* [BloomFilterAggregate](expressions/BloomFilterAggregate.md#estimatedNumItemsExpression) expression is created

## <span id="spark.sql.optimizer.runtime.bloomFilter.maxNumBits"> optimizer.runtime.bloomFilter.maxNumBits

**spark.sql.optimizer.runtime.bloomFilter.maxNumBits**

Maximum number of bits for the runtime bloom filter

Default: `67108864L` (8MB)

Must be a [non-zero positive number](expressions/BloomFilterAggregate.md#checkInputDataTypes)

[SQLConf.RUNTIME_BLOOM_FILTER_MAX_NUM_BITS](SQLConf.md#RUNTIME_BLOOM_FILTER_MAX_NUM_BITS)

Used when:

* `BloomFilterAggregate` is requested to [checkInputDataTypes](expressions/BloomFilterAggregate.md#checkInputDataTypes) and for the [numBits](expressions/BloomFilterAggregate.md#numBits)

## <span id="spark.sql.optimizer.runtimeFilter.number.threshold"> optimizer.runtimeFilter.number.threshold

**spark.sql.optimizer.runtimeFilter.number.threshold**

The total number of injected runtime filters (non-DPP) for a single query. This is to prevent driver OOMs with too many Bloom filters.

Default: `10`

Must be a non-zero positive number

[SQLConf.RUNTIME_FILTER_NUMBER_THRESHOLD](SQLConf.md#RUNTIME_FILTER_NUMBER_THRESHOLD)

Used when:

* [InjectRuntimeFilter](logical-optimizations/InjectRuntimeFilter.md) logical optimization is executed

## <span id="spark.sql.optimizer.runtimeFilter.semiJoinReduction.enabled"> optimizer.runtimeFilter.semiJoinReduction.enabled

**spark.sql.optimizer.runtimeFilter.semiJoinReduction.enabled**

Enables inserting a semi join on one side of a shuffle join if the other side has a selective predicate (to reduce the amount of shuffle data)

Default: `false`

Use [SQLConf.runtimeFilterSemiJoinReductionEnabled](SQLConf.md#runtimeFilterSemiJoinReductionEnabled) for the current value

Used when:

* [InjectRuntimeFilter](logical-optimizations/InjectRuntimeFilter.md) logical optimization is executed

## <span id="spark.sql.optimizer.serializer.nestedSchemaPruning.enabled"> optimizer.serializer.nestedSchemaPruning.enabled

**spark.sql.optimizer.serializer.nestedSchemaPruning.enabled**

**(internal)** Prune nested fields from object serialization operator which are unnecessary in satisfying a query. This optimization allows object serializers to avoid executing unnecessary nested expressions.

Default: `true`

## <span id="spark.sql.parquet.columnarReaderBatchSize"> parquet.columnarReaderBatchSize

**spark.sql.parquet.columnarReaderBatchSize**

The number of rows to include in a parquet vectorized reader batch (the capacity of [VectorizedParquetRecordReader](datasources/parquet/VectorizedParquetRecordReader.md))

Default: `4096` (4k)

The number should be carefully chosen to minimize overhead and avoid OOMs while reading data.

Use [SQLConf.parquetVectorizedReaderBatchSize](SQLConf.md#parquetVectorizedReaderBatchSize) for the current value

Used when:

* `ParquetFileFormat` is requested for a [data reader](datasources/parquet/ParquetFileFormat.md#buildReaderWithPartitionValues) (and creates a [VectorizedParquetRecordReader](datasources/parquet/VectorizedParquetRecordReader.md) for [Vectorized Parquet Decoding](vectorized-decoding/index.md))
* `ParquetPartitionReaderFactory` is [created](datasources/parquet/ParquetPartitionReaderFactory.md#capacity)
* `WritableColumnVector` is requested to `reserve` required capacity (and fails)

## <span id="spark.sql.parquet.mergeSchema"> parquet.mergeSchema

**spark.sql.parquet.mergeSchema**

Controls whether the Parquet data source merges schemas collected from all data files or not. If `false`, the schema is picked from the summary file or a random data file if no summary file is available.

Default: `false`

Use [SQLConf.isParquetSchemaMergingEnabled](SQLConf.md#isParquetSchemaMergingEnabled) for the current value

Parquet option (of higher priority): [mergeSchema](datasources/parquet/ParquetOptions.md#mergeSchema)

Used when:

* `ParquetOptions` is created (and initializes [mergeSchema](datasources/parquet/ParquetOptions.md#mergeSchema) option)

## <span id="spark.sql.objectHashAggregate.sortBased.fallbackThreshold"> spark.sql.objectHashAggregate.sortBased.fallbackThreshold

**(internal)** The number of entires in an in-memory hash map (to store aggregation buffers per grouping keys) before [ObjectHashAggregateExec](physical-operators/ObjectHashAggregateExec.md) ([ObjectAggregationIterator](physical-operators/ObjectAggregationIterator.md#processInputs), precisely) falls back to sort-based aggregation

Default: `128` (entries)

Use [SQLConf.objectAggSortBasedFallbackThreshold](SQLConf.md#objectAggSortBasedFallbackThreshold) for the current value

Learn more in [Demo: ObjectHashAggregateExec and Sort-Based Fallback Tasks](demo/objecthashaggregateexec-sort-based-fallback-tasks.md)

## <span id="spark.sql.adaptive.optimizeSkewsInRebalancePartitions.enabled"> spark.sql.adaptive.optimizeSkewsInRebalancePartitions.enabled

When `true` and [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) is `true`, Spark SQL will optimize the skewed shuffle partitions in RebalancePartitions and split them to smaller ones according to the target size (specified by [spark.sql.adaptive.advisoryPartitionSizeInBytes](#spark.sql.adaptive.advisoryPartitionSizeInBytes)), to avoid data skew

Default: `true`

Use [SQLConf.ADAPTIVE_OPTIMIZE_SKEWS_IN_REBALANCE_PARTITIONS_ENABLED](SQLConf.md#ADAPTIVE_OPTIMIZE_SKEWS_IN_REBALANCE_PARTITIONS_ENABLED) method to access the property (in a type-safe way)

## <span id="spark.sql.codegen.aggregate.fastHashMap.capacityBit"> spark.sql.codegen.aggregate.fastHashMap.capacityBit

**(internal)** Capacity for the max number of rows to be held in memory by the fast hash aggregate product operator.
The bit is not for actual value, but the actual `numBuckets` is determined by `loadFactor` (e.g., the default bit value `16`, the actual numBuckets is `((1 << 16) / 0.5`).

Default: `16`

Must be in the range of `[10, 30]` (inclusive)

Use [SQLConf.fastHashAggregateRowMaxCapacityBit](SQLConf.md#fastHashAggregateRowMaxCapacityBit) for the current value

Used when:

* `HashAggregateExec` physical operator is requested to [doProduceWithKeys](physical-operators/HashAggregateExec.md#doProduceWithKeys)

## <span id="spark.sql.codegen.aggregate.map.twolevel.enabled"> spark.sql.codegen.aggregate.map.twolevel.enabled

**(internal)** Enable two-level aggregate hash map.
When enabled, records will first be inserted/looked-up at a 1st-level, small, fast map, and then fallback to a 2nd-level, larger, slower map when 1st level is full or keys cannot be found.
When disabled, records go directly to the 2nd level.

Default: `true`

Use [SQLConf.enableTwoLevelAggMap](SQLConf.md#enableTwoLevelAggMap) for the current value

Used when:

* `HashAggregateExec` physical operator is requested to [doProduceWithKeys](physical-operators/HashAggregateExec.md#doProduceWithKeys)

## <span id="spark.sql.codegen.aggregate.map.vectorized.enable"> spark.sql.codegen.aggregate.map.vectorized.enable

**(internal)** Enables vectorized aggregate hash map. For testing/benchmarking only.

Default: `false`

Use [SQLConf.enableVectorizedHashMap](SQLConf.md#enableVectorizedHashMap) for the current value

Used when:

* `HashAggregateExec` physical operator is requested to [enableTwoLevelHashMap](physical-operators/HashAggregateExec.md#enableTwoLevelHashMap), [doProduceWithKeys](physical-operators/HashAggregateExec.md#doProduceWithKeys)

## <span id="spark.sql.codegen.aggregate.map.twolevel.partialOnly"> spark.sql.codegen.aggregate.map.twolevel.partialOnly

**(internal)** Enables two-level aggregate hash map for partial aggregate only, because final aggregate might get more distinct keys compared to partial aggregate. "Overhead of looking up 1st-level map might dominate when having a lot of distinct keys.

Default: `true`

Used when:

* [HashAggregateExec](physical-operators/HashAggregateExec.md) physical operator is requested to [checkIfFastHashMapSupported](physical-operators/HashAggregateExec.md#checkIfFastHashMapSupported)

## <span id="spark.sql.legacy.allowNonEmptyLocationInCTAS"> spark.sql.legacy.allowNonEmptyLocationInCTAS

**(internal)** When `false`, CTAS with LOCATION throws an analysis exception if the location is not empty.

Default: `false`

Use [SQLConf.allowNonEmptyLocationInCTAS](SQLConf.md#allowNonEmptyLocationInCTAS) for the current value

## <span id="spark.sql.legacy.allowAutoGeneratedAliasForView"> spark.sql.legacy.allowAutoGeneratedAliasForView

**(internal)** When `true`, it's allowed to use an input query without explicit alias when creating a permanent view.

Default: `false`

Use [SQLConf.allowAutoGeneratedAliasForView](SQLConf.md#allowAutoGeneratedAliasForView) for the current value

## <span id="spark.sql.sessionWindow.buffer.spill.threshold"> spark.sql.sessionWindow.buffer.spill.threshold

**(internal)** The threshold for number of rows to be spilled by window operator. Note that the buffer is used only for the query Spark SQL cannot apply aggregations on determining session window.

Default: [spark.shuffle.spill.numElementsForceSpillThreshold](#spark.shuffle.spill.numElementsForceSpillThreshold)

Use [SQLConf.sessionWindowBufferSpillThreshold](SQLConf.md#sessionWindowBufferSpillThreshold) for the current value

## <span id="spark.sql.execution.arrow.pyspark.selfDestruct.enabled"> spark.sql.execution.arrow.pyspark.selfDestruct.enabled

(Experimental) When `true`, make use of Apache Arrow's self-destruct and split-blocks options for columnar data transfers in PySpark, when converting from Arrow to Pandas. This reduces memory usage at the cost of some CPU time.
Applies to: `pyspark.sql.DataFrame.toPandas` when [spark.sql.execution.arrow.pyspark.enabled](#spark.sql.execution.arrow.pyspark.enabled) is `true`.

Default: `false`

Use [SQLConf.arrowPySparkSelfDestructEnabled](SQLConf.md#arrowPySparkSelfDestructEnabled) for the current value

## <span id="spark.sql.legacy.allowStarWithSingleTableIdentifierInCount"> spark.sql.legacy.allowStarWithSingleTableIdentifierInCount

**(internal)** When `true`, the SQL function `count` is allowed to take a single `tblName.*` as parameter

Default: `false`

Use [SQLConf.allowStarWithSingleTableIdentifierInCount](SQLConf.md#allowStarWithSingleTableIdentifierInCount) for the current value

## <span id="spark.sql.sessionWindow.buffer.in.memory.threshold"> spark.sql.sessionWindow.buffer.in.memory.threshold

**(internal)** Threshold for number of windows guaranteed to be held in memory by the session window operator. Note that the buffer is used only for the query Spark SQL cannot apply aggregations on determining session window.

Default: `4096`

Use [SQLConf.sessionWindowBufferInMemoryThreshold](SQLConf.md#sessionWindowBufferInMemoryThreshold) for the current value

## <span id="spark.sql.orc.enableNestedColumnVectorizedReader"> spark.sql.orc.enableNestedColumnVectorizedReader

Enables vectorized orc decoding for nested column

Default: `false`

Use [SQLConf.orcVectorizedReaderNestedColumnEnabled](SQLConf.md#orcVectorizedReaderNestedColumnEnabled) for the current value

## <span id="spark.sql.adaptive.forceApply"> spark.sql.adaptive.forceApply

**(internal)** When `true` (together with [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) enabled), Spark will [force apply adaptive query execution for all supported queries](physical-optimizations/InsertAdaptiveSparkPlan.md#shouldApplyAQE).

Default: `false`

Use [SQLConf.ADAPTIVE_EXECUTION_FORCE_APPLY](SQLConf.md#ADAPTIVE_EXECUTION_FORCE_APPLY) method to access the property (in a type-safe way).

## <span id="spark.sql.adaptive.coalescePartitions.enabled"> spark.sql.adaptive.coalescePartitions.enabled

Controls coalescing shuffle partitions

When `true` and [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) is enabled, Spark will coalesce contiguous shuffle partitions according to the target size (specified by [spark.sql.adaptive.advisoryPartitionSizeInBytes](#spark.sql.adaptive.advisoryPartitionSizeInBytes)), to avoid too many small tasks.

Default: `true`

Use [SQLConf.coalesceShufflePartitionsEnabled](SQLConf.md#coalesceShufflePartitionsEnabled) method to access the current value.

## <span id="spark.sql.adaptive.coalescePartitions.minPartitionSize"> spark.sql.adaptive.coalescePartitions.minPartitionSize

The minimum size (in bytes unless specified) of shuffle partitions after coalescing. This is useful when the adaptively calculated target size is too small during partition coalescing

Default: `1MB`

Use [SQLConf.coalesceShufflePartitionsEnabled](SQLConf.md#coalesceShufflePartitionsEnabled) method to access the current value.

## <span id="spark.sql.adaptive.coalescePartitions.parallelismFirst"> spark.sql.adaptive.coalescePartitions.parallelismFirst

When `true`, Spark does not respect the target size specified by [spark.sql.adaptive.advisoryPartitionSizeInBytes](#spark.sql.adaptive.advisoryPartitionSizeInBytes) when coalescing contiguous shuffle partitions, but adaptively calculate the target size according to the default parallelism of the Spark cluster. The calculated size is usually smaller than the configured target size. This is to maximize the parallelism and avoid performance regression when enabling adaptive query execution. It's recommended to set this config to `false` and respect the configured target size.

Default: `true`

Use [SQLConf.coalesceShufflePartitionsEnabled](SQLConf.md#coalesceShufflePartitionsEnabled) method to access the current value.

## <span id="spark.sql.adaptive.advisoryPartitionSizeInBytes"> spark.sql.adaptive.advisoryPartitionSizeInBytes

The advisory size in bytes of the shuffle partition during adaptive optimization (when [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) is enabled). It takes effect when Spark coalesces small shuffle partitions or splits skewed shuffle partition.

Default: `64MB`

Fallback Property: `spark.sql.adaptive.shuffle.targetPostShuffleInputSize`

Use [SQLConf.ADVISORY_PARTITION_SIZE_IN_BYTES](SQLConf.md#ADVISORY_PARTITION_SIZE_IN_BYTES) to reference the name.

## <span id="spark.sql.adaptive.coalescePartitions.minPartitionSize"><span id="COALESCE_PARTITIONS_MIN_PARTITION_SIZE"><span id="COALESCE_PARTITIONS_MIN_PARTITION_NUM"> spark.sql.adaptive.coalescePartitions.minPartitionSize

The minimum size (in bytes) of shuffle partitions after coalescing.

Useful when the adaptively calculated target size is too small during partition coalescing.

Default: `(undefined)`

Must be positive

Used when:

* [CoalesceShufflePartitions](physical-optimizations/CoalesceShufflePartitions.md) adaptive physical optimization is executed

## <span id="spark.sql.adaptive.coalescePartitions.initialPartitionNum"> spark.sql.adaptive.coalescePartitions.initialPartitionNum

The initial number of shuffle partitions before coalescing.

By default it equals to [spark.sql.shuffle.partitions](#spark.sql.shuffle.partitions).
If not set, the default value is the default parallelism of the Spark cluster.
This configuration only has an effect when [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) and [spark.sql.adaptive.coalescePartitions.enabled](#spark.sql.adaptive.coalescePartitions.enabled) are both enabled.

Default: `(undefined)`

## <span id="spark.sql.adaptive.enabled"> spark.sql.adaptive.enabled

Enables [Adaptive Query Execution](adaptive-query-execution/index.md)

Default: `true`

Use [SQLConf.adaptiveExecutionEnabled](SQLConf.md#adaptiveExecutionEnabled) method to access the current value.

## <span id="spark.sql.adaptive.fetchShuffleBlocksInBatch"> spark.sql.adaptive.fetchShuffleBlocksInBatch

**(internal)** Whether to fetch the contiguous shuffle blocks in batch. Instead of fetching blocks one by one, fetching contiguous shuffle blocks for the same map task in batch can reduce IO and improve performance. Note, multiple contiguous blocks exist in single "fetch request only happen when [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) and [spark.sql.adaptive.coalescePartitions.enabled](#spark.sql.adaptive.coalescePartitions.enabled) are both enabled. This feature also depends on a relocatable serializer, the concatenation support codec in use and the new version shuffle fetch protocol.

Default: `true`

Use [SQLConf.fetchShuffleBlocksInBatch](SQLConf.md#fetchShuffleBlocksInBatch) method to access the current value.

## <span id="spark.sql.adaptive.localShuffleReader.enabled"> spark.sql.adaptive.localShuffleReader.enabled

When `true` (and [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) is `true`), Spark SQL tries to use local shuffle reader to read the shuffle data when the shuffle partitioning is not needed, for example, after converting sort-merge join to broadcast-hash join.

Default: `true`

Use [SQLConf.LOCAL_SHUFFLE_READER_ENABLED](SQLConf.md#LOCAL_SHUFFLE_READER_ENABLED) to access the property (in a type-safe way)

## <span id="spark.sql.adaptive.logLevel"> spark.sql.adaptive.logLevel

**(internal)** Log level for adaptive execution logging of plan changes. The value can be `TRACE`, `DEBUG`, `INFO`, `WARN` or `ERROR`.

Default: `DEBUG`

Use [SQLConf.adaptiveExecutionLogLevel](SQLConf.md#adaptiveExecutionLogLevel) for the current value

## <span id="spark.sql.adaptive.maxShuffledHashJoinLocalMapThreshold"> spark.sql.adaptive.maxShuffledHashJoinLocalMapThreshold

The maximum size (in bytes) per partition that can be allowed to build local hash map. If this value is not smaller than [spark.sql.adaptive.advisoryPartitionSizeInBytes](#spark.sql.adaptive.advisoryPartitionSizeInBytes) and all the partition size are not larger than this config, join selection prefer to use shuffled hash join instead of sort merge join regardless of the value of [spark.sql.join.preferSortMergeJoin](#spark.sql.join.preferSortMergeJoin).

Default: `0`

Available as [SQLConf.ADAPTIVE_MAX_SHUFFLE_HASH_JOIN_LOCAL_MAP_THRESHOLD](SQLConf.md#ADAPTIVE_MAX_SHUFFLE_HASH_JOIN_LOCAL_MAP_THRESHOLD)

## <span id="spark.sql.adaptive.skewJoin.enabled"> spark.sql.adaptive.skewJoin.enabled

When `true` and [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) is enabled, Spark dynamically handles skew in sort-merge join by splitting (and replicating if needed) skewed partitions.

Default: `true`

Use [SQLConf.SKEW_JOIN_ENABLED](SQLConf.md#SKEW_JOIN_ENABLED) to reference the property.

## <span id="spark.sql.adaptive.skewJoin.skewedPartitionFactor"> spark.sql.adaptive.skewJoin.skewedPartitionFactor

A partition is considered skewed if its size is larger than this factor multiplying the median partition size and also larger than [spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes](#spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes).

Default: `5`

## <span id="spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes"> spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes

A partition is considered skewed if its size in bytes is larger than this threshold and also larger than [spark.sql.adaptive.skewJoin.skewedPartitionFactor](#spark.sql.adaptive.skewJoin.skewedPartitionFactor) multiplying the median partition size. Ideally this config should be set larger than [spark.sql.adaptive.advisoryPartitionSizeInBytes](#spark.sql.adaptive.advisoryPartitionSizeInBytes).

Default: `256MB`

## <span id="spark.sql.adaptive.nonEmptyPartitionRatioForBroadcastJoin"> spark.sql.adaptive.nonEmptyPartitionRatioForBroadcastJoin

**(internal)** A relation with a non-empty partition ratio (the number of non-empty partitions to all partitions) lower than this config will not be considered as the build side of a broadcast-hash join in [Adaptive Query Execution](adaptive-query-execution/index.md) regardless of the size.

Effective with [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) `true`

Default: `0.2`

Use [SQLConf.nonEmptyPartitionRatioForBroadcastJoin](SQLConf.md#nonEmptyPartitionRatioForBroadcastJoin) method to access the current value.

## <span id="spark.sql.analyzer.maxIterations"> spark.sql.analyzer.maxIterations

**(internal)** The max number of iterations the analyzer runs.

Default: `100`

## <span id="spark.sql.analyzer.failAmbiguousSelfJoin"> spark.sql.analyzer.failAmbiguousSelfJoin

**(internal)** When `true`, fail the Dataset query if it contains ambiguous self-join.

Default: `true`

## <span id="spark.sql.ansi.enabled"> spark.sql.ansi.enabled

When `true`, Spark tries to conform to the ANSI SQL specification:

1. Spark will throw a runtime exception if an overflow occurs in any operation on integral/decimal field.
2. Spark will forbid using the reserved keywords of ANSI SQL as identifiers in the SQL parser.

Default: `false`

## <span id="spark.sql.cli.print.header"> spark.sql.cli.print.header

When `true`, spark-sql CLI prints the names of the columns in query output

Default: `false`

Use [SQLConf.cliPrintHeader](SQLConf.md#cliPrintHeader) for the current value

## <span id="spark.sql.codegen.wholeStage"> spark.sql.codegen.wholeStage

**(internal)** Whether the whole stage (of multiple physical operators) will be compiled into a single Java method (`true`) or not (`false`).

Default: `true`

Use [SQLConf.wholeStageEnabled](SQLConf.md#wholeStageEnabled) method to access the current value.

## <span id="spark.sql.codegen.methodSplitThreshold"> spark.sql.codegen.methodSplitThreshold

**(internal)** The threshold of source-code splitting in the codegen. When the number of characters in a single Java function (without comment) exceeds the threshold, the function will be automatically split to multiple smaller ones. We cannot know how many bytecode will be generated, so use the code length as metric. When running on HotSpot, a function's bytecode should not go beyond 8KB, otherwise it will not be JITted; it also should not be too small, otherwise there will be many function calls.

Default: `1024`

Use [SQLConf.methodSplitThreshold](SQLConf.md#methodSplitThreshold) for the current value

## <span id="spark.sql.debug.maxToStringFields"> spark.sql.debug.maxToStringFields

Maximum number of fields of sequence-like entries can be converted to strings in debug output. Any elements beyond the limit will be dropped and replaced by a "... N more fields" placeholder.

Default: `25`

Use [SQLConf.maxToStringFields](SQLConf.md#maxToStringFields) method to access the current value.

## <span id="spark.sql.defaultCatalog"> spark.sql.defaultCatalog

Name of the default catalog

Default: [spark_catalog](connector/catalog/CatalogManager.md#SESSION_CATALOG_NAME)

Use [SQLConf.DEFAULT_CATALOG](SQLConf.md#DEFAULT_CATALOG) to access the current value.

## <span id="spark.sql.execution.arrow.pyspark.enabled"> spark.sql.execution.arrow.pyspark.enabled

When true, make use of Apache Arrow for columnar data transfers in PySpark. This optimization applies to:

1. pyspark.sql.DataFrame.toPandas
2. pyspark.sql.SparkSession.createDataFrame when its input is a Pandas DataFrame

The following data types are unsupported: BinaryType, MapType, [ArrayType](types/ArrayType.md) of TimestampType, and nested StructType.

Default: `false`

## <span id="spark.sql.execution.removeRedundantSorts"> spark.sql.execution.removeRedundantSorts

**(internal)** Whether to remove redundant physical sort node

Default: `true`

Used as [SQLConf.REMOVE_REDUNDANT_SORTS_ENABLED](SQLConf.md#REMOVE_REDUNDANT_SORTS_ENABLED)

## <span id="spark.sql.execution.reuseSubquery"> spark.sql.execution.reuseSubquery

**(internal)** When `true`, the planner will try to find duplicated subqueries and re-use them.

Default: `true`

Use [SQLConf.subqueryReuseEnabled](SQLConf.md#subqueryReuseEnabled) for the current value

## <span id="spark.sql.execution.sortBeforeRepartition"> spark.sql.execution.sortBeforeRepartition

**(internal)** When perform a repartition following a shuffle, the output row ordering would be nondeterministic. If some downstream stages fail and some tasks of the repartition stage retry, these tasks may generate different data, and that can lead to correctness issues. Turn on this config to insert a local sort before actually doing repartition to generate consistent repartition results. The performance of `repartition()` may go down since we insert extra local sort before it.

Default: `true`

Since: `2.1.4`

Use [SQLConf.sortBeforeRepartition](SQLConf.md#sortBeforeRepartition) method to access the current value.

## <span id="spark.sql.execution.rangeExchange.sampleSizePerPartition"> spark.sql.execution.rangeExchange.sampleSizePerPartition

**(internal)** Number of points to sample per partition in order to determine the range boundaries for range partitioning, typically used in global sorting (without limit).

Default: `100`

Since: `2.3.0`

Use [SQLConf.rangeExchangeSampleSizePerPartition](SQLConf.md#rangeExchangeSampleSizePerPartition) method to access the current value.

## <span id="spark.sql.execution.arrow.pyspark.fallback.enabled"> spark.sql.execution.arrow.pyspark.fallback.enabled

When true, optimizations enabled by [spark.sql.execution.arrow.pyspark.enabled](#spark.sql.execution.arrow.pyspark.enabled) will fallback automatically to non-optimized implementations if an error occurs.

Default: `true`

## <span id="spark.sql.execution.arrow.sparkr.enabled"> spark.sql.execution.arrow.sparkr.enabled

When true, make use of Apache Arrow for columnar data transfers in SparkR.
This optimization applies to:

1. createDataFrame when its input is an R DataFrame
2. collect
3. dapply
4. gapply

The following data types are unsupported:
FloatType, BinaryType, [ArrayType](types/ArrayType.md), StructType and MapType.

Default: `false`

## <span id="spark.sql.execution.pandas.udf.buffer.size"> spark.sql.execution.pandas.udf.buffer.size

Same as `${BUFFER_SIZE.key}` but only applies to Pandas UDF executions. If it is not set, the fallback is `${BUFFER_SIZE.key}`. Note that Pandas execution requires more than 4 bytes. Lowering this value could make small Pandas UDF batch iterated and pipelined; however, it might degrade performance. See SPARK-27870.

Default: `65536`

## <span id="spark.sql.execution.pandas.convertToArrowArraySafely"> spark.sql.execution.pandas.convertToArrowArraySafely

**(internal)** When true, Arrow will perform safe type conversion when converting Pandas.
Series to Arrow array during serialization. Arrow will raise errors when detecting unsafe type conversion like overflow. When false, disabling Arrow's type check and do type conversions anyway. This config only works for Arrow 0.11.0+.

Default: `false`

## <span id="spark.sql.statistics.histogram.enabled"> spark.sql.statistics.histogram.enabled

Enables generating histograms for [ANALYZE TABLE](sql/AstBuilder.md#visitAnalyze) SQL statement

Default: `false`

!!! note "Equi-Height Histogram"
    Histograms can provide better estimation accuracy. Currently, Spark only supports equi-height histogram. Note that collecting histograms takes extra cost. For example, collecting column statistics usually takes only one table scan, but generating equi-height histogram will cause an extra table scan.

Use [SQLConf.histogramEnabled](SQLConf.md#histogramEnabled) method to access the current value.

## <span id="spark.sql.session.timeZone"> spark.sql.session.timeZone

The ID of session-local timezone (e.g. "GMT", "America/Los_Angeles")

Default: Java's `TimeZone.getDefault.getID`

Use [SQLConf.sessionLocalTimeZone](SQLConf.md#sessionLocalTimeZone) method to access the current value.

## <span id="spark.sql.sources.commitProtocolClass"> spark.sql.sources.commitProtocolClass

**(internal)** Fully-qualified class name of the `FileCommitProtocol` ([Spark Core]({{ book.spark_core }}/FileCommitProtocol))

Default: [SQLHadoopMapReduceCommitProtocol](datasources/SQLHadoopMapReduceCommitProtocol.md)

Use [SQLConf.fileCommitProtocolClass](SQLConf.md#fileCommitProtocolClass) method to access the current value.

## <span id="spark.sql.sources.ignoreDataLocality"> spark.sql.sources.ignoreDataLocality

**(internal)** When `true`, Spark will not fetch the block locations for each file on listing files. This speeds up file listing, but the scheduler cannot schedule tasks to take advantage of data locality. It can be particularly useful if data is read from a remote cluster so the scheduler could never take advantage of locality anyway.

Default: `false`

## <span id="spark.sql.sources.outputCommitterClass"><span id="OUTPUT_COMMITTER_CLASS"> spark.sql.sources.outputCommitterClass

**(internal)** The fully-qualified class name of the user-defined Hadoop [OutputCommitter]({{ hadoop.api }}/org/apache/hadoop/mapreduce/OutputCommitter.html) used by data sources

Default: `undefined`

Use [SQLConf.OUTPUT_COMMITTER_CLASS](SQLConf.md#OUTPUT_COMMITTER_CLASS) to access the property

## <span id="spark.sql.sources.validatePartitionColumns"> spark.sql.sources.validatePartitionColumns

**(internal)** When this option is set to true, partition column values will be validated with user-specified schema. If the validation fails, a runtime exception is thrown. When this option is set to false, the partition column value will be converted to null if it can not be casted to corresponding user-specified schema.

Default: `true`

## <span id="spark.sql.sources.useV1SourceList"><span id="USE_V1_SOURCE_LIST"> spark.sql.sources.useV1SourceList

**(internal)** A comma-separated list of data source short names ([DataSourceRegister](DataSourceRegister.md)s) or fully-qualified canonical class names of the data sources ([TableProvider](connector/TableProvider.md)s) for which DataSource V2 code path is disabled (and Data Source V1 code path used).

Default: `avro,csv,json,kafka,orc,parquet,text`

Used when:

* `DataSource` utility is used to [lookupDataSourceV2](DataSource.md#lookupDataSourceV2)

## <span id="spark.sql.storeAssignmentPolicy"> spark.sql.storeAssignmentPolicy

When inserting a value into a column with different data type, Spark will perform type coercion. Currently, we support 3 policies for the type coercion rules: ANSI, legacy and strict. With ANSI policy, Spark performs the type coercion as per ANSI SQL. In practice, the behavior is mostly the same as PostgreSQL. It disallows certain unreasonable type conversions such as converting `string` to `int` or `double` to `boolean`. With legacy policy, Spark allows the type coercion as long as it is a valid `Cast`, which is very loose. e.g. converting `string` to `int` or `double` to `boolean` is allowed. It is also the only behavior in Spark 2.x and it is compatible with Hive. With strict policy, Spark doesn't allow any possible precision loss or data truncation in type coercion, e.g. converting `double` to `int` or `decimal` to `double` is not allowed.

Possible values: `ANSI`, `LEGACY`, `STRICT`

Default: `ANSI`

## <span id="spark.sql.thriftServer.interruptOnCancel"> spark.sql.thriftServer.interruptOnCancel

When `true`, all running tasks will be interrupted if one cancels a query.
When `false`, all running tasks will remain until finished.

Default: `false`

Use [SQLConf.THRIFTSERVER_FORCE_CANCEL](SQLConf.md#THRIFTSERVER_FORCE_CANCEL) to access the property

## <span id="spark.sql.hive.tablePropertyLengthThreshold"> spark.sql.hive.tablePropertyLengthThreshold

**(internal)** The maximum length allowed in a single cell when storing Spark-specific information in Hive's metastore as table properties.
Currently it covers 2 things: the schema's JSON string, the histogram of column statistics.

Default: (undefined)

Use [SQLConf.dynamicPartitionPruningEnabled](SQLConf.md#dynamicPartitionPruningEnabled) to access the current value.

## <span id="spark.sql.orc.mergeSchema"> spark.sql.orc.mergeSchema

When true, the Orc data source merges schemas collected from all data files, otherwise the schema is picked from a random data file.

Default: `false`

## <span id="spark.sql.sources.bucketing.autoBucketedScan.enabled"> spark.sql.sources.bucketing.autoBucketedScan.enabled

When `true`, decide whether to do bucketed scan on input tables based on query plan automatically. Do not use bucketed scan if 1. query does not have operators to utilize bucketing (e.g. join, group-by, etc), or 2. there's an exchange operator between these operators and table scan.

Note when [spark.sql.sources.bucketing.enabled](#spark.sql.sources.bucketing.enabled) is set to `false`, this configuration does not take any effect.

Default: `true`

Use [SQLConf.autoBucketedScanEnabled](SQLConf.md#autoBucketedScanEnabled) to access the property

## <span id="spark.sql.datetime.java8API.enabled"> spark.sql.datetime.java8API.enabled

When `true`, java.time.Instant and java.time.LocalDate classes of Java 8 API are used as external types for Catalyst's TimestampType and DateType. When `false`, java.sql.Timestamp and java.sql.Date are used for the same purpose.

Default: `false`

## <span id="spark.sql.legacy.interval.enabled"> spark.sql.legacy.interval.enabled

**(internal)** When `true`, Spark SQL uses the mixed legacy interval type `CalendarIntervalType` instead of the ANSI compliant interval types `YearMonthIntervalType` and `DayTimeIntervalType`.
For instance, the date subtraction expression returns `CalendarIntervalType` when the SQL config is set to `true` otherwise an ANSI interval.

Default: `false`

Use [SQLConf.legacyIntervalEnabled](SQLConf.md#legacyIntervalEnabled) to access the current value

## <span id="spark.sql.sources.binaryFile.maxLength"> spark.sql.sources.binaryFile.maxLength

**(internal)** The max length of a file that can be read by the binary file data source. Spark will fail fast and not attempt to read the file if its length exceeds this value. The theoretical max is Int.MaxValue, though VMs might implement a smaller max.

Default: `Int.MaxValue`

## <span id="spark.sql.mapKeyDedupPolicy"> spark.sql.mapKeyDedupPolicy

The policy to deduplicate map keys in builtin function: CreateMap, MapFromArrays, MapFromEntries, StringToMap, MapConcat and TransformKeys. When EXCEPTION, the query fails if duplicated map keys are detected. When LAST_WIN, the map key that is inserted at last takes precedence.

Possible values: `EXCEPTION`, `LAST_WIN`

Default: `EXCEPTION`

## <span id="spark.sql.maxConcurrentOutputFileWriters"> spark.sql.maxConcurrentOutputFileWriters

**(internal)** Maximum number of output file writers for `FileFormatWriter` to use concurrently ([writing out a query result](datasources/FileFormatWriter.md#write)). If number of writers needed reaches this limit, a task will sort rest of output then writing them.

Default: `0`

Use [SQLConf.maxConcurrentOutputFileWriters](SQLConf.md#maxConcurrentOutputFileWriters) for the current value

## <span id="spark.sql.maxMetadataStringLength"> spark.sql.maxMetadataStringLength

Maximum number of characters to output for a metadata string (e.g., `Location` in [FileScan](datasources/FileScan.md#getMetaData))

Default: `100`

Must be bigger than `3`

Use [SQLConf.maxMetadataStringLength](SQLConf.md#maxMetadataStringLength) for the current value

## <span id="spark.sql.maven.additionalRemoteRepositories"> spark.sql.maven.additionalRemoteRepositories

A comma-delimited string config of the optional additional remote Maven mirror repositories. This is only used for downloading Hive jars in IsolatedClientLoader if the default Maven Central repo is unreachable.

Default: `https://maven-central.storage-download.googleapis.com/maven2/`

## <span id="spark.sql.maxPlanStringLength"> spark.sql.maxPlanStringLength

Maximum number of characters to output for a plan string.  If the plan is longer, further output will be truncated.
The default setting always generates a full plan.
Set this to a lower value such as 8k if plan strings are taking up too much memory or are causing OutOfMemory errors in the driver or UI processes.

Default: `Integer.MAX_VALUE - 15`

## <span id="spark.sql.addPartitionInBatch.size"> spark.sql.addPartitionInBatch.size

**(internal)** The number of partitions to be handled in one turn when use `AlterTableAddPartitionCommand` to add partitions into table. The smaller batch size is, the less memory is required for the real handler, e.g. Hive Metastore.

Default: `100`

## <span id="spark.sql.scriptTransformation.exitTimeoutInSeconds"> spark.sql.scriptTransformation.exitTimeoutInSeconds

**(internal)** Timeout for executor to wait for the termination of transformation script when EOF.

Default: `10` seconds

## <span id="spark.sql.avro.compression.codec"> spark.sql.avro.compression.codec

The compression codec to use when writing Avro data to disk

Default: `snappy`

The supported codecs are:

* `uncompressed`
* `deflate`
* `snappy`
* `bzip2`
* `xz`

Use [SQLConf.avroCompressionCodec](SQLConf.md#avroCompressionCodec) method to access the current value.

## <span id="spark.sql.broadcastTimeout"> spark.sql.broadcastTimeout

Timeout in seconds for the broadcast wait time in broadcast joins.

Default: `5 * 60`

When negative, it is assumed infinite (i.e. `Duration.Inf`)

Use [SQLConf.broadcastTimeout](SQLConf.md#broadcastTimeout) method to access the current value.

## <span id="spark.sql.bucketing.coalesceBucketsInJoin.enabled"> spark.sql.bucketing.coalesceBucketsInJoin.enabled

When enabled (`true`), if two bucketed tables with the different number of buckets are joined, the side with a bigger number of buckets will be coalesced to have the same number of buckets as the other side. Bigger number of buckets is divisible by the smaller number of buckets. Bucket coalescing is applied to sort-merge joins and shuffled hash join.

!!! note
    Coalescing bucketed table can avoid unnecessary shuffling in join, but it also reduces parallelism and could possibly cause OOM for shuffled hash join.

Default: `false`

Use [SQLConf.coalesceBucketsInJoinEnabled](SQLConf.md#coalesceBucketsInJoinEnabled) method to access the current value.

## <span id="spark.sql.caseSensitive"> spark.sql.caseSensitive

**(internal)** Controls whether the query analyzer should be case sensitive (`true`) or not (`false`).

Default: `false`

It is highly discouraged to turn on case sensitive mode.

Use [SQLConf.caseSensitiveAnalysis](SQLConf.md#caseSensitiveAnalysis) method to access the current value.

## <span id="spark.sql.catalog.spark_catalog"><span id="V2_SESSION_CATALOG_IMPLEMENTATION"> spark.sql.catalog.spark_catalog

The [CatalogPlugin](connector/catalog/CatalogPlugin.md) for `spark_catalog`

Default: [defaultSessionCatalog](connector/catalog/CatalogManager.md#defaultSessionCatalog)

## <span id="spark.sql.cbo.enabled"> spark.sql.cbo.enabled

Enables [Cost-Based Optimization](cost-based-optimization/index.md) (CBO) for estimation of plan statistics when `true`.

Default: `false`

Use [SQLConf.cboEnabled](SQLConf.md#cboEnabled) method to access the current value.

## <span id="spark.sql.cbo.joinReorder.enabled"> spark.sql.cbo.joinReorder.enabled

Enables join reorder for cost-based optimization (CBO).

Default: `false`

Use [SQLConf.joinReorderEnabled](SQLConf.md#joinReorderEnabled) method to access the current value.

## <span id="spark.sql.cbo.planStats.enabled"> spark.sql.cbo.planStats.enabled

When `true`, the logical plan will fetch row counts and column statistics from catalog.

Default: `false`

## <span id="spark.sql.cbo.starSchemaDetection"> spark.sql.cbo.starSchemaDetection

Enables *join reordering* based on star schema detection for cost-based optimization (CBO) in [ReorderJoin](logical-optimizations/ReorderJoin.md) logical plan optimization.

Default: `false`

Use [SQLConf.starSchemaDetection](SQLConf.md#starSchemaDetection) method to access the current value.

## <span id="spark.sql.codegen.aggregate.map.vectorized.enable"> spark.sql.codegen.aggregate.map.vectorized.enable

**(internal)** Enables vectorized aggregate hash map. This is for testing/benchmarking only.

Default: `false`

## <span id="spark.sql.codegen.aggregate.splitAggregateFunc.enabled"> spark.sql.codegen.aggregate.splitAggregateFunc.enabled

**(internal)** When true, the code generator would split aggregate code into individual methods instead of a single big method. This can be used to avoid oversized function that can miss the opportunity of JIT optimization.

Default: `true`

## <span id="spark.sql.codegen.comments"> spark.sql.codegen.comments

Controls whether `CodegenContext` should [register comments](physical-operators/CodegenSupport.md#registerComment) (`true`) or not (`false`).

Default: `false`

## <span id="spark.sql.codegen.factoryMode"> spark.sql.codegen.factoryMode

**(internal)** Determines the codegen generator fallback behavior

Default: `FALLBACK`

Acceptable values:

* `CODEGEN_ONLY` - disable fallback mode
* `FALLBACK` - try codegen first and, if any compile error happens, fallback to interpreted mode
* `NO_CODEGEN` - skips codegen and always uses interpreted path

Used when `CodeGeneratorWithInterpretedFallback` is requested to [createObject](expressions/CodeGeneratorWithInterpretedFallback.md#createObject) (when `UnsafeProjection` is requested to [create an UnsafeProjection for Catalyst expressions](expressions/UnsafeProjection.md#create))

## <span id="spark.sql.codegen.useIdInClassName"> spark.sql.codegen.useIdInClassName

**(internal)** Controls whether to embed the (whole-stage) codegen stage ID into the class name of the generated class as a suffix (`true`) or not (`false`)

Default: `true`

Use [SQLConf.wholeStageUseIdInClassName](SQLConf.md#wholeStageUseIdInClassName) method to access the current value.

## <span id="spark.sql.codegen.maxFields"> spark.sql.codegen.maxFields

**(internal)** Maximum number of output fields (including nested fields) that whole-stage codegen supports. Going above the number deactivates whole-stage codegen.

Default: `100`

Use [SQLConf.wholeStageMaxNumFields](SQLConf.md#wholeStageMaxNumFields) method to access the current value.

## <span id="spark.sql.codegen.splitConsumeFuncByOperator"> spark.sql.codegen.splitConsumeFuncByOperator

**(internal)** Controls whether whole stage codegen puts the logic of consuming rows of each physical operator into individual methods, instead of a single big method. This can be used to avoid oversized function that can miss the opportunity of JIT optimization.

Default: `true`

Use [SQLConf.wholeStageSplitConsumeFuncByOperator](SQLConf.md#wholeStageSplitConsumeFuncByOperator) method to access the current value.

## <span id="spark.sql.columnNameOfCorruptRecord"> spark.sql.columnNameOfCorruptRecord

## <span id="spark.sql.constraintPropagation.enabled"> spark.sql.constraintPropagation.enabled

**(internal)** When true, the query optimizer will infer and propagate data constraints in the query plan to optimize them. Constraint propagation can sometimes be computationally expensive for certain kinds of query plans (such as those with a large number of predicates and aliases) which might negatively impact overall runtime.

Default: `true`

Use [SQLConf.constraintPropagationEnabled](SQLConf.md#constraintPropagationEnabled) method to access the current value.

## <span id="spark.sql.csv.filterPushdown.enabled"> spark.sql.csv.filterPushdown.enabled

**(internal)** When `true`, enable filter pushdown to CSV datasource.

Default: `true`

## <span id="spark.sql.defaultSizeInBytes"> spark.sql.defaultSizeInBytes

**(internal)** Estimated size of a table or relation used in query planning

Default: Java's `Long.MaxValue`

Set to Java's `Long.MaxValue` which is larger than [spark.sql.autoBroadcastJoinThreshold](#spark.sql.autoBroadcastJoinThreshold) to be more conservative. That is to say by default the optimizer will not choose to broadcast a table unless it knows for sure that the table size is small enough.

Used by the planner to decide when it is safe to broadcast a relation. By default, the system will assume that tables are too large to broadcast.

Use [SQLConf.defaultSizeInBytes](SQLConf.md#defaultSizeInBytes) method to access the current value.

## <span id="spark.sql.dialect"> spark.sql.dialect

## <span id="spark.sql.execution.useObjectHashAggregateExec"> execution.useObjectHashAggregateExec

**spark.sql.execution.useObjectHashAggregateExec**

**(internal)** [Prefers ObjectHashAggregateExec (over SortAggregateExec) for aggregation](AggUtils.md#createAggregate)

Default: `true`

Use [SQLConf.useObjectHashAggregation](SQLConf.md#useObjectHashAggregation) method to access the current value.

## <span id="spark.sql.files.ignoreCorruptFiles"> spark.sql.files.ignoreCorruptFiles

Controls whether to ignore corrupt files (`true`) or not (`false`). If `true`, the Spark jobs will continue to run when encountering corrupted files and the contents that have been read will still be returned.

Default: `false`

Use [SQLConf.ignoreCorruptFiles](SQLConf.md#ignoreCorruptFiles) method to access the current value.

## <span id="spark.sql.files.ignoreMissingFiles"> spark.sql.files.ignoreMissingFiles

Controls whether to ignore missing files (`true`) or not (`false`). If `true`, the Spark jobs will continue to run when encountering missing files and the contents that have been read will still be returned.

Default: `false`

Use [SQLConf.ignoreMissingFiles](SQLConf.md#ignoreMissingFiles) method to access the current value.

## <span id="spark.sql.files.maxRecordsPerFile"> spark.sql.files.maxRecordsPerFile

Maximum number of records to write out to a single file. If this value is `0` or negative, there is no limit.

Default: `0`

Use [SQLConf.maxRecordsPerFile](SQLConf.md#maxRecordsPerFile) method to access the current value.

## <span id="spark.sql.inMemoryColumnarStorage.compressed"> spark.sql.inMemoryColumnarStorage.compressed

When enabled, Spark SQL will automatically select a compression codec for each column based on statistics of the data.

Default: `true`

Use [SQLConf.useCompression](SQLConf.md#useCompression) method to access the current value.

## <span id="spark.sql.inMemoryColumnarStorage.batchSize"> spark.sql.inMemoryColumnarStorage.batchSize

Controls the size of batches for columnar caching. Larger batch sizes can improve memory utilization and compression, but risk OOMs when caching data.

Default: `10000`

Use [SQLConf.columnBatchSize](SQLConf.md#columnBatchSize) method to access the current value.

## <span id="spark.sql.inMemoryTableScanStatistics.enable"> spark.sql.inMemoryTableScanStatistics.enable

**(internal)** When true, enable in-memory table scan accumulators.

Default: `false`

## <span id="spark.sql.inMemoryColumnarStorage.enableVectorizedReader"> spark.sql.inMemoryColumnarStorage.enableVectorizedReader

Enables [vectorized reader](vectorized-query-execution/index.md) for columnar caching

Default: `true`

Use [SQLConf.cacheVectorizedReaderEnabled](SQLConf.md#cacheVectorizedReaderEnabled) method to access the current value.

## <span id="spark.sql.join.preferSortMergeJoin"> spark.sql.join.preferSortMergeJoin

**(internal)** Controls whether [JoinSelection](execution-planning-strategies/JoinSelection.md) execution planning strategy prefers [sort merge join](physical-operators/SortMergeJoinExec.md) over [shuffled hash join](physical-operators/ShuffledHashJoinExec.md).

Default: `true`

Use [SQLConf.preferSortMergeJoin](SQLConf.md#preferSortMergeJoin) method to access the current value.

## <span id="spark.sql.jsonGenerator.ignoreNullFields"> spark.sql.jsonGenerator.ignoreNullFields

Whether to ignore null fields when generating JSON objects in JSON data source and JSON functions such as to_json. If false, it generates null for null fields in JSON objects.

Default: `true`

## <span id="spark.sql.leafNodeDefaultParallelism"><span id="LEAF_NODE_DEFAULT_PARALLELISM"> spark.sql.leafNodeDefaultParallelism

The [default parallelism of leaf operators](SparkSession.md#leafNodeDefaultParallelism) that produce data

Must be positive

Default: `SparkContext.defaultParallelism` ([Spark Core]({{ book.spark_core }}/SparkContext#defaultParallelism))

## <span id="spark.sql.legacy.doLooseUpcast"> spark.sql.legacy.doLooseUpcast

**(internal)** When `true`, the upcast will be loose and allows string to atomic types.

Default: `false`

## <span id="spark.sql.legacy.ctePrecedencePolicy"> spark.sql.legacy.ctePrecedencePolicy

**(internal)** This config will be removed in future versions and `CORRECTED` will be the only behavior.

Possible values:

1. `CORRECTED` - inner CTE definitions take precedence
1. `EXCEPTION` - `AnalysisException` is thrown while name conflict is detected in nested CTE
1. `LEGACY` - outer CTE definitions takes precedence over inner definitions

Default: `EXCEPTION`

## <span id="spark.sql.legacy.timeParserPolicy"> spark.sql.legacy.timeParserPolicy

**(internal)** When LEGACY, java.text.SimpleDateFormat is used for formatting and parsing dates/timestamps in a locale-sensitive manner, which is the approach before Spark 3.0. When set to CORRECTED, classes from `java.time.*` packages are used for the same purpose. The default value is EXCEPTION, RuntimeException is thrown when we will get different results.

Possible values: `EXCEPTION`, `LEGACY`, `CORRECTED`

Default: `EXCEPTION`

## <span id="spark.sql.legacy.followThreeValuedLogicInArrayExists"> spark.sql.legacy.followThreeValuedLogicInArrayExists

**(internal)** When true, the ArrayExists will follow the three-valued boolean logic.

Default: `true`

## <span id="spark.sql.legacy.fromDayTimeString.enabled"> spark.sql.legacy.fromDayTimeString.enabled

**(internal)** When `true`, the `from` bound is not taken into account in conversion of a day-time string to an interval, and the `to` bound is used to skip all interval units out of the specified range. When `false`, `ParseException` is thrown if the input does not match to the pattern defined by `from` and `to`.

Default: `false`

## <span id="spark.sql.legacy.notReserveProperties"> spark.sql.legacy.notReserveProperties

**(internal)** When `true`, all database and table properties are not reserved and available for create/alter syntaxes. But please be aware that the reserved properties will be silently removed.

Default: `false`

## <span id="spark.sql.legacy.addSingleFileInAddFile"> spark.sql.legacy.addSingleFileInAddFile

**(internal)** When `true`, only a single file can be added using ADD FILE. If false, then users can add directory by passing directory path to ADD FILE.

Default: `false`

## <span id="spark.sql.legacy.exponentLiteralAsDecimal.enabled"> spark.sql.legacy.exponentLiteralAsDecimal.enabled

**(internal)** When `true`, a literal with an exponent (e.g. 1E-30) would be parsed as Decimal rather than Double.

Default: `false`

## <span id="spark.sql.legacy.allowNegativeScaleOfDecimal"> spark.sql.legacy.allowNegativeScaleOfDecimal

**(internal)** When `true`, negative scale of Decimal type is allowed. For example, the type of number 1E10BD under legacy mode is DecimalType(2, -9), but is Decimal(11, 0) in non legacy mode.

Default: `false`

## <span id="spark.sql.legacy.bucketedTableScan.outputOrdering"> spark.sql.legacy.bucketedTableScan.outputOrdering

**(internal)** When `true`, the bucketed table scan will list files during planning to figure out the output ordering, which is expensive and may make the planning quite slow.

Default: `false`

## <span id="spark.sql.legacy.json.allowEmptyString.enabled"> spark.sql.legacy.json.allowEmptyString.enabled

**(internal)** When `true`, the parser of JSON data source treats empty strings as null for some data types such as `IntegerType`.

Default: `false`

## <span id="spark.sql.legacy.createEmptyCollectionUsingStringType"> spark.sql.legacy.createEmptyCollectionUsingStringType

**(internal)** When `true`, Spark returns an empty collection with `StringType` as element type if the `array`/`map` function is called without any parameters. Otherwise, Spark returns an empty collection with `NullType` as element type.

Default: `false`

## <span id="spark.sql.legacy.allowUntypedScalaUDF"> spark.sql.legacy.allowUntypedScalaUDF

**(internal)** When `true`, user is allowed to use `org.apache.spark.sql.functions.udf(f: AnyRef, dataType: DataType)`. Otherwise, an exception will be thrown at runtime.

Default: `false`

## <span id="spark.sql.legacy.dataset.nameNonStructGroupingKeyAsValue"> spark.sql.legacy.dataset.nameNonStructGroupingKeyAsValue

**(internal)** When `true`, the key attribute resulted from running `Dataset.groupByKey` for non-struct key type, will be named as `value`, following the behavior of Spark version 2.4 and earlier.

Default: `false`

## <span id="spark.sql.legacy.setCommandRejectsSparkCoreConfs"> spark.sql.legacy.setCommandRejectsSparkCoreConfs

**(internal)** If it is set to true, SET command will fail when the key is registered as a SparkConf entry.

Default: `true`

## <span id="spark.sql.legacy.typeCoercion.datetimeToString.enabled"> spark.sql.legacy.typeCoercion.datetimeToString.enabled

**(internal)** When `true`, date/timestamp will cast to string in binary comparisons with String

Default: `false`

## <span id="spark.sql.legacy.allowHashOnMapType"> spark.sql.legacy.allowHashOnMapType

**(internal)** When `true`, hash expressions can be applied on elements of MapType. Otherwise, an analysis exception will be thrown.

Default: `false`

## <span id="spark.sql.legacy.parquet.datetimeRebaseModeInWrite"> spark.sql.legacy.parquet.datetimeRebaseModeInWrite

**(internal)** When LEGACY, Spark will rebase dates/timestamps from Proleptic Gregorian calendar to the legacy hybrid (Julian + Gregorian) calendar when writing Parquet files. When CORRECTED, Spark will not do rebase and write the dates/timestamps as it is. When EXCEPTION, which is the default, Spark will fail the writing if it sees ancient dates/timestamps that are ambiguous between the two calendars.

Possible values: `EXCEPTION`, `LEGACY`, `CORRECTED`

Default: `EXCEPTION`

## <span id="spark.sql.legacy.parquet.datetimeRebaseModeInRead"> spark.sql.legacy.parquet.datetimeRebaseModeInRead

**(internal)** When LEGACY, Spark will rebase dates/timestamps from the legacy hybrid (Julian + Gregorian) calendar to Proleptic Gregorian calendar when reading Parquet files. When CORRECTED, Spark will not do rebase and read the dates/timestamps as it is. When EXCEPTION, which is the default, Spark will fail the reading if it sees ancient dates/timestamps that are ambiguous between the two calendars. This config is only effective if the writer info (like Spark, Hive) of the Parquet files is unknown.

Possible values: `EXCEPTION`, `LEGACY`, `CORRECTED`

Default: `EXCEPTION`

## <span id="spark.sql.legacy.avro.datetimeRebaseModeInWrite"> spark.sql.legacy.avro.datetimeRebaseModeInWrite

**(internal)** When LEGACY, Spark will rebase dates/timestamps from Proleptic Gregorian calendar to the legacy hybrid (Julian + Gregorian) calendar when writing Avro files. When CORRECTED, Spark will not do rebase and write the dates/timestamps as it is. When EXCEPTION, which is the default, Spark will fail the writing if it sees ancient dates/timestamps that are ambiguous between the two calendars.

Possible values: `EXCEPTION`, `LEGACY`, `CORRECTED`

Default: `EXCEPTION`

## <span id="spark.sql.legacy.avro.datetimeRebaseModeInRead"> spark.sql.legacy.avro.datetimeRebaseModeInRead

**(internal)** When LEGACY, Spark will rebase dates/timestamps from the legacy hybrid (Julian + Gregorian) calendar to Proleptic Gregorian calendar when reading Avro files. When CORRECTED, Spark will not do rebase and read the dates/timestamps as it is. When EXCEPTION, which is the default, Spark will fail the reading if it sees ancient dates/timestamps that are ambiguous between the two calendars. This config is only effective if the writer info (like Spark, Hive) of the Avro files is unknown.

Possible values: `EXCEPTION`, `LEGACY`, `CORRECTED`

Default: `EXCEPTION`

## <span id="spark.sql.legacy.rdd.applyConf"> spark.sql.legacy.rdd.applyConf

**(internal)** Enables propagation of [SQL configurations](SQLConf.md#getAllConfs) when executing operations on the [RDD that represents a structured query](QueryExecution.md#toRdd). This is the (buggy) behavior up to 2.4.4.

Default: `true`

This is for cases not tracked by [SQL execution](SQLExecution.md), when a `Dataset` is converted to an RDD either using Dataset.md#rdd[rdd] operation or [QueryExecution](QueryExecution.md#toRdd), and then the returned RDD is used to invoke actions on it.

This config is deprecated and will be removed in 3.0.0.

## <span id="spark.sql.legacy.replaceDatabricksSparkAvro.enabled"> spark.sql.legacy.replaceDatabricksSparkAvro.enabled

Enables resolving (_mapping_) the data source provider `com.databricks.spark.avro` to the built-in (but external) Avro data source module for backward compatibility.

Default: `true`

Use [SQLConf.replaceDatabricksSparkAvroEnabled](SQLConf.md#replaceDatabricksSparkAvroEnabled) method to access the current value.

## <span id="spark.sql.limit.scaleUpFactor"> spark.sql.limit.scaleUpFactor

**(internal)** Minimal increase rate in the number of partitions between attempts when executing `take` operator on a structured query. Higher values lead to more partitions read. Lower values might lead to longer execution times as more jobs will be run.

Default: `4`

Use [SQLConf.limitScaleUpFactor](SQLConf.md#limitScaleUpFactor) method to access the current value.

## <span id="spark.sql.optimizeNullAwareAntiJoin"> spark.sql.optimizeNullAwareAntiJoin

**(internal)** Enables [single-column NULL-aware anti join execution planning](ExtractSingleColumnNullAwareAntiJoin.md#unapply) into [BroadcastHashJoinExec](physical-operators/BroadcastHashJoinExec.md) (with flag [isNullAwareAntiJoin](physical-operators/BroadcastHashJoinExec.md#isNullAwareAntiJoin) enabled), optimized from O(M*N) calculation into O(M) calculation using hash lookup instead of looping lookup.

Default: `true`

Use [SQLConf.optimizeNullAwareAntiJoin](SQLConf.md#optimizeNullAwareAntiJoin) method to access the current value.

## <span id="spark.sql.orc.impl"> spark.sql.orc.impl

**(internal)** When `native`, use the native version of ORC support instead of the ORC library in Hive 1.2.1.

Default: `native`

Acceptable values:

* `hive`
* `native`

## <span id="spark.sql.planChangeLog.level"> spark.sql.planChangeLog.level

**(internal)** Log level for logging the change from the original plan to the new plan after a rule or batch is applied.

Default: `trace`

Supported Values (case-insensitive):

* trace
* debug
* info
* warn
* error

Use [SQLConf.planChangeLogLevel](SQLConf.md#planChangeLogLevel) method to access the current value.

## <span id="spark.sql.planChangeLog.batches"> spark.sql.planChangeLog.batches

**(internal)** Comma-separated list of batch names for plan changes logging

Default: (undefined)

Use [SQLConf.planChangeBatches](SQLConf.md#planChangeBatches) method to access the current value.

## <span id="spark.sql.planChangeLog.rules"> spark.sql.planChangeLog.rules

**(internal)** Comma-separated list of rule names for plan changes logging

Default: (undefined)

Use [SQLConf.planChangeRules](SQLConf.md#planChangeRules) method to access the current value.

## <span id="spark.sql.pyspark.jvmStacktrace.enabled"> spark.sql.pyspark.jvmStacktrace.enabled

When true, it shows the JVM stacktrace in the user-facing PySpark exception together with Python stacktrace. By default, it is disabled and hides JVM stacktrace and shows a Python-friendly exception only.

Default: `false`

## <span id="spark.sql.parquet.binaryAsString"> spark.sql.parquet.binaryAsString

Some other Parquet-producing systems, in particular Impala and older versions of Spark SQL, do not differentiate between binary data and strings when writing out the Parquet schema. This flag tells Spark SQL to interpret binary data as a string to provide compatibility with these systems.

Default: `false`

Use [SQLConf.isParquetBinaryAsString](SQLConf.md#isParquetBinaryAsString) method to access the current value.

## <span id="spark.sql.parquet.compression.codec"> spark.sql.parquet.compression.codec

Sets the compression codec used when writing Parquet files. If either `compression` or `parquet.compression` is specified in the table-specific options/properties, the precedence would be `compression`, `parquet.compression`, `spark.sql.parquet.compression.codec`.

Acceptable values:

* `brotli`
* `gzip`
* `lz4`
* `lzo`
* `none`
* `snappy`
* `uncompressed`
* `zstd`

Default: `snappy`

Use [SQLConf.parquetCompressionCodec](SQLConf.md#parquetCompressionCodec) method to access the current value.

## <span id="spark.sql.parquet.enableVectorizedReader"> spark.sql.parquet.enableVectorizedReader

Enables [vectorized parquet decoding](vectorized-decoding/index.md).

Default: `true`

Use [SQLConf.parquetVectorizedReaderEnabled](SQLConf.md#parquetVectorizedReaderEnabled) method to access the current value.

## <span id="spark.sql.parquet.filterPushdown"> spark.sql.parquet.filterPushdown

Controls the [filter predicate push-down optimization](logical-optimizations/PushDownPredicate.md) for data sources using [parquet](datasources/parquet/ParquetFileFormat.md) file format

Default: `true`

Use [SQLConf.parquetFilterPushDown](SQLConf.md#parquetFilterPushDown) method to access the current value.

## <span id="spark.sql.parquet.filterPushdown.date"> spark.sql.parquet.filterPushdown.date

**(internal)** Enables parquet filter push-down optimization for `Date` type (when [spark.sql.parquet.filterPushdown](#spark.sql.parquet.filterPushdown) is enabled)

Default: `true`

Use [SQLConf.parquetFilterPushDownDate](SQLConf.md#parquetFilterPushDownDate) method to access the current value.

## <span id="spark.sql.parquet.filterPushdown.decimal"> spark.sql.parquet.filterPushdown.decimal

**(internal)** Enables parquet filter push-down optimization for `Decimal` type (when [spark.sql.parquet.filterPushdown](#spark.sql.parquet.filterPushdown) is enabled)

Default: `true`

Use [SQLConf.parquetFilterPushDownDecimal](SQLConf.md#parquetFilterPushDownDecimal) method to access the current value.

## <span id="spark.sql.parquet.int96RebaseModeInWrite"> spark.sql.parquet.int96RebaseModeInWrite

**(internal)** Enables rebasing timestamps while writing Parquet files

Formerly known as [spark.sql.legacy.parquet.int96RebaseModeInWrite](#spark.sql.legacy.parquet.int96RebaseModeInWrite)

Acceptable values:

* `EXCEPTION` - Fail writing parquet files if there are ancient timestamps that are ambiguous between the two calendars
* `LEGACY` - Rebase `INT96` timestamps from Proleptic Gregorian calendar to the legacy hybrid (Julian + Gregorian) calendar (gives maximum interoperability)
* `CORRECTED` - Write datetime values with no change (*rabase*). Only when you are 100% sure that the written files will only be read by Spark 3.0+ or other systems that use Proleptic Gregorian calendar

Default: `EXCEPTION`

Writing dates before `1582-10-15` or timestamps before `1900-01-01T00:00:00Z` can be dangerous, as the files may be read by Spark 2.x or legacy versions of Hive later, which uses a legacy hybrid calendar that is different from Spark 3.0+'s Proleptic Gregorian calendar.

See more details in SPARK-31404.

## <span id="spark.sql.parquet.pushdown.inFilterThreshold"> spark.sql.parquet.pushdown.inFilterThreshold

**(internal)** For IN predicate, Parquet filter will push-down a set of OR clauses if its number of values not exceeds this threshold. Otherwise, Parquet filter will push-down a value greater than or equal to its minimum value and less than or equal to its maximum value (when [spark.sql.parquet.filterPushdown](#spark.sql.parquet.filterPushdown) is enabled)

Disabled when `0`

Default: `10`

Use [SQLConf.parquetFilterPushDownInFilterThreshold](SQLConf.md#parquetFilterPushDownInFilterThreshold) method to access the current value.

## <span id="spark.sql.parquet.filterPushdown.string.startsWith"> spark.sql.parquet.filterPushdown.string.startsWith

**(internal)** Enables parquet filter push-down optimization for `startsWith` function (when [spark.sql.parquet.filterPushdown](#spark.sql.parquet.filterPushdown) is enabled)

Default: `true`

Use [SQLConf.parquetFilterPushDownStringStartWith](SQLConf.md#parquetFilterPushDownStringStartWith) method to access the current value.

## <span id="spark.sql.parquet.filterPushdown.timestamp"> spark.sql.parquet.filterPushdown.timestamp

**(internal)** Enables parquet filter push-down optimization for `Timestamp` type.
It can only have an effect when the following hold:

1. [spark.sql.parquet.filterPushdown](#spark.sql.parquet.filterPushdown) is enabled
1. `Timestamp` stored as `TIMESTAMP_MICROS` or `TIMESTAMP_MILLIS` type

Default: `true`

Use [SQLConf.parquetFilterPushDownTimestamp](SQLConf.md#parquetFilterPushDownTimestamp) method to access the current value.

## <span id="spark.sql.parquet.int96AsTimestamp"> spark.sql.parquet.int96AsTimestamp

Some Parquet-producing systems, in particular Impala, store Timestamp into INT96. Spark would also store Timestamp as INT96 because we need to avoid precision lost of the nanoseconds field. This flag tells Spark SQL to interpret INT96 data as a timestamp to provide compatibility with these systems.

Default: `true`

Use [SQLConf.isParquetINT96AsTimestamp](SQLConf.md#isParquetINT96AsTimestamp) method to access the current value.

## <span id="spark.sql.parquet.int96TimestampConversion"> spark.sql.parquet.int96TimestampConversion

Controls whether timestamp adjustments should be applied to INT96 data when converting to timestamps, for data written by Impala.

Default: `false`

This is necessary because Impala stores INT96 data with a different timezone offset than Hive and Spark.

Use [SQLConf.isParquetINT96TimestampConversion](SQLConf.md#isParquetINT96TimestampConversion) method to access the current value.

## <span id="spark.sql.parquet.output.committer.class"> spark.sql.parquet.output.committer.class

**(internal)** The output committer class used by [parquet](datasources/parquet/index.md) data source. The specified class needs to be a subclass of `org.apache.hadoop.mapreduce.OutputCommitter`. Typically, it's also a subclass of `org.apache.parquet.hadoop.ParquetOutputCommitter`. If it is not, then metadata summaries will never be created, irrespective of the value of `parquet.summary.metadata.level`.

Default: `org.apache.parquet.hadoop.ParquetOutputCommitter`

Use [SQLConf.parquetOutputCommitterClass](SQLConf.md#parquetOutputCommitterClass) method to access the current value.

## <span id="spark.sql.parquet.outputTimestampType"> spark.sql.parquet.outputTimestampType

Sets which Parquet timestamp type to use when Spark writes data to Parquet files. INT96 is a non-standard but commonly used timestamp type in Parquet. TIMESTAMP_MICROS is a standard timestamp type in Parquet, which stores number of microseconds from the Unix epoch. TIMESTAMP_MILLIS is also standard, but with millisecond precision, which means Spark has to truncate the microsecond portion of its timestamp value.

Acceptable values:

* `INT96`
* `TIMESTAMP_MICROS`
* `TIMESTAMP_MILLIS`

Default: `INT96`

Use [SQLConf.parquetOutputTimestampType](SQLConf.md#parquetOutputTimestampType) method to access the current value.

## <span id="spark.sql.parquet.recordLevelFilter.enabled"> spark.sql.parquet.recordLevelFilter.enabled

Enables Parquet's native record-level filtering using the pushed down filters (when [spark.sql.parquet.filterPushdown](#spark.sql.parquet.filterPushdown) is enabled).

Default: `false`

Use [SQLConf.parquetRecordFilterEnabled](SQLConf.md#parquetRecordFilterEnabled) method to access the current value.

## <span id="spark.sql.parquet.respectSummaryFiles"> spark.sql.parquet.respectSummaryFiles

When true, we make assumption that all part-files of Parquet are consistent with summary files and we will ignore them when merging schema. Otherwise, if this is false, which is the default, we will merge all part-files. This should be considered as expert-only option, and shouldn't be enabled before knowing what it means exactly.

Default: `false`

Use [SQLConf.isParquetSchemaRespectSummaries](SQLConf.md#isParquetSchemaRespectSummaries) method to access the current value.

## <span id="spark.sql.parser.quotedRegexColumnNames"> spark.sql.parser.quotedRegexColumnNames

Controls whether quoted identifiers (using backticks) in SELECT statements should be interpreted as regular expressions.

Default: `false`

Use [SQLConf.supportQuotedRegexColumnName](SQLConf.md#supportQuotedRegexColumnName) method to access the current value.

## <span id="spark.sql.pivotMaxValues"> spark.sql.pivotMaxValues

Maximum number of (distinct) values that will be collected without error (when doing a [pivot](basic-aggregation/RelationalGroupedDataset.md#pivot) without specifying the values for the pivot column)

Default: `10000`

Use [SQLConf.dataFramePivotMaxValues](SQLConf.md#dataFramePivotMaxValues) method to access the current value.

## <span id="spark.sql.redaction.options.regex"> spark.sql.redaction.options.regex

Regular expression to find options of a Spark SQL command with sensitive information

Default: `(?i)secret!password`

The values of the options matched will be redacted in the explain output.

This redaction is applied on top of the global redaction configuration defined by `spark.redaction.regex` configuration.

Used exclusively when `SQLConf` is requested to [redactOptions](SQLConf.md#redactOptions).

## <span id="spark.sql.redaction.string.regex"> spark.sql.redaction.string.regex

Regular expression to point at sensitive information in text output

Default: `(undefined)`

When this regex matches a string part, it is replaced by a dummy value (i.e. `*********(redacted)`). This is currently used to redact the output of SQL explain commands.

NOTE: When this conf is not set, the value of `spark.redaction.string.regex` is used instead.

Use [SQLConf.stringRedactionPattern](SQLConf.md#stringRedactionPattern) method to access the current value.

## <span id="spark.sql.retainGroupColumns"> spark.sql.retainGroupColumns

Controls whether to retain columns used for aggregation or not (in [RelationalGroupedDataset](basic-aggregation/RelationalGroupedDataset.md) operators).

Default: `true`

Use [SQLConf.dataFrameRetainGroupColumns](SQLConf.md#dataFrameRetainGroupColumns) method to access the current value.

## <span id="spark.sql.runSQLOnFiles"> spark.sql.runSQLOnFiles

**(internal)** Controls whether Spark SQL could use `datasource`.`path` as a table in a SQL query.

Default: `true`

Use [SQLConf.runSQLonFile](SQLConf.md#runSQLonFile) method to access the current value.

## <span id="spark.sql.selfJoinAutoResolveAmbiguity"> spark.sql.selfJoinAutoResolveAmbiguity

Controls whether to resolve ambiguity in join conditions for [self-joins](joins.md#join) automatically (`true`) or not (`false`)

Default: `true`

## <span id="spark.sql.sort.enableRadixSort"> spark.sql.sort.enableRadixSort

**(internal)** Controls whether to use radix sort (`true`) or not (`false`) in [ShuffleExchangeExec](physical-operators/ShuffleExchangeExec.md) and [SortExec](physical-operators/SortExec.md) physical operators

Default: `true`

Radix sort is much faster but requires additional memory to be reserved up-front. The memory overhead may be significant when sorting very small rows (up to 50% more).

Use [SQLConf.enableRadixSort](SQLConf.md#enableRadixSort) method to access the current value.

## <span id="spark.sql.sources.bucketing.enabled"> spark.sql.sources.bucketing.enabled

Enables [bucketing](bucketing.md) support. When disabled (i.e. `false`), bucketed tables are considered regular (non-bucketed) tables.

Default: `true`

Use [SQLConf.bucketingEnabled](SQLConf.md#bucketingEnabled) method to access the current value.

## <span id="spark.sql.sources.default"><span id="DEFAULT_DATA_SOURCE_NAME"> spark.sql.sources.default

Default data source to use for loading or saving data

Default: [parquet](datasources/parquet/index.md)

Use [SQLConf.defaultDataSourceName](SQLConf.md#defaultDataSourceName) method to access the current value.

## <span id="spark.sql.statistics.fallBackToHdfs"> spark.sql.statistics.fallBackToHdfs

Enables automatic calculation of table size statistic by falling back to HDFS if the table statistics are not available from table metadata.

Default: `false`

This can be useful in determining if a table is small enough for auto broadcast joins in query planning.

Use [SQLConf.fallBackToHdfsForStatsEnabled](SQLConf.md#fallBackToHdfsForStatsEnabled) method to access the current value.

## <span id="spark.sql.statistics.histogram.numBins"> spark.sql.statistics.histogram.numBins

**(internal)** The number of bins when generating histograms.

Default: `254`

NOTE: The number of bins must be greater than 1.

Use [SQLConf.histogramNumBins](SQLConf.md#histogramNumBins) method to access the current value.

## <span id="spark.sql.statistics.parallelFileListingInStatsComputation.enabled"> spark.sql.statisticsparallelFileListingInStatsComputation.enabled*

**(internal)** Enables parallel file listing in SQL commands, e.g. `ANALYZE TABLE` (as opposed to single thread listing that can be particularly slow with tables with hundreds of partitions)

Default: `true`

Use [SQLConf.parallelFileListingInStatsComputation](SQLConf.md#parallelFileListingInStatsComputation) method to access the current value.

## <span id="spark.sql.statistics.ndv.maxError"> spark.sql.statistics.ndv.maxError

**(internal)** The maximum estimation error allowed in HyperLogLog++ algorithm when generating column level statistics.

Default: `0.05`

## <span id="spark.sql.statistics.percentile.accuracy"> spark.sql.statistics.percentile.accuracy

**(internal)** Accuracy of percentile approximation when generating equi-height histograms. Larger value means better accuracy. The relative error can be deduced by 1.0 / PERCENTILE_ACCURACY.

Default: `10000`

## <span id="spark.sql.statistics.size.autoUpdate.enabled"> spark.sql.statistics.size.autoUpdate.enabled

Enables automatic update of the table size statistic of a table after the table has changed.

Default: `false`

IMPORTANT: If the total number of files of the table is very large this can be expensive and slow down data change commands.

Use [SQLConf.autoSizeUpdateEnabled](SQLConf.md#autoSizeUpdateEnabled) method to access the current value.

## <span id="spark.sql.subexpressionElimination.enabled"> spark.sql.subexpressionElimination.enabled

**(internal)** Enables [Subexpression Elimination](subexpression-elimination.md)

Default: `true`

Use [SQLConf.subexpressionEliminationEnabled](SQLConf.md#subexpressionEliminationEnabled) method to access the current value.

## <span id="spark.sql.shuffle.partitions"> spark.sql.shuffle.partitions

The default number of partitions to use when shuffling data for joins or aggregations.

Default: `200`

!!! note
    Corresponds to Apache Hive's [mapred.reduce.tasks](https://cwiki.apache.org/confluence/display/Hive/Configuration+Properties#ConfigurationProperties-mapred.reduce.tasks) property that Spark SQL considers deprecated.

!!! note "Spark Structured Streaming"
    `spark.sql.shuffle.partitions` cannot be changed in Spark Structured Streaming between query restarts from the same checkpoint location.

Use [SQLConf.numShufflePartitions](SQLConf.md#numShufflePartitions) method to access the current value.

## <span id="spark.sql.sources.fileCompressionFactor"> spark.sql.sources.fileCompressionFactor

**(internal)** When estimating the output data size of a table scan, multiply the file size with this factor as the estimated data size, in case the data is compressed in the file and lead to a heavily underestimated result.

Default: `1.0`

Use [SQLConf.fileCompressionFactor](SQLConf.md#fileCompressionFactor) method to access the current value.

## <span id="spark.sql.sources.partitionOverwriteMode"> spark.sql.sources.partitionOverwriteMode

Enables [dynamic partition inserts](dynamic-partition-inserts.md) when `dynamic`

Default: `static`

When `INSERT OVERWRITE` a partitioned data source table with dynamic partition columns, Spark SQL supports two modes (case-insensitive):

* **static** - Spark deletes all the partitions that match the partition specification (e.g. `PARTITION(a=1,b)`) in the INSERT statement, before overwriting

* **dynamic** - Spark doesn't delete partitions ahead, and only overwrites those partitions that have data written into it

The default `STATIC` overwrite mode is to keep the same behavior of Spark prior to 2.3. Note that this config doesn't affect Hive serde tables, as they are always overwritten with dynamic mode.

Use [SQLConf.partitionOverwriteMode](SQLConf.md#partitionOverwriteMode) method to access the current value.

## <span id="spark.sql.truncateTable.ignorePermissionAcl.enabled"> spark.sql.truncateTable.ignorePermissionAcl.enabled

**(internal)** Disables setting back original permission and ACLs when re-creating the table/partition paths for [TRUNCATE TABLE](logical-operators/TruncateTableCommand.md) command.

Default: `false`

Use [SQLConf.truncateTableIgnorePermissionAcl](SQLConf.md#truncateTableIgnorePermissionAcl) method to access the current value.

## <span id="spark.sql.ui.retainedExecutions"> spark.sql.ui.retainedExecutions

Number of `SQLExecutionUIData`s to keep in `failedExecutions` and `completedExecutions` internal registries.

Default: `1000`

When a query execution finishes, the execution is removed from the internal `activeExecutions` registry and stored in `failedExecutions` or `completedExecutions` given the end execution status. It is when `SQLListener` makes sure that the number of `SQLExecutionUIData` entires does not exceed `spark.sql.ui.retainedExecutions` Spark property and removes the excess of entries.

## <span id="spark.sql.variable.substitute"> spark.sql.variable.substitute

Enables [Variable Substitution](variable-substitution.md)

Default: `true`

Use [SQLConf.variableSubstituteEnabled](SQLConf.md#variableSubstituteEnabled) method to access the current value.

## <span id="spark.sql.windowExec.buffer.in.memory.threshold"> spark.sql.windowExec.buffer.in.memory.threshold

**(internal)** Threshold for number of rows guaranteed to be held in memory by [WindowExec](physical-operators/WindowExec.md) physical operator.

Default: `4096`

Use [SQLConf.windowExecBufferInMemoryThreshold](SQLConf.md#windowExecBufferInMemoryThreshold) method to access the current value.

## <span id="spark.sql.windowExec.buffer.spill.threshold"> spark.sql.windowExec.buffer.spill.threshold

**(internal)** Threshold for number of rows buffered in a [WindowExec](physical-operators/WindowExec.md) physical operator.

Default: `4096`

Use [SQLConf.windowExecBufferSpillThreshold](SQLConf.md#windowExecBufferSpillThreshold) method to access the current value.
