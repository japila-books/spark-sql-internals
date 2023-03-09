# StaticSQLConf &mdash; Static Configuration Properties

`StaticSQLConf` holds cross-session, immutable and static SQL configuration properties.

```text
assert(sc.isInstanceOf[org.apache.spark.SparkContext])

import org.apache.spark.sql.internal.StaticSQLConf
sc.getConf.get(StaticSQLConf.SPARK_SESSION_EXTENSIONS.key)
```

`StaticSQLConf` configuration properties can only be queried and can never be changed once the first `SparkSession` is created (unlike the regular [configuration properties](configuration-properties.md)).

```text
import org.apache.spark.sql.internal.StaticSQLConf
scala> val metastoreName = spark.conf.get(StaticSQLConf.CATALOG_IMPLEMENTATION.key)
metastoreName: String = hive

scala> spark.conf.set(StaticSQLConf.CATALOG_IMPLEMENTATION.key, "hive")
org.apache.spark.sql.AnalysisException: Cannot modify the value of a static config: spark.sql.catalogImplementation;
  at org.apache.spark.sql.RuntimeConfig.requireNonStaticConf(RuntimeConfig.scala:144)
  at org.apache.spark.sql.RuntimeConfig.set(RuntimeConfig.scala:41)
  ... 50 elided
```

## <span id="spark.sql.cache.serializer"><span id="SPARK_CACHE_SERIALIZER"> cache.serializer

