# SQLConf

`SQLConf` is an internal configuration store of the configuration properties and hints used in Spark SQL.

!!! important
    `SQLConf` is an internal part of Spark SQL and is not supposed to be used directly. Spark SQL configuration is available through the developer-facing [RuntimeConfig](RuntimeConfig.md).

`SQLConf` offers methods to `get`, `set`, `unset` or `clear` values of the configuration properties and hints as well as to read the current values.

## Accessing SQLConf

You can access a `SQLConf` using:

* `SQLConf.get` (preferred) - the `SQLConf` of the current active `SparkSession`

* [SessionState](SparkSession.md#sessionState) - direct access through [SessionState](SparkSession.md#sessionState) of the `SparkSession` of your choice (that gives more flexibility on what `SparkSession` is used that can be different from the current active `SparkSession`)

```text
import org.apache.spark.sql.internal.SQLConf

// Use type-safe access to configuration properties
// using SQLConf.get.getConf
val parallelFileListingInStatsComputation = SQLConf.get.getConf(SQLConf.PARALLEL_FILE_LISTING_IN_STATS_COMPUTATION)

// or even simpler
SQLConf.get.parallelFileListingInStatsComputation
```

```text
scala> :type spark
org.apache.spark.sql.SparkSession

// Direct access to the session SQLConf
val sqlConf = spark.sessionState.conf
scala> :type sqlConf
org.apache.spark.sql.internal.SQLConf

scala> println(sqlConf.offHeapColumnVectorEnabled)
false

// Or simply import the conf value
import spark.sessionState.conf

// accessing properties through accessor methods
scala> conf.numShufflePartitions
res1: Int = 200

// Prefer SQLConf.get (over direct access)
import org.apache.spark.sql.internal.SQLConf
val cc = SQLConf.get
scala> cc == conf
res4: Boolean = true

// setting properties using aliases
import org.apache.spark.sql.internal.SQLConf.SHUFFLE_PARTITIONS
conf.setConf(SHUFFLE_PARTITIONS, 2)
scala> conf.numShufflePartitions
res2: Int = 2

// unset aka reset properties to the default value
conf.unsetConf(SHUFFLE_PARTITIONS)
scala> conf.numShufflePartitions
res3: Int = 200
```

## <span id="ADAPTIVE_AUTO_BROADCASTJOIN_THRESHOLD"> ADAPTIVE_AUTO_BROADCASTJOIN_THRESHOLD

[spark.sql.adaptive.autoBroadcastJoinThreshold](configuration-properties.md#spark.sql.adaptive.autoBroadcastJoinThreshold)

Used when:

* `JoinSelectionHelper` is requested to [canBroadcastBySize](JoinSelectionHelper.md#canBroadcastBySize)

## <span id="ADAPTIVE_EXECUTION_FORCE_APPLY"> ADAPTIVE_EXECUTION_FORCE_APPLY

[spark.sql.adaptive.forceApply](configuration-properties.md#spark.sql.adaptive.forceApply) configuration property

Used when:

* [InsertAdaptiveSparkPlan](physical-optimizations/InsertAdaptiveSparkPlan.md) physical optimization is executed

## <span id="ADAPTIVE_EXECUTION_ENABLED"><span id="adaptiveExecutionEnabled"> adaptiveExecutionEnabled

The value of [spark.sql.adaptive.enabled](configuration-properties.md#spark.sql.adaptive.enabled) configuration property

Used when:

* [InsertAdaptiveSparkPlan](physical-optimizations/InsertAdaptiveSparkPlan.md) physical optimization is executed
* `SQLConf` is requested for the [numShufflePartitions](#numShufflePartitions)

## <span id="ADAPTIVE_EXECUTION_LOG_LEVEL"><span id="adaptiveExecutionLogLevel"> adaptiveExecutionLogLevel

The value of [spark.sql.adaptive.logLevel](configuration-properties.md#spark.sql.adaptive.logLevel) configuration property

Used when [AdaptiveSparkPlanExec](physical-operators/AdaptiveSparkPlanExec.md) physical operator is executed

## <span id="ADAPTIVE_MAX_SHUFFLE_HASH_JOIN_LOCAL_MAP_THRESHOLD"> ADAPTIVE_MAX_SHUFFLE_HASH_JOIN_LOCAL_MAP_THRESHOLD

[spark.sql.adaptive.maxShuffledHashJoinLocalMapThreshold](configuration-properties.md#spark.sql.adaptive.maxShuffledHashJoinLocalMapThreshold) configuration property

Used when:

* `DynamicJoinSelection` is requested to [preferShuffledHashJoin](logical-optimizations/DynamicJoinSelection.md#preferShuffledHashJoin)

## <span id="ADAPTIVE_OPTIMIZER_EXCLUDED_RULES"> ADAPTIVE_OPTIMIZER_EXCLUDED_RULES

[spark.sql.adaptive.optimizer.excludedRules](configuration-properties.md#spark.sql.adaptive.optimizer.excludedRules)

## <span id="ADVISORY_PARTITION_SIZE_IN_BYTES"> ADVISORY_PARTITION_SIZE_IN_BYTES

[spark.sql.adaptive.advisoryPartitionSizeInBytes](configuration-properties.md#spark.sql.adaptive.advisoryPartitionSizeInBytes) configuration property

Used when:

* [CoalesceShufflePartitions](physical-optimizations/CoalesceShufflePartitions.md) and [OptimizeSkewedJoin](physical-optimizations/OptimizeSkewedJoin.md) physical optimizations are executed

## <span id="autoBroadcastJoinThreshold"> autoBroadcastJoinThreshold

The value of [spark.sql.autoBroadcastJoinThreshold](configuration-properties.md#spark.sql.autoBroadcastJoinThreshold) configuration property

Used when:

* [JoinSelection](execution-planning-strategies/JoinSelection.md) execution planning strategy is executed

## <span id="autoBucketedScanEnabled"><span id="AUTO_BUCKETED_SCAN_ENABLED"> autoBucketedScanEnabled

The value of [spark.sql.sources.bucketing.autoBucketedScan.enabled](configuration-properties.md#spark.sql.sources.bucketing.autoBucketedScan.enabled) configuration property

Used when:

* [DisableUnnecessaryBucketedScan](physical-optimizations/DisableUnnecessaryBucketedScan.md) physical optimization is executed

## <span id="ALLOW_STAR_WITH_SINGLE_TABLE_IDENTIFIER_IN_COUNT"><span id="allowStarWithSingleTableIdentifierInCount"> allowStarWithSingleTableIdentifierInCount

[spark.sql.legacy.allowStarWithSingleTableIdentifierInCount](configuration-properties.md#spark.sql.legacy.allowStarWithSingleTableIdentifierInCount)

Used when:

* `ResolveReferences` logical resolution rule is [executed](logical-analysis-rules/ResolveReferences.md#expandStarExpression)

## <span id="ARROW_PYSPARK_SELF_DESTRUCT_ENABLED"><span id="arrowPySparkSelfDestructEnabled"> arrowPySparkSelfDestructEnabled

[spark.sql.execution.arrow.pyspark.selfDestruct.enabled](configuration-properties.md#spark.sql.execution.arrow.pyspark.selfDestruct.enabled)

Used when:

* `PandasConversionMixin` is requested to `toPandas`

## <span id="ALLOW_AUTO_GENERATED_ALIAS_FOR_VEW"><span id="allowAutoGeneratedAliasForView"> allowAutoGeneratedAliasForView

[spark.sql.legacy.allowAutoGeneratedAliasForView](configuration-properties.md#spark.sql.legacy.allowAutoGeneratedAliasForView)

Used when:

* `ViewHelper` utility is used to `verifyAutoGeneratedAliasesNotExists`

## <span id="ALLOW_NON_EMPTY_LOCATION_IN_CTAS"><span id="allowNonEmptyLocationInCTAS"> allowNonEmptyLocationInCTAS

[spark.sql.legacy.allowNonEmptyLocationInCTAS](configuration-properties.md#spark.sql.legacy.allowNonEmptyLocationInCTAS)

Used when:

* `DataWritingCommand` utility is used to [assertEmptyRootPath](logical-operators/DataWritingCommand.md#assertEmptyRootPath)

## <span id="ADAPTIVE_OPTIMIZE_SKEWS_IN_REBALANCE_PARTITIONS_ENABLED"><span id="allowNonEmptyLocationInCTAS"> allowNonEmptyLocationInCTAS

[spark.sql.adaptive.optimizeSkewsInRebalancePartitions.enabled](configuration-properties.md#spark.sql.adaptive.optimizeSkewsInRebalancePartitions.enabled)

Used when:

* `OptimizeSkewInRebalancePartitions` physical optimization is executed

## <span id="ADAPTIVE_CUSTOM_COST_EVALUATOR_CLASS"> ADAPTIVE_CUSTOM_COST_EVALUATOR_CLASS

[spark.sql.adaptive.customCostEvaluatorClass](configuration-properties.md#spark.sql.adaptive.customCostEvaluatorClass)

## <span id="autoSizeUpdateEnabled"> autoSizeUpdateEnabled

The value of [spark.sql.statistics.size.autoUpdate.enabled](configuration-properties.md#spark.sql.statistics.size.autoUpdate.enabled) configuration property

Used when:

* `CommandUtils` is requested for [updating existing table statistics](CommandUtils.md#updateTableStats)
* `AlterTableAddPartitionCommand` logical command is executed

## <span id="avroCompressionCodec"> avroCompressionCodec

The value of [spark.sql.avro.compression.codec](configuration-properties.md#spark.sql.avro.compression.codec) configuration property

Used when `AvroOptions` is requested for the [compression](avro/AvroOptions.md#compression) configuration property (and it was not set explicitly)

## <span id="broadcastTimeout"> broadcastTimeout

The value of [spark.sql.broadcastTimeout](configuration-properties.md#spark.sql.broadcastTimeout) configuration property

Used in [BroadcastExchangeExec](physical-operators/BroadcastExchangeExec.md) (for broadcasting a table to executors)

## <span id="bucketingEnabled"> bucketingEnabled

The value of [spark.sql.sources.bucketing.enabled](configuration-properties.md#spark.sql.sources.bucketing.enabled) configuration property

Used when `FileSourceScanExec` physical operator is requested for the [input RDD](physical-operators/FileSourceScanExec.md#inputRDD) and to determine [output partitioning](physical-operators/FileSourceScanExec.md#outputPartitioning) and [ordering](physical-operators/FileSourceScanExec.md#outputOrdering)

## <span id="cacheVectorizedReaderEnabled"> cacheVectorizedReaderEnabled

The value of [spark.sql.inMemoryColumnarStorage.enableVectorizedReader](configuration-properties.md#spark.sql.inMemoryColumnarStorage.enableVectorizedReader) configuration property

Used when `InMemoryTableScanExec` physical operator is requested for [supportsBatch](physical-operators/InMemoryTableScanExec.md#supportsBatch) flag.

## <span id="CAN_CHANGE_CACHED_PLAN_OUTPUT_PARTITIONING"> CAN_CHANGE_CACHED_PLAN_OUTPUT_PARTITIONING

[spark.sql.optimizer.canChangeCachedPlanOutputPartitioning](configuration-properties.md#spark.sql.optimizer.canChangeCachedPlanOutputPartitioning)

Used when:

* `CacheManager` is requested to [getOrCloneSessionWithConfigsOff](CacheManager.md#getOrCloneSessionWithConfigsOff)

## <span id="caseSensitiveAnalysis"> caseSensitiveAnalysis

The value of [spark.sql.caseSensitive](configuration-properties.md#spark.sql.caseSensitive) configuration property

## <span id="cboEnabled"> cboEnabled

The value of [spark.sql.cbo.enabled](configuration-properties.md#spark.sql.cbo.enabled) configuration property

Used in:

* [ReorderJoin](logical-optimizations/ReorderJoin.md) logical plan optimization (and indirectly in `StarSchemaDetection` for `reorderStarJoins`)
* [CostBasedJoinReorder](logical-optimizations/CostBasedJoinReorder.md) logical plan optimization

## <span id="cliPrintHeader"><span id="CLI_PRINT_HEADER"> cliPrintHeader

[spark.sql.cli.print.header](configuration-properties.md#spark.sql.cli.print.header)

Used when:

* `SparkSQLCLIDriver` is requested to `processCmd`

## <span id="coalesceBucketsInJoinEnabled"><span id="COALESCE_BUCKETS_IN_JOIN_ENABLED"> coalesceBucketsInJoinEnabled

The value of [spark.sql.bucketing.coalesceBucketsInJoin.enabled](configuration-properties.md#spark.sql.bucketing.coalesceBucketsInJoin.enabled) configuration property

Used when:

* [CoalesceBucketsInJoin](physical-optimizations/CoalesceBucketsInJoin.md) physical optimization is executed

## <span id="COALESCE_PARTITIONS_MIN_PARTITION_SIZE"> COALESCE_PARTITIONS_MIN_PARTITION_SIZE

[spark.sql.adaptive.coalescePartitions.minPartitionSize](configuration-properties.md#spark.sql.adaptive.coalescePartitions.minPartitionSize) configuration property

Used when:

* [CoalesceShufflePartitions](physical-optimizations/CoalesceShufflePartitions.md) physical optimization is executed

## <span id="COALESCE_PARTITIONS_PARALLELISM_FIRST"> COALESCE_PARTITIONS_PARALLELISM_FIRST

[spark.sql.adaptive.coalescePartitions.parallelismFirst](configuration-properties.md#spark.sql.adaptive.coalescePartitions.parallelismFirst) configuration property

Used when:

* [CoalesceShufflePartitions](physical-optimizations/CoalesceShufflePartitions.md) physical optimization is executed

## <span id="coalesceShufflePartitionsEnabled"><span id="COALESCE_PARTITIONS_ENABLED"> coalesceShufflePartitionsEnabled

The value of [spark.sql.adaptive.coalescePartitions.enabled](configuration-properties.md#spark.sql.adaptive.coalescePartitions.enabled) configuration property

Used when:

* [CoalesceShufflePartitions](physical-optimizations/CoalesceShufflePartitions.md) and [EnsureRequirements](physical-optimizations/EnsureRequirements.md) physical optimizations are executed

## <span id="codegenCacheMaxEntries"><span id="CODEGEN_CACHE_MAX_ENTRIES"> codegenCacheMaxEntries

[spark.sql.codegen.cache.maxEntries](StaticSQLConf.md#spark.sql.codegen.cache.maxEntries)

## <span id="COLUMN_BATCH_SIZE"><span id="columnBatchSize"> columnBatchSize

The value of [spark.sql.inMemoryColumnarStorage.batchSize](configuration-properties.md#spark.sql.inMemoryColumnarStorage.batchSize) configuration property

Used when:

* `CacheManager` is requested to [cache a structured query](CacheManager.md#cacheQuery)
* `RowToColumnarExec` physical operator is requested to [doExecuteColumnar](physical-operators/RowToColumnarExec.md#doExecuteColumnar)

## <span id="constraintPropagationEnabled"><span id="CONSTRAINT_PROPAGATION_ENABLED"> constraintPropagationEnabled

The value of [spark.sql.constraintPropagation.enabled](configuration-properties.md#spark.sql.constraintPropagation.enabled) configuration property

Used when:

* [InferFiltersFromConstraints](logical-optimizations/InferFiltersFromConstraints.md) logical optimization is executed
* `QueryPlanConstraints` is requested for the constraints

## <span id="CONVERT_METASTORE_ORC"> CONVERT_METASTORE_ORC

The value of [spark.sql.hive.convertMetastoreOrc](hive/configuration-properties.md#spark.sql.hive.convertMetastoreOrc) configuration property

Used when [RelationConversions](hive/RelationConversions.md) logical post-hoc evaluation rule is executed (and requested to [isConvertible](hive/RelationConversions.md#isConvertible))

## <span id="CONVERT_METASTORE_PARQUET"> CONVERT_METASTORE_PARQUET

The value of [spark.sql.hive.convertMetastoreParquet](hive/configuration-properties.md#spark.sql.hive.convertMetastoreParquet) configuration property

Used when [RelationConversions](hive/RelationConversions.md) logical post-hoc evaluation rule is executed (and requested to [isConvertible](hive/RelationConversions.md#isConvertible))

## <span id="CSV_EXPRESSION_OPTIMIZATION"><span id="csvExpressionOptimization"> csvExpressionOptimization

[spark.sql.optimizer.enableCsvExpressionOptimization](configuration-properties.md#spark.sql.optimizer.enableCsvExpressionOptimization)

Used when:

* `OptimizeCsvJsonExprs` logical optimization is executed

## <span id="dataFramePivotMaxValues"> dataFramePivotMaxValues

The value of [spark.sql.pivotMaxValues](configuration-properties.md#spark.sql.pivotMaxValues) configuration property

Used in [pivot](RelationalGroupedDataset.md#pivot) operator.

## dataFrameRetainGroupColumns { #dataFrameRetainGroupColumns }

[spark.sql.retainGroupColumns](configuration-properties.md#spark.sql.retainGroupColumns)

## <span id="DECORRELATE_INNER_QUERY_ENABLED"><span id="decorrelateInnerQueryEnabled"> decorrelateInnerQueryEnabled

[spark.sql.optimizer.decorrelateInnerQuery.enabled](configuration-properties.md#spark.sql.optimizer.decorrelateInnerQuery.enabled)

Used when:

* `CheckAnalysis` is requested to [checkCorrelationsInSubquery](CheckAnalysis.md#checkCorrelationsInSubquery) (with a [Project](logical-operators/Project.md) unary logical operator)
* [PullupCorrelatedPredicates](logical-optimizations/PullupCorrelatedPredicates.md) logical optimization is executed

## <span id="DEFAULT_CATALOG"> DEFAULT_CATALOG

The value of [spark.sql.defaultCatalog](configuration-properties.md#spark.sql.defaultCatalog) configuration property

Used when `CatalogManager` is requested for the [current CatalogPlugin](connector/catalog/CatalogManager.md#currentCatalog)

## <span id="defaultDataSourceName"><span id="DEFAULT_DATA_SOURCE_NAME"> defaultDataSourceName

[spark.sql.sources.default](configuration-properties.md#spark.sql.sources.default)

## <span id="defaultSizeInBytes"> defaultSizeInBytes

[spark.sql.defaultSizeInBytes](configuration-properties.md#spark.sql.defaultSizeInBytes)

Used when:

* `DetermineTableStats` logical resolution rule could not compute the table size or [spark.sql.statistics.fallBackToHdfs](#spark.sql.statistics.fallBackToHdfs) is disabled
* [ExternalRDD](logical-operators/ExternalRDD.md#computeStats), [LogicalRDD](logical-operators/LogicalRDD.md#computeStats) and [DataSourceV2Relation](logical-operators/DataSourceV2Relation.md) are requested to compute stats
* (Spark Structured Streaming) `StreamingRelation`, `StreamingExecutionRelation`, `StreamingRelationV2` and `ContinuousExecutionRelation` are requested for statistics (i.e. `computeStats`)
* `DataSource` [creates a HadoopFsRelation for FileFormat data source](DataSource.md#resolveRelation) (and builds a [CatalogFileIndex](files/CatalogFileIndex.md) when no table statistics are available)
* `BaseRelation` is requested for [an estimated size of this relation](BaseRelation.md#sizeInBytes) (in bytes)

## <span id="DYNAMIC_PARTITION_PRUNING_ENABLED"><span id="dynamicPartitionPruningEnabled"> dynamicPartitionPruningEnabled

[spark.sql.optimizer.dynamicPartitionPruning.enabled](configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.enabled)

## <span id="DYNAMIC_PARTITION_PRUNING_FALLBACK_FILTER_RATIO"><span id="dynamicPartitionPruningFallbackFilterRatio"> dynamicPartitionPruningFallbackFilterRatio

The value of [spark.sql.optimizer.dynamicPartitionPruning.fallbackFilterRatio](configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.fallbackFilterRatio) configuration property

Used when:

* [PartitionPruning](logical-optimizations/PartitionPruning.md) logical optimization rule is executed

## <span id="DYNAMIC_PARTITION_PRUNING_PRUNING_SIDE_EXTRA_FILTER_RATIO"><span id="dynamicPartitionPruningPruningSideExtraFilterRatio"> dynamicPartitionPruningPruningSideExtraFilterRatio

The value of [spark.sql.optimizer.dynamicPartitionPruning.pruningSideExtraFilterRatio](configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.pruningSideExtraFilterRatio) configuration property

Used when:

* [PartitionPruning](logical-optimizations/PartitionPruning.md) logical optimization rule is executed

## <span id="DYNAMIC_PARTITION_PRUNING_REUSE_BROADCAST_ONLY"><span id="dynamicPartitionPruningReuseBroadcastOnly"> dynamicPartitionPruningReuseBroadcastOnly

[spark.sql.optimizer.dynamicPartitionPruning.reuseBroadcastOnly](configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.reuseBroadcastOnly)

## <span id="DYNAMIC_PARTITION_PRUNING_USE_STATS"><span id="dynamicPartitionPruningUseStats"> dynamicPartitionPruningUseStats

[spark.sql.optimizer.dynamicPartitionPruning.useStats](configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.useStats)

## <span id="ENABLE_FULL_OUTER_SHUFFLED_HASH_JOIN_CODEGEN"> ENABLE_FULL_OUTER_SHUFFLED_HASH_JOIN_CODEGEN

[spark.sql.codegen.join.fullOuterShuffledHashJoin.enabled](configuration-properties.md#spark.sql.codegen.join.fullOuterShuffledHashJoin.enabled)

## <span id="enableDefaultColumns"><span id="ENABLE_DEFAULT_COLUMNS"> enableDefaultColumns

[spark.sql.defaultColumn.enabled](configuration-properties.md#spark.sql.defaultColumn.enabled)

## <span id="enableRadixSort"> enableRadixSort

[spark.sql.sort.enableRadixSort](configuration-properties.md#spark.sql.sort.enableRadixSort)

Used when:

* `SortExec` physical operator is requested to [create an UnsafeExternalRowSorter](physical-operators/SortExec.md#createSorter).

## <span id="enableTwoLevelAggMap"><span id="ENABLE_TWOLEVEL_AGG_MAP"> enableTwoLevelAggMap

[spark.sql.codegen.aggregate.map.twolevel.enabled](configuration-properties.md#spark.sql.codegen.aggregate.map.twolevel.enabled)

## <span id="enableVectorizedHashMap"><span id="ENABLE_VECTORIZED_HASH_MAP"> enableVectorizedHashMap

[spark.sql.codegen.aggregate.map.vectorized.enable](configuration-properties.md#spark.sql.codegen.aggregate.map.vectorized.enable)

## <span id="EXCHANGE_REUSE_ENABLED"><span id="exchangeReuseEnabled"> exchangeReuseEnabled

[spark.sql.exchange.reuse](configuration-properties.md#spark.sql.exchange.reuse)

Used when:

* [AdaptiveSparkPlanExec](physical-operators/AdaptiveSparkPlanExec.md) physical operator is requested to [createQueryStages](physical-operators/AdaptiveSparkPlanExec.md#createQueryStages)

* [PartitionPruning](logical-optimizations/PartitionPruning.md) logical optimization rule is executed.

* `PlanDynamicPruningFilters` and [ReuseExchange](physical-optimizations/ReuseExchange.md) physical optimizations are executed

## <span id="fallBackToHdfsForStatsEnabled"> fallBackToHdfsForStatsEnabled

[spark.sql.statistics.fallBackToHdfs](configuration-properties.md#spark.sql.statistics.fallBackToHdfs)

Used when `DetermineTableStats` logical resolution rule is executed.

## <span id="fastHashAggregateRowMaxCapacityBit"><span id="FAST_HASH_AGGREGATE_MAX_ROWS_CAPACITY_BIT"> fastHashAggregateRowMaxCapacityBit

[spark.sql.codegen.aggregate.fastHashMap.capacityBit](configuration-properties.md#spark.sql.codegen.aggregate.fastHashMap.capacityBit)

## <span id="FETCH_SHUFFLE_BLOCKS_IN_BATCH"><span id="fetchShuffleBlocksInBatch"> fetchShuffleBlocksInBatch

The value of [spark.sql.adaptive.fetchShuffleBlocksInBatch](configuration-properties.md#spark.sql.adaptive.fetchShuffleBlocksInBatch) configuration property

Used when [ShuffledRowRDD](ShuffledRowRDD.md) is created

## <span id="fileCommitProtocolClass"><span id="FILE_COMMIT_PROTOCOL_CLASS"> fileCommitProtocolClass

[spark.sql.sources.commitProtocolClass](configuration-properties.md#spark.sql.sources.commitProtocolClass)

## <span id="fileCompressionFactor"><span id="FILE_COMPRESSION_FACTOR"> fileCompressionFactor

The value of [spark.sql.sources.fileCompressionFactor](configuration-properties.md#spark.sql.sources.fileCompressionFactor) configuration property

Used when:

* `HadoopFsRelation` is requested for a [size](files/HadoopFsRelation.md#sizeInBytes)
* `FileScan` is requested to [estimate statistics](files/FileScan.md#estimateStatistics)

## <span id="filesMaxPartitionBytes"><span id="FILES_MAX_PARTITION_BYTES"> filesMaxPartitionBytes

[spark.sql.files.maxPartitionBytes](configuration-properties.md#spark.sql.files.maxPartitionBytes)

## <span id="filesMinPartitionNum"><span id="FILES_MIN_PARTITION_NUM"> filesMinPartitionNum

[spark.sql.files.minPartitionNum](configuration-properties.md#spark.sql.files.minPartitionNum)

## <span id="filesOpenCostInBytes"> filesOpenCostInBytes

[spark.sql.files.openCostInBytes](configuration-properties.md#spark.sql.files.openCostInBytes)

## <span id="filesourcePartitionFileCacheSize"><span id="HIVE_FILESOURCE_PARTITION_FILE_CACHE_SIZE"> filesourcePartitionFileCacheSize

[spark.sql.hive.filesourcePartitionFileCacheSize](configuration-properties.md#spark.sql.hive.filesourcePartitionFileCacheSize)

## <span id="histogramEnabled"><span id="MAX_TO_STRING_FIELDS"> histogramEnabled

The value of [spark.sql.statistics.histogram.enabled](configuration-properties.md#spark.sql.statistics.histogram.enabled) configuration property

Used when [AnalyzeColumnCommand](logical-operators/AnalyzeColumnCommand.md) logical command is executed.

## <span id="histogramNumBins"> histogramNumBins

[spark.sql.statistics.histogram.numBins](configuration-properties.md#spark.sql.statistics.histogram.numBins)

Used when `AnalyzeColumnCommand` is AnalyzeColumnCommand.md#run[executed] with configuration-properties.md#spark.sql.statistics.histogram.enabled[spark.sql.statistics.histogram.enabled] turned on (and AnalyzeColumnCommand.md#computePercentiles[calculates percentiles]).

## <span id="HIVE_TABLE_PROPERTY_LENGTH_THRESHOLD"> HIVE_TABLE_PROPERTY_LENGTH_THRESHOLD

[spark.sql.hive.tablePropertyLengthThreshold](configuration-properties.md#spark.sql.hive.tablePropertyLengthThreshold)

Used when:

* `CatalogTable` is requested to [splitLargeTableProp](CatalogTable.md#splitLargeTableProp)

## <span id="hugeMethodLimit"> hugeMethodLimit

[spark.sql.codegen.hugeMethodLimit](configuration-properties.md#spark.sql.codegen.hugeMethodLimit)

## <span id="ignoreCorruptFiles"><span id="IGNORE_CORRUPT_FILES"> ignoreCorruptFiles

The value of [spark.sql.files.ignoreCorruptFiles](configuration-properties.md#spark.sql.files.ignoreCorruptFiles) configuration property

Used when:

* `AvroUtils` utility is requested to `inferSchema`
* `OrcFileFormat` is requested to `inferSchema` and `buildReader`
* `FileScanRDD` is [created](rdds/FileScanRDD.md#ignoreCorruptFiles) (and then to [compute a partition](rdds/FileScanRDD.md#compute))
* `SchemaMergeUtils` utility is requested to `mergeSchemasInParallel`
* `OrcUtils` utility is requested to `readSchema`
* `FilePartitionReader` is requested to `ignoreCorruptFiles`

## <span id="ignoreMissingFiles"><span id="IGNORE_MISSING_FILES"> ignoreMissingFiles

The value of [spark.sql.files.ignoreMissingFiles](configuration-properties.md#spark.sql.files.ignoreMissingFiles) configuration property

Used when:

* `FileScanRDD` is [created](rdds/FileScanRDD.md#ignoreMissingFiles) (and then to [compute a partition](rdds/FileScanRDD.md#compute))
* `InMemoryFileIndex` utility is requested to [bulkListLeafFiles](files/InMemoryFileIndex.md#bulkListLeafFiles)
* `FilePartitionReader` is requested to `ignoreMissingFiles`

## <span id="inMemoryPartitionPruning"> inMemoryPartitionPruning

[spark.sql.inMemoryColumnarStorage.partitionPruning](configuration-properties.md#spark.sql.inMemoryColumnarStorage.partitionPruning)

## <span id="isParquetBinaryAsString"> isParquetBinaryAsString

[spark.sql.parquet.binaryAsString](configuration-properties.md#spark.sql.parquet.binaryAsString)

## <span id="isParquetINT96AsTimestamp"> isParquetINT96AsTimestamp

[spark.sql.parquet.int96AsTimestamp](configuration-properties.md#spark.sql.parquet.int96AsTimestamp)

## <span id="isParquetINT96TimestampConversion"> isParquetINT96TimestampConversion

[spark.sql.parquet.int96TimestampConversion](configuration-properties.md#spark.sql.parquet.int96TimestampConversion)

Used when `ParquetFileFormat` is requested to [build a data reader with partition column values appended](parquet/ParquetFileFormat.md#buildReaderWithPartitionValues).

## <span id="isParquetSchemaMergingEnabled"><span id="PARQUET_SCHEMA_MERGING_ENABLED"> isParquetSchemaMergingEnabled

[spark.sql.parquet.mergeSchema](configuration-properties.md#spark.sql.parquet.mergeSchema)

## <span id="isParquetSchemaRespectSummaries"><span id="PARQUET_SCHEMA_RESPECT_SUMMARIES"> isParquetSchemaRespectSummaries

[spark.sql.parquet.respectSummaryFiles](configuration-properties.md#spark.sql.parquet.respectSummaryFiles)

Used when:

* `ParquetUtils` is used to [inferSchema](parquet/ParquetUtils.md#inferSchema)

## <span id="joinReorderEnabled"> joinReorderEnabled

[spark.sql.cbo.joinReorder.enabled](configuration-properties.md#spark.sql.cbo.joinReorder.enabled)

Used in [CostBasedJoinReorder](logical-optimizations/CostBasedJoinReorder.md) logical plan optimization

## <span id="legacyIntervalEnabled"><span id="LEGACY_INTERVAL_ENABLED"> legacyIntervalEnabled

[spark.sql.legacy.interval.enabled](configuration-properties.md#spark.sql.legacy.interval.enabled)

Used when:

* `SubtractTimestamps` expression is created
* `SubtractDates` expression is created
* `AstBuilder` is requested to [visitTypeConstructor](sql/AstBuilder.md#visitTypeConstructor) and [visitInterval](sql/AstBuilder.md#visitInterval)

## <span id="limitScaleUpFactor"> limitScaleUpFactor

[spark.sql.limit.scaleUpFactor](configuration-properties.md#spark.sql.limit.scaleUpFactor)

Used when a physical operator is requested [the first n rows as an array](physical-operators/SparkPlan.md#executeTake).

## <span id="LOCAL_SHUFFLE_READER_ENABLED"> LOCAL_SHUFFLE_READER_ENABLED

[spark.sql.adaptive.localShuffleReader.enabled](configuration-properties.md#spark.sql.adaptive.localShuffleReader.enabled)

Used when:

* [OptimizeShuffleWithLocalRead](physical-optimizations/OptimizeShuffleWithLocalRead.md) adaptive physical optimization is executed

## <span id="manageFilesourcePartitions"><span id="HIVE_MANAGE_FILESOURCE_PARTITIONS"> manageFilesourcePartitions

[spark.sql.hive.manageFilesourcePartitions](configuration-properties.md#spark.sql.hive.manageFilesourcePartitions)

## <span id="maxConcurrentOutputFileWriters"><span id="MAX_CONCURRENT_OUTPUT_FILE_WRITERS"> maxConcurrentOutputFileWriters

The value of [spark.sql.maxConcurrentOutputFileWriters](configuration-properties.md#spark.sql.maxConcurrentOutputFileWriters) configuration property

Used when:

* `FileFormatWriter` is requested to [write out a query result](files/FileFormatWriter.md#write)

## <span id="maxMetadataStringLength"><span id="MAX_METADATA_STRING_LENGTH"> maxMetadataStringLength

[spark.sql.maxMetadataStringLength](configuration-properties.md#spark.sql.maxMetadataStringLength)

Used when:

* `DataSourceScanExec` is requested for [simpleString](physical-operators/DataSourceScanExec.md#simpleString)
* `FileScan` is requested for [description](files/FileScan.md#description) and [metadata](files/FileScan.md#getMetaData)
* `HiveTableRelation` is requested for [simpleString](hive/HiveTableRelation.md#simpleString)

## <span id="maxRecordsPerFile"><span id="MAX_RECORDS_PER_FILE"> maxRecordsPerFile

[spark.sql.files.maxRecordsPerFile](configuration-properties.md#spark.sql.files.maxRecordsPerFile)

Used when:

* `FileFormatWriter` utility is used to [write out a query result](files/FileFormatWriter.md#write)
* `FileWrite` is requested for a [BatchWrite](files/FileWrite.md#toBatch)

## <span id="maxToStringFields"><span id="MAX_TO_STRING_FIELDS"> maxToStringFields

The value of [spark.sql.debug.maxToStringFields](configuration-properties.md#spark.sql.debug.maxToStringFields) configuration property

## <span id="metastorePartitionPruning"><span id="HIVE_METASTORE_PARTITION_PRUNING"> metastorePartitionPruning

[spark.sql.hive.metastorePartitionPruning](configuration-properties.md#spark.sql.hive.metastorePartitionPruning)

Used when [HiveTableScanExec](hive/HiveTableScanExec.md) physical operator is executed with a partitioned table (and requested for [rawPartitions](hive/HiveTableScanExec.md#rawPartitions))

## <span id="methodSplitThreshold"><span id="CODEGEN_METHOD_SPLIT_THRESHOLD"> methodSplitThreshold

[spark.sql.codegen.methodSplitThreshold](configuration-properties.md#spark.sql.codegen.methodSplitThreshold)

Used when:

* `Expression` is requested to [reduceCodeSize](expressions/Expression.md#reduceCodeSize)
* `CodegenContext` is requested to [buildCodeBlocks](whole-stage-code-generation/CodegenContext.md#buildCodeBlocks) and [subexpressionEliminationForWholeStageCodegen](whole-stage-code-generation/CodegenContext.md#subexpressionEliminationForWholeStageCodegen)
* `ExpandExec` physical operator is requested to `doConsume`
* `HashAggregateExec` physical operator is requested to [generateEvalCodeForAggFuncs](physical-operators/HashAggregateExec.md#generateEvalCodeForAggFuncs)

## <span id="minNumPostShufflePartitions"> minNumPostShufflePartitions

[spark.sql.adaptive.minNumPostShufflePartitions](configuration-properties.md#spark.sql.adaptive.minNumPostShufflePartitions)

Used when [EnsureRequirements](physical-optimizations/EnsureRequirements.md) physical optimization is executed (for [Adaptive Query Execution](adaptive-query-execution/index.md)).

## <span id="nestedSchemaPruningEnabled"><span id="NESTED_SCHEMA_PRUNING_ENABLED"> nestedSchemaPruningEnabled

The value of [spark.sql.optimizer.nestedSchemaPruning.enabled](configuration-properties.md#spark.sql.optimizer.nestedSchemaPruning.enabled) configuration property

Used when [SchemaPruning](logical-optimizations/SchemaPruning.md), [ColumnPruning](logical-optimizations/ColumnPruning.md) and [V2ScanRelationPushDown](logical-optimizations/V2ScanRelationPushDown.md) logical optimizations are executed

## <span id="nonEmptyPartitionRatioForBroadcastJoin"><span id="NON_EMPTY_PARTITION_RATIO_FOR_BROADCAST_JOIN"> nonEmptyPartitionRatioForBroadcastJoin

The value of [spark.sql.adaptive.nonEmptyPartitionRatioForBroadcastJoin](configuration-properties.md#spark.sql.adaptive.nonEmptyPartitionRatioForBroadcastJoin) configuration property

Used when:

* [DynamicJoinSelection](logical-optimizations/DynamicJoinSelection.md) adaptive logical optimization is executed (and [shouldDemoteBroadcastHashJoin](logical-optimizations/DynamicJoinSelection.md#shouldDemoteBroadcastHashJoin))

## <span id="numShufflePartitions"><span id="SHUFFLE_PARTITIONS"> numShufflePartitions

[spark.sql.shuffle.partitions](configuration-properties.md#spark.sql.shuffle.partitions)

## <span id="COLUMN_VECTOR_OFFHEAP_ENABLED"><span id="offHeapColumnVectorEnabled"> offHeapColumnVectorEnabled

[spark.sql.columnVector.offheap.enabled](configuration-properties.md#spark.sql.columnVector.offheap.enabled)

## <span id="rangeExchangeSampleSizePerPartition"><span id="RANGE_EXCHANGE_SAMPLE_SIZE_PER_PARTITION"> rangeExchangeSampleSizePerPartition

The value of [spark.sql.execution.rangeExchange.sampleSizePerPartition](configuration-properties.md#spark.sql.execution.rangeExchange.sampleSizePerPartition) configuration property

Used when:

* [ShuffleExchangeExec](physical-operators/ShuffleExchangeExec.md) physical operator is executed

## <span id="REMOVE_REDUNDANT_SORTS_ENABLED"> REMOVE_REDUNDANT_SORTS_ENABLED

The value of [spark.sql.execution.removeRedundantSorts](configuration-properties.md#spark.sql.execution.removeRedundantSorts) configuration property

Used when:

* [RemoveRedundantSorts](physical-optimizations/RemoveRedundantSorts.md) physical optimization is executed

## <span id="REPLACE_HASH_WITH_SORT_AGG_ENABLED"> REPLACE_HASH_WITH_SORT_AGG_ENABLED

[spark.sql.execution.replaceHashWithSortAgg](configuration-properties.md#spark.sql.execution.replaceHashWithSortAgg)

## <span id="runtimeFilterBloomFilterEnabled"><span id="RUNTIME_BLOOM_FILTER_ENABLED"> runtimeFilterBloomFilterEnabled

[spark.sql.optimizer.runtime.bloomFilter.enabled](configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.enabled)

## <span id="RUNTIME_BLOOM_FILTER_MAX_NUM_BITS"> RUNTIME_BLOOM_FILTER_MAX_NUM_BITS

[spark.sql.optimizer.runtime.bloomFilter.maxNumBits](configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.maxNumBits)

## <span id="RUNTIME_FILTER_NUMBER_THRESHOLD"> RUNTIME_FILTER_NUMBER_THRESHOLD

[spark.sql.optimizer.runtimeFilter.number.threshold](configuration-properties.md#spark.sql.optimizer.runtimeFilter.number.threshold)

## <span id="runtimeFilterSemiJoinReductionEnabled"><span id="RUNTIME_FILTER_SEMI_JOIN_REDUCTION_ENABLED"> runtimeFilterSemiJoinReductionEnabled

[spark.sql.optimizer.runtimeFilter.semiJoinReduction.enabled](configuration-properties.md#spark.sql.optimizer.runtimeFilter.semiJoinReduction.enabled)

## <span id="SKEW_JOIN_SKEWED_PARTITION_FACTOR"> SKEW_JOIN_SKEWED_PARTITION_FACTOR

[spark.sql.adaptive.skewJoin.skewedPartitionFactor](configuration-properties.md#spark.sql.adaptive.skewJoin.skewedPartitionFactor) configuration property

Used when:

* [OptimizeSkewedJoin](physical-optimizations/OptimizeSkewedJoin.md) physical optimization is executed

## <span id="SKEW_JOIN_SKEWED_PARTITION_THRESHOLD"> SKEW_JOIN_SKEWED_PARTITION_THRESHOLD

[spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes](configuration-properties.md#spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes) configuration property

Used when:

* [OptimizeSkewedJoin](physical-optimizations/OptimizeSkewedJoin.md) physical optimization is executed

## <span id="SKEW_JOIN_ENABLED"> SKEW_JOIN_ENABLED

[spark.sql.adaptive.skewJoin.enabled](configuration-properties.md#spark.sql.adaptive.skewJoin.enabled) configuration property

Used when:

* [OptimizeSkewedJoin](physical-optimizations/OptimizeSkewedJoin.md) physical optimization is executed

## <span id="objectAggSortBasedFallbackThreshold"><span id="OBJECT_AGG_SORT_BASED_FALLBACK_THRESHOLD"> objectAggSortBasedFallbackThreshold

[spark.sql.objectHashAggregate.sortBased.fallbackThreshold](configuration-properties.md#spark.sql.objectHashAggregate.sortBased.fallbackThreshold)

## <span id="offHeapColumnVectorEnabled"> offHeapColumnVectorEnabled

[spark.sql.columnVector.offheap.enabled](configuration-properties.md#spark.sql.columnVector.offheap.enabled)

Used when:

* `InMemoryTableScanExec` is requested for the [vectorTypes](physical-operators/InMemoryTableScanExec.md#vectorTypes) and the [input RDD](physical-operators/InMemoryTableScanExec.md#inputRDD)
* `OrcFileFormat` is requested to `buildReaderWithPartitionValues`
* `ParquetFileFormat` is requested for [vectorTypes](parquet/ParquetFileFormat.md#vectorTypes) and [build a data reader with partition column values appended](parquet/ParquetFileFormat.md#buildReaderWithPartitionValues)

## <span id="OPTIMIZE_ONE_ROW_RELATION_SUBQUERY"> OPTIMIZE_ONE_ROW_RELATION_SUBQUERY

[spark.sql.optimizer.optimizeOneRowRelationSubquery](configuration-properties.md#spark.sql.optimizer.optimizeOneRowRelationSubquery)

Used when:

* `OptimizeOneRowRelationSubquery` logical optimization is executed

## <span id="optimizeNullAwareAntiJoin"><span id="OPTIMIZE_NULL_AWARE_ANTI_JOIN"> optimizeNullAwareAntiJoin

[spark.sql.optimizeNullAwareAntiJoin](configuration-properties.md#spark.sql.optimizeNullAwareAntiJoin) configuration property

Used when:

* [ExtractSingleColumnNullAwareAntiJoin](ExtractSingleColumnNullAwareAntiJoin.md) Scala extractor is executed

## <span id="optimizerExcludedRules"><span id="OPTIMIZER_EXCLUDED_RULES"> optimizerExcludedRules

The value of [spark.sql.optimizer.excludedRules](configuration-properties.md#spark.sql.optimizer.excludedRules) configuration property

Used when `Optimizer` is requested for the [batches](catalyst/Optimizer.md#batches)

## <span id="optimizerInSetConversionThreshold"> optimizerInSetConversionThreshold

[spark.sql.optimizer.inSetConversionThreshold](configuration-properties.md#spark.sql.optimizer.inSetConversionThreshold)

Used when [OptimizeIn](logical-optimizations/OptimizeIn.md) logical query optimization is executed

## <span id="ORC_VECTORIZED_READER_NESTED_COLUMN_ENABLED"><span id="orcVectorizedReaderNestedColumnEnabled"> orcVectorizedReaderNestedColumnEnabled

[spark.sql.orc.enableNestedColumnVectorizedReader](configuration-properties.md#spark.sql.orc.enableNestedColumnVectorizedReader)

Used when:

* `OrcFileFormat` is requested to `supportBatchForNestedColumn`

## <span id="OUTPUT_COMMITTER_CLASS"> OUTPUT_COMMITTER_CLASS

[spark.sql.sources.outputCommitterClass](configuration-properties.md#spark.sql.sources.outputCommitterClass)

Used when:

* `SQLHadoopMapReduceCommitProtocol` is requested to [setupCommitter](transactional-writes/SQLHadoopMapReduceCommitProtocol.md#setupCommitter)
* `ParquetFileFormat` is requested to [prepareWrite](parquet/ParquetFileFormat.md#prepareWrite)
* `ParquetWrite` is requested to [prepareWrite](parquet/ParquetWrite.md#prepareWrite)

## <span id="parallelFileListingInStatsComputation"> parallelFileListingInStatsComputation

[spark.sql.statistics.parallelFileListingInStatsComputation.enabled](configuration-properties.md#spark.sql.statistics.parallelFileListingInStatsComputation.enabled)

Used when `CommandUtils` helper object is requested to [calculate the total size of a table (with partitions)](CommandUtils.md#calculateTotalSize) (for [AnalyzeColumnCommand](logical-operators/AnalyzeColumnCommand.md) and [AnalyzeTableCommand](logical-operators/AnalyzeTableCommand.md) commands)

## <span id="parquetAggregatePushDown"><span id="PARQUET_AGGREGATE_PUSHDOWN_ENABLED"> parquetAggregatePushDown

[spark.sql.parquet.aggregatePushdown](configuration-properties.md#spark.sql.parquet.aggregatePushdown)

## <span id="parquetCompressionCodec"><span id="PARQUET_COMPRESSION"> parquetCompressionCodec

[spark.sql.parquet.compression.codec](configuration-properties.md#spark.sql.parquet.compression.codec)

Used when:

* `ParquetOptions` is requested for [compressionCodecClassName](parquet/ParquetOptions.md#compressionCodecClassName)

## <span id="parquetFilterPushDown"><span id="PARQUET_FILTER_PUSHDOWN_ENABLED"> parquetFilterPushDown

[spark.sql.parquet.filterPushdown](configuration-properties.md#spark.sql.parquet.filterPushdown)

## <span id="parquetFilterPushDownDate"><span id="PARQUET_FILTER_PUSHDOWN_DATE_ENABLED"> parquetFilterPushDownDate

[spark.sql.parquet.filterPushdown.date](configuration-properties.md#spark.sql.parquet.filterPushdown.date)

Used when:

* `ParquetFileFormat` is requested to [build a data reader (with partition column values appended)](parquet/ParquetFileFormat.md#buildReaderWithPartitionValues)

## <span id="parquetFilterPushDownDecimal"><span id="PARQUET_FILTER_PUSHDOWN_DECIMAL_ENABLED"> parquetFilterPushDownDecimal

[spark.sql.parquet.filterPushdown.decimal](configuration-properties.md#spark.sql.parquet.filterPushdown.decimal)

Used when:

* `ParquetFileFormat` is requested to [build a data reader (with partition column values appended)](parquet/ParquetFileFormat.md#buildReaderWithPartitionValues)
* `ParquetPartitionReaderFactory` is requested to [buildReaderBase](parquet/ParquetPartitionReaderFactory.md#buildReaderBase)
* `ParquetScanBuilder` is requested for [pushedParquetFilters](parquet/ParquetScanBuilder.md#pushedParquetFilters)

## <span id="parquetFilterPushDownInFilterThreshold"><span id="PARQUET_FILTER_PUSHDOWN_INFILTERTHRESHOLD"> parquetFilterPushDownInFilterThreshold

[spark.sql.parquet.pushdown.inFilterThreshold](configuration-properties.md#spark.sql.parquet.pushdown.inFilterThreshold)

Used when:

* `ParquetFileFormat` is requested to [build a data reader (with partition column values appended)](parquet/ParquetFileFormat.md#buildReaderWithPartitionValues)
* `ParquetPartitionReaderFactory` is requested to [buildReaderBase](parquet/ParquetPartitionReaderFactory.md#buildReaderBase)
* `ParquetScanBuilder` is requested for [pushedParquetFilters](parquet/ParquetScanBuilder.md#pushedParquetFilters)

## <span id="parquetFilterPushDownStringPredicate"><span id="PARQUET_FILTER_PUSHDOWN_STRING_PREDICATE_ENABLED"> parquetFilterPushDownStringPredicate

[spark.sql.parquet.filterPushdown.stringPredicate](configuration-properties.md#spark.sql.parquet.filterPushdown.stringPredicate)

## <span id="parquetFilterPushDownStringStartWith"><span id="PARQUET_FILTER_PUSHDOWN_STRING_STARTSWITH_ENABLED"> parquetFilterPushDownStringStartWith

[spark.sql.parquet.filterPushdown.string.startsWith](configuration-properties.md#spark.sql.parquet.filterPushdown.string.startsWith)

## <span id="parquetFilterPushDownTimestamp"><span id="PARQUET_FILTER_PUSHDOWN_TIMESTAMP_ENABLED"> parquetFilterPushDownTimestamp

[spark.sql.parquet.filterPushdown.timestamp](configuration-properties.md#spark.sql.parquet.filterPushdown.timestamp)

Used when:

* `ParquetFileFormat` is requested to [build a data reader (with partition column values appended)](parquet/ParquetFileFormat.md#buildReaderWithPartitionValues)
* `ParquetPartitionReaderFactory` is requested to [buildReaderBase](parquet/ParquetPartitionReaderFactory.md#buildReaderBase)
* `ParquetScanBuilder` is requested for [pushedParquetFilters](parquet/ParquetScanBuilder.md#pushedParquetFilters)

## <span id="parquetOutputCommitterClass"><span id="PARQUET_OUTPUT_COMMITTER_CLASS"> parquetOutputCommitterClass

[spark.sql.parquet.output.committer.class](configuration-properties.md#spark.sql.parquet.output.committer.class)

Used when:

* `ParquetFileFormat` is requested to [prepareWrite](parquet/ParquetFileFormat.md#prepareWrite)
* `ParquetWrite` is requested to [prepareWrite](parquet/ParquetWrite.md#prepareWrite)

## <span id="parquetOutputTimestampType"><span id="PARQUET_OUTPUT_TIMESTAMP_TYPE"> parquetOutputTimestampType

[spark.sql.parquet.outputTimestampType](configuration-properties.md#spark.sql.parquet.outputTimestampType)

Used when:

* `ParquetFileFormat` is requested to [prepareWrite](parquet/ParquetFileFormat.md#prepareWrite)
* `SparkToParquetSchemaConverter` is [created](parquet/SparkToParquetSchemaConverter.md)
* `ParquetWriteSupport` is requested to [init](parquet/ParquetWriteSupport.md#init)
* `ParquetWrite` is requested to [prepareWrite](parquet/ParquetWrite.md#prepareWrite)

## <span id="parquetRecordFilterEnabled"> parquetRecordFilterEnabled

[spark.sql.parquet.recordLevelFilter.enabled](configuration-properties.md#spark.sql.parquet.recordLevelFilter.enabled)

Used when `ParquetFileFormat` is requested to [build a data reader (with partition column values appended)](parquet/ParquetFileFormat.md#buildReaderWithPartitionValues).

## <span id="parquetVectorizedReaderBatchSize"> parquetVectorizedReaderBatchSize

[spark.sql.parquet.columnarReaderBatchSize](configuration-properties.md#spark.sql.parquet.columnarReaderBatchSize)

## <span id="parquetVectorizedReaderEnabled"> parquetVectorizedReaderEnabled

[spark.sql.parquet.enableVectorizedReader](configuration-properties.md#spark.sql.parquet.enableVectorizedReader)

Used when:

* `FileSourceScanExec` is requested for [needsUnsafeRowConversion](physical-operators/FileSourceScanExec.md#needsUnsafeRowConversion) flag
* `ParquetFileFormat` is requested for [supportBatch](parquet/ParquetFileFormat.md#supportBatch) flag and [build a data reader with partition column values appended](parquet/ParquetFileFormat.md#buildReaderWithPartitionValues)

## <span id="parquetVectorizedReaderNestedColumnEnabled"><span id="PARQUET_VECTORIZED_READER_NESTED_COLUMN_ENABLED"> parquetVectorizedReaderNestedColumnEnabled

[spark.sql.parquet.enableNestedColumnVectorizedReader](configuration-properties.md#spark.sql.parquet.enableNestedColumnVectorizedReader)

## <span id="partitionOverwriteMode"><span id="PARTITION_OVERWRITE_MODE"> partitionOverwriteMode

The value of [spark.sql.sources.partitionOverwriteMode](configuration-properties.md#spark.sql.sources.partitionOverwriteMode) configuration property

Used when [InsertIntoHadoopFsRelationCommand](logical-operators/InsertIntoHadoopFsRelationCommand.md) logical command is executed

## <span id="planChangeLogLevel"><span id="PLAN_CHANGE_LOG_LEVEL"> planChangeLogLevel

The value of [spark.sql.planChangeLog.level](configuration-properties.md#spark.sql.planChangeLog.level) configuration property

Used when:

* [PlanChangeLogger](catalyst/PlanChangeLogger.md) is created

## <span id="planChangeBatches"><span id="PLAN_CHANGE_LOG_BATCHES"> planChangeBatches

The value of [spark.sql.planChangeLog.batches](configuration-properties.md#spark.sql.planChangeLog.batches) configuration property

Used when:

* `PlanChangeLogger` is requested to [logBatch](catalyst/PlanChangeLogger.md#logBatch)

## <span id="planChangeRules"><span id="PLAN_CHANGE_LOG_RULES"> planChangeRules

The value of [spark.sql.planChangeLog.rules](configuration-properties.md#spark.sql.planChangeLog.rules) configuration property

Used when:

* `PlanChangeLogger` is requested to [logRule](catalyst/PlanChangeLogger.md#logRule)

## <span id="preferSortMergeJoin"> preferSortMergeJoin

[spark.sql.join.preferSortMergeJoin](configuration-properties.md#spark.sql.join.preferSortMergeJoin)

Used in [JoinSelection](execution-planning-strategies/JoinSelection.md) execution planning strategy to prefer sort merge join over shuffle hash join.

## <span id="LEAF_NODE_DEFAULT_PARALLELISM"> LEAF_NODE_DEFAULT_PARALLELISM

[spark.sql.leafNodeDefaultParallelism](configuration-properties.md#spark.sql.leafNodeDefaultParallelism)

Used when:

* `SparkSession` is requested for the [leafNodeDefaultParallelism](SparkSession.md#leafNodeDefaultParallelism)

## <span id="LEGACY_CTE_PRECEDENCE_POLICY"> LEGACY_CTE_PRECEDENCE_POLICY

[spark.sql.legacy.ctePrecedencePolicy](configuration-properties.md#spark.sql.legacy.ctePrecedencePolicy)

## PROPAGATE_DISTINCT_KEYS_ENABLED { #PROPAGATE_DISTINCT_KEYS_ENABLED }

[spark.sql.optimizer.propagateDistinctKeys.enabled](configuration-properties.md#spark.sql.optimizer.propagateDistinctKeys.enabled)

## <span id="replaceDatabricksSparkAvroEnabled"><span id="LEGACY_REPLACE_DATABRICKS_SPARK_AVRO_ENABLED"> replaceDatabricksSparkAvroEnabled

[spark.sql.legacy.replaceDatabricksSparkAvro.enabled](configuration-properties.md#spark.sql.legacy.replaceDatabricksSparkAvro.enabled)

## <span id="replaceExceptWithFilter"><span id="REPLACE_EXCEPT_WITH_FILTER"> replaceExceptWithFilter

[spark.sql.optimizer.replaceExceptWithFilter](configuration-properties.md#spark.sql.optimizer.replaceExceptWithFilter)

Used when [ReplaceExceptWithFilter](logical-optimizations/ReplaceExceptWithFilter.md) logical optimization is executed

## <span id="runSQLonFile"> runSQLonFile

[spark.sql.runSQLOnFiles](configuration-properties.md#spark.sql.runSQLOnFiles)

Used when:

* `ResolveSQLOnFile` is requested to [maybeSQLFile](logical-analysis-rules/ResolveSQLOnFile.md#maybeSQLFile)

## <span id="RUNTIME_BLOOM_FILTER_EXPECTED_NUM_ITEMS"> RUNTIME_BLOOM_FILTER_EXPECTED_NUM_ITEMS

[spark.sql.optimizer.runtime.bloomFilter.expectedNumItems](configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.expectedNumItems)

## <span id="RUNTIME_ROW_LEVEL_OPERATION_GROUP_FILTER_ENABLED"> runtimeRowLevelOperationGroupFilterEnabled { #runtimeRowLevelOperationGroupFilterEnabled }

[spark.sql.optimizer.runtime.rowLevelOperationGroupFilter.enabled](configuration-properties.md#spark.sql.optimizer.runtime.rowLevelOperationGroupFilter.enabled)

## <span id="SESSION_LOCAL_TIMEZONE"> sessionLocalTimeZone { #sessionLocalTimeZone }

[spark.sql.session.timeZone](configuration-properties.md#spark.sql.session.timeZone)

## <span id="SESSION_WINDOW_BUFFER_IN_MEMORY_THRESHOLD"> sessionWindowBufferInMemoryThreshold { #sessionWindowBufferInMemoryThreshold }

[spark.sql.sessionWindow.buffer.in.memory.threshold](configuration-properties.md#spark.sql.sessionWindow.buffer.in.memory.threshold)

Used when:

* `UpdatingSessionsExec` unary physical operator is executed

## <span id="SESSION_WINDOW_BUFFER_SPILL_THRESHOLD"><span id="sessionWindowBufferSpillThreshold"> sessionWindowBufferSpillThreshold

[spark.sql.sessionWindow.buffer.spill.threshold](configuration-properties.md#spark.sql.sessionWindow.buffer.spill.threshold)

Used when:

* `UpdatingSessionsExec` unary physical operator is executed

## <span id="sortBeforeRepartition"><span id="SORT_BEFORE_REPARTITION"> sortBeforeRepartition

The value of [spark.sql.execution.sortBeforeRepartition](configuration-properties.md#spark.sql.execution.sortBeforeRepartition) configuration property

Used when [ShuffleExchangeExec](physical-operators/ShuffleExchangeExec.md) physical operator is executed

## <span id="starSchemaDetection"> starSchemaDetection

[spark.sql.cbo.starSchemaDetection](configuration-properties.md#spark.sql.cbo.starSchemaDetection)

Used in [ReorderJoin](logical-optimizations/ReorderJoin.md) logical optimization (and indirectly in `StarSchemaDetection`)

## <span id="stringRedactionPattern"> stringRedactionPattern

[spark.sql.redaction.string.regex](configuration-properties.md#spark.sql.redaction.string.regex)

Used when:

* `DataSourceScanExec` is requested to [redact sensitive information](physical-operators/DataSourceScanExec.md#redact) (in text representations)
* `QueryExecution` is requested to [redact sensitive information](QueryExecution.md#withRedaction) (in text representations)

## <span id="subexpressionEliminationEnabled"> subexpressionEliminationEnabled

[spark.sql.subexpressionElimination.enabled](configuration-properties.md#spark.sql.subexpressionElimination.enabled)

Used when `SparkPlan` is requested for [subexpressionEliminationEnabled](physical-operators/SparkPlan.md#subexpressionEliminationEnabled) flag.

## <span id="subqueryReuseEnabled"><span id="SUBQUERY_REUSE_ENABLED"> subqueryReuseEnabled

[spark.sql.execution.reuseSubquery](configuration-properties.md#spark.sql.execution.reuseSubquery)

Used when:

* [ReuseAdaptiveSubquery](physical-optimizations/ReuseAdaptiveSubquery.md) adaptive physical optimization is executed
* [ReuseExchangeAndSubquery](physical-optimizations/ReuseExchangeAndSubquery.md) physical optimization is executed

## <span id="supportQuotedRegexColumnName"> supportQuotedRegexColumnName

[spark.sql.parser.quotedRegexColumnNames](configuration-properties.md#spark.sql.parser.quotedRegexColumnNames)

Used when:

* [Dataset.col](dataset/untyped-transformations.md#col) operator is used
* `AstBuilder` is requested to parse a [dereference](sql/AstBuilder.md#visitDereference) and [column reference](sql/AstBuilder.md#visitColumnReference) in a SQL statement

## <span id="targetPostShuffleInputSize"> targetPostShuffleInputSize

[spark.sql.adaptive.shuffle.targetPostShuffleInputSize](configuration-properties.md#spark.sql.adaptive.shuffle.targetPostShuffleInputSize)

Used when [EnsureRequirements](physical-optimizations/EnsureRequirements.md) physical optimization is executed (for [Adaptive Query Execution](adaptive-query-execution/index.md))

## <span id="THRIFTSERVER_FORCE_CANCEL"> THRIFTSERVER_FORCE_CANCEL

[spark.sql.thriftServer.interruptOnCancel](configuration-properties.md#spark.sql.thriftServer.interruptOnCancel)

Used when:

* `SparkExecuteStatementOperation` is created (`forceCancel`)

## <span id="truncateTableIgnorePermissionAcl"><span id="TRUNCATE_TABLE_IGNORE_PERMISSION_ACL"> truncateTableIgnorePermissionAcl

[spark.sql.truncateTable.ignorePermissionAcl.enabled](configuration-properties.md#spark.sql.truncateTable.ignorePermissionAcl.enabled)

Used when [TruncateTableCommand](logical-operators/TruncateTableCommand.md) logical command is executed

## <span id="useCompression"><span id="COMPRESS_CACHED"> useCompression

The value of [spark.sql.inMemoryColumnarStorage.compressed](configuration-properties.md#spark.sql.inMemoryColumnarStorage.compressed) configuration property

Used when `CacheManager` is requested to [cache a structured query](CacheManager.md#cacheQuery)

## <span id="useObjectHashAggregation"> useObjectHashAggregation

[spark.sql.execution.useObjectHashAggregateExec](configuration-properties.md#spark.sql.execution.useObjectHashAggregateExec)

Used when [Aggregation](execution-planning-strategies/Aggregation.md) execution planning strategy is executed (and uses `AggUtils` to [create an aggregation physical operator](aggregations/AggUtils.md#createAggregate)).

## <span id="VARIABLE_SUBSTITUTE_ENABLED"><span id="variableSubstituteEnabled"><span id="spark.sql.variable.substitute"> variableSubstituteEnabled

[spark.sql.variable.substitute](configuration-properties.md#spark.sql.variable.substitute)

Used when:

* `VariableSubstitution` is requested to [substitute variables in a SQL command](sql/VariableSubstitution.md#substitute)

## <span id="wholeStageEnabled"> wholeStageEnabled

[spark.sql.codegen.wholeStage](configuration-properties.md#spark.sql.codegen.wholeStage)

Used in:

* [CollapseCodegenStages](physical-optimizations/CollapseCodegenStages.md) to control codegen
* [ParquetFileFormat](parquet/ParquetFileFormat.md) to control row batch reading

## <span id="wholeStageFallback"> wholeStageFallback

[spark.sql.codegen.fallback](configuration-properties.md#spark.sql.codegen.fallback)

## <span id="wholeStageMaxNumFields"> wholeStageMaxNumFields

[spark.sql.codegen.maxFields](configuration-properties.md#spark.sql.codegen.maxFields)

Used in:

* [CollapseCodegenStages](physical-optimizations/CollapseCodegenStages.md) to control codegen
* [ParquetFileFormat](parquet/ParquetFileFormat.md) to control row batch reading

## <span id="wholeStageSplitConsumeFuncByOperator"> wholeStageSplitConsumeFuncByOperator

[spark.sql.codegen.splitConsumeFuncByOperator](configuration-properties.md#spark.sql.codegen.splitConsumeFuncByOperator)

Used when `CodegenSupport` is requested to [consume](physical-operators/CodegenSupport.md#consume)

## <span id="wholeStageUseIdInClassName"> wholeStageUseIdInClassName

[spark.sql.codegen.useIdInClassName](configuration-properties.md#spark.sql.codegen.useIdInClassName)

Used when `WholeStageCodegenExec` is requested to [generate the Java source code for the child physical plan subtree](physical-operators/WholeStageCodegenExec.md#doCodeGen) (when [created](physical-operators/WholeStageCodegenExec.md#creating-instance))

## <span id="windowExecBufferInMemoryThreshold"><span id="WINDOW_EXEC_BUFFER_IN_MEMORY_THRESHOLD"> windowExecBufferInMemoryThreshold

[spark.sql.windowExec.buffer.in.memory.threshold](configuration-properties.md#spark.sql.windowExec.buffer.in.memory.threshold)

Used when:

* [WindowExec](physical-operators/WindowExec.md) unary physical operator is executed

## <span id="windowExecBufferSpillThreshold"><span id="WINDOW_EXEC_BUFFER_SPILL_THRESHOLD"> windowExecBufferSpillThreshold

[spark.sql.windowExec.buffer.spill.threshold](configuration-properties.md#spark.sql.windowExec.buffer.spill.threshold)

Used when:

* [WindowExec](physical-operators/WindowExec.md) unary physical operator is executed
