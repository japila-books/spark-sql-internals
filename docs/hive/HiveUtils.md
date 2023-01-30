# HiveUtils

`HiveUtils` is an utility that is used to create a <<newClientForMetadata, HiveClientImpl>> that [HiveExternalCatalog](HiveExternalCatalog.md#client) uses to interact with a Hive metastore.

`HiveUtils` is a Scala object with `private[spark]` access modifier. Use the following utility to access the properties.

[source, scala]
----
// Use :paste -raw to paste the following code in spark-shell
// BEGIN
package org.apache.spark
import org.apache.spark.sql.hive.HiveUtils
object opener {
  def CONVERT_METASTORE_PARQUET = HiveUtils.CONVERT_METASTORE_PARQUET
}
// END

import org.apache.spark.opener
spark.sessionState.conf.getConf(opener.CONVERT_METASTORE_PARQUET)
----

[[logging]]
[TIP]
====
Enable `ALL` logging level for `org.apache.spark.sql.hive.HiveUtils$` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```
log4j.logger.org.apache.spark.sql.hive.HiveUtils=ALL
```

Refer to ../spark-logging.md[Logging].
====

=== [[builtinHiveVersion]] `builtinHiveVersion` Property

[source, scala]
----
builtinHiveVersion: String = "1.2.1"
----

`builtinHiveVersion` is used when:

* [spark.sql.hive.metastore.version](configuration-properties.md#spark.sql.hive.metastore.version) configuration property is used
* `HiveUtils` utility is used to [newClientForExecution](#newClientForExecution) and [newClientForMetadata](#newClientForMetadata)
* [Spark Thrift Server](../thrift-server/spark-sql-thrift-server.md) is used

=== [[newClientForMetadata]] Creating HiveClientImpl -- `newClientForMetadata` Method

[source, scala]
----
newClientForMetadata(
  conf: SparkConf,
  hadoopConf: Configuration): HiveClient  // <1>
newClientForMetadata(
  conf: SparkConf,
  hadoopConf: Configuration,
  configurations: Map[String, String]): HiveClient
----
<1> Uses time configurations formatted

Internally, `newClientForMetadata` creates a new [SQLConf](../SQLConf.md) with **spark.sql** properties only (from the input `SparkConf`).

`newClientForMetadata` then creates an [IsolatedClientLoader](IsolatedClientLoader.md) per the input parameters and the following configuration properties:

* [spark.sql.hive.metastore.version](configuration-properties.md#spark.sql.hive.metastore.version)

* [spark.sql.hive.metastore.jars](configuration-properties.md#spark.sql.hive.metastore.jars)

* [spark.sql.hive.metastore.sharedPrefixes](configuration-properties.md#spark.sql.hive.metastore.sharedPrefixes)

* [spark.sql.hive.metastore.barrierPrefixes](configuration-properties.md#spark.sql.hive.metastore.barrierPrefixes)

You should see one of the following INFO messages in the logs:

```text
Initializing HiveMetastoreConnection version [hiveMetastoreVersion] using Spark classes.
Initializing HiveMetastoreConnection version [hiveMetastoreVersion] using maven.
Initializing HiveMetastoreConnection version [hiveMetastoreVersion] using [jars]
```

In the end, `newClientForMetadata` requests the `IsolatedClientLoader` for a IsolatedClientLoader.md#createClient[HiveClient].

`newClientForMetadata` is used when `HiveExternalCatalog` is requested for a [HiveClient](HiveExternalCatalog.md#client).

=== [[newClientForExecution]] `newClientForExecution` Utility

[source, scala]
----
newClientForExecution(
  conf: SparkConf,
  hadoopConf: Configuration): HiveClientImpl
----

`newClientForExecution`...FIXME

`newClientForExecution` is used for [HiveThriftServer2](../thrift-server/spark-sql-thrift-server.md).

=== [[inferSchema]] `inferSchema` Method

[source, scala]
----
inferSchema(
  table: CatalogTable): CatalogTable
----

`inferSchema`...FIXME

NOTE: `inferSchema` is used when ResolveHiveSerdeTable.md[ResolveHiveSerdeTable] logical resolution rule is executed.

=== [[withHiveExternalCatalog]] `withHiveExternalCatalog` Utility

[source, scala]
----
withHiveExternalCatalog(
  sc: SparkContext): SparkContext
----

`withHiveExternalCatalog` simply sets the ../StaticSQLConf.md#spark.sql.catalogImplementation[spark.sql.catalogImplementation] configuration property to `hive` for the input `SparkContext`.

NOTE: `withHiveExternalCatalog` is used when the deprecated `HiveContext` is created.
