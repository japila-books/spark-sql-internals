# InsertIntoHiveDirCommand Logical Command

:spark-version: 2.4.5
:hive-version: 2.3.6
:hadoop-version: 2.10.0
:url-hive-javadoc: https://hive.apache.org/javadocs/r{hive-version}/api
:url-hadoop-javadoc: https://hadoop.apache.org/docs/r{hadoop-version}/api

`InsertIntoHiveDirCommand` is a SaveAsHiveFile.md[logical command] that writes the result of executing a <<query, structured query>> to a Hadoop DFS location of a <<storage, Hive table>>.

`InsertIntoHiveDirCommand` is <<creating-instance, created>> when HiveAnalysis.md[HiveAnalysis] logical resolution rule is executed and resolves a ../InsertIntoDir.md[InsertIntoDir] logical operator with a Hive table.

[source, scala]
----
//
// The example does NOT work when executed
// "Data not in the BIGINT data type range so converted to null"
// It is enough to show the InsertIntoHiveDirCommand operator though
//
assert(spark.version == "2.4.5")

val tableName = "insert_into_hive_dir_demo"
sql(s"""CREATE TABLE IF NOT EXISTS $tableName (id LONG) USING hive""")

val locationUri = spark.sharedState.externalCatalog.getTable("default", tableName).location.toString
val q = sql(s"""INSERT OVERWRITE DIRECTORY '$locationUri' USING hive SELECT 1L AS id""")
scala> q.explain(true)
== Parsed Logical Plan ==
'InsertIntoDir false, Storage(Location: hdfs://localhost:9000/user/hive/warehouse/insert_into_hive_dir_demo), hive, true
+- Project [1 AS id#49L]
   +- OneRowRelation

== Analyzed Logical Plan ==
InsertIntoHiveDirCommand false, Storage(Location: hdfs://localhost:9000/user/hive/warehouse/insert_into_hive_dir_demo), true, [id]
+- Project [1 AS id#49L]
   +- OneRowRelation

== Optimized Logical Plan ==
InsertIntoHiveDirCommand false, Storage(Location: hdfs://localhost:9000/user/hive/warehouse/insert_into_hive_dir_demo), true, [id]
+- Project [1 AS id#49L]
   +- OneRowRelation

== Physical Plan ==
Execute InsertIntoHiveDirCommand InsertIntoHiveDirCommand false, Storage(Location: hdfs://localhost:9000/user/hive/warehouse/insert_into_hive_dir_demo), true, [id]
+- *(1) Project [1 AS id#49L]
   +- Scan OneRowRelation[]

// FIXME Why does the following throw an exception?
// spark.table(tableName)
----

=== [[creating-instance]] Creating InsertIntoHiveDirCommand Instance

`InsertIntoHiveDirCommand` takes the following to be created:

* [[isLocal]] `isLocal` Flag
* [[storage]] ../spark-sql-CatalogStorageFormat.md[CatalogStorageFormat]
* [[query]] Structured query (as a ../spark-sql-LogicalPlan.md[LogicalPlan])
* [[overwrite]] `overwrite` Flag
* [[outputColumnNames]] Names of the output columns

=== [[run]] Executing Logical Command -- `run` Method

[source, scala]
----
run(
  sparkSession: SparkSession,
  child: SparkPlan): Seq[Row]
----

NOTE: `run` is part of ../spark-sql-LogicalPlan-DataWritingCommand.md#run[DataWritingCommand] contract.

`run` asserts that the ../spark-sql-CatalogStorageFormat.md#locationUri[table location] of the <<storage, CatalogStorageFormat>> is specified (or throws an `AssertionError`).

`run` ../spark-sql-SchemaUtils.md#checkColumnNameDuplication[checkColumnNameDuplication] of the given <<outputColumnNames, output columns>>.

`run` creates a [CatalogTable](../CatalogTable.md) for the table location (and the `VIEW` table type) and HiveClientImpl.md#toHiveTable[converts it to a Hive Table metadata].

`run` specifies `serialization.lib` metadata to the ../spark-sql-CatalogStorageFormat.md#serde[serde] of the given <<storage, CatalogStorageFormat>> or `LazySimpleSerDe` if not defined.

`run` creates a new map-reduce job for execution (a Hadoop {url-hadoop-javadoc}/org/apache/hadoop/mapred/JobConf.html[JobConf]) with a ../SessionState.md#newHadoopConf[new Hadoop Configuration] (from the input ../SparkSession.md[SparkSession]).

`run` prepares the path to write to (based on the given <<isLocal, isLocal>> flag and creating it if necessary). `run` SaveAsHiveFile.md#getExternalTmpPath[getExternalTmpPath].

`run` SaveAsHiveFile.md#saveAsHiveFile[saveAsHiveFile].

In the end, `run` SaveAsHiveFile.md#deleteExternalTmpPath[deleteExternalTmpPath].

In case of any error (`Throwable`), `run` throws an `SparkException`:

```
Failed inserting overwrite directory [locationUri]
```
