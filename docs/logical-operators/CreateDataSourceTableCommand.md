title: CreateDataSourceTableCommand

# CreateDataSourceTableCommand Logical Command

`CreateDataSourceTableCommand` is a xref:spark-sql-LogicalPlan-RunnableCommand.adoc[logical command] that <<run, creates a new table>> (in a xref:spark-sql-SessionCatalog.adoc[SessionCatalog]).

`CreateDataSourceTableCommand` is created when xref:spark-sql-Analyzer-DataSourceAnalysis.adoc[DataSourceAnalysis] posthoc logical resolution rule resolves a xref:spark-sql-LogicalPlan-CreateTable.adoc[CreateTable] logical operator for a non-Hive table provider with no query.

=== [[creating-instance]] Creating CreateDataSourceTableCommand Instance

`CreateDataSourceTableCommand` takes the following to be created:

* [[table]] xref:spark-sql-CatalogTable.adoc[CatalogTable]
* [[ignoreIfExists]] `ignoreIfExists` Flag

`CreateDataSourceTableCommand` initializes the <<internal-properties, internal properties>>.

=== [[run]] Executing Logical Command -- `run` Method

[source, scala]
----
run(sparkSession: SparkSession): Seq[Row]
----

NOTE: `run` is part of <<spark-sql-LogicalPlan-RunnableCommand.adoc#run, RunnableCommand Contract>> to execute (run) a logical command.

`run` link:spark-sql-SessionCatalog.adoc#createTable[creates a new table] in a session-scoped `SessionCatalog`.

NOTE: `run` uses the input `SparkSession` to link:SparkSession.md#sessionState[access SessionState] that in turn is used to link:SessionState.md#catalog[access the current SessionCatalog].

Internally, `run` link:spark-sql-DataSource.adoc#resolveRelation[creates a BaseRelation] to access the table's schema.

CAUTION: FIXME

NOTE: `run` accepts tables only (not views) with the provider defined.
