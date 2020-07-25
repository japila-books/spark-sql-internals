# Configuration Properties

<<properties, Configuration properties>> (aka _settings_) allow you to fine-tune a Spark SQL application.

You can set a configuration property in a link:SparkSession.md[SparkSession] while creating a new instance using link:SparkSession-Builder.md#config[config] method.

[source, scala]
----
import org.apache.spark.sql.SparkSession
val spark: SparkSession = SparkSession.builder
  .master("local[*]")
  .appName("My Spark Application")
  .config("spark.sql.warehouse.dir", "c:/Temp") // <1>
  .getOrCreate
----
<1> Sets link:spark-sql-StaticSQLConf.adoc#spark.sql.warehouse.dir[spark.sql.warehouse.dir] for the Spark SQL session

You can also set a property using SQL `SET` command.

[source, scala]
----
scala> spark.conf.getOption("spark.sql.hive.metastore.version")
res1: Option[String] = None

scala> spark.sql("SET spark.sql.hive.metastore.version=2.3.2").show(truncate = false)
+--------------------------------+-----+
|key                             |value|
+--------------------------------+-----+
|spark.sql.hive.metastore.version|2.3.2|
+--------------------------------+-----+

scala> spark.conf.get("spark.sql.hive.metastore.version")
res2: String = 2.3.2
----

[[properties]]
.Spark SQL Configuration Properties
[cols="a", options="header",width="100%"]
|===
| Configuration Property

| [[spark.sql.adaptive.minNumPostShufflePartitions]] *spark.sql.adaptive.minNumPostShufflePartitions*

*(internal)* The advisory minimal number of post-shuffle partitions for <<spark-sql-ExchangeCoordinator.adoc#minNumPostShufflePartitions, ExchangeCoordinator>>.

Default: `-1`

This setting is used in Spark SQL tests to have enough parallelism to expose issues that will not be exposed with a single partition. Only positive values are used.

