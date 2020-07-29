title: CreateDataSourceTableCommand

# CreateDataSourceTableCommand Logical Command

`CreateDataSourceTableCommand` is a xref:spark-sql-LogicalPlan-RunnableCommand.md[logical command] that <<run, creates a new table>> (in a xref:spark-sql-SessionCatalog.md[SessionCatalog]).

`CreateDataSourceTableCommand` is created when [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) posthoc logical resolution rule resolves a xref:spark-sql-LogicalPlan-CreateTable.md[CreateTable] logical operator for a non-Hive table provider with no query.

=== [[creating-instance]] Creating CreateDataSourceTableCommand Instance

`CreateDataSourceTableCommand` takes the following to be created:

* [[table]] xref:spark-sql-CatalogTable.md[CatalogTable]
* [[ignoreIfExists]] `ignoreIfExists` Flag

`CreateDataSourceTableCommand` initializes the <<internal-properties, internal properties>>.

=== [[run]] Executing Logical Command -- `run` Method

[source, scala]
----
run(sparkSession: SparkSession): Seq[Row]
----

NOTE: `run` is part of <<spark-sql-LogicalPlan-RunnableCommand.md#run, RunnableCommand Contract>> to execute (run) a logical command.

`run` spark-sql-SessionCatalog.md#createTable[creates a new table] in a session-scoped `SessionCatalog`.

NOTE: `run` uses the input `SparkSession` to SparkSession.md#sessionState[access SessionState] that in turn is used to SessionState.md#catalog[access the current SessionCatalog].

Internally, `run` spark-sql-DataSource.md#resolveRelation[creates a BaseRelation] to access the table's schema.

CAUTION: FIXME

NOTE: `run` accepts tables only (not views) with the provider defined.
