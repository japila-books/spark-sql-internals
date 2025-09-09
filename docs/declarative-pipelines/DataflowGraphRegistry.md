# DataflowGraphRegistry

`DataflowGraphRegistry` is a registry of [Dataflow Graphs](#dataflowGraphs) (a mere wrapper around a collection of [GraphRegistrationContext](GraphRegistrationContext.md)s)

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

```scala
assert(DataflowGraphRegistry.getAllDataflowGraphs.size == 1)
```

## Dataflow Graphs { #dataflowGraphs }

```scala
dataflowGraphs: ConcurrentHashMap[String, GraphRegistrationContext]
```

`DataflowGraphRegistry` manages [GraphRegistrationContext](GraphRegistrationContext.md)s (by graph IDs).

A new [GraphRegistrationContext](GraphRegistrationContext.md) is added when `DataflowGraphRegistry` is requested to [create a new dataflow graph](#createDataflowGraph).

A single [GraphRegistrationContext](GraphRegistrationContext.md) can be looked up with [getDataflowGraph](#getDataflowGraph) and [getDataflowGraphOrThrow](#getDataflowGraphOrThrow).

All the [GraphRegistrationContext](GraphRegistrationContext.md)s can be returned with [getAllDataflowGraphs](#getAllDataflowGraphs).

A [GraphRegistrationContext](GraphRegistrationContext.md) is removed when [dropDataflowGraph](#dropDataflowGraph).

`dataflowGraphs` is cleared up with [dropAllDataflowGraphs](#dropAllDataflowGraphs).

## Create Dataflow Graph { #createDataflowGraph }

```scala
createDataflowGraph(
  defaultCatalog: String,
  defaultDatabase: String,
  defaultSqlConf: Map[String, String]): String
```

`createDataflowGraph` generates a graph ID (as a pseudo-randomly generated UUID).

`createDataflowGraph` registers a new [GraphRegistrationContext](GraphRegistrationContext.md) with the graph ID (in this [dataflowGraphs](#dataflowGraphs) registry).

In the end, `createDataflowGraph` returns the graph ID.

---

`createDataflowGraph` is used when:

* `PipelinesHandler` is requested to [create a dataflow graph](PipelinesHandler.md#createDataflowGraph)

## Find Dataflow Graph (or Throw SparkException) { #getDataflowGraphOrThrow }

```scala
getDataflowGraphOrThrow(
  dataflowGraphId: String): GraphRegistrationContext
```

`getDataflowGraphOrThrow` [looks up the GraphRegistrationContext](#getDataflowGraph) for the given `dataflowGraphId` or throws an `SparkException` if it does not exist.

```text
Dataflow graph with id [graphId] could not be found
```

---

`getDataflowGraphOrThrow` is used when:

* `PipelinesHandler` ([Spark Connect]({{ book.spark_connect }})) is requested to [defineDataset](PipelinesHandler.md#defineDataset), [defineFlow](PipelinesHandler.md#defineFlow), [defineSqlGraphElements](PipelinesHandler.md#defineSqlGraphElements), [startRun](PipelinesHandler.md#startRun)

## Find Dataflow Graph { #getDataflowGraph }

```scala
getDataflowGraph(
  graphId: String): Option[GraphRegistrationContext]
```

`getDataflowGraph` finds the [GraphRegistrationContext](GraphRegistrationContext.md) for the given `graphId` (in this [dataflowGraphs](#dataflowGraphs) registry).

---

`getDataflowGraph` is used when:

* `DataflowGraphRegistry` is requested to [getDataflowGraphOrThrow](#getDataflowGraphOrThrow)
