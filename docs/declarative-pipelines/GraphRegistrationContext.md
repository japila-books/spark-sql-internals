# GraphRegistrationContext

`GraphRegistrationContext` is a registry of [tables](#tables), [views](#views), and [flows](#flows) in a pipeline (_dataflow graph_).

`GraphRegistrationContext` is required to create a new [SqlGraphRegistrationContext](SqlGraphRegistrationContext.md).

Eventually, `GraphRegistrationContext` [becomes a DataflowGraph](#toDataflowGraph) (to create a [PipelineUpdateContextImpl](PipelineUpdateContextImpl.md#unresolvedGraph) to [run a pipeline](PipelinesHandler.md#startRun)).

## Creating Instance

`GraphRegistrationContext` takes the following to be created:

* <span id="defaultCatalog"> Default Catalog
* <span id="defaultDatabase"> Default Database
* <span id="defaultSqlConf"> Default SQL Configuration Properties

`GraphRegistrationContext` is created when:

* `DataflowGraphRegistry` is requested to [createDataflowGraph](DataflowGraphRegistry.md#createDataflowGraph)

## Create DataflowGraph { #toDataflowGraph }

```scala
toDataflowGraph: DataflowGraph
```

`toDataflowGraph` creates a new [DataflowGraph](DataflowGraph.md) with the [tables](#tables), [views](#views), [sinks](#sinks) and [flows](#flows) fully-qualified, resolved, and de-duplicated.

??? note "AnalysisException"
    `toDataflowGraph` reports an `AnalysisException` when this `GraphRegistrationContext` is [empty](#isPipelineEmpty).

---

`toDataflowGraph` is used when:

* `PipelinesHandler` is requested to [start a pipeline run](PipelinesHandler.md#startRun)

### isPipelineEmpty { #isPipelineEmpty }

```scala
isPipelineEmpty: Boolean
```

`isPipelineEmpty` is `true` when this pipeline (this `GraphRegistrationContext`) is empty, i.e., for all the following met:

1. No [tables](#tables) registered
1. No [PersistedView](PersistedView.md)s registered (among the [views](#views))
1. No [sinks](#sinks) registered

### assertNoDuplicates { #assertNoDuplicates }

```scala
assertNoDuplicates(
  qualifiedTables: Seq[Table],
  validatedViews: Seq[View],
  qualifiedFlows: Seq[UnresolvedFlow]): Unit
```

`assertNoDuplicates`...FIXME

### assertFlowIdentifierIsUnique { #assertFlowIdentifierIsUnique }

```scala
assertFlowIdentifierIsUnique(
  flow: UnresolvedFlow,
  datasetType: DatasetType,
  flows: Seq[UnresolvedFlow]): Unit
```

`assertFlowIdentifierIsUnique` throws an `AnalysisException` if the given [UnresolvedFlow](UnresolvedFlow.md)'s identifier is used by multiple flows (among the given `flows`):

```text
Flow [flow_name] was found in multiple datasets: [dataset_names]
```

## Tables { #tables }

`GraphRegistrationContext` creates an empty registry of [Table](Table.md)s when [created](#creating-instance).

A new [Table](Table.md) is added when `GraphRegistrationContext` is requested to [register a table](#registerTable).

## Views { #views }

`GraphRegistrationContext` creates an empty registry of [View](View.md)s when [created](#creating-instance).

## Sinks { #sinks }

`GraphRegistrationContext` creates an empty registry of [Sink](Sink.md)s when [created](#creating-instance).

A new sink is registered using [registerSink](#registerSink) (when `PipelinesHandler` is requested to [define a sink](PipelinesHandler.md#defineOutput)).

All the sinks registered are available via [getSinks](#getSinks).

A pipeline is considered [empty](#isPipelineEmpty) if there are no sinks (among the other persistent entities).

Eventually, `GraphRegistrationContext` uses the `sinks` to [create a DataflowGraph](#toDataflowGraph).

## Flows { #flows }

`GraphRegistrationContext` creates an empty registry of [UnresolvedFlow](UnresolvedFlow.md)s when [created](#creating-instance).

## Register Flow { #registerFlow }

```scala
registerFlow(
  flowDef: UnresolvedFlow): Unit
```

`registerFlow` adds the given [UnresolvedFlow](UnresolvedFlow.md) to the [flows](#flows) registry.

---

`registerFlow` is used when:

* `PipelinesHandler` is requested to [define a flow](PipelinesHandler.md#defineFlow)
* `SqlGraphRegistrationContext` is requested to [process the following SQL queries](SqlGraphRegistrationContext.md#processSqlQuery):
    * [CREATE FLOW AS INSERT INTO BY NAME](../logical-operators/CreateFlowCommand.md)
    * [CREATE MATERIALIZED VIEW AS](../logical-operators/CreateMaterializedViewAsSelect.md)
    * [CREATE STREAMING TABLE AS](../logical-operators/CreateStreamingTableAsSelect.md)
    * [CREATE TEMPORARY VIEW](../logical-operators/CreateViewCommand.md)
    * [CREATE VIEW](../logical-operators/CreateView.md)

## Register Sink { #registerSink }

```scala
registerSink(
  sinkDef: Sink): Unit
```

`registerSink` adds the given [Sink](Sink.md) to the [sinks](#sinks) registry.

---

`registerSink` is used when:

* `PipelinesHandler` is requested to [define an output](PipelinesHandler.md#defineOutput)

## Register Table { #registerTable }

```scala
registerTable(
  tableDef: Table): Unit
```

`registerTable` adds the given [Table](Table.md) to the [tables](#tables) registry.

---

`registerTable` is used when:

* `PipelinesHandler` is requested to [define an output](PipelinesHandler.md#defineOutput)
* `SqlGraphRegistrationContext` is requested to [process the following SQL queries](SqlGraphRegistrationContext.md#processSqlQuery):
    * [CREATE MATERIALIZED VIEW AS](../logical-operators/CreateMaterializedViewAsSelect.md)
    * [CREATE STREAMING TABLE](../logical-operators/CreateStreamingTable.md)
    * [CREATE STREAMING TABLE AS](../logical-operators/CreateStreamingTableAsSelect.md)
