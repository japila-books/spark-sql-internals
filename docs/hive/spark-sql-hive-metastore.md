# Hive Metastore

Spark SQL uses a Hive metastore to manage the metadata of persistent relational entities (e.g. databases, tables, columns, partitions) in a relational database (for fast access).

A Hive metastore warehouse (aka <<spark.sql.warehouse.dir, spark-warehouse>>) is the directory where Spark SQL persists tables whereas a Hive metastore (aka <<javax.jdo.option.ConnectionURL, metastore_db>>) is a relational database to manage the metadata of the persistent relational entities, e.g. databases, tables, columns, partitions.

By default, Spark SQL uses the embedded deployment mode of a Hive metastore with a https://db.apache.org/derby/[Apache Derby] database.

[IMPORTANT]
====
The default embedded deployment mode is not recommended for production use due to limitation of only one active SparkSession.md[SparkSession] at a time.

Read Cloudera's https://www.cloudera.com/documentation/enterprise/latest/topics/cdh_ig_hive_metastore_configure.html[Configuring the Hive Metastore for CDH] document that explains the available deployment modes of a Hive metastore.
====

When `SparkSession` is SparkSession-Builder.md#enableHiveSupport[created with Hive support] the external catalog (aka _metastore_) is [HiveExternalCatalog](HiveExternalCatalog.md). `HiveExternalCatalog` uses <<spark.sql.warehouse.dir, spark.sql.warehouse.dir>> directory for the location of the databases and <<javax.jdo.option, javax.jdo.option properties>> for the connection to the Hive metastore database.

[NOTE]
====
The metadata of relational entities is persisted in a metastore database over JDBC and http://www.datanucleus.org/[DataNucleus AccessPlatform] that uses <<javax.jdo.option, javax.jdo.option>> properties.

Read https://cwiki.apache.org/confluence/display/Hive/AdminManual+MetastoreAdmin[Hive Metastore Administration] to learn how to manage a Hive Metastore.
====

[[javax.jdo.option]]
[[hive-metastore-database-connection-properties]]
.Hive Metastore Database Connection Properties
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| [[javax.jdo.option.ConnectionURL]] `javax.jdo.option.ConnectionURL`
a| The JDBC connection URL of a Hive metastore database to use

```
// the default setting in Spark SQL
jdbc:derby:;databaseName=metastore_db;create=true

// Example: memory only and so volatile and not for production use
jdbc:derby:memory:;databaseName=${metastoreLocation.getAbsolutePath};create=true

jdbc:mysql://192.168.175.160:3306/metastore?useSSL=false
```

| [[javax.jdo.option.ConnectionDriverName]] `javax.jdo.option.ConnectionDriverName`
a| The JDBC driver of a Hive metastore database to use

```
org.apache.derby.jdbc.EmbeddedDriver
```

| [[javax.jdo.option.ConnectionUserName]] `javax.jdo.option.ConnectionUserName`
| The user name to use to connect to a Hive metastore database

| [[javax.jdo.option.ConnectionPassword]] `javax.jdo.option.ConnectionPassword`
| The password to use to connect to a Hive metastore database
|===

You can configure <<javax.jdo.option, javax.jdo.option>> properties in <<hive-site.xml, hive-site.xml>> or using options with <<spark.hadoop, spark.hadoop>> prefix.

You can access the current connection properties for a Hive metastore in a Spark SQL application using the Spark internal classes.

[source, scala]
----
scala> :type spark
org.apache.spark.sql.SparkSession

scala> spark.sharedState.externalCatalog
res1: org.apache.spark.sql.catalyst.catalog.ExternalCatalog = org.apache.spark.sql.hive.HiveExternalCatalog@79dd79eb

// Use `:paste -raw` to paste the following code
// This is to pass the private[spark] "gate"
// BEGIN
package org.apache.spark
import org.apache.spark.sql.SparkSession
object jacek {
  def open(spark: SparkSession) = {
    import org.apache.spark.sql.hive.HiveExternalCatalog
    spark.sharedState.externalCatalog.asInstanceOf[HiveExternalCatalog].client
  }
}
// END
import org.apache.spark.jacek
val hiveClient = jacek.open(spark)
scala> hiveClient.getConf("javax.jdo.option.ConnectionURL", "")
res2: String = jdbc:derby:;databaseName=metastore_db;create=true
----

