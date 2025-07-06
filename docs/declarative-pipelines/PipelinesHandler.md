# PipelinesHandler

## handlePipelinesCommand { #handlePipelinesCommand }

```scala
handlePipelinesCommand(
  sessionHolder: SessionHolder,
  cmd: proto.PipelineCommand,
  responseObserver: StreamObserver[ExecutePlanResponse],
  transformRelationFunc: Relation => LogicalPlan): PipelineCommandResult
```

`handlePipelinesCommand`...FIXME

---

`handlePipelinesCommand` is used when:

* `SparkConnectPlanner` is requested to `handlePipelineCommand` (for `PIPELINE_COMMAND` command)

### startRun { #startRun }

```scala
startRun(
  cmd: proto.PipelineCommand.StartRun,
  responseObserver: StreamObserver[ExecutePlanResponse],
  sessionHolder: SessionHolder): Unit
```

`startRun`...FIXME

### createDataflowGraph { #createDataflowGraph }

```scala
createDataflowGraph(
  cmd: proto.PipelineCommand.CreateDataflowGraph,
  spark: SparkSession): String
```

`createDataflowGraph`...FIXME

### defineSqlGraphElements { #defineSqlGraphElements }

```scala
defineSqlGraphElements(
  cmd: proto.PipelineCommand.DefineSqlGraphElements,
  session: SparkSession): Unit
```

`defineSqlGraphElements`...FIXME

### defineDataset { #defineDataset }

```scala
defineDataset(
  dataset: proto.PipelineCommand.DefineDataset,
  sparkSession: SparkSession): Unit
```

`defineDataset`...FIXME

### defineFlow { #defineFlow }

```scala
defineFlow(
  flow: proto.PipelineCommand.DefineFlow,
  transformRelationFunc: Relation => LogicalPlan,
  sparkSession: SparkSession): Unit
```

`defineFlow`...FIXME
