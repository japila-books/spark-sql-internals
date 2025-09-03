# PipelinesHandler

`PipelinesHandler` is used to [handle pipeline commands](#handlePipelinesCommand) in [Spark Connect]({{ book.spark_connect }}) ([SparkConnectPlanner]({{ book.spark_connect }}/server/SparkConnectPlanner), precisely).

## Handle Pipelines Command { #handlePipelinesCommand }

```scala
handlePipelinesCommand(
  sessionHolder: SessionHolder,
  cmd: proto.PipelineCommand,
  responseObserver: StreamObserver[ExecutePlanResponse],
  transformRelationFunc: Relation => LogicalPlan): PipelineCommandResult
```

`handlePipelinesCommand` handles the given pipeline `cmd` command.

| PipelineCommand | Description |
|-----------------|-------------|
| `CREATE_DATAFLOW_GRAPH` | [Creates a new Dataflow Graph](#createDataflowGraph) |
| `DROP_DATAFLOW_GRAPH` | [Drops a pipeline](#DROP_DATAFLOW_GRAPH) |
| `DEFINE_DATASET` | [Defines a dataset](#DEFINE_DATASET) |
| `DEFINE_FLOW` | [Defines a flow](#DEFINE_FLOW) |
| `START_RUN` | [Starts a pipeline](#START_RUN) |
| `DEFINE_SQL_GRAPH_ELEMENTS` | [DEFINE_SQL_GRAPH_ELEMENTS](#DEFINE_SQL_GRAPH_ELEMENTS) |

`handlePipelinesCommand` reports an `UnsupportedOperationException` for incorrect commands:

```text
[other] not supported
```

---

`handlePipelinesCommand` is used when:

* `SparkConnectPlanner` is requested to `handlePipelineCommand` (for `PIPELINE_COMMAND` command)

### Define Dataset Command { #DEFINE_DATASET }

`handlePipelinesCommand` prints out the following INFO message to the logs:

```text
Define pipelines dataset cmd received: [cmd]
```

`handlePipelinesCommand` [defines a dataset](#defineDataset).

### Define Flow Command { #DEFINE_FLOW }

`handlePipelinesCommand` prints out the following INFO message to the logs:

```text
Define pipelines flow cmd received: [cmd]
```

`handlePipelinesCommand` [defines a flow](#defineFlow).

### Start Pipeline { #startRun }

```scala
startRun(
  cmd: proto.PipelineCommand.StartRun,
  responseObserver: StreamObserver[ExecutePlanResponse],
  sessionHolder: SessionHolder): Unit
```

`startRun` prints out the following INFO message to the logs:

```text
Start pipeline cmd received: [cmd]
```

`startRun` finds the [GraphRegistrationContext](GraphRegistrationContext.md) by `dataflowGraphId` in the [DataflowGraphRegistry](DataflowGraphRegistry.md) (in the given `SessionHolder`).

`startRun` creates a `PipelineEventSender` to send pipeline events back to the Spark Connect client (_Python pipeline runtime_).

`startRun` creates a [PipelineUpdateContextImpl](PipelineUpdateContextImpl.md) (with the `PipelineEventSender`).

In the end, `startRun` requests the `PipelineUpdateContextImpl` for the [PipelineExecution](PipelineExecution.md) to [runPipeline](PipelineExecution.md#runPipeline) or [dryRunPipeline](PipelineExecution.md#dryRunPipeline) for `dry-run` or `run` command, respectively.

### Create Dataflow Graph { #createDataflowGraph }

```scala
createDataflowGraph(
  cmd: proto.PipelineCommand.CreateDataflowGraph,
  spark: SparkSession): String
```

`createDataflowGraph` finds the catalog and the database in the given `cmd` command and [creates a dataflow graph](DataflowGraphRegistry.md#createDataflowGraph).

`createDataflowGraph` returns the ID of the created dataflow graph.

### defineSqlGraphElements { #defineSqlGraphElements }

```scala
defineSqlGraphElements(
  cmd: proto.PipelineCommand.DefineSqlGraphElements,
  session: SparkSession): Unit
```

`defineSqlGraphElements`...FIXME

### Define Dataset (Table or View) { #defineDataset }

```scala
defineDataset(
  dataset: proto.PipelineCommand.DefineDataset,
  sparkSession: SparkSession): Unit
```

`defineDataset` looks up the [GraphRegistrationContext](DataflowGraphRegistry.md#getDataflowGraphOrThrow) for the given `dataset` (or throws a `SparkException` if not found).

`defineDataset` branches off based on the `dataset` type:

| Dataset Type | Action |
|--------------|--------|
| `MATERIALIZED_VIEW` or `TABLE` | [Registers a table](GraphRegistrationContext.md#registerTable) |
| `TEMPORARY_VIEW` | [Registers a view](GraphRegistrationContext.md#registerView) |

For unknown types, `defineDataset` reports an `IllegalArgumentException`:

```text
Unknown dataset type: [type]
```

### Define Flow { #defineFlow }

```scala
defineFlow(
  flow: proto.PipelineCommand.DefineFlow,
  transformRelationFunc: Relation => LogicalPlan,
  sparkSession: SparkSession): Unit
```

`defineFlow` looks up the [GraphRegistrationContext](DataflowGraphRegistry.md#getDataflowGraphOrThrow) for the given `flow` (or throws a `SparkException` if not found).

!!! note "Implicit Flows"
    An **implicit flow** is a flow with the name of the target dataset (i.e. one defined as part of dataset creation).

`defineFlow` [creates a flow identifier](GraphIdentifierManager.md#parseTableIdentifier) (for the `flow` name).

??? note "AnalysisException"
    `defineFlow` reports an `AnalysisException` if the given `flow` is not an implicit flow, but is defined with a multi-part identifier.

In the end, `defineFlow` [registers a flow](GraphRegistrationContext.md#registerFlow).
