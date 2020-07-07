# InsertIntoHiveTable Logical Command

`InsertIntoHiveTable` is a link:SaveAsHiveFile.adoc[logical command] that writes the result of executing a <<query, structured query>> to a <<table, Hive table>>.

`InsertIntoHiveTable` is <<creating-instance, created>> when:

* link:HiveAnalysis.adoc[HiveAnalysis] logical resolution rule is executed and resolves a link:../InsertIntoTable.adoc[InsertIntoTable] logical operator with a link:HiveTableRelation.adoc[Hive table]

* link:CreateHiveTableAsSelectCommand.adoc[CreateHiveTableAsSelectCommand] logical command is executed

=== [[creating-instance]] Creating InsertIntoHiveTable Instance

`InsertIntoHiveTable` takes the following to be created:

* [[table]] link:../spark-sql-CatalogTable.adoc[CatalogTable]
* [[partition]] Partition keys with optional values (`Map[String, Option[String]]`)
* [[query]] Structured query (as a link:../spark-sql-LogicalPlan.adoc[LogicalPlan])
* [[overwrite]] `overwrite` Flag
* [[ifPartitionNotExists]] `ifPartitionNotExists` Flag
* [[outputColumnNames]] Names of the output columns

=== [[run]] Executing Data-Writing Logical Command -- `run` Method

[source, scala]
----
run(
  sparkSession: SparkSession,
  child: SparkPlan): Seq[Row]
----

NOTE: `run` is part of link:../spark-sql-LogicalPlan-DataWritingCommand.adoc#run[DataWritingCommand] contract.

`run` requests the input link:../spark-sql-SparkSession.adoc[SparkSession] for link:../spark-sql-SparkSession.adoc#sharedState[SharedState] that is then requested for the link:../spark-sql-SharedState.adoc#externalCatalog[ExternalCatalog].

`run` requests the link:../spark-sql-SessionState.adoc[SessionState] for a new link:../spark-sql-SessionState.adoc#newHadoopConf[Hadoop Configuration].

`run` link:HiveClientImpl.adoc#toHiveTable[converts the CatalogTable metadata to Hive's].

`run` link:SaveAsHiveFile.adoc#getExternalTmpPath[getExternalTmpPath].

`run` <<processInsert, processInsert>> (and link:SaveAsHiveFile.adoc#deleteExternalTmpPath[deleteExternalTmpPath]).

`run` requests the input link:../spark-sql-SparkSession.adoc[SparkSession] for link:../spark-sql-SparkSession.adoc#catalog[Catalog] that is requested to link:../spark-sql-Catalog.adoc#uncacheTable[uncache the table].

`run` un-caches the Hive table. `run` requests the input link:../spark-sql-SparkSession.adoc[SparkSession] for link:../spark-sql-SparkSession.adoc#sessionState[SessionState]. `run` requests the `SessionState` for the link:../spark-sql-SessionState.adoc#catalog[SessionCatalog] that is requested to link:../spark-sql-SessionCatalog.adoc#refreshTable[invalidate the cache for the table].

In the end, `run` link:../spark-sql-CommandUtils.adoc#updateTableStats[update the table statistics].

=== [[processInsert]] `processInsert` Internal Method

[source, scala]
----
processInsert(
  sparkSession: SparkSession,
  externalCatalog: ExternalCatalog,
  hadoopConf: Configuration,
  tableDesc: TableDesc,
  tmpLocation: Path,
  child: SparkPlan): Unit
----

`processInsert`...FIXME

NOTE: `processInsert` is used when `InsertIntoHiveTable` logical command is <<run, executed>>.
