# SqlGraphRegistrationContext

## Creating Instance

`SqlGraphRegistrationContext` takes the following to be created:

* <span id="graphRegistrationContext"> [GraphRegistrationContext](GraphRegistrationContext.md)

`SqlGraphRegistrationContext` is created when:

* `PipelinesHandler` is requested to [handle DEFINE_SQL_GRAPH_ELEMENTS command](PipelinesHandler.md#handlePipelinesCommand) (and [defineSqlGraphElements](PipelinesHandler.md#defineSqlGraphElements))
* `SqlGraphRegistrationContext` is requested to [process a SQL file](#processSqlFile)

## SqlGraphRegistrationContextState { #context }

When [created](#creating-instance), `SqlGraphRegistrationContext` creates a [SqlGraphRegistrationContextState](SqlGraphRegistrationContextState.md) (with the [defaultCatalog](GraphRegistrationContext.md#defaultCatalog), the [defaultDatabase](GraphRegistrationContext.md#defaultDatabase) and the [defaultSqlConf](GraphRegistrationContext.md#defaultSqlConf)).

## Process SQL File { #processSqlFile }

```scala
processSqlFile(
  sqlText: String,
  sqlFilePath: String,
  spark: SparkSession): Unit
```

`processSqlFile` creates a [SqlGraphRegistrationContext](SqlGraphRegistrationContext.md) for this [GraphRegistrationContext](#graphRegistrationContext).

!!! warning
    Why does `processSqlFile` creates a brand new [SqlGraphRegistrationContext](SqlGraphRegistrationContext.md) for the same [GraphRegistrationContext](#graphRegistrationContext) it is executed with?!

`processSqlFile` [splits the contents of the SQL file into separate queries](#splitSqlFileIntoQueries) and [processes every SQL query](#processSqlQuery).

---

`processSqlFile` is used when:

* `PipelinesHandler` is requested to [defineSqlGraphElements](PipelinesHandler.md#defineSqlGraphElements)

### Process Single SQL Query { #processSqlQuery }

```scala
processSqlQuery(
  queryPlan: LogicalPlan,
  queryOrigin: QueryOrigin): Unit
```

`processSqlQuery` handles (_processes_) the given [LogicalPlan](../logical-operators/LogicalPlan.md) logical commands:

| Logical Command | Command Handler | Datasets |
|-|-|-|
| [CreateFlowCommand](../logical-operators/CreateFlowCommand.md) | [CreateFlowHandler](#CreateFlowCommand) | [UnresolvedFlow](GraphRegistrationContext.md#registerFlow) ([once](UnresolvedFlow.md#once) disabled) |
| [CreateMaterializedViewAsSelect](../logical-operators/CreateMaterializedViewAsSelect.md) | [CreateMaterializedViewAsSelectHandler](#CreateMaterializedViewAsSelect) | [Table](GraphRegistrationContext.md#registerTable) ([isStreamingTable](Table.md#isStreamingTable) disabled)<br>[UnresolvedFlow](GraphRegistrationContext.md#registerFlow) ([once](UnresolvedFlow.md#once) disabled) |
| [CreateStreamingTable](../logical-operators/CreateStreamingTable.md) | [CreateStreamingTableHandler](#CreateStreamingTable) | [Table](GraphRegistrationContext.md#registerTable) ([isStreamingTable](Table.md#isStreamingTable) enabled) |
| [CreateStreamingTableAsSelect](../logical-operators/CreateStreamingTableAsSelect.md) | [CreateStreamingTableAsSelectHandler](#CreateStreamingTableAsSelect) | [Table](GraphRegistrationContext.md#registerTable) ([isStreamingTable](Table.md#isStreamingTable) enabled)<br>[UnresolvedFlow](GraphRegistrationContext.md#registerFlow) ([once](UnresolvedFlow.md#once) disabled) |
| [CreateView](../logical-operators/CreateView.md) | [CreatePersistedViewCommandHandler](#CreateView) | [PersistedView](GraphRegistrationContext.md#registerView)<br>[UnresolvedFlow](GraphRegistrationContext.md#registerFlow) ([once](UnresolvedFlow.md#once) disabled) |
| [CreateViewCommand](../logical-operators/CreateViewCommand.md) | [CreateTemporaryViewHandler](#CreateViewCommand) | [TemporaryView](GraphRegistrationContext.md#registerView)<br>[UnresolvedFlow](GraphRegistrationContext.md#registerFlow) ([once](UnresolvedFlow.md#once) disabled) |
| [SetCatalogCommand](../logical-operators/SetCatalogCommand.md) | [SetCatalogCommandHandler](#SetCatalogCommand) | |
| [SetCommand](../logical-operators/SetCommand.md) | [SetCommandHandler](#SetCommand) | |
| [SetNamespaceCommand](../logical-operators/SetNamespaceCommand.md) | [SetNamespaceCommandHandler](#SetNamespaceCommand) | |

### splitSqlFileIntoQueries { #splitSqlFileIntoQueries }

```scala
splitSqlFileIntoQueries(
  spark: SparkSession,
  sqlFileText: String,
  sqlFilePath: String): Seq[SqlQueryPlanWithOrigin]
```

`splitSqlFileIntoQueries`...FIXME

## Logical Command Handlers

### CreateFlowCommand { #CreateFlowCommand }

[CreateFlowCommand](../logical-operators/CreateFlowCommand.md) logical commands are handled by `CreateFlowHandler`.

A flow name must be a single-part name (that is resolved against the current pipelines catalog and database).

The [flowOperation](../logical-operators/CreateFlowCommand.md#flowOperation) of a [CreateFlowCommand](../logical-operators/CreateFlowCommand.md) command must be [InsertIntoStatement](../logical-operators/InsertIntoStatement.md).

??? warning
    Only `INSERT INTO ... BY NAME` flows are supported in [Spark Declarative Pipelines](index.md).

    `INSERT OVERWRITE` flows are not supported.

    `IF NOT EXISTS` not supported for flows.

    Neither partition spec nor user-specified schema can be specified.

In the end, `CreateFlowHandler` requests this [GraphRegistrationContext](#graphRegistrationContext) to [register](GraphRegistrationContext.md#registerFlow) an [UnresolvedFlow](UnresolvedFlow.md).

### CreateMaterializedViewAsSelect { #CreateMaterializedViewAsSelect }

[processSqlQuery](#processSqlQuery) handles [CreateMaterializedViewAsSelect](../logical-operators/CreateMaterializedViewAsSelect.md) logical commands using `CreateMaterializedViewAsSelectHandler`.

`CreateMaterializedViewAsSelectHandler` requests this [GraphRegistrationContext](#graphRegistrationContext) to [register a table](GraphRegistrationContext.md#registerTable) and a [flow](GraphRegistrationContext.md#registerFlow) (that backs the materialized view).

### CreateStreamingTable { #CreateStreamingTable }

[processSqlQuery](#processSqlQuery) handles [CreateStreamingTable](../logical-operators/CreateStreamingTable.md) logical commands using `CreateStreamingTableHandler`.

`CreateStreamingTableHandler` requests this [SqlGraphRegistrationContextState](#context) to [register a streaming table](GraphRegistrationContext.md#registerTable).

### CreateStreamingTableAsSelect { #CreateStreamingTableAsSelect }

[processSqlQuery](#processSqlQuery) handles [CreateStreamingTableAsSelect](../logical-operators/CreateStreamingTableAsSelect.md) logical commands using `CreateStreamingTableAsSelectHandler`.

`CreateStreamingTableAsSelectHandler` requests this [SqlGraphRegistrationContextState](#context) to [register a streaming table](GraphRegistrationContext.md#registerTable) and the accompanying [flow](GraphRegistrationContext.md#registerFlow) (for the streaming table).

### CreateView { #CreateView }

[processSqlQuery](#processSqlQuery) handles [CreateView](../logical-operators/CreateView.md) logical commands using `CreatePersistedViewCommandHandler`.

`CreatePersistedViewCommandHandler` requests this [GraphRegistrationContext](#graphRegistrationContext) to [register a PersistedView](GraphRegistrationContext.md#registerView) and the accompanying [flow](GraphRegistrationContext.md#registerFlow) (for the `PersistedView`).

### CreateViewCommand { #CreateViewCommand }

[processSqlQuery](#processSqlQuery) handles [CreateViewCommand](../logical-operators/CreateViewCommand.md) logical commands using `CreateTemporaryViewHandler`.

`CreateTemporaryViewHandler` requests this [GraphRegistrationContext](#graphRegistrationContext) to [register a TemporaryView](GraphRegistrationContext.md#registerView) and the accompanying [flow](GraphRegistrationContext.md#registerFlow) (for the `TemporaryView`).

### SetCatalogCommand { #SetCatalogCommand }

[processSqlQuery](#processSqlQuery) handles [SetCatalogCommand](../logical-operators/SetCatalogCommand.md) logical commands using `SetCatalogCommandHandler`.

`SetCatalogCommandHandler` requests this [SqlGraphRegistrationContextState](#context) to [setCurrentCatalog](SqlGraphRegistrationContextState.md#setCurrentCatalog) to the [catalogName](../logical-operators/SetCatalogCommand.md#catalogName) of the given [SetCatalogCommand](../logical-operators/SetCatalogCommand.md).

In the end, `SetCatalogCommandHandler` requests this [SqlGraphRegistrationContextState](#context) to [clearCurrentDatabase](SqlGraphRegistrationContextState.md#clearCurrentDatabase).

### SetCommand { #SetCommand }

[processSqlQuery](#processSqlQuery) handles [SetCommand](../logical-operators/SetCommand.md) logical commands using `SetCommandHandler`.

`SetCommandHandler` requests this [SqlGraphRegistrationContextState](#context) to [setSqlConf](#setSqlConf) with the key-value pair of the given [SetCommand](../logical-operators/SetCommand.md) logical command.

??? warning "RuntimeException"

    `handle` makes sure that the given `SetCommand` comes with a `key = value` pair or throws a `RuntimeException`:

    ```text
    Invalid SET command without key-value pair
    ```

    ```text
    Invalid SET command without value
    ```

### SetNamespaceCommand { #SetNamespaceCommand }

[processSqlQuery](#processSqlQuery) handles [SetNamespaceCommand](../logical-operators/SetNamespaceCommand.md) logical commands using `SetNamespaceCommandHandler`.

`SetNamespaceCommandHandler` requests this [SqlGraphRegistrationContextState](#context) for the following:

* For a `database`-only, single-part namespace, [setCurrentDatabase](SqlGraphRegistrationContextState.md#setCurrentDatabase)
* For a `catalog.database` two-part namespace, [setCurrentCatalog](SqlGraphRegistrationContextState.md#setCurrentCatalog) and [setCurrentDatabase](SqlGraphRegistrationContextState.md#setCurrentDatabase)

??? warning "SparkException"

    `handle` throws a `SparkException` for invalid namespaces:

    ```text
    Invalid schema identifier provided on USE command: [namespace]
    ```
