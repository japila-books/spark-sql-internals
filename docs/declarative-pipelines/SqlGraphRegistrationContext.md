# SqlGraphRegistrationContext

## Creating Instance

`SqlGraphRegistrationContext` takes the following to be created:

* <span id="graphRegistrationContext"> [GraphRegistrationContext](GraphRegistrationContext.md)

`SqlGraphRegistrationContext` is created when:

* `PipelinesHandler` is requested to [handle DEFINE_SQL_GRAPH_ELEMENTS command](PipelinesHandler.md#handlePipelinesCommand) (and [defineSqlGraphElements](PipelinesHandler.md#defineSqlGraphElements))
* `SqlGraphRegistrationContext` is requested to [processSqlFile](#processSqlFile)

### SqlGraphRegistrationContextState { #context }

When [created](#creating-instance), `SqlGraphRegistrationContext` creates a `SqlGraphRegistrationContextState` for the [defaultCatalog](GraphRegistrationContext.md#defaultCatalog), the [defaultDatabase](GraphRegistrationContext.md#defaultDatabase) and the [defaultSqlConf](GraphRegistrationContext.md#defaultSqlConf).

## Process SQL Definition File { #processSqlFile }

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

* [SetCommand](#SetCommand)
* [SetNamespaceCommand](#SetNamespaceCommand)
* `SetCatalogCommand`
* `CreateView`
* `CreateViewCommand`
* [CreateMaterializedViewAsSelect](#CreateMaterializedViewAsSelect)
* `CreateStreamingTableAsSelect`
* [CreateStreamingTable](#CreateStreamingTable)
* [CreateFlowCommand](#CreateFlowCommand)

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

!!! note
    Only `INSERT INTO ... BY NAME` flows are supported in [Spark Declarative Pipelines](index.md).

    `INSERT OVERWRITE` flows are not supported.

    `IF NOT EXISTS` not supported for flows.

    Neither partition spec nor user-specified schema can be specified.

In the end, `CreateFlowHandler` requests this [GraphRegistrationContext](#graphRegistrationContext) to [register](GraphRegistrationContext.md#registerFlow) an [UnresolvedFlow](UnresolvedFlow.md).

### CreateMaterializedViewAsSelect { #CreateMaterializedViewAsSelect }

[CreateMaterializedViewAsSelect](../logical-operators/CreateMaterializedViewAsSelect.md) logical commands are handled by `CreateMaterializedViewAsSelectHandler`.

`CreateMaterializedViewAsSelectHandler` requests this [GraphRegistrationContext](#graphRegistrationContext) to register a [table](GraphRegistrationContext.md#registerTable) and a [flow](GraphRegistrationContext.md#registerFlow) (that backs the materialized view).

### SetCommand { #SetCommand }

[processSqlQuery](#processSqlQuery) handles [SetCommand](../logical-operators/SetCommand.md) logical commands using `SetCommandHandler`.

```scala
handle(
  setCommand: SetCommand): Unit
```

`handle` requests this [SqlGraphRegistrationContextState](#context) to [setSqlConf](#setSqlConf) with the key-value pair of the given [SetCommand](../logical-operators/SetCommand.md) logical command.

??? note "RuntimeException"

    `handle` makes sure that the given `SetCommand` comes with a `key = value` pair or throws a `RuntimeException`:

    ```text
    Invalid SET command without key-value pair
    ```

    ```text
    Invalid SET command without value
    ```

### SetNamespaceCommand { #SetNamespaceCommand }

[processSqlQuery](#processSqlQuery) handles [SetNamespaceCommand](../logical-operators/SetNamespaceCommand.md) logical commands using `SetNamespaceCommandHandler`.

```scala
handle(
  setNamespaceCommand: SetNamespaceCommand): Unit
```

`handle` requests this [SqlGraphRegistrationContextState](#context) for the following:

* For a `database`-only, single-part namespace, [setCurrentDatabase](SqlGraphRegistrationContextState.md#setCurrentDatabase)
* For a `catalog.database` two-part namespace, [setCurrentCatalog](SqlGraphRegistrationContextState.md#setCurrentCatalog) and [setCurrentDatabase](SqlGraphRegistrationContextState.md#setCurrentDatabase)

??? note "SparkException"

    `handle` throws a `SparkException` for invalid namespaces:

    ```text
    Invalid schema identifier provided on USE command: [namespace]
    ```

### CreateStreamingTable { #CreateStreamingTable }

[processSqlQuery](#processSqlQuery) handles [CreateStreamingTable](../logical-operators/CreateStreamingTable.md) logical commands using `CreateStreamingTableHandler`.

```scala
handle(
  cst: CreateStreamingTable,
  queryOrigin: QueryOrigin): Unit
```

`handle` requests this [SqlGraphRegistrationContextState](#context) to [register a streaming table](GraphRegistrationContext.md#registerTable).
