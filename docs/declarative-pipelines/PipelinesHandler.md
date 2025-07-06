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
