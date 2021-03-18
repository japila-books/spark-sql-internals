# SQLConf &mdash; Internal Configuration Store

`SQLConf` is an internal **configuration store** for configuration properties and hints used in Spark SQL.

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

## <span id="ADAPTIVE_EXECUTION_FORCE_APPLY"> ADAPTIVE_EXECUTION_FORCE_APPLY

[spark.sql.adaptive.forceApply](configuration-properties.md#spark.sql.adaptive.forceApply) configuration property

Used when [InsertAdaptiveSparkPlan](physical-optimizations/InsertAdaptiveSparkPlan.md) physical optimization is executed

## <span id="ADAPTIVE_EXECUTION_ENABLED"><span id="adaptiveExecutionEnabled"> adaptiveExecutionEnabled

The value of [spark.sql.adaptive.enabled](configuration-properties.md#spark.sql.adaptive.enabled) configuration property

Used when:

* `AdaptiveSparkPlanHelper` is requested to `getOrCloneSessionWithAqeOff`

* [InsertAdaptiveSparkPlan](physical-optimizations/InsertAdaptiveSparkPlan.md) and [EnsureRequirements](physical-optimizations/EnsureRequirements.md) physical optimizations are executed

## <span id="ADAPTIVE_EXECUTION_LOG_LEVEL"><span id="adaptiveExecutionLogLevel"> adaptiveExecutionLogLevel

The value of [spark.sql.adaptive.logLevel](configuration-properties.md#spark.sql.adaptive.logLevel) configuration property

Used when [AdaptiveSparkPlanExec](physical-operators/AdaptiveSparkPlanExec.md) physical operator is executed

## <span id="ADVISORY_PARTITION_SIZE_IN_BYTES"> ADVISORY_PARTITION_SIZE_IN_BYTES

[spark.sql.adaptive.advisoryPartitionSizeInBytes](configuration-properties.md#spark.sql.adaptive.advisoryPartitionSizeInBytes) configuration property

Used when [CoalesceShufflePartitions](physical-optimizations/CoalesceShufflePartitions.md) and [OptimizeSkewedJoin](physical-optimizations/OptimizeSkewedJoin.md) physical optimizations are executed

## <span id="autoBroadcastJoinThreshold"> autoBroadcastJoinThreshold

The value of [spark.sql.autoBroadcastJoinThreshold](configuration-properties.md#spark.sql.autoBroadcastJoinThreshold) configuration property

Used in [JoinSelection](execution-planning-strategies/JoinSelection.md) execution planning strategy

## <span id="autoSizeUpdateEnabled"> autoSizeUpdateEnabled

The value of [spark.sql.statistics.size.autoUpdate.enabled](configuration-properties.md#spark.sql.statistics.size.autoUpdate.enabled) configuration property

Used when:

* `CommandUtils` is requested for [updating existing table statistics](CommandUtils.md#updateTableStats)
* `AlterTableAddPartitionCommand` logical command is executed

## <span id="avroCompressionCodec"> avroCompressionCodec

The value of [spark.sql.avro.compression.codec](configuration-properties.md#spark.sql.avro.compression.codec) configuration property

Used when `AvroOptions` is requested for the [compression](datasources/avro/AvroOptions.md#compression) configuration property (and it was not set explicitly)

## <span id="broadcastTimeout"> broadcastTimeout

The value of [spark.sql.broadcastTimeout](configuration-properties.md#spark.sql.broadcastTimeout) configuration property

Used in [BroadcastExchangeExec](physical-operators/BroadcastExchangeExec.md) (for broadcasting a table to executors)

## <span id="bucketingEnabled"> bucketingEnabled

The value of [spark.sql.sources.bucketing.enabled](configuration-properties.md#spark.sql.sources.bucketing.enabled) configuration property

Used when `FileSourceScanExec` physical operator is requested for the [input RDD](physical-operators/FileSourceScanExec.md#inputRDD) and to determine [output partitioning](physical-operators/FileSourceScanExec.md#outputPartitioning) and [ordering](physical-operators/FileSourceScanExec.md#outputOrdering)

## <span id="cacheVectorizedReaderEnabled"> cacheVectorizedReaderEnabled

The value of [spark.sql.inMemoryColumnarStorage.enableVectorizedReader](configuration-properties.md#spark.sql.inMemoryColumnarStorage.enableVectorizedReader) configuration property

Used when `InMemoryTableScanExec` physical operator is requested for [supportsBatch](physical-operators/InMemoryTableScanExec.md#supportsBatch) flag.

## <span id="caseSensitiveAnalysis"> caseSensitiveAnalysis

The value of [spark.sql.caseSensitive](configuration-properties.md#spark.sql.caseSensitive) configuration property

## <span id="cboEnabled"> cboEnabled

The value of [spark.sql.cbo.enabled](configuration-properties.md#spark.sql.cbo.enabled) configuration property

Used in:

* [ReorderJoin](logical-optimizations/ReorderJoin.md) logical plan optimization (and indirectly in `StarSchemaDetection` for `reorderStarJoins`)
* [CostBasedJoinReorder](logical-optimizations/CostBasedJoinReorder.md) logical plan optimization

## <span id="coalesceShufflePartitionsEnabled"><span id="COALESCE_PARTITIONS_ENABLED"> coalesceShufflePartitionsEnabled

The value of [spark.sql.adaptive.coalescePartitions.enabled](configuration-properties.md#spark.sql.adaptive.coalescePartitions.enabled) configuration property

Used when [CoalesceShufflePartitions](physical-optimizations/CoalesceShufflePartitions.md) and [EnsureRequirements](physical-optimizations/EnsureRequirements.md) physical optimizations are executed

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

## <span id="dataFramePivotMaxValues"> dataFramePivotMaxValues

The value of [spark.sql.pivotMaxValues](configuration-properties.md#spark.sql.pivotMaxValues) configuration property

Used in [pivot](RelationalGroupedDataset.md#pivot) operator.

## <span id="dataFrameRetainGroupColumns"> dataFrameRetainGroupColumns

The value of [spark.sql.retainGroupColumns](configuration-properties.md#spark.sql.retainGroupColumns) configuration property

Used in [RelationalGroupedDataset](RelationalGroupedDataset.md) when creating the result `Dataset` (after `agg`, `count`, `mean`, `max`, `avg`, `min`, and `sum` operators).

## <span id="DEFAULT_CATALOG"> DEFAULT_CATALOG

The value of [spark.sql.defaultCatalog](configuration-properties.md#spark.sql.defaultCatalog) configuration property

Used when `CatalogManager` is requested for the [current CatalogPlugin](connector/catalog/CatalogManager.md#currentCatalog)

## <span id="defaultDataSourceName"><span id="DEFAULT_DATA_SOURCE_NAME"> defaultDataSourceName

The value of [spark.sql.sources.default](configuration-properties.md#spark.sql.sources.default) configuration property

Used when:

* FIXME

## <span id="DYNAMIC_PARTITION_PRUNING_ENABLED"><span id="dynamicPartitionPruningEnabled"> dynamicPartitionPruningEnabled

The value of [spark.sql.optimizer.dynamicPartitionPruning.enabled](configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.enabled) configuration property

Used when:

* [CleanupDynamicPruningFilters](logical-optimizations/CleanupDynamicPruningFilters.md) logical optimization rule is executed

* [PartitionPruning](logical-optimizations/PartitionPruning.md) logical optimization rule is executed

* [PlanDynamicPruningFilters](physical-optimizations/PlanDynamicPruningFilters.md) preparation physical rule is executed

## <span id="DYNAMIC_PARTITION_PRUNING_FALLBACK_FILTER_RATIO"><span id="dynamicPartitionPruningFallbackFilterRatio"> dynamicPartitionPruningFallbackFilterRatio

The value of [spark.sql.optimizer.dynamicPartitionPruning.fallbackFilterRatio](configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.fallbackFilterRatio) configuration property

Used when [PartitionPruning](logical-optimizations/PartitionPruning.md) logical optimization rule is executed.

## <span id="DYNAMIC_PARTITION_PRUNING_USE_STATS"><span id="dynamicPartitionPruningUseStats"> dynamicPartitionPruningUseStats

The value of [spark.sql.optimizer.dynamicPartitionPruning.useStats](configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.useStats) configuration property

Used when [PartitionPruning](logical-optimizations/PartitionPruning.md) logical optimization rule is executed.

## <span id="DYNAMIC_PARTITION_PRUNING_REUSE_BROADCAST_ONLY"><span id="dynamicPartitionPruningReuseBroadcastOnly"> dynamicPartitionPruningReuseBroadcastOnly

The value of [spark.sql.optimizer.dynamicPartitionPruning.reuseBroadcastOnly](configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.reuseBroadcastOnly) configuration property

Used when [PartitionPruning](logical-optimizations/PartitionPruning.md) logical optimization is executed

## <span id="defaultSizeInBytes"> defaultSizeInBytes

The value of [spark.sql.defaultSizeInBytes](configuration-properties.md#spark.sql.defaultSizeInBytes) configuration property

Used when:

* `DetermineTableStats` logical resolution rule could not compute the table size or [spark.sql.statistics.fallBackToHdfs](#spark.sql.statistics.fallBackToHdfs) is disabled
* [ExternalRDD](logical-operators/ExternalRDD.md#computeStats), [LogicalRDD](logical-operators/LogicalRDD.md#computeStats) and [DataSourceV2Relation](logical-operators/DataSourceV2Relation.md) are requested to compute stats
*  (Spark Structured Streaming) `StreamingRelation`, `StreamingExecutionRelation`, `StreamingRelationV2` and `ContinuousExecutionRelation` are requested for statistics (i.e. `computeStats`)
* `DataSource` [creates a HadoopFsRelation for FileFormat data source](DataSource.md#resolveRelation) (and builds a [CatalogFileIndex](CatalogFileIndex.md) when no table statistics are available)
* `BaseRelation` is requested for [an estimated size of this relation](BaseRelation.md#sizeInBytes) (in bytes)

## <span id="EXCHANGE_REUSE_ENABLED"><span id="exchangeReuseEnabled"> exchangeReuseEnabled

The value of [spark.sql.exchange.reuse](configuration-properties.md#spark.sql.exchange.reuse) configuration property

Used when:

* [AdaptiveSparkPlanExec](physical-operators/AdaptiveSparkPlanExec.md) physical operator is requested to [createQueryStages](physical-operators/AdaptiveSparkPlanExec.md#createQueryStages)

* [PartitionPruning](logical-optimizations/PartitionPruning.md) logical optimization rule is executed.

* `PlanDynamicPruningFilters` and [ReuseExchange](physical-optimizations/ReuseExchange.md) physical optimizations are executed

## <span id="enableRadixSort"> enableRadixSort

[spark.sql.sort.enableRadixSort](configuration-properties.md#spark.sql.sort.enableRadixSort)

Used when `SortExec` physical operator is requested for a <<SortExec.md#createSorter, UnsafeExternalRowSorter>>.

## <span id="fallBackToHdfsForStatsEnabled"> fallBackToHdfsForStatsEnabled

[spark.sql.statistics.fallBackToHdfs](configuration-properties.md#spark.sql.statistics.fallBackToHdfs)

Used when `DetermineTableStats` logical resolution rule is executed.

## <span id="FETCH_SHUFFLE_BLOCKS_IN_BATCH"><span id="fetchShuffleBlocksInBatch"> fetchShuffleBlocksInBatch

The value of [spark.sql.adaptive.fetchShuffleBlocksInBatch](configuration-properties.md#spark.sql.adaptive.fetchShuffleBlocksInBatch) configuration property

Used when [ShuffledRowRDD](ShuffledRowRDD.md) is created

## <span id="fileCommitProtocolClass"> fileCommitProtocolClass

[spark.sql.sources.commitProtocolClass](configuration-properties.md#spark.sql.sources.commitProtocolClass)

Used (to instantiate a `FileCommitProtocol`) when:

* `SaveAsHiveFile` is requested to <<hive/SaveAsHiveFile.md#saveAsHiveFile, saveAsHiveFile>>

* [InsertIntoHadoopFsRelationCommand](logical-operators/InsertIntoHadoopFsRelationCommand.md) logical command is executed

## <span id="fileCompressionFactor"><span id="FILE_COMPRESSION_FACTOR"> fileCompressionFactor

The value of [spark.sql.sources.fileCompressionFactor](configuration-properties.md#spark.sql.sources.fileCompressionFactor) configuration property

Used when:

* `HadoopFsRelation` is requested for a [size](HadoopFsRelation.md#sizeInBytes)
* `FileScan` is requested to [estimate statistics](FileScan.md#estimateStatistics)

## <span id="filesMaxPartitionBytes"> filesMaxPartitionBytes

[spark.sql.files.maxPartitionBytes](configuration-properties.md#spark.sql.files.maxPartitionBytes)

Used when <<FileSourceScanExec.md#, FileSourceScanExec>> leaf physical operator is requested to <<FileSourceScanExec.md#createNonBucketedReadRDD, create an RDD for non-bucketed reads>>

## <span id="filesOpenCostInBytes"> filesOpenCostInBytes

[spark.sql.files.openCostInBytes](configuration-properties.md#spark.sql.files.openCostInBytes)

Used when <<FileSourceScanExec.md#, FileSourceScanExec>> leaf physical operator is requested to <<FileSourceScanExec.md#createNonBucketedReadRDD, create an RDD for non-bucketed reads>>

## <span id="histogramEnabled"><span id="MAX_TO_STRING_FIELDS"> histogramEnabled

The value of [spark.sql.statistics.histogram.enabled](configuration-properties.md#spark.sql.statistics.histogram.enabled) configuration property

Used when [AnalyzeColumnCommand](logical-operators/AnalyzeColumnCommand.md) logical command is executed.

## <span id="histogramNumBins"> histogramNumBins

[spark.sql.statistics.histogram.numBins](configuration-properties.md#spark.sql.statistics.histogram.numBins)

Used when `AnalyzeColumnCommand` is AnalyzeColumnCommand.md#run[executed] with configuration-properties.md#spark.sql.statistics.histogram.enabled[spark.sql.statistics.histogram.enabled] turned on (and AnalyzeColumnCommand.md#computePercentiles[calculates percentiles]).

## <span id="hugeMethodLimit"> hugeMethodLimit

[spark.sql.codegen.hugeMethodLimit](configuration-properties.md#spark.sql.codegen.hugeMethodLimit)

Used when `WholeStageCodegenExec` unary physical operator is requested to <<WholeStageCodegenExec.md#doExecute, execute>> (and generate a `RDD[InternalRow]`), i.e. when the compiled function exceeds this threshold, the whole-stage codegen is deactivated for this subtree of the query plan.

## <span id="ignoreCorruptFiles"><span id="IGNORE_CORRUPT_FILES"> ignoreCorruptFiles

The value of [spark.sql.files.ignoreCorruptFiles](configuration-properties.md#spark.sql.files.ignoreCorruptFiles) configuration property

Used when:

* `AvroUtils` utility is requested to `inferSchema`
* `OrcFileFormat` is requested to [inferSchema](datasources/orc/OrcFileFormat.md#inferSchema) and [buildReader](datasources/orc/OrcFileFormat.md#buildReader)
* `FileScanRDD` is [created](rdds/FileScanRDD.md#ignoreCorruptFiles) (and then to [compute a partition](rdds/FileScanRDD.md#compute))
* `SchemaMergeUtils` utility is requested to `mergeSchemasInParallel`
* `OrcUtils` utility is requested to `readSchema`
* `FilePartitionReader` is requested to `ignoreCorruptFiles`

## <span id="ignoreMissingFiles"><span id="IGNORE_MISSING_FILES"> ignoreMissingFiles

The value of [spark.sql.files.ignoreMissingFiles](configuration-properties.md#spark.sql.files.ignoreMissingFiles) configuration property

Used when:

* `FileScanRDD` is [created](rdds/FileScanRDD.md#ignoreMissingFiles) (and then to [compute a partition](rdds/FileScanRDD.md#compute))
* `InMemoryFileIndex` utility is requested to [bulkListLeafFiles](InMemoryFileIndex.md#bulkListLeafFiles)
* `FilePartitionReader` is requested to `ignoreMissingFiles`

## <span id="inMemoryPartitionPruning"> inMemoryPartitionPruning

[spark.sql.inMemoryColumnarStorage.partitionPruning](configuration-properties.md#spark.sql.inMemoryColumnarStorage.partitionPruning)

Used when `InMemoryTableScanExec` physical operator is requested for [filtered cached column batches](physical-operators/InMemoryTableScanExec.md#filteredCachedBatches) (as a `RDD[CachedBatch]`).

## <span id="isParquetBinaryAsString"> isParquetBinaryAsString

[spark.sql.parquet.binaryAsString](configuration-properties.md#spark.sql.parquet.binaryAsString)

## <span id="isParquetINT96AsTimestamp"> isParquetINT96AsTimestamp

[spark.sql.parquet.int96AsTimestamp](configuration-properties.md#spark.sql.parquet.int96AsTimestamp)

## <span id="isParquetINT96TimestampConversion"> isParquetINT96TimestampConversion

[spark.sql.parquet.int96TimestampConversion](configuration-properties.md#spark.sql.parquet.int96TimestampConversion)

Used when `ParquetFileFormat` is requested to [build a data reader with partition column values appended](datasources/parquet/ParquetFileFormat.md#buildReaderWithPartitionValues).

## <span id="joinReorderEnabled"> joinReorderEnabled

[spark.sql.cbo.joinReorder.enabled](configuration-properties.md#spark.sql.cbo.joinReorder.enabled)

Used in [CostBasedJoinReorder](logical-optimizations/CostBasedJoinReorder.md) logical plan optimization

## <span id="limitScaleUpFactor"> limitScaleUpFactor

[spark.sql.limit.scaleUpFactor](configuration-properties.md#spark.sql.limit.scaleUpFactor)

Used when a physical operator is requested [the first n rows as an array](physical-operators/SparkPlan.md#executeTake).

## <span id="manageFilesourcePartitions"><span id="HIVE_MANAGE_FILESOURCE_PARTITIONS"> manageFilesourcePartitions

[spark.sql.hive.manageFilesourcePartitions](hive/configuration-properties.md#spark.sql.hive.manageFilesourcePartitions)

Used when:

* `HiveMetastoreCatalog` is requested to [convert a HiveTableRelation to a LogicalRelation over a HadoopFsRelation](hive/HiveMetastoreCatalog.md#convertToLogicalRelation)
* [CreateDataSourceTableCommand](logical-operators/CreateDataSourceTableCommand.md), [CreateDataSourceTableAsSelectCommand](logical-operators/CreateDataSourceTableAsSelectCommand.md) and [InsertIntoHadoopFsRelationCommand](logical-operators/InsertIntoHadoopFsRelationCommand.md) logical commands are executed
* `DDLUtils` utility is used to [verifyPartitionProviderIsHive](spark-sql-DDLUtils.md#verifyPartitionProviderIsHive)
* `DataSource` is requested to [resolve a relation](DataSource.md#resolveRelation) (for file-based data source tables and creates a `HadoopFsRelation`)
* `FileStatusCache` is requested to `getOrCreate`

## <span id="maxRecordsPerFile"><span id="MAX_RECORDS_PER_FILE"> maxRecordsPerFile

The value of [spark.sql.files.maxRecordsPerFile](configuration-properties.md#spark.sql.files.maxRecordsPerFile) configuration property

Used when:

* `FileFormatWriter` utility is used to [write out a query result](FileFormatWriter.md#write)

## <span id="maxToStringFields"><span id="MAX_TO_STRING_FIELDS"> maxToStringFields

The value of [spark.sql.debug.maxToStringFields](configuration-properties.md#spark.sql.debug.maxToStringFields) configuration property

## <span id="metastorePartitionPruning"><span id="HIVE_METASTORE_PARTITION_PRUNING"> metastorePartitionPruning

[spark.sql.hive.metastorePartitionPruning](configuration-properties.md#spark.sql.hive.metastorePartitionPruning)

Used when [HiveTableScanExec](hive/HiveTableScanExec.md) physical operator is executed with a partitioned table (and requested for [rawPartitions](hive/HiveTableScanExec.md#rawPartitions))

## <span id="minNumPostShufflePartitions"> minNumPostShufflePartitions

[spark.sql.adaptive.minNumPostShufflePartitions](configuration-properties.md#spark.sql.adaptive.minNumPostShufflePartitions)

Used when [EnsureRequirements](physical-optimizations/EnsureRequirements.md) physical optimization is executed (for [Adaptive Query Execution](new-and-noteworthy/adaptive-query-execution.md)).

## <span id="nestedSchemaPruningEnabled"><span id="NESTED_SCHEMA_PRUNING_ENABLED"> nestedSchemaPruningEnabled

The value of [spark.sql.optimizer.nestedSchemaPruning.enabled](configuration-properties.md#spark.sql.optimizer.nestedSchemaPruning.enabled) configuration property

Used when [SchemaPruning](logical-optimizations/SchemaPruning.md), [ColumnPruning](logical-optimizations/ColumnPruning.md) and [V2ScanRelationPushDown](logical-optimizations/V2ScanRelationPushDown.md) logical optimizations are executed

## <span id="nonEmptyPartitionRatioForBroadcastJoin"><span id="NON_EMPTY_PARTITION_RATIO_FOR_BROADCAST_JOIN"> nonEmptyPartitionRatioForBroadcastJoin

The value of [spark.sql.adaptive.nonEmptyPartitionRatioForBroadcastJoin](configuration-properties.md#spark.sql.adaptive.nonEmptyPartitionRatioForBroadcastJoin) configuration property

Used when [DemoteBroadcastHashJoin](logical-optimizations/DemoteBroadcastHashJoin.md) logical optimization is executed

## <span id="numShufflePartitions"><span id="SHUFFLE_PARTITIONS"> numShufflePartitions

The value of [spark.sql.shuffle.partitions](configuration-properties.md#spark.sql.shuffle.partitions) configuration property

## <span id="rangeExchangeSampleSizePerPartition"><span id="RANGE_EXCHANGE_SAMPLE_SIZE_PER_PARTITION"> rangeExchangeSampleSizePerPartition

The value of [spark.sql.execution.rangeExchange.sampleSizePerPartition](configuration-properties.md#spark.sql.execution.rangeExchange.sampleSizePerPartition) configuration property

Used when [ShuffleExchangeExec](physical-operators/ShuffleExchangeExec.md) physical operator is executed

## <span id="SKEW_JOIN_SKEWED_PARTITION_FACTOR"> SKEW_JOIN_SKEWED_PARTITION_FACTOR

[spark.sql.adaptive.skewJoin.skewedPartitionFactor](configuration-properties.md#spark.sql.adaptive.skewJoin.skewedPartitionFactor) configuration property

Used when [OptimizeSkewedJoin](physical-optimizations/OptimizeSkewedJoin.md) physical optimization is executed

## <span id="SKEW_JOIN_SKEWED_PARTITION_THRESHOLD"> SKEW_JOIN_SKEWED_PARTITION_THRESHOLD

[spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes](configuration-properties.md#spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes) configuration property

Used when [OptimizeSkewedJoin](physical-optimizations/OptimizeSkewedJoin.md) physical optimization is executed

## <span id="SKEW_JOIN_ENABLED"> SKEW_JOIN_ENABLED

[spark.sql.adaptive.skewJoin.enabled](configuration-properties.md#spark.sql.adaptive.skewJoin.enabled) configuration property

Used when [OptimizeSkewedJoin](physical-optimizations/OptimizeSkewedJoin.md) physical optimization is executed

## <span id="offHeapColumnVectorEnabled"> offHeapColumnVectorEnabled

[spark.sql.columnVector.offheap.enabled](configuration-properties.md#spark.sql.columnVector.offheap.enabled)

Used when:

* `InMemoryTableScanExec` is requested for the [vectorTypes](physical-operators/InMemoryTableScanExec.md#vectorTypes) and the [input RDD](physical-operators/InMemoryTableScanExec.md#inputRDD)
* `OrcFileFormat` is requested to [build a data reader with partition column values appended](datasources/orc/OrcFileFormat.md#buildReaderWithPartitionValues)
* `ParquetFileFormat` is requested for [vectorTypes](datasources/parquet/ParquetFileFormat.md#vectorTypes) and [build a data reader with partition column values appended](datasources/parquet/ParquetFileFormat.md#buildReaderWithPartitionValues)

## <span id="optimizerExcludedRules"><span id="OPTIMIZER_EXCLUDED_RULES"> optimizerExcludedRules

The value of [spark.sql.optimizer.excludedRules](configuration-properties.md#spark.sql.optimizer.excludedRules) configuration property

Used when `Optimizer` is requested for the [batches](catalyst/Optimizer.md#batches)

## <span id="optimizerInSetConversionThreshold"> optimizerInSetConversionThreshold

[spark.sql.optimizer.inSetConversionThreshold](configuration-properties.md#spark.sql.optimizer.inSetConversionThreshold)

Used when [OptimizeIn](logical-optimizations/OptimizeIn.md) logical query optimization is executed

## <span id="ORC_IMPLEMENTATION"> ORC_IMPLEMENTATION

Supported values:

* `native` for [OrcFileFormat](datasources/orc/OrcFileFormat.md)
* `hive` for `org.apache.spark.sql.hive.orc.OrcFileFormat`

## <span id="parallelFileListingInStatsComputation"> parallelFileListingInStatsComputation

[spark.sql.statistics.parallelFileListingInStatsComputation.enabled](configuration-properties.md#spark.sql.statistics.parallelFileListingInStatsComputation.enabled)

Used when `CommandUtils` helper object is requested to [calculate the total size of a table (with partitions)](CommandUtils.md#calculateTotalSize) (for [AnalyzeColumnCommand](logical-operators/AnalyzeColumnCommand.md) and [AnalyzeTableCommand](logical-operators/AnalyzeTableCommand.md) commands)

## <span id="parquetFilterPushDown"> parquetFilterPushDown

[spark.sql.parquet.filterPushdown](configuration-properties.md#spark.sql.parquet.filterPushdown)

Used when `ParquetFileFormat` is requested to [build a data reader with partition column values appended](datasources/parquet/ParquetFileFormat.md#buildReaderWithPartitionValues).

## <span id="parquetFilterPushDownDate"> parquetFilterPushDownDate

[spark.sql.parquet.filterPushdown.date](configuration-properties.md#spark.sql.parquet.filterPushdown.date)

Used when `ParquetFileFormat` is requested to [build a data reader with partition column values appended](datasources/parquet/ParquetFileFormat.md#buildReaderWithPartitionValues).

## <span id="parquetRecordFilterEnabled"> parquetRecordFilterEnabled

[spark.sql.parquet.recordLevelFilter.enabled](configuration-properties.md#spark.sql.parquet.recordLevelFilter.enabled)

Used when `ParquetFileFormat` is requested to [build a data reader with partition column values appended](datasources/parquet/ParquetFileFormat.md#buildReaderWithPartitionValues).

## <span id="parquetVectorizedReaderBatchSize"> parquetVectorizedReaderBatchSize

[spark.sql.parquet.columnarReaderBatchSize](configuration-properties.md#spark.sql.parquet.columnarReaderBatchSize)

Used when `ParquetFileFormat` is requested for a [data reader](datasources/parquet/ParquetFileFormat.md#buildReaderWithPartitionValues) (and creates a [VectorizedParquetRecordReader](datasources/parquet/VectorizedParquetRecordReader.md) for [Vectorized Parquet Decoding](vectorized-parquet-reader.md))

## <span id="parquetVectorizedReaderEnabled"> parquetVectorizedReaderEnabled

[spark.sql.parquet.enableVectorizedReader](configuration-properties.md#spark.sql.parquet.enableVectorizedReader)

Used when:

* `FileSourceScanExec` is requested for [needsUnsafeRowConversion](physical-operators/FileSourceScanExec.md#needsUnsafeRowConversion) flag
* `ParquetFileFormat` is requested for [supportBatch](datasources/parquet/ParquetFileFormat.md#supportBatch) flag and [build a data reader with partition column values appended](datasources/parquet/ParquetFileFormat.md#buildReaderWithPartitionValues)

## <span id="partitionOverwriteMode"><span id="PARTITION_OVERWRITE_MODE"> partitionOverwriteMode

The value of [spark.sql.sources.partitionOverwriteMode](configuration-properties.md#spark.sql.sources.partitionOverwriteMode) configuration property

Used when [InsertIntoHadoopFsRelationCommand](logical-operators/InsertIntoHadoopFsRelationCommand.md) logical command is executed

## <span id="preferSortMergeJoin"> preferSortMergeJoin

[spark.sql.join.preferSortMergeJoin](configuration-properties.md#spark.sql.join.preferSortMergeJoin)

Used in [JoinSelection](execution-planning-strategies/JoinSelection.md) execution planning strategy to prefer sort merge join over shuffle hash join.

## <span id="replaceDatabricksSparkAvroEnabled"><span id="LEGACY_REPLACE_DATABRICKS_SPARK_AVRO_ENABLED"> replaceDatabricksSparkAvroEnabled

[spark.sql.legacy.replaceDatabricksSparkAvro.enabled](configuration-properties.md#spark.sql.legacy.replaceDatabricksSparkAvro.enabled)

## <span id="replaceExceptWithFilter"><span id="REPLACE_EXCEPT_WITH_FILTER"> replaceExceptWithFilter

[spark.sql.optimizer.replaceExceptWithFilter](configuration-properties.md#spark.sql.optimizer.replaceExceptWithFilter)

Used when [ReplaceExceptWithFilter](logical-optimizations/ReplaceExceptWithFilter.md) logical optimization is executed

## <span id="runSQLonFile"> runSQLonFile

[spark.sql.runSQLOnFiles](configuration-properties.md#spark.sql.runSQLOnFiles)

Used when:

* `ResolveRelations` is requested to [isRunningDirectlyOnFiles](logical-analysis-rules/ResolveRelations.md#isRunningDirectlyOnFiles)
* `ResolveSQLOnFile` is requested to [maybeSQLFile](logical-analysis-rules/ResolveSQLOnFile.md#maybeSQLFile)

## <span id="sessionLocalTimeZone"> sessionLocalTimeZone

The value of [spark.sql.session.timeZone](configuration-properties.md#spark.sql.session.timeZone) configuration property

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

## <span id="supportQuotedRegexColumnName"> supportQuotedRegexColumnName

[spark.sql.parser.quotedRegexColumnNames](configuration-properties.md#spark.sql.parser.quotedRegexColumnNames)

Used when:

* [Dataset.col](Dataset-untyped-transformations.md#col) operator is used
* `AstBuilder` is requested to parse a [dereference](sql/AstBuilder.md#visitDereference) and [column reference](sql/AstBuilder.md#visitColumnReference) in a SQL statement

## <span id="targetPostShuffleInputSize"> targetPostShuffleInputSize

[spark.sql.adaptive.shuffle.targetPostShuffleInputSize](configuration-properties.md#spark.sql.adaptive.shuffle.targetPostShuffleInputSize)

Used when [EnsureRequirements](physical-optimizations/EnsureRequirements.md) physical optimization is executed (for [Adaptive Query Execution](new-and-noteworthy/adaptive-query-execution.md))

## <span id="truncateTableIgnorePermissionAcl"><span id="TRUNCATE_TABLE_IGNORE_PERMISSION_ACL"> truncateTableIgnorePermissionAcl

[spark.sql.truncateTable.ignorePermissionAcl.enabled](configuration-properties.md#spark.sql.truncateTable.ignorePermissionAcl.enabled)

Used when [TruncateTableCommand](logical-operators/TruncateTableCommand.md) logical command is executed

## <span id="useCompression"><span id="COMPRESS_CACHED"> useCompression

The value of [spark.sql.inMemoryColumnarStorage.compressed](configuration-properties.md#spark.sql.inMemoryColumnarStorage.compressed) configuration property

Used when `CacheManager` is requested to [cache a structured query](CacheManager.md#cacheQuery)

## <span id="useObjectHashAggregation"> useObjectHashAggregation

[spark.sql.execution.useObjectHashAggregateExec](configuration-properties.md#spark.sql.execution.useObjectHashAggregateExec)

Used when [Aggregation](execution-planning-strategies/Aggregation.md) execution planning strategy is executed (and uses `AggUtils` to [create an aggregation physical operator](AggUtils.md#createAggregate)).

## <span id="wholeStageEnabled"> wholeStageEnabled

[spark.sql.codegen.wholeStage](configuration-properties.md#spark.sql.codegen.wholeStage)

Used in:

* [CollapseCodegenStages](physical-optimizations/CollapseCodegenStages.md) to control codegen
* [ParquetFileFormat](datasources/parquet/ParquetFileFormat.md) to control row batch reading

## <span id="wholeStageFallback"> wholeStageFallback

[spark.sql.codegen.fallback](configuration-properties.md#spark.sql.codegen.fallback)

Used when [WholeStageCodegenExec](physical-operators/WholeStageCodegenExec.md) physical operator is executed.

## <span id="wholeStageMaxNumFields"> wholeStageMaxNumFields

[spark.sql.codegen.maxFields](configuration-properties.md#spark.sql.codegen.maxFields)

Used in:

* [CollapseCodegenStages](physical-optimizations/CollapseCodegenStages.md) to control codegen
* [ParquetFileFormat](datasources/parquet/ParquetFileFormat.md) to control row batch reading

## <span id="wholeStageSplitConsumeFuncByOperator"> wholeStageSplitConsumeFuncByOperator

[spark.sql.codegen.splitConsumeFuncByOperator](configuration-properties.md#spark.sql.codegen.splitConsumeFuncByOperator)

Used when `CodegenSupport` is requested to [consume](physical-operators/CodegenSupport.md#consume)

## <span id="wholeStageUseIdInClassName"> wholeStageUseIdInClassName

[spark.sql.codegen.useIdInClassName](configuration-properties.md#spark.sql.codegen.useIdInClassName)

Used when `WholeStageCodegenExec` is requested to [generate the Java source code for the child physical plan subtree](physical-operators/WholeStageCodegenExec.md#doCodeGen) (when [created](physical-operators/WholeStageCodegenExec.md#creating-instance))

## <span id="windowExecBufferInMemoryThreshold"> windowExecBufferInMemoryThreshold

[spark.sql.windowExec.buffer.in.memory.threshold](configuration-properties.md#spark.sql.windowExec.buffer.in.memory.threshold)

Used when [WindowExec](physical-operators/WindowExec.md) unary physical operator is executed

## <span id="windowExecBufferSpillThreshold"> windowExecBufferSpillThreshold

[spark.sql.windowExec.buffer.spill.threshold](configuration-properties.md#spark.sql.windowExec.buffer.spill.threshold)

Used when [WindowExec](physical-operators/WindowExec.md) unary physical operator is executed