The benefits of using an external Hive metastore:

. Allow multiple Spark applications (sessions) to access it concurrently

. Allow a single Spark application to use table statistics without running "ANALYZE TABLE" every execution

NOTE: As of Spark 2.2 (see https://issues.apache.org/jira/browse/SPARK-18112[SPARK-18112 Spark2.x does not support read data from Hive 2.x metastore]) Spark SQL supports reading data from Hive 2.1.1 metastore.

CAUTION: FIXME Describe <<hive-site.xml, hive-site.xml>> vs `config` method vs `--conf` with <<spark.hadoop, spark.hadoop>> prefix.

Spark SQL uses the Hive-specific configuration properties that further fine-tune the Hive integration, e.g. spark-sql-properties.md#spark.sql.hive.metastore.version[spark.sql.hive.metastore.version] or spark-sql-properties.md#spark.sql.hive.metastore.jars[spark.sql.hive.metastore.jars].

=== [[spark.sql.warehouse.dir]] `spark.sql.warehouse.dir` Configuration Property

StaticSQLConf.md#spark.sql.warehouse.dir[spark.sql.warehouse.dir] is a static configuration property that sets Hive's `hive.metastore.warehouse.dir` property, i.e. the location of default database for the Hive warehouse.

[TIP]
====
Refer to SharedState.md[SharedState] to learn about (the low-level details of) Spark SQL support for Apache Hive.

See also the official https://cwiki.apache.org/confluence/display/Hive/AdminManual+MetastoreAdmin[Hive Metastore Administration] document.
====

=== Hive Metastore Deployment Modes

=== Configuring External Hive Metastore in Spark SQL

In order to use an external Hive metastore you should do the following:

. Enable Hive support in SparkSession-Builder.md#enableHiveSupport[SparkSession] (that makes sure that the Hive classes are on CLASSPATH and sets StaticSQLConf.md#spark.sql.catalogImplementation[spark.sql.catalogImplementation] internal configuration property to `hive`)

. StaticSQLConf.md#spark.sql.warehouse.dir[spark.sql.warehouse.dir] required?

. Define <<hive.metastore.warehouse.dir, hive.metastore.warehouse.dir>> in <<hive-site.xml, hive-site.xml>> configuration resource

. Check out SharedState.md#warehousePath[warehousePath]

. Execute `./bin/run-example sql.hive.SparkHiveExample` to verify Hive configuration

When not configured by the <<hive-site.xml, hive-site.xml>>, `SparkSession` automatically creates `metastore_db` in the current directory and creates a directory configured by <<spark.sql.warehouse.dir, spark.sql.warehouse.dir>>, which defaults to the directory `spark-warehouse` in the current directory that the Spark application is started.

[NOTE]
====
`hive.metastore.warehouse.dir` property in `hive-site.xml` is deprecated since Spark 2.0.0. Use <<spark.sql.warehouse.dir, spark.sql.warehouse.dir>> to specify the default location of the databases in a Hive warehouse.

You may need to grant write privilege to the user who starts the Spark application.
====

=== Hadoop Configuration Properties for Hive

[[hadoop-configuration-properties]]
.Hadoop Configuration Properties for Hive
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| [[hive.metastore.uris]] `hive.metastore.uris`
a| The Thrift URI of a remote Hive metastore, i.e. one that is in a separate JVM process or on a remote node

```
config("hive.metastore.uris", "thrift://192.168.175.160:9083")
```

| [[hive.metastore.warehouse.dir]] `hive.metastore.warehouse.dir`
a| `SharedState` uses SharedState.md#hive.metastore.warehouse.dir[hive.metastore.warehouse.dir] to set StaticSQLConf.md#spark.sql.warehouse.dir[spark.sql.warehouse.dir] if the latter is undefined.

CAUTION: FIXME How is `hive.metastore.warehouse.dir` related to `spark.sql.warehouse.dir`? `SharedState.warehousePath`? Review https://github.com/apache/spark/pull/16996/files

| [[hive.metastore.schema.verification]] `hive.metastore.schema.verification`
| Set to `false` (as seems to cause exceptions with an empty metastore database as of Hive 2.1)
|===

You may also want to use the following Hive configuration properties that (seem to) cause exceptions with an empty metastore database as of Hive 2.1.

* `datanucleus.schema.autoCreateAll` set to `true`

=== [[spark.hadoop]] spark.hadoop Configuration Properties

CAUTION: FIXME Describe the purpose of `spark.hadoop.*` properties

You can specify any of the Hadoop configuration properties, e.g. <<hive.metastore.warehouse.dir, hive.metastore.warehouse.dir>> with *spark.hadoop* prefix.

```
$ spark-shell --conf spark.hadoop.hive.metastore.warehouse.dir=/tmp/hive-warehouse
...
scala> spark.sharedState
18/01/08 10:46:19 INFO SharedState: spark.sql.warehouse.dir is not set, but hive.metastore.warehouse.dir is set. Setting spark.sql.warehouse.dir to the value of hive.metastore.warehouse.dir ('/tmp/hive-warehouse').
18/01/08 10:46:19 INFO SharedState: Warehouse path is '/tmp/hive-warehouse'.
res1: org.apache.spark.sql.internal.SharedState = org.apache.spark.sql.internal.SharedState@5a69b3cf
```

=== [[hive-site.xml]] hive-site.xml Configuration Resource

`hive-site.xml` configures Hive clients (e.g. Spark SQL) with the Hive Metastore configuration.

`hive-site.xml` is loaded when SharedState.md#warehousePath[SharedState] is created (which is...FIXME).

Configuration of Hive is done by placing your `hive-site.xml`, `core-site.xml` (for security configuration),
and `hdfs-site.xml` (for HDFS configuration) file in `conf/` (that is automatically added to the CLASSPATH of a Spark application).

TIP: You can use `--driver-class-path` or `spark.driver.extraClassPath` to point to the directory with configuration resources, e.g. `hive-site.xml`.

[source, xml]
----
<configuration>
  <property>
    <name>hive.metastore.warehouse.dir</name>
    <value>/tmp/hive-warehouse</value>
    <description>Hive Metastore location</description>
  </property>
</configuration>
----

TIP: Read *Resources* section in Hadoop's http://hadoop.apache.org/docs/r2.7.3/api/org/apache/hadoop/conf/Configuration.html[Configuration] javadoc to learn more about configuration resources.

[TIP]
====
Use `SparkContext.hadoopConfiguration` to know which configuration resources have already been registered.

[source, scala]
----
scala> sc.hadoopConfiguration
res1: org.apache.hadoop.conf.Configuration = Configuration: core-default.xml, core-site.xml, mapred-default.xml, mapred-site.xml, yarn-default.xml, yarn-site.xml

// Initialize warehousePath
scala> spark.sharedState.warehousePath
res2: String = file:/Users/jacek/dev/oss/spark/spark-warehouse/

// Note file:/Users/jacek/dev/oss/spark/spark-warehouse/ is added to configuration resources
scala> sc.hadoopConfiguration
res3: org.apache.hadoop.conf.Configuration = Configuration: core-default.xml, core-site.xml, mapred-default.xml, mapred-site.xml, yarn-default.xml, yarn-site.xml, file:/Users/jacek/dev/oss/spark/conf/hive-site.xml
----

Enable `org.apache.spark.sql.internal.SharedState` logger to `INFO` logging level to know where `hive-site.xml` comes from.

```
scala> spark.sharedState.warehousePath
18/01/08 09:49:33 INFO SharedState: loading hive config file: file:/Users/jacek/dev/oss/spark/conf/hive-site.xml
18/01/08 09:49:33 INFO SharedState: Setting hive.metastore.warehouse.dir ('null') to the value of spark.sql.warehouse.dir ('file:/Users/jacek/dev/oss/spark/spark-warehouse/').
18/01/08 09:49:33 INFO SharedState: Warehouse path is 'file:/Users/jacek/dev/oss/spark/spark-warehouse/'.
res2: String = file:/Users/jacek/dev/oss/spark/spark-warehouse/
```
====