[spark.sql.cache.serializer](configuration-properties.md#spark.sql.cache.serializer)

## <span id="spark.sql.codegen.cache.maxEntries"> codegen.cache.maxEntries

**spark.sql.codegen.cache.maxEntries**

**(internal)** When non-zero, enable caching of generated classes for operators and expressions. All jobs share the cache that can use up to the specified number for generated classes.

Default: `100`

Use [SQLConf.codegenCacheMaxEntries](StaticSQLConf.md#codegenCacheMaxEntries) to access the current value

Used when:

* `CodeGenerator` is loaded (and creates the [cache](whole-stage-code-generation/CodeGenerator.md#cache))

## <span id="spark.sql.broadcastExchange.maxThreadThreshold"><span id="BROADCAST_EXCHANGE_MAX_THREAD_THRESHOLD"> spark.sql.broadcastExchange.maxThreadThreshold

**(internal)** The maximum degree of parallelism to fetch and broadcast the table. If we encounter memory issue like frequently full GC or OOM when broadcast table we can decrease this number in order to reduce memory usage. Notice the number should be carefully chosen since decreasing parallelism might cause longer waiting for other broadcasting. Also, increasing parallelism may cause memory problem.

The threshold must be in (0,128]

Default: `128`

## <span id="spark.sql.catalogImplementation"><span id="CATALOG_IMPLEMENTATION"> spark.sql.catalogImplementation

**(internal)** Configures `in-memory` (default) or ``hive``-related [BaseSessionStateBuilder](BaseSessionStateBuilder.md) and [ExternalCatalog](ExternalCatalog.md)

[Builder.enableHiveSupport](SparkSession-Builder.md#enableHiveSupport) is used to enable [Hive support](hive/index.md) for a [SparkSession](SparkSession.md).

Used when:

* `SparkSession` utility is requested for the [name of the BaseSessionStateBuilder implementation](SparkSession.md#sessionStateClassName) (when `SparkSession` is requested for a [SessionState](SparkSession.md#sessionState))

* `SharedState` utility is requested for the [name of the ExternalCatalog implementation](SharedState.md#externalCatalogClassName) (when `SharedState` is requested for an [ExternalCatalog](SharedState.md#externalCatalog))

* `SparkSession.Builder` is requested to [enable Hive support](SparkSession-Builder.md#enableHiveSupport)

* `spark-shell` is executed

* `SetCommand` is executed (with `hive.` keys)

## <span id="spark.sql.debug"><span id="DEBUG_MODE"> spark.sql.debug

**(internal)** Only used for internal debugging when `HiveExternalCatalog` is requested to [restoreTableMetadata](hive/HiveExternalCatalog.md#restoreTableMetadata).

Default: `false`

Not all functions are supported when enabled.

## <span id="spark.sql.defaultUrlStreamHandlerFactory.enabled"><span id="DEFAULT_URL_STREAM_HANDLER_FACTORY_ENABLED"> spark.sql.defaultUrlStreamHandlerFactory.enabled

**(internal)** When true, register Hadoop's FsUrlStreamHandlerFactory to support ADD JAR against HDFS locations. It should be disabled when a different stream protocol handler should be registered to support a particular protocol type, or if Hadoop's FsUrlStreamHandlerFactory conflicts with other protocol types such as `http` or `https`. See also SPARK-25694 and HADOOP-14598.

Default: `true`

## <span id="spark.sql.event.truncate.length"><span id="SQL_EVENT_TRUNCATE_LENGTH"> spark.sql.event.truncate.length

Threshold of SQL length beyond which it will be truncated before adding to event. Defaults to no truncation. If set to 0, callsite will be logged instead.

Must be set greater or equal to zero.

Default: `Int.MaxValue`

## <span id="spark.sql.extensions"><span id="SPARK_SESSION_EXTENSIONS"> spark.sql.extensions

A comma-separated list of **SQL extension configuration classes** to configure [SparkSessionExtensions](SparkSessionExtensions.md):

1. The classes must implement `SparkSessionExtensions => Unit`
1. The classes must have a no-args constructor
1. If multiple extensions are specified, they are applied in the specified order.
1. For the case of rules and planner strategies, they are applied in the specified order.
1. For the case of parsers, the last parser is used and each parser can delegate to its predecessor
1. For the case of function name conflicts, the last registered function name is used

Default: `(empty)`

Used when:

* `SparkSession` utility is used to [apply SparkSessionExtensions](SparkSession.md#applyExtensions)

## <span id="spark.sql.filesourceTableRelationCacheSize"><span id="FILESOURCE_TABLE_RELATION_CACHE_SIZE"> spark.sql.filesourceTableRelationCacheSize

**(internal)** The maximum size of the cache that maps qualified table names to table relation plans. Must not be negative.

Default: `1000`

## <span id="spark.sql.globalTempDatabase"><span id="GLOBAL_TEMP_DATABASE"> spark.sql.globalTempDatabase

**(internal)** Name of the Spark-owned internal database of global temporary views

Default: `global_temp`

The name of the internal database cannot conflict with the names of any database that is already available in [ExternalCatalog](SharedState.md#externalCatalog).

Used to create a [GlobalTempViewManager](GlobalTempViewManager.md) when `SharedState` is first requested for [one](SharedState.md#globalTempViewManager).

## <span id="spark.sql.hive.thriftServer.singleSession"><span id="HIVE_THRIFT_SERVER_SINGLESESSION"> spark.sql.hive.thriftServer.singleSession

When enabled (`true`), Hive Thrift server is running in a single session mode. All the JDBC/ODBC connections share the temporary views, function registries, SQL configuration and the current database.

Default: `false`

## <span id="spark.sql.legacy.sessionInitWithConfigDefaults"><span id="SQL_LEGACY_SESSION_INIT_WITH_DEFAULTS"> spark.sql.legacy.sessionInitWithConfigDefaults

Flag to revert to legacy behavior where a cloned SparkSession receives SparkConf defaults, dropping any overrides in its parent SparkSession.

Default: `false`

## <span id="spark.sql.queryExecutionListeners"><span id="QUERY_EXECUTION_LISTENERS"> spark.sql.queryExecutionListeners

Class names of [QueryExecutionListener](QueryExecutionListener.md)s that will be automatically [registered](ExecutionListenerManager.md#register) (with new [SparkSession](SparkSession.md)s)

Default: (empty)

The classes should have either a no-arg constructor, or a constructor that expects a `SparkConf` argument.

## <span id="spark.sql.sources.schemaStringLengthThreshold"><span id="SCHEMA_STRING_LENGTH_THRESHOLD"> spark.sql.sources.schemaStringLengthThreshold

**(internal)** The maximum length allowed in a single cell when storing additional schema information in Hive's metastore

Default: `4000`

## <span id="spark.sql.streaming.ui.enabled"><span id="STREAMING_UI_ENABLED"> spark.sql.streaming.ui.enabled

Whether to run the Structured Streaming Web UI for the Spark application when the Spark Web UI is enabled.

Default: `true`

## <span id="spark.sql.streaming.ui.retainedProgressUpdates"><span id="STREAMING_UI_RETAINED_PROGRESS_UPDATES"> spark.sql.streaming.ui.retainedProgressUpdates

The number of progress updates to retain for a streaming query for Structured Streaming UI.

Default: `100`

## <span id="spark.sql.streaming.ui.retainedQueries"><span id="STREAMING_UI_RETAINED_QUERIES"> spark.sql.streaming.ui.retainedQueries

The number of inactive queries to retain for Structured Streaming UI.

Default: `100`

## <span id="spark.sql.ui.retainedExecutions"><span id="UI_RETAINED_EXECUTIONS"> spark.sql.ui.retainedExecutions

Number of executions to retain in the Spark UI.

Default: `1000`

## <span id="spark.sql.warehouse.dir"><span id="WAREHOUSE_PATH"> spark.sql.warehouse.dir

Directory of a Spark warehouse

Default: `spark-warehouse`
