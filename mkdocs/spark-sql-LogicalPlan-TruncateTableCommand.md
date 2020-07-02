title: TruncateTableCommand

# TruncateTableCommand Logical Command

`TruncateTableCommand` is a xref:spark-sql-LogicalPlan-RunnableCommand.adoc[logical command] that represents xref:spark-sql-SparkSqlAstBuilder.adoc#visitTruncateTable[TRUNCATE TABLE] SQL statement.

=== [[creating-instance]] Creating TruncateTableCommand Instance

`TruncateTableCommand` takes the following to be created:

* [[tableName]] `TableIdentifier`
* [[partitionSpec]] Optional `TablePartitionSpec`

=== [[run]] Executing Logical Command -- `run` Method

[source, scala]
----
run(spark: SparkSession): Seq[Row]
----

NOTE: `run` is part of xref:spark-sql-LogicalPlan-RunnableCommand.adoc#run[RunnableCommand Contract] to execute (_run_) a logical command.

`run`...FIXME

`run` throws an `AnalysisException` when executed on xref:spark-sql-CatalogTable.adoc#tableType[external tables]:

```
Operation not allowed: TRUNCATE TABLE on external tables: [tableIdentWithDB]
```

`run` throws an `AnalysisException` when executed on xref:spark-sql-CatalogTable.adoc#tableType[views]:

```
Operation not allowed: TRUNCATE TABLE on views: [tableIdentWithDB]
```

`run` throws an `AnalysisException` when executed with <<partitionSpec, TablePartitionSpec>> on xref:spark-sql-CatalogTable.adoc#partitionColumnNames[non-partitioned tables]:

```
Operation not allowed: TRUNCATE TABLE ... PARTITION is not supported for tables that are not partitioned: [tableIdentWithDB]
```

`run` throws an `AnalysisException` when executed with <<partitionSpec, TablePartitionSpec>> with xref:spark-sql-DDLUtils.adoc#verifyPartitionProviderIsHive[filesource partition disabled or partition metadata not in a Hive metastore].
