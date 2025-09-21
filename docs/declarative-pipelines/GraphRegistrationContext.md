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

`toDataflowGraph` creates a new [DataflowGraph](DataflowGraph.md) with the [tables](#tables), [views](#views), and [flows](#flows) fully-qualified, resolved, and de-duplicated.

??? note "AnalysisException"
    `toDataflowGraph` reports an `AnalysisException` for a `GraphRegistrationContext` with no [tables](#tables) and no `PersistedView`s (in the [views](#views) registry).

---

`toDataflowGraph` is used when:

* `PipelinesHandler` is requested to [start a pipeline run](PipelinesHandler.md#startRun)

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

`registerTable` adds the given [Table](Table.md) to the [tables](#tables) registry.

---

`registerTable` is used when:

* `PipelinesHandler` is requested to [define a dataset](PipelinesHandler.md#defineDataset)

## Register Flow { #registerFlow }

```scala
registerFlow(
  flowDef: UnresolvedFlow): Unit
```

`registerFlow` adds the given [UnresolvedFlow](UnresolvedFlow.md) to the [flows](#flows) registry.

---

`registerFlow` is used when:

* `PipelinesHandler` is requested to [define a flow](PipelinesHandler.md#defineFlow)
* `SqlGraphRegistrationContext` is requested to [handle the following logical commands](SqlGraphRegistrationContext.md#processSqlQuery):
    * [CreateFlowCommand](SqlGraphRegistrationContext.md#CreateFlowCommand)
    * [CreateMaterializedViewAsSelect](SqlGraphRegistrationContext.md#CreateMaterializedViewAsSelect)
    * [CreateView](SqlGraphRegistrationContext.md#CreateView)
    * [CreateStreamingTableAsSelect](SqlGraphRegistrationContext.md#CreateStreamingTableAsSelect)
    * [CreateViewCommand](SqlGraphRegistrationContext.md#CreateViewCommand)
