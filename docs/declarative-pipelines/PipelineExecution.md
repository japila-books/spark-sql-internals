# PipelineExecution

## Run Pipeline (and Wait for Completion) { #runPipeline }

```scala
runPipeline(): Unit
```

`runPipeline` [starts the pipeline](#startPipeline) and requests the [PipelineExecution](PipelineUpdateContext.md#pipelineexecution) (of this [PipelineUpdateContext](#context)) to [wait for the execution to complete](#awaitCompletion).

---

`runPipeline` is used when:

* `PipelinesHandler` is requested to [startRun](PipelinesHandler.md#startRun) (for [Spark Connect]({{ book.spark_connect }}))

## Start Pipeline { #startPipeline }

```scala
startPipeline(): Unit
```

`startPipeline` [resolves and validates the pipeline graph](#initializeGraph).

`startPipeline` creates a new [TriggeredGraphExecution](#graphExecution).

In the end, `startPipeline` requests the [GraphExecution](#graphExecution) to [start](TriggeredGraphExecution.md#start).

---

`startPipeline` is used when:

* `PipelineExecution` is requested to [runPipeline](#runPipeline)