Use [SQLConf.minNumPostShufflePartitions](SQLConf.md#minNumPostShufflePartitions) method to access the current value.

| [[spark.sql.adaptive.shuffle.targetPostShuffleInputSize]] *spark.sql.adaptive.shuffle.targetPostShuffleInputSize*

Recommended size of the input data of a post-shuffle partition (in bytes)

Default: `64 * 1024 * 1024` bytes

Use [SQLConf.targetPostShuffleInputSize](SQLConf.md#targetPostShuffleInputSize) method to access the current value.

| [[spark.sql.allowMultipleContexts]] *spark.sql.allowMultipleContexts*

Controls whether creating multiple SQLContexts/HiveContexts is allowed (`true`) or not (`false`)

Default: `true`

| [[spark.sql.autoBroadcastJoinThreshold]] *spark.sql.autoBroadcastJoinThreshold*

Maximum size (in bytes) for a table that will be broadcast to all worker nodes when performing a join.

Default: `10L * 1024 * 1024` (10M)

If the size of the statistics of the logical plan of a table is at most the setting, the DataFrame is broadcast for join.

Negative values or `0` disable broadcasting.

Use [SQLConf.autoBroadcastJoinThreshold](SQLConf.md#autoBroadcastJoinThreshold) method to access the current value.

| [[spark.sql.avro.compression.codec]] *spark.sql.avro.compression.codec*

The compression codec to use when writing Avro data to disk

Default: `snappy`

The supported codecs are:

* `uncompressed`
* `deflate`
* `snappy`
* `bzip2`
* `xz`

Use [SQLConf.avroCompressionCodec](SQLConf.md#avroCompressionCodec) method to access the current value.

| [[spark.sql.broadcastTimeout]] *spark.sql.broadcastTimeout*

Timeout in seconds for the broadcast wait time in broadcast joins.

Default: `5 * 60`

When negative, it is assumed infinite (i.e. `Duration.Inf`)

Use [SQLConf.broadcastTimeout](SQLConf.md#broadcastTimeout) method to access the current value.

| [[spark.sql.caseSensitive]] *spark.sql.caseSensitive*

*(internal)* Controls whether the query analyzer should be case sensitive (`true`) or not (`false`).

Default: `false`

It is highly discouraged to turn on case sensitive mode.

Use [SQLConf.caseSensitiveAnalysis](SQLConf.md#caseSensitiveAnalysis) method to access the current value.

| [[spark.sql.cbo.enabled]] *spark.sql.cbo.enabled*

Enables [Cost-Based Optimization](spark-sql-cost-based-optimization.md) (CBO) for estimation of plan statistics when `true`.

Default: `false`

Use [SQLConf.cboEnabled](SQLConf.md#cboEnabled) method to access the current value.

| [[spark.sql.cbo.joinReorder.enabled]] *spark.sql.cbo.joinReorder.enabled*

Enables join reorder for cost-based optimization (CBO).

Default: `false`

Use [SQLConf.joinReorderEnabled](SQLConf.md#joinReorderEnabled) method to access the current value.

| [[spark.sql.cbo.starSchemaDetection]] *spark.sql.cbo.starSchemaDetection*

Enables *join reordering* based on star schema detection for cost-based optimization (CBO) in link:spark-sql-Optimizer-ReorderJoin.adoc[ReorderJoin] logical plan optimization.

Default: `false`

Use [SQLConf.starSchemaDetection](SQLConf.md#starSchemaDetection) method to access the current value.

| [[spark.sql.codegen.comments]] *spark.sql.codegen.comments*

Controls whether `CodegenContext` should link:spark-sql-CodegenSupport.adoc#registerComment[register comments] (`true`) or not (`false`).

Default: `false`

| [[spark.sql.codegen.factoryMode]] *spark.sql.codegen.factoryMode*

*(internal)* Determines the codegen generator fallback behavior

Default: `FALLBACK`

Acceptable values:

* [[spark.sql.codegen.factoryMode-CODEGEN_ONLY]] `CODEGEN_ONLY` - disable fallback mode
* [[spark.sql.codegen.factoryMode-FALLBACK]] `FALLBACK` - try codegen first and, if any compile error happens, fallback to interpreted mode
* [[spark.sql.codegen.factoryMode-NO_CODEGEN]] `NO_CODEGEN` - skips codegen and always uses interpreted path

Used when `CodeGeneratorWithInterpretedFallback` is requested to <<spark-sql-CodeGeneratorWithInterpretedFallback.adoc#createObject, createObject>> (when `UnsafeProjection` is requested to <<spark-sql-UnsafeProjection.adoc#create, create an UnsafeProjection for Catalyst expressions>>)

| [[spark.sql.codegen.fallback]] *spark.sql.codegen.fallback*

*(internal)* Whether the whole stage codegen could be temporary disabled for the part of a query that has failed to compile generated code (`true`) or not (`false`).

Default: `true`

Use [SQLConf.wholeStageFallback](SQLConf.md#wholeStageFallback) method to access the current value.

| [[spark.sql.codegen.hugeMethodLimit]] *spark.sql.codegen.hugeMethodLimit*

*(internal)* The maximum bytecode size of a single compiled Java function generated by whole-stage codegen.

Default: `65535`

The default value `65535` is the largest bytecode size possible for a valid Java method. When running on HotSpot, it may be preferable to set the value to `8000` (which is the value of `HugeMethodLimit` in the OpenJDK JVM settings)

Use [SQLConf.hugeMethodLimit](SQLConf.md#hugeMethodLimit) method to access the current value.

| [[spark.sql.codegen.useIdInClassName]] *spark.sql.codegen.useIdInClassName*

*(internal)* Controls whether to embed the (whole-stage) codegen stage ID into the class name of the generated class as a suffix (`true`) or not (`false`)

Default: `true`

Use [SQLConf.wholeStageUseIdInClassName](SQLConf.md#wholeStageUseIdInClassName) method to access the current value.

| [[spark.sql.codegen.maxFields]] *spark.sql.codegen.maxFields*

*(internal)* Maximum number of output fields (including nested fields) that whole-stage codegen supports. Going above the number deactivates whole-stage codegen.

Default: `100`

Use [SQLConf.wholeStageMaxNumFields](SQLConf.md#wholeStageMaxNumFields) method to access the current value.

| [[spark.sql.codegen.splitConsumeFuncByOperator]] *spark.sql.codegen.splitConsumeFuncByOperator*

*(internal)* Controls whether whole stage codegen puts the logic of consuming rows of each physical operator into individual methods, instead of a single big method. This can be used to avoid oversized function that can miss the opportunity of JIT optimization.

Default: `true`

Use [SQLConf.wholeStageSplitConsumeFuncByOperator](SQLConf.md#wholeStageSplitConsumeFuncByOperator) method to access the current value.

| [[spark.sql.codegen.wholeStage]] *spark.sql.codegen.wholeStage*

*(internal)* Whether the whole stage (of multiple physical operators) will be compiled into a single Java method (`true`) or not (`false`).

Default: `true`

Use [SQLConf.wholeStageEnabled](SQLConf.md#wholeStageEnabled) method to access the current value.

| [[spark.sql.columnVector.offheap.enabled]] *spark.sql.columnVector.offheap.enabled*

*(internal)* Enables link:spark-sql-OffHeapColumnVector.adoc[OffHeapColumnVector] in link:spark-sql-ColumnarBatch.adoc[ColumnarBatch] (`true`) or not (`false`). When `false`, link:spark-sql-OnHeapColumnVector.adoc[OnHeapColumnVector] is used instead.

Default: `false`

Use [SQLConf.offHeapColumnVectorEnabled](SQLConf.md#offHeapColumnVectorEnabled) method to access the current value.

| [[spark.sql.columnNameOfCorruptRecord]] *spark.sql.columnNameOfCorruptRecord*

| [[spark.sql.constraintPropagation.enabled]] *spark.sql.constraintPropagation.enabled*

*(internal)* When true, the query optimizer will infer and propagate data constraints in the query plan to optimize them. Constraint propagation can sometimes be computationally expensive for certain kinds of query plans (such as those with a large number of predicates and aliases) which might negatively impact overall runtime.

Default: `true`

Use [SQLConf.constraintPropagationEnabled](SQLConf.md#constraintPropagationEnabled) method to access the current value.

| [[spark.sql.defaultSizeInBytes]] *spark.sql.defaultSizeInBytes*

*(internal)* Estimated size of a table or relation used in query planning

Default: Java's `Long.MaxValue`

Set to Java's `Long.MaxValue` which is larger than <<spark.sql.autoBroadcastJoinThreshold, spark.sql.autoBroadcastJoinThreshold>> to be more conservative. That is to say by default the optimizer will not choose to broadcast a table unless it knows for sure that the table size is small enough.

Used by the planner to decide when it is safe to broadcast a relation. By default, the system will assume that tables are too large to broadcast.

Use [SQLConf.defaultSizeInBytes](SQLConf.md#defaultSizeInBytes) method to access the current value.

| [[spark.sql.dialect]] *spark.sql.dialect*

| [[spark.sql.exchange.reuse]] *spark.sql.exchange.reuse*

*(internal)* When enabled (i.e. `true`), the link:spark-sql-SparkPlanner.adoc[Spark planner] will find duplicated exchanges and subqueries and re-use them.

Default: `true`

NOTE: When disabled (i.e. `false`), link:spark-sql-ReuseSubquery.adoc[ReuseSubquery] and link:spark-sql-ReuseExchange.adoc[ReuseExchange] physical optimizations (that the Spark planner uses for physical query plan optimization) do nothing.

Use [SQLConf.exchangeReuseEnabled](SQLConf.md#exchangeReuseEnabled) method to access the current value.

a| [[spark.sql.execution.useObjectHashAggregateExec]] *spark.sql.execution.useObjectHashAggregateExec*

Enables link:spark-sql-SparkPlan-ObjectHashAggregateExec.adoc[ObjectHashAggregateExec] when [Aggregation](execution-planning-strategies/Aggregation.md) execution planning strategy is executed.

Default: `true`

Use [SQLConf.useObjectHashAggregation](SQLConf.md#useObjectHashAggregation) method to access the current value.

| [[spark.sql.files.ignoreCorruptFiles]] *spark.sql.files.ignoreCorruptFiles*

Controls whether to ignore corrupt files (`true`) or not (`false`). If `true`, the Spark jobs will continue to run when encountering corrupted files and the contents that have been read will still be returned.

Default: `false`

Use [SQLConf.ignoreCorruptFiles](SQLConf.md#ignoreCorruptFiles) method to access the current value.

a| [[spark.sql.files.ignoreMissingFiles]] *spark.sql.files.ignoreMissingFiles*

Controls whether to ignore missing files (`true`) or not (`false`). If `true`, the Spark jobs will continue to run when encountering missing files and the contents that have been read will still be returned.

Default: `false`

Use [SQLConf.ignoreMissingFiles](SQLConf.md#ignoreMissingFiles) method to access the current value.

| [[spark.sql.files.maxPartitionBytes]] *spark.sql.files.maxPartitionBytes*

The maximum number of bytes to pack into a single partition when reading files.

Default: `128 * 1024 * 1024` (which corresponds to `parquet.block.size`)

Use [SQLConf.filesMaxPartitionBytes](SQLConf.md#filesMaxPartitionBytes) method to access the current value.

| [[spark.sql.files.openCostInBytes]] *spark.sql.files.openCostInBytes*

*(internal)* The estimated cost to open a file, measured by the number of bytes could be scanned at the same time (to include multiple files into a partition).

Default: `4 * 1024 * 1024`

It's better to over estimate it, then the partitions with small files will be faster than partitions with bigger files (which is scheduled first).

Use [SQLConf.filesOpenCostInBytes](SQLConf.md#filesOpenCostInBytes) method to access the current value.

| [[spark.sql.files.maxRecordsPerFile]] *spark.sql.files.maxRecordsPerFile*

Maximum number of records to write out to a single file. If this value is `0` or negative, there is no limit.

Default: `0`

Use [SQLConf.maxRecordsPerFile](SQLConf.md#maxRecordsPerFile) method to access the current value.

| [[spark.sql.inMemoryColumnarStorage.batchSize]] *spark.sql.inMemoryColumnarStorage.batchSize*

*(internal)* Controls...FIXME

Default: `10000`

Use [SQLConf.columnBatchSize](SQLConf.md#columnBatchSize) method to access the current value.

| [[spark.sql.inMemoryColumnarStorage.compressed]] *spark.sql.inMemoryColumnarStorage.compressed*

*(internal)* Controls...FIXME

Default: `true`

Use [SQLConf.useCompression](SQLConf.md#useCompression) method to access the current value.

| [[spark.sql.inMemoryColumnarStorage.enableVectorizedReader]] *spark.sql.inMemoryColumnarStorage.enableVectorizedReader*

Enables link:spark-sql-vectorized-query-execution.adoc[vectorized reader] for columnar caching.

Default: `true`

Use [SQLConf.cacheVectorizedReaderEnabled](SQLConf.md#cacheVectorizedReaderEnabled) method to access the current value.

| [[spark.sql.inMemoryColumnarStorage.partitionPruning]] *spark.sql.inMemoryColumnarStorage.partitionPruning*

*(internal)* Enables partition pruning for in-memory columnar tables

Default: `true`

Use [SQLConf.inMemoryPartitionPruning](SQLConf.md#inMemoryPartitionPruning) method to access the current value.

| [[spark.sql.join.preferSortMergeJoin]] *spark.sql.join.preferSortMergeJoin*

*(internal)* Controls whether [JoinSelection](execution-planning-strategies/JoinSelection.md) execution planning strategy prefers [sort merge join](physical-operators/SortMergeJoinExec.md) over [shuffled hash join](physical-operators/ShuffledHashJoinExec.md).

Default: `true`

Use [SQLConf.preferSortMergeJoin](SQLConf.md#preferSortMergeJoin) method to access the current value.

| [[spark.sql.legacy.rdd.applyConf]] *spark.sql.legacy.rdd.applyConf*

*(internal)* Enables propagation of [SQL configurations](SQLConf.md#getAllConfs) when executing operations on the xref:spark-sql-QueryExecution.adoc#toRdd[RDD that represents a structured query]. This is the (buggy) behavior up to 2.4.4.

Default: `true`

This is for cases not tracked by xref:spark-sql-SQLExecution.adoc[SQL execution], when a `Dataset` is converted to an RDD either using xref:spark-sql-Dataset.adoc#rdd[rdd] operation or xref:spark-sql-QueryExecution.adoc#toRdd[QueryExecution], and then the returned RDD is used to invoke actions on it.

This config is deprecated and will be removed in 3.0.0.

| [[spark.sql.legacy.replaceDatabricksSparkAvro.enabled]] *spark.sql.legacy.replaceDatabricksSparkAvro.enabled*

Enables resolving (_mapping_) the data source provider `com.databricks.spark.avro` to the built-in (but external) Avro data source module for backward compatibility.

Default: `true`

Use [SQLConf.replaceDatabricksSparkAvroEnabled](SQLConf.md#replaceDatabricksSparkAvroEnabled) method to access the current value.

| [[spark.sql.limit.scaleUpFactor]] *spark.sql.limit.scaleUpFactor*

*(internal)* Minimal increase rate in the number of partitions between attempts when executing `take` operator on a structured query. Higher values lead to more partitions read. Lower values might lead to longer execution times as more jobs will be run.

Default: `4`

Use [SQLConf.limitScaleUpFactor](SQLConf.md#limitScaleUpFactor) method to access the current value.

| [[spark.sql.optimizer.excludedRules]] *spark.sql.optimizer.excludedRules*

Comma-separated list of optimization rule names that should be disabled (excluded) in the <<spark-sql-Optimizer.adoc#spark.sql.optimizer.excludedRules, optimizer>>. The optimizer will log the rules that have indeed been excluded.

Default: `(empty)`

NOTE: It is not guaranteed that all the rules in this configuration will eventually be excluded, as some rules are necessary for correctness.

Use [SQLConf.optimizerExcludedRules](SQLConf.md#optimizerExcludedRules) method to access the current value.

| [[spark.sql.optimizer.inSetConversionThreshold]] *spark.sql.optimizer.inSetConversionThreshold*

*(internal)* The threshold of set size for `InSet` conversion.

Default: `10`

Use [SQLConf.optimizerInSetConversionThreshold](SQLConf.md#optimizerInSetConversionThreshold) method to access the current value.

| [[spark.sql.optimizer.maxIterations]] *spark.sql.optimizer.maxIterations*

Maximum number of iterations for link:spark-sql-Analyzer.adoc#fixedPoint[Analyzer] and  link:spark-sql-Optimizer.adoc#fixedPoint[Optimizer].

Default: `100`

| [[spark.sql.optimizer.replaceExceptWithFilter]] *spark.sql.optimizer.replaceExceptWithFilter*

*(internal)* When `true`, the apply function of the rule verifies whether the right node of the except operation is of type Filter or Project followed by Filter. If yes, the rule further verifies 1) Excluding the filter operations from the right (as well as the left node, if any) on the top, whether both the nodes evaluates to a same result. 2) The left and right nodes don't contain any SubqueryExpressions. 3) The output column names of the left node are distinct. If all the conditions are met, the rule will replace the except operation with a Filter by flipping the filter condition(s) of the right node.

Default: `true`

| [[spark.sql.orc.impl]] *spark.sql.orc.impl*

*(internal)* When `native`, use the native version of ORC support instead of the ORC library in Hive 1.2.1.

Default: `native`

Acceptable values:

* `hive`
* `native`

| [[spark.sql.parquet.binaryAsString]] *spark.sql.parquet.binaryAsString*

Some other Parquet-producing systems, in particular Impala and older versions of Spark SQL, do not differentiate between binary data and strings when writing out the Parquet schema. This flag tells Spark SQL to interpret binary data as a string to provide compatibility with these systems.

Default: `false`

Use [SQLConf.isParquetBinaryAsString](SQLConf.md#isParquetBinaryAsString) method to access the current value.

| [[spark.sql.parquet.columnarReaderBatchSize]] *spark.sql.parquet.columnarReaderBatchSize*

The number of rows to include in a parquet vectorized reader batch (the capacity of <<spark-sql-VectorizedParquetRecordReader.adoc#, VectorizedParquetRecordReader>>).

Default: `4096` (4k)

The number should be carefully chosen to minimize overhead and avoid OOMs while reading data.

Use [SQLConf.parquetVectorizedReaderBatchSize](SQLConf.md#parquetVectorizedReaderBatchSize) method to access the current value.

| [[spark.sql.parquet.int96AsTimestamp]] *spark.sql.parquet.int96AsTimestamp*

Some Parquet-producing systems, in particular Impala, store Timestamp into INT96. Spark would also store Timestamp as INT96 because we need to avoid precision lost of the nanoseconds field. This flag tells Spark SQL to interpret INT96 data as a timestamp to provide compatibility with these systems.

Default: `true`

Use [SQLConf.isParquetINT96AsTimestamp](SQLConf.md#isParquetINT96AsTimestamp) method to access the current value.

| [[spark.sql.parquet.enableVectorizedReader]] *spark.sql.parquet.enableVectorizedReader*

Enables link:spark-sql-vectorized-parquet-reader.adoc[vectorized parquet decoding].

Default: `true`

Use [SQLConf.parquetVectorizedReaderEnabled](SQLConf.md#parquetVectorizedReaderEnabled) method to access the current value.

| [[spark.sql.parquet.filterPushdown]] *spark.sql.parquet.filterPushdown*

Controls the link:spark-sql-Optimizer-PushDownPredicate.adoc[filter predicate push-down optimization] for data sources using link:spark-sql-ParquetFileFormat.adoc[parquet] file format

Default: `true`

Use [SQLConf.parquetFilterPushDown](SQLConf.md#parquetFilterPushDown) method to access the current value.

| [[spark.sql.parquet.filterPushdown.date]] *spark.sql.parquet.filterPushdown.date*

*(internal)* Enables parquet filter push-down optimization for Date (when <<spark.sql.parquet.filterPushdown, spark.sql.parquet.filterPushdown>> is enabled)

Default: `true`

Use [SQLConf.parquetFilterPushDownDate](SQLConf.md#parquetFilterPushDownDate) method to access the current value.

| [[spark.sql.parquet.int96TimestampConversion]] *spark.sql.parquet.int96TimestampConversion*

Controls whether timestamp adjustments should be applied to INT96 data when converting to timestamps, for data written by Impala.

Default: `false`

This is necessary because Impala stores INT96 data with a different timezone offset than Hive and Spark.

Use [SQLConf.isParquetINT96TimestampConversion](SQLConf.md#isParquetINT96TimestampConversion) method to access the current value.

| [[spark.sql.parquet.recordLevelFilter.enabled]] *spark.sql.parquet.recordLevelFilter.enabled*

Enables Parquet's native record-level filtering using the pushed down filters.

Default: `false`

NOTE: This configuration only has an effect when <<spark.sql.parquet.filterPushdown, spark.sql.parquet.filterPushdown>> is enabled (and it is by default).

Use [SQLConf.parquetRecordFilterEnabled](SQLConf.md#parquetRecordFilterEnabled) method to access the current value.

| [[spark.sql.parser.quotedRegexColumnNames]] *spark.sql.parser.quotedRegexColumnNames*

Controls whether quoted identifiers (using backticks) in SELECT statements should be interpreted as regular expressions.

Default: `false`

Use [SQLConf.supportQuotedRegexColumnName](SQLConf.md#supportQuotedRegexColumnName) method to access the current value.

| [[spark.sql.sort.enableRadixSort]] *spark.sql.sort.enableRadixSort*

*(internal)* Controls whether to use radix sort (`true`) or not (`false`) in <<spark-sql-SparkPlan-ShuffleExchangeExec.adoc#, ShuffleExchangeExec>> and <<spark-sql-SparkPlan-SortExec.adoc#, SortExec>> physical operators

Default: `true`

Radix sort is much faster but requires additional memory to be reserved up-front. The memory overhead may be significant when sorting very small rows (up to 50% more).

Use [SQLConf.enableRadixSort](SQLConf.md#enableRadixSort) method to access the current value.

| [[spark.sql.sources.commitProtocolClass]] *spark.sql.sources.commitProtocolClass*

*(internal)* Fully-qualified class name of the `FileCommitProtocol` to use for...FIXME

Default: <<spark-sql-SQLHadoopMapReduceCommitProtocol.adoc#, SQLHadoopMapReduceCommitProtocol>>

Use [SQLConf.fileCommitProtocolClass](SQLConf.md#fileCommitProtocolClass) method to access the current value.

| [[spark.sql.sources.partitionOverwriteMode]] *spark.sql.sources.partitionOverwriteMode*

Enables <<spark-sql-dynamic-partition-inserts.adoc#, dynamic partition inserts>> when <<spark.sql.sources.partitionOverwriteMode-dynamic, dynamic>>

Default: `static`

When `INSERT OVERWRITE` a partitioned data source table with dynamic partition columns, Spark SQL supports two modes (case-insensitive):

* [[spark.sql.sources.partitionOverwriteMode-static]] *static* - Spark deletes all the partitions that match the partition specification (e.g. `PARTITION(a=1,b)`) in the INSERT statement, before overwriting

* [[spark.sql.sources.partitionOverwriteMode-dynamic]] *dynamic* - Spark doesn't delete partitions ahead, and only overwrites those partitions that have data written into it

The default (<<spark.sql.sources.partitionOverwriteMode-static, STATIC>>) is to keep the same behavior of Spark prior to 2.3. Note that this config doesn't affect Hive serde tables, as they are always overwritten with dynamic mode.

Use [SQLConf.partitionOverwriteMode](SQLConf.md#partitionOverwriteMode) method to access the current value.

| [[spark.sql.pivotMaxValues]] *spark.sql.pivotMaxValues*

Maximum number of (distinct) values that will be collected without error (when doing a link:spark-sql-RelationalGroupedDataset.adoc#pivot[pivot] without specifying the values for the pivot column)

Default: `10000`

Use [SQLConf.dataFramePivotMaxValues](SQLConf.md#dataFramePivotMaxValues) method to access the current value.

| [[spark.sql.redaction.options.regex]] *spark.sql.redaction.options.regex*

Regular expression to find options of a Spark SQL command with sensitive information

Default: `(?i)secret!password`

The values of the options matched will be redacted in the explain output.

This redaction is applied on top of the global redaction configuration defined by `spark.redaction.regex` configuration.

Used exclusively when `SQLConf` is requested to [redactOptions](SQLConf.md#redactOptions).

| [[spark.sql.redaction.string.regex]] *spark.sql.redaction.string.regex*

Regular expression to point at sensitive information in text output

Default: `(undefined)`

When this regex matches a string part, it is replaced by a dummy value (i.e. `*********(redacted)`). This is currently used to redact the output of SQL explain commands.

NOTE: When this conf is not set, the value of `spark.redaction.string.regex` is used instead.

Use [SQLConf.stringRedactionPattern](SQLConf.md#stringRedactionPattern) method to access the current value.

| [[spark.sql.retainGroupColumns]] *spark.sql.retainGroupColumns*

Controls whether to retain columns used for aggregation or not (in link:spark-sql-RelationalGroupedDataset.adoc[RelationalGroupedDataset] operators).

Default: `true`

Use [SQLConf.dataFrameRetainGroupColumns](SQLConf.md#dataFrameRetainGroupColumns) method to access the current value.

| [[spark.sql.runSQLOnFiles]] *spark.sql.runSQLOnFiles*

*(internal)* Controls whether Spark SQL could use `datasource`.`path` as a table in a SQL query.

Default: `true`

Use [SQLConf.runSQLonFile](SQLConf.md#runSQLonFile) method to access the current value.

| [[spark.sql.selfJoinAutoResolveAmbiguity]] *spark.sql.selfJoinAutoResolveAmbiguity*

Controls whether to resolve ambiguity in join conditions for link:spark-sql-joins.adoc#join[self-joins] automatically (`true`) or not (`false`)

Default: `true`

| [[spark.sql.session.timeZone]] *spark.sql.session.timeZone*

The ID of session-local timezone, e.g. "GMT", "America/Los_Angeles", etc.

Default: Java's `TimeZone.getDefault.getID`

Use [SQLConf.sessionLocalTimeZone](SQLConf.md#sessionLocalTimeZone) method to access the current value.

| [[spark.sql.shuffle.partitions]] *spark.sql.shuffle.partitions*

Number of partitions to use by default when shuffling data for joins or aggregations

Default: `200`

Corresponds to Apache Hive's https://cwiki.apache.org/confluence/display/Hive/Configuration+Properties#ConfigurationProperties-mapred.reduce.tasks[mapred.reduce.tasks] property that Spark considers deprecated.

Use [SQLConf.numShufflePartitions](SQLConf.md#numShufflePartitions) method to access the current value.

| [[spark.sql.sources.bucketing.enabled]] *spark.sql.sources.bucketing.enabled*

Enables link:spark-sql-bucketing.adoc[bucketing] support. When disabled (i.e. `false`), bucketed tables are considered regular (non-bucketed) tables.

Default: `true`

Use [SQLConf.bucketingEnabled](SQLConf.md#bucketingEnabled) method to access the current value.

| [[spark.sql.sources.default]] *spark.sql.sources.default*

Defines the default data source to use for [DataFrameReader](DataFrameReader.md).

Default: `parquet`

Used when:

* Reading (link:spark-sql-DataFrameWriter.adoc[DataFrameWriter]) or writing ([DataFrameReader](DataFrameReader.md)) datasets

* link:spark-sql-Catalog.adoc#createExternalTable[Creating external table from a path] (in `Catalog.createExternalTable`)

* Reading (`DataStreamReader`) or writing (`DataStreamWriter`) in Structured Streaming

| [[spark.sql.statistics.fallBackToHdfs]] *spark.sql.statistics.fallBackToHdfs*

Enables automatic calculation of table size statistic by falling back to HDFS if the table statistics are not available from table metadata.

Default: `false`

This can be useful in determining if a table is small enough for auto broadcast joins in query planning.

Use [SQLConf.fallBackToHdfsForStatsEnabled](SQLConf.md#fallBackToHdfsForStatsEnabled) method to access the current value.

| [[spark.sql.statistics.histogram.enabled]] *spark.sql.statistics.histogram.enabled*

Enables generating histograms when link:spark-sql-LogicalPlan-AnalyzeColumnCommand.adoc#computeColumnStats[computing column statistics]

Default: `false`

NOTE: Histograms can provide better estimation accuracy. Currently, Spark only supports equi-height histogram. Note that collecting histograms takes extra cost. For example, collecting column statistics usually takes only one table scan, but generating equi-height histogram will cause an extra table scan.

Use [SQLConf.histogramEnabled](SQLConf.md#histogramEnabled) method to access the current value.

| [[spark.sql.statistics.histogram.numBins]] *spark.sql.statistics.histogram.numBins*

*(internal)* The number of bins when generating histograms.

Default: `254`

NOTE: The number of bins must be greater than 1.

Use [SQLConf.histogramNumBins](SQLConf.md#histogramNumBins) method to access the current value.

| [[spark.sql.statistics.parallelFileListingInStatsComputation.enabled]] *spark.sql.statistics.parallelFileListingInStatsComputation.enabled*

*(internal)* Enables parallel file listing in SQL commands, e.g. `ANALYZE TABLE` (as opposed to single thread listing that can be particularly slow with tables with hundreds of partitions)

Default: `true`

Use [SQLConf.parallelFileListingInStatsComputation](SQLConf.md#parallelFileListingInStatsComputation) method to access the current value.

| [[spark.sql.statistics.ndv.maxError]] *spark.sql.statistics.ndv.maxError*

*(internal)* The maximum estimation error allowed in HyperLogLog++ algorithm when generating column level statistics.

Default: `0.05`

| [[spark.sql.statistics.percentile.accuracy]] *spark.sql.statistics.percentile.accuracy*

*(internal)* Accuracy of percentile approximation when generating equi-height histograms. Larger value means better accuracy. The relative error can be deduced by 1.0 / PERCENTILE_ACCURACY.

Default: `10000`

| [[spark.sql.statistics.size.autoUpdate.enabled]] *spark.sql.statistics.size.autoUpdate.enabled*

Enables automatic update of the table size statistic of a table after the table has changed.

Default: `false`

IMPORTANT: If the total number of files of the table is very large this can be expensive and slow down data change commands.

Use [SQLConf.autoSizeUpdateEnabled](SQLConf.md#autoSizeUpdateEnabled) method to access the current value.

| [[spark.sql.subexpressionElimination.enabled]] *spark.sql.subexpressionElimination.enabled*

*(internal)* Enables link:spark-sql-subexpression-elimination.adoc[subexpression elimination]

Default: `true`

Use [SQLConf.subexpressionEliminationEnabled](SQLConf.md#subexpressionEliminationEnabled) method to access the current value.

| [[spark.sql.truncateTable.ignorePermissionAcl.enabled]] *spark.sql.truncateTable.ignorePermissionAcl.enabled*

*(internal)* Disables setting back original permission and ACLs when re-creating the table/partition paths for xref:spark-sql-LogicalPlan-TruncateTableCommand.adoc[TRUNCATE TABLE] command.

Default: `false`

Use [SQLConf.truncateTableIgnorePermissionAcl](SQLConf.md#truncateTableIgnorePermissionAcl) method to access the current value.

| [[spark.sql.ui.retainedExecutions]] *spark.sql.ui.retainedExecutions*

The number of link:spark-sql-SQLListener.adoc#SQLExecutionUIData[SQLExecutionUIData] entries to keep in `failedExecutions` and `completedExecutions` internal registries.

Default: `1000`

When a query execution finishes, the execution is removed from the internal `activeExecutions` registry and stored in `failedExecutions` or `completedExecutions` given the end execution status. It is when `SQLListener` makes sure that the number of `SQLExecutionUIData` entires does not exceed `spark.sql.ui.retainedExecutions` Spark property and removes the excess of entries.

| [[spark.sql.windowExec.buffer.in.memory.threshold]] *spark.sql.windowExec.buffer.in.memory.threshold*

*(internal)* Threshold for number of rows guaranteed to be held in memory by <<spark-sql-SparkPlan-WindowExec.adoc#, WindowExec>> physical operator.

Default: `4096`

Use [SQLConf.windowExecBufferInMemoryThreshold](SQLConf.md#windowExecBufferInMemoryThreshold) method to access the current value.

| [[spark.sql.windowExec.buffer.spill.threshold]] *spark.sql.windowExec.buffer.spill.threshold*

*(internal)* Threshold for number of rows buffered in a <<spark-sql-SparkPlan-WindowExec.adoc#, WindowExec>> physical operator.

Default: `4096`

Use [SQLConf.windowExecBufferSpillThreshold](SQLConf.md#windowExecBufferSpillThreshold) method to access the current value.

|===

## <span id="spark.sql.adaptive.enabled"> spark.sql.adaptive.enabled

Enables [Adaptive Query Execution](spark-sql-adaptive-query-execution.md) (that re-optimizes the query plan in the middle of query execution, based on accurate runtime statistics).

Default: `false`

Since: 1.6.0

Use [SQLConf.adaptiveExecutionEnabled](SQLConf.md#adaptiveExecutionEnabled) method to access the current value.
