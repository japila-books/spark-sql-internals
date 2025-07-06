# GraphRegistrationContext

`GraphRegistrationContext` is a registry of [tables](#tables), [views](#views), and [flows](#flows) in a dataflow graph.

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

## Tables { #tables }

`GraphRegistrationContext` creates an empty registry of [Table](Table.md)s when [created](#creating-instance).

A new [Table](Table.md) is added when [registerTable](#registerTable).

## Views { #views }

`GraphRegistrationContext` creates an empty registry of [View](View.md)s when [created](#creating-instance).

## Flows { #flows }

`GraphRegistrationContext` creates an empty registry of [UnresolvedFlow](UnresolvedFlow.md)s when [created](#creating-instance).

## Register Table { #registerTable }

```scala
registerTable(
  tableDef: Table): Unit
```

`registerTable` adds the given [Table](Table.md) to [tables](#tables) registry.

---

`registerTable` is used when:

* `PipelinesHandler` ([Spark Connect]({{ book.spark_connect }})) is requested is requested to [defineDataset](PipelinesHandler.md#defineDataset)
