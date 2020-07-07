# Configuration Properties

This page contains the link:../spark-sql-properties.adoc[configuration properties] of the link:index.adoc[Hive data source].

[[properties]]
.Hive-Specific Spark SQL Configuration Properties
[cols="1a",options="header",width="100%"]
|===
| Configuration Property

| [[spark.sql.hive.convertMetastoreOrc]] *spark.sql.hive.convertMetastoreOrc*

Controls whether to use the built-in ORC reader and writer for Hive tables with the ORC storage format (instead of Hive SerDe).

Default: `true`

| [[spark.sql.hive.convertMetastoreParquet]] *spark.sql.hive.convertMetastoreParquet*

Controls whether to use the built-in Parquet reader and writer for Hive tables with the parquet storage format (instead of Hive SerDe).

Default: `true`

Internally, this property enables link:RelationConversions.adoc[RelationConversions] logical rule to link:RelationConversions.adoc#convert[convert HiveTableRelations to HadoopFsRelation]

| [[spark.sql.hive.convertMetastoreParquet.mergeSchema]] *spark.sql.hive.convertMetastoreParquet.mergeSchema*

Enables trying to merge possibly different but compatible Parquet schemas in different Parquet data files.

Default: `false`

This configuration is only effective when <<spark.sql.hive.convertMetastoreParquet, spark.sql.hive.convertMetastoreParquet>> is enabled.

| [[spark.sql.hive.manageFilesourcePartitions]] *spark.sql.hive.manageFilesourcePartitions*

Enables *metastore partition management* for file source tables (_filesource partition management_). This includes both datasource and converted Hive tables.

Default: `true`

When enabled (`true`), datasource tables store partition metadata in the Hive metastore, and use the metastore to prune partitions during query planning.

Use link:../spark-sql-SQLConf.adoc#manageFilesourcePartitions[SQLConf.manageFilesourcePartitions] method to access the current value.

| [[spark.sql.hive.metastore.barrierPrefixes]] *spark.sql.hive.metastore.barrierPrefixes*

Comma-separated list of class prefixes that should explicitly be reloaded for each version of Hive that Spark SQL is communicating with, e.g. Hive UDFs that are declared in a prefix that typically would be shared (i.e. `org.apache.spark.*`)

Default: `(empty)`

| [[spark.sql.hive.metastore.jars]] *spark.sql.hive.metastore.jars*

Location of the jars that should be used to link:HiveUtils.adoc#newClientForMetadata[create a HiveClientImpl].

Default: `builtin`

Supported locations:

* `builtin` - the jars that were used to load Spark SQL (aka _Spark classes_). Valid only when using the execution version of Hive, i.e. <<spark.sql.hive.metastore.version, spark.sql.hive.metastore.version>>

* `maven` - download the Hive jars from Maven repositories

* Classpath in the standard format for both Hive and Hadoop

| [[spark.sql.hive.metastore.sharedPrefixes]] *spark.sql.hive.metastore.sharedPrefixes*

Comma-separated list of class prefixes that should be loaded using the classloader that is shared between Spark SQL and a specific version of Hive.

Default: `"com.mysql.jdbc", "org.postgresql", "com.microsoft.sqlserver", "oracle.jdbc"`

An example of classes that should be shared are:

* JDBC drivers that are needed to talk to the metastore

* Other classes that interact with classes that are already shared, e.g. custom appenders that are used by log4j

| [[spark.sql.hive.metastore.version]] *spark.sql.hive.metastore.version*

Version of the Hive metastore (and the link:HiveUtils.adoc#newClientForMetadata[client classes and jars]).

Default: link:HiveUtils.adoc#builtinHiveVersion[1.2.1]

Supported versions link:IsolatedClientLoader.adoc#hiveVersion[range from 0.12.0 up to and including 2.3.3]

| [[spark.sql.hive.verifyPartitionPath]] *spark.sql.hive.verifyPartitionPath*

When enabled (`true`), check all the partition paths under the table's root directory when reading data stored in HDFS. This configuration will be deprecated in the future releases and replaced by spark.files.ignoreMissingFiles.

Default: `false`

| [[spark.sql.hive.metastorePartitionPruning]] *spark.sql.hive.metastorePartitionPruning*

When enabled (`true`), some predicates will be pushed down into the Hive metastore so that unmatching partitions can be eliminated earlier.

Default: `true`

This only affects Hive tables that are not converted to filesource relations (based on <<spark.sql.hive.convertMetastoreParquet, spark.sql.hive.convertMetastoreParquet>> and <<spark.sql.hive.convertMetastoreOrc, spark.sql.hive.convertMetastoreOrc>> properties).

Use link:../spark-sql-SQLConf.adoc#metastorePartitionPruning[SQLConf.metastorePartitionPruning] method to access the current value.

| [[spark.sql.hive.filesourcePartitionFileCacheSize]] *spark.sql.hive.filesourcePartitionFileCacheSize*

| [[spark.sql.hive.caseSensitiveInferenceMode]] *spark.sql.hive.caseSensitiveInferenceMode*

| [[spark.sql.hive.convertCTAS]] *spark.sql.hive.convertCTAS*

| [[spark.sql.hive.gatherFastStats]] *spark.sql.hive.gatherFastStats*

| [[spark.sql.hive.advancedPartitionPredicatePushdown.enabled]] *spark.sql.hive.advancedPartitionPredicatePushdown.enabled*

|===
