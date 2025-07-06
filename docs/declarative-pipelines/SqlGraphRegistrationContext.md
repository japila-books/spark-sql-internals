# SqlGraphRegistrationContext

## Creating Instance

`SqlGraphRegistrationContext` takes the following to be created:

* <span id="graphRegistrationContext"> [GraphRegistrationContext](GraphRegistrationContext.md)

`SqlGraphRegistrationContext` is created when:

* `PipelinesHandler` ([Spark Connect]({{ book.spark_connect }})) is requested to [defineSqlGraphElements](PipelinesHandler.md#defineSqlGraphElements)
* `SqlGraphRegistrationContext` is requested to [processSqlFile](#processSqlFile)

## processSqlQuery { #processSqlQuery }

```scala
processSqlQuery(
  queryPlan: LogicalPlan,
  queryOrigin: QueryOrigin): Unit
```

`processSqlQuery`...FIXME

---

`processSqlQuery` is used when:

* `SqlGraphRegistrationContext` is requested to [processSqlFile](#processSqlFile)

## processSqlFile { #processSqlFile }

```scala
processSqlFile(
  sqlText: String,
  sqlFilePath: String,
  spark: SparkSession): Unit
```

`processSqlFile`...FIXME

---

`processSqlFile` is used when:

* `PipelinesHandler` ([Spark Connect]({{ book.spark_connect }})) is requested to [defineSqlGraphElements](PipelinesHandler.md#defineSqlGraphElements)
