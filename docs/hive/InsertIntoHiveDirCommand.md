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

## Creating Instance

`InsertIntoHiveDirCommand` takes the following to be created:

* [[isLocal]] `isLocal` Flag
* [[storage]] [CatalogStorageFormat](../CatalogStorageFormat.md)
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

NOTE: `run` is part of [DataWritingCommand](../logical-operators/DataWritingCommand.md#run) contract.

`run` asserts that the [table location](../CatalogStorageFormat.md#locationUri) of the [CatalogStorageFormat](#storage) is specified (or throws an `AssertionError`).

`run` makes sure that there are no duplicates among the given [output columns](#outputColumnNames).

`run` creates a [CatalogTable](../CatalogTable.md) for the table location (and the `VIEW` table type) and HiveClientImpl.md#toHiveTable[converts it to a Hive Table metadata].

`run` specifies `serialization.lib` metadata to the [serde](../CatalogStorageFormat.md#serde) of the given [CatalogStorageFormat](#storage) or `LazySimpleSerDe` if not defined.

`run` creates a new map-reduce job for execution (a Hadoop [JobConf]({{ hadoop.api }}/org/apache/hadoop/mapred/JobConf.html)) with a [new Hadoop Configuration](../SessionState.md#newHadoopConf) (from the input [SparkSession](../SparkSession.md)).

`run` prepares the path to write to (based on the given <<isLocal, isLocal>> flag and creating it if necessary). `run` SaveAsHiveFile.md#getExternalTmpPath[getExternalTmpPath].

`run` [saveAsHiveFile](SaveAsHiveFile.md#saveAsHiveFile).

In the end, `run` SaveAsHiveFile.md#deleteExternalTmpPath[deleteExternalTmpPath].

In case of any error (`Throwable`), `run` throws an `SparkException`:

```
Failed inserting overwrite directory [locationUri]
```
