# SqlGraphRegistrationContext

## Creating Instance

`SqlGraphRegistrationContext` takes the following to be created:

* <span id="graphRegistrationContext"> [GraphRegistrationContext](GraphRegistrationContext.md)

`SqlGraphRegistrationContext` is created when:

* `PipelinesHandler` ([Spark Connect]({{ book.spark_connect }})) is requested to [handle DEFINE_SQL_GRAPH_ELEMENTS command](PipelinesHandler.md#handlePipelinesCommand) (and [defineSqlGraphElements](PipelinesHandler.md#defineSqlGraphElements))
* `SqlGraphRegistrationContext` is requested to [processSqlFile](#processSqlFile)

## processSqlFile { #processSqlFile }

```scala
processSqlFile(
  sqlText: String,
  sqlFilePath: String,
  spark: SparkSession): Unit
```

`processSqlFile` creates a [SqlGraphRegistrationContext](SqlGraphRegistrationContext.md) for this [GraphRegistrationContext](#graphRegistrationContext).

!!! warning
    Why does `processSqlFile` creates a brand new [SqlGraphRegistrationContext](SqlGraphRegistrationContext.md) for the same [GraphRegistrationContext](#graphRegistrationContext) it is executed with?!

`processSqlFile` [splitSqlFileIntoQueries](#splitSqlFileIntoQueries) followed by [processSqlQuery](#processSqlQuery) for every query (a `LogicalPlan`).

---

`processSqlFile` is used when:

* `PipelinesHandler` ([Spark Connect]({{ book.spark_connect }})) is requested to [defineSqlGraphElements](PipelinesHandler.md#defineSqlGraphElements)

### processSqlQuery { #processSqlQuery }

```scala
processSqlQuery(
  queryPlan: LogicalPlan,
  queryOrigin: QueryOrigin): Unit
```

`processSqlQuery` handles (_processes_) the given `LogicalPlan` query plan:

* `SetCommand`
* `SetNamespaceCommand`
* `SetCatalogCommand`
* `CreateView`
* `CreateViewCommand`
* `CreateMaterializedViewAsSelect`
* `CreateStreamingTableAsSelect`
* `CreateStreamingTable`
* `CreateFlowCommand`

### splitSqlFileIntoQueries { #splitSqlFileIntoQueries }

```scala
splitSqlFileIntoQueries(
  spark: SparkSession,
  sqlFileText: String,
  sqlFilePath: String): Seq[SqlQueryPlanWithOrigin]
```

`splitSqlFileIntoQueries`...FIXME
