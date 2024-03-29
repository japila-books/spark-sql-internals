# Hive Integration

Spark SQL can read and write data stored in [Apache Hive](http://hive.apache.org/) using [HiveExternalCatalog](hive/HiveExternalCatalog.md).

From [Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Apache_Hive):

> Apache Hive supports analysis of large datasets stored in Hadoop's HDFS and compatible file systems such as Amazon S3 filesystem.
>
> It provides an SQL-like language called HiveQL with schema on read and transparently converts queries to Hadoop MapReduce, Apache Tez and Apache Spark jobs.
>
> All three execution engines can run in Hadoop YARN.

[Builder.enableHiveSupport](SparkSession-Builder.md#enableHiveSupport) is used to enable Hive support (that simply sets [spark.sql.catalogImplementation](StaticSQLConf.md#spark.sql.catalogImplementation) internal configuration property to `hive` only when the Hive classes are available).

```text
import org.apache.spark.sql.SparkSession
val spark = SparkSession
  .builder
  .enableHiveSupport()  // <-- enables Hive support
  .getOrCreate

scala> sql("set spark.sql.catalogImplementation").show(false)
+-------------------------------+-----+
|key                            |value|
+-------------------------------+-----+
|spark.sql.catalogImplementation|hive |
+-------------------------------+-----+

assert(spark.conf.get("spark.sql.catalogImplementation") == "hive")
```

## Hive Configuration - hive-site.xml

The configuration for Hive is in `hive-site.xml` on the classpath.

The default configuration uses Hive 1.2.1 with the default warehouse in `/user/hive/warehouse`.

```text
16/04/09 13:37:54 INFO HiveContext: Initializing execution hive, version 1.2.1
16/04/09 13:37:58 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 1.2.0
16/04/09 13:37:58 WARN ObjectStore: Failed to get database default, returning NoSuchObjectException
16/04/09 13:37:58 INFO HiveContext: default warehouse location is /user/hive/warehouse
16/04/09 13:37:58 INFO HiveContext: Initializing HiveMetastoreConnection version 1.2.1 using Spark classes.
16/04/09 13:38:01 DEBUG HiveContext: create HiveContext
```
