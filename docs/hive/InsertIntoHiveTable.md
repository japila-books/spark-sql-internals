# InsertIntoHiveTable Logical Command

`InsertIntoHiveTable` is a SaveAsHiveFile.md[logical command] that writes the result of executing a <<query, structured query>> to a <<table, Hive table>>.

`InsertIntoHiveTable` is <<creating-instance, created>> when:

* HiveAnalysis.md[HiveAnalysis] logical resolution rule is executed and resolves a ../InsertIntoTable.md[InsertIntoTable] logical operator with a HiveTableRelation.md[Hive table]

* CreateHiveTableAsSelectCommand.md[CreateHiveTableAsSelectCommand] logical command is executed

=== [[creating-instance]] Creating InsertIntoHiveTable Instance

`InsertIntoHiveTable` takes the following to be created:

* [[table]] ../spark-sql-CatalogTable.md[CatalogTable]
* [[partition]] Partition keys with optional values (`Map[String, Option[String]]`)
* [[query]] Structured query (as a ../spark-sql-LogicalPlan.md[LogicalPlan])
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

NOTE: `run` is part of ../spark-sql-LogicalPlan-DataWritingCommand.md#run[DataWritingCommand] contract.

`run` requests the input ../SparkSession.md[SparkSession] for ../SparkSession.md#sharedState[SharedState] that is then requested for the ../SharedState.md#externalCatalog[ExternalCatalog].

`run` requests the ../SessionState.md[SessionState] for a new ../SessionState.md#newHadoopConf[Hadoop Configuration].

`run` HiveClientImpl.md#toHiveTable[converts the CatalogTable metadata to Hive's].

`run` SaveAsHiveFile.md#getExternalTmpPath[getExternalTmpPath].

`run` <<processInsert, processInsert>> (and SaveAsHiveFile.md#deleteExternalTmpPath[deleteExternalTmpPath]).

`run` requests the input ../SparkSession.md[SparkSession] for ../SparkSession.md#catalog[Catalog] that is requested to ../spark-sql-Catalog.md#uncacheTable[uncache the table].

`run` un-caches the Hive table. `run` requests the input ../SparkSession.md[SparkSession] for ../SparkSession.md#sessionState[SessionState]. `run` requests the `SessionState` for the ../SessionState.md#catalog[SessionCatalog] that is requested to ../spark-sql-SessionCatalog.md#refreshTable[invalidate the cache for the table].

In the end, `run` ../spark-sql-CommandUtils.md#updateTableStats[update the table statistics].

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
