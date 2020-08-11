# SharedState &mdash; State Shared Across SparkSessions

`SharedState` holds the state that can be shared across [SparkSessions](SparkSession.md):

* <span id="cacheManager"> [CacheManager](CacheManager.md)
* [ExternalCatalogWithListener](#externalCatalog)
* [GlobalTempViewManager](#globalTempViewManager)
* [Hadoop Configuration](#hadoopConf)
* <span id="jarClassLoader"> `NonClosableMutableURLClassLoader`
* [SparkConf](#conf)
* [SparkContext](#sparkContext)
* <span id="statusStore"> [SQLAppStatusStore](spark-sql-SQLAppStatusStore.md)
* `StreamingQueryStatusListener`

`SharedState` is shared when `SparkSession` is created using [SparkSession.newSession](SparkSession.md#newSession):

```scala
assert(spark.sharedState == spark.newSession.sharedState)
```

## Creating Instance

`SharedState` takes the following to be created:

* <span id="sparkContext"> `SparkContext`
* <span id="initialConfigs"> Initial configuration properties

`SharedState` is created for [SparkSession](SparkSession.md#sharedState) (and cached for later reuse).

## Accessing SharedState

`SharedState` is available using [SparkSession.sharedState](SparkSession.md#sharedState).

```scala
scala> :type spark
org.apache.spark.sql.SparkSession

scala> :type spark.sharedState
org.apache.spark.sql.internal.SharedState
```

## Shared SQL Services

### <span id="externalCatalog"> ExternalCatalog

```scala
externalCatalog: ExternalCatalog
```

[ExternalCatalog](ExternalCatalog.md) that is created reflectively based on [spark.sql.catalogImplementation](#externalCatalogClassName) internal configuration property:

* [HiveExternalCatalog](hive/HiveExternalCatalog.md) for `hive`
* [InMemoryCatalog](InMemoryCatalog.md) for `in-memory`

While initialized:

1. [Creates](ExternalCatalog.md#createDatabase) the *default* database (with `default database` description and [warehousePath](#warehousePath) location) unless [available already](ExternalCatalog.md#databaseExists).

1. [Registers](ExternalCatalog.md#addListener) a `ExternalCatalogEventListener` that propagates external catalog events to the Spark listener bus.

### <span id="globalTempViewManager"> GlobalTempViewManager

```scala
globalTempViewManager: GlobalTempViewManager
```

[GlobalTempViewManager](spark-sql-GlobalTempViewManager.md)

When accessed for the very first time, `globalTempViewManager` gets the name of the global temporary view database based on [spark.sql.globalTempDatabase](spark-sql-StaticSQLConf.md#spark.sql.globalTempDatabase) internal static configuration property.

In the end, `globalTempViewManager` creates a new [GlobalTempViewManager](spark-sql-GlobalTempViewManager.md) (with the configured database name).

`globalTempViewManager` throws a `SparkException` when the global temporary view database [exist](ExternalCatalog.md#databaseExists) in the [ExternalCatalog](#externalCatalog):

```text
[globalTempDB] is a system preserved database, please rename your existing database to resolve the name conflict, or set a different value for spark.sql.globalTempDatabase, and launch your Spark application again.
```

`globalTempViewManager` is used when [BaseSessionStateBuilder](BaseSessionStateBuilder.md#catalog) and [HiveSessionStateBuilder](hive/HiveSessionStateBuilder.md#catalog) are requested for a [SessionCatalog](SessionCatalog.md).

## <span id="externalCatalogClassName"> externalCatalogClassName Internal Method

```scala
externalCatalogClassName(
  conf: SparkConf): String
```

`externalCatalogClassName` gives the name of the class of the [ExternalCatalog](ExternalCatalog.md) implementation based on [spark.sql.catalogImplementation](spark-sql-StaticSQLConf.md#spark.sql.catalogImplementation) configuration property:

* [org.apache.spark.sql.hive.HiveExternalCatalog](hive/HiveExternalCatalog.md) for `hive`
* [org.apache.spark.sql.catalyst.catalog.InMemoryCatalog](InMemoryCatalog.md) for `in-memory`

`externalCatalogClassName` is used when `SharedState` is requested for the [ExternalCatalog](#externalCatalog).

## <span id="warehousePath"> Warehouse Location

```scala
warehousePath: String
```

!!! warning
    This is no longer part of SharedState and will go away once I find out where. Your help is appreciated.

`warehousePath` is the location of the warehouse.

`warehousePath` is [hive.metastore.warehouse.dir](hive/spark-sql-hive-metastore.md#hive.metastore.warehouse.dir) (if defined) or [spark.sql.warehouse.dir](spark-sql-StaticSQLConf.md#spark.sql.warehouse.dir).

`warehousePath` prints out the following INFO message to the logs when `SharedState` is [created](#creating-instance):

```text
Warehouse path is '[warehousePath]'.
```

`warehousePath` is used when `SharedState` initializes [ExternalCatalog](#externalCatalog) (and creates the default database in the metastore).

While initialized, `warehousePath` does the following:

1. Loads `hive-site.xml` when found on CLASSPATH, i.e. adds it as a configuration resource to Hadoop's http://hadoop.apache.org/docs/r2.7.3/api/org/apache/hadoop/conf/Configuration.html[Configuration] (of `SparkContext`).

1. Removes `hive.metastore.warehouse.dir` from `SparkConf` (of `SparkContext`) and leaves it off if defined using any of the Hadoop configuration resources.

1. Sets [spark.sql.warehouse.dir](spark-sql-StaticSQLConf.md#spark.sql.warehouse.dir) or [hive.metastore.warehouse.dir](hive/spark-sql-hive-metastore.md#hive.metastore.warehouse.dir) in the Hadoop configuration (of `SparkContext`)

    * If `hive.metastore.warehouse.dir` has been defined in any of the Hadoop configuration resources but [spark.sql.warehouse.dir](spark-sql-StaticSQLConf.md#spark.sql.warehouse.dir) has not, `spark.sql.warehouse.dir` becomes the value of `hive.metastore.warehouse.dir`.

      `warehousePath` prints out the following INFO message to the logs:

      ```text
      spark.sql.warehouse.dir is not set, but hive.metastore.warehouse.dir is set. Setting spark.sql.warehouse.dir to the value of hive.metastore.warehouse.dir ('[hiveWarehouseDir]').
      ```

    * Otherwise, the Hadoop configuration's `hive.metastore.warehouse.dir` is set to `spark.sql.warehouse.dir`

    `warehousePath` prints out the following INFO message to the logs:

    ```text
    Setting hive.metastore.warehouse.dir ('[hiveWarehouseDir]') to the value of spark.sql.warehouse.dir ('[sparkWarehouseDir]').
    ```

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.internal.SharedState` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.internal.SharedState=ALL
```

Refer to [Logging](spark-logging.md).
