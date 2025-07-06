# GraphRegistrationContext

## Creating Instance

`GraphRegistrationContext` takes the following to be created:

* <span id="defaultCatalog"> Default Catalog
* <span id="defaultDatabase"> Default Database
* <span id="defaultSqlConf"> Default SQL Configuration Properties

`GraphRegistrationContext` is created when:

* `DataflowGraphRegistry` is requested to [createDataflowGraph](DataflowGraphRegistry.md#createDataflowGraph)

## toDataflowGraph { #toDataflowGraph }

```scala
toDataflowGraph: DataflowGraph
```

`toDataflowGraph` creates a [DataflowGraph](DataflowGraph.md) for the [tables](#tables), [views](#views), and [flows](#flows).

---

`toDataflowGraph` is used when:

* `PipelinesHandler` ([Spark Connect]({{ book.spark_connect }})) is requested to [startRun](PipelinesHandler.md#startRun)
