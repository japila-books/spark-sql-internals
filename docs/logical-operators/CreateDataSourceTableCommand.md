# CreateDataSourceTableCommand Logical Command

`CreateDataSourceTableCommand` is a RunnableCommand.md[logical command] that <<run, creates a new table>> (in a [SessionCatalog](../SessionCatalog.md)).

`CreateDataSourceTableCommand` is created when [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) posthoc logical resolution rule resolves a CreateTable.md[CreateTable] logical operator for a non-Hive table provider with no query.

## Creating Instance

`CreateDataSourceTableCommand` takes the following to be created:

* [[table]] [CatalogTable](../CatalogTable.md)
* [[ignoreIfExists]] `ignoreIfExists` Flag

=== [[run]] Executing Logical Command -- `run` Method

[source, scala]
----
run(sparkSession: SparkSession): Seq[Row]
----

NOTE: `run` is part of <<RunnableCommand.md#run, RunnableCommand Contract>> to execute (run) a logical command.

`run` requests a session-scoped `SessionCatalog` to [create a table](../SessionCatalog.md#createTable).

NOTE: `run` uses the input `SparkSession` to SparkSession.md#sessionState[access SessionState] that in turn is used to SessionState.md#catalog[access the current SessionCatalog].

Internally, `run` [creates a BaseRelation](../DataSource.md#resolveRelation) to access the table's schema.

CAUTION: FIXME

NOTE: `run` accepts tables only (not views) with the provider defined.
