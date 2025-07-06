# DataflowGraphRegistry

!!! note "Scala object"
    `DataflowGraphRegistry` is an `object` in Scala which means it is a class that has exactly one instance (itself).
    A Scala `object` is created lazily when it is referenced for the first time.

    Learn more in [Tour of Scala](https://docs.scala-lang.org/tour/singleton-objects.html).

## Demo

```scala
import org.apache.spark.sql.connect.pipelines.DataflowGraphRegistry

val graphId = DataflowGraphRegistry.createDataflowGraph(
  defaultCatalog=spark.catalog.currentCatalog(),
  defaultDatabase=spark.catalog.currentDatabase,
  defaultSqlConf=Map.empty)
```

## createDataflowGraph { #createDataflowGraph }

```scala
createDataflowGraph(
  defaultCatalog: String,
  defaultDatabase: String,
  defaultSqlConf: Map[String, String]): String
```

`createDataflowGraph`...FIXME

---

`createDataflowGraph` is used when:

* `PipelinesHandler` ([Spark Connect]({{ book.spark_connect }})) is requested to [createDataflowGraph](PipelinesHandler.md#createDataflowGraph)
