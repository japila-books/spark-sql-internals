# PipelineExecution

`PipelineExecution` manages the lifecycle of a [GraphExecution](#graphExecution) (in the given [PipelineUpdateContext](#context)).

`PipelineExecution` is part of [PipelineUpdateContext](PipelineUpdateContext.md#pipelineExecution).

## Creating Instance

`PipelineExecution` takes the following to be created:

* <span id="context"> [PipelineUpdateContext](PipelineUpdateContext.md)

`PipelineExecution` is created alongside [PipelineUpdateContext](PipelineUpdateContext.md#pipelineExecution).

## Run Pipeline (and Wait for Completion) { #runPipeline }

```scala
runPipeline(): Unit
```

`runPipeline` [starts this pipeline](#startPipeline) and requests the [PipelineExecution](PipelineUpdateContext.md#pipelineExecution) (of this [PipelineUpdateContext](#context)) to [wait for the execution to complete](#awaitCompletion).

---

`runPipeline` is used when:

* `PipelinesHandler` is requested to [start a pipeline run](PipelinesHandler.md#startRun)

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

## Await Completion { #awaitCompletion }

```scala
awaitCompletion(): Unit
```

`awaitCompletion` requests this [GraphExecution](#graphExecution) to [awaitCompletion](GraphExecution.md#awaitCompletion).

---

`awaitCompletion` is used when:

* `PipelineExecution` is requested to [runPipeline](#runPipeline)

## Initialize Dataflow Graph { #initializeGraph }

```scala
initializeGraph(): DataflowGraph
```

`initializeGraph` requests this [PipelineUpdateContext](#context) for the [unresolved DataflowGraph](PipelineUpdateContext.md#unresolvedGraph) to be [resolved](DataflowGraph.md#resolve) and [validated](DataflowGraph.md#validate).

In the end, `initializeGraph` [materializes the tables (datasets)](DatasetManager.md#materializeDatasets).

---

`initializeGraph` is used when:

* `PipelineExecution` is requested to [start the pipeline](#startPipeline)

## GraphExecution { #graphExecution }

```scala
graphExecution: Option[GraphExecution]
```

`graphExecution` is the [GraphExecution](GraphExecution.md) of the pipeline.

`PipelineExecution` creates a [TriggeredGraphExecution](TriggeredGraphExecution.md) when [startPipeline](#startPipeline).

Used in:

* [awaitCompletion](#awaitCompletion)
* [executionStarted](#executionStarted)
* [startPipeline](#startPipeline)
* [stopPipeline](#stopPipeline)

## Is Execution Started { #executionStarted }

```scala
executionStarted: Boolean
```

`executionStarted` is a flag that indicates whether this [GraphExecution](#graphExecution) has been created or not.

---

`executionStarted` is used when:

* `SessionHolder` ([Spark Connect]({{ book.spark_connect }}/server/SessionHolder/)) is requested to `removeCachedPipelineExecution`

## stopPipeline { #stopPipeline }

```scala
stopPipeline(): Unit
```

`stopPipeline` requests this [GraphExecution](#graphExecution) to [stop](GraphExecution.md#stop).

In case this `GraphExecution` has not been created (_started_) yet, `stopPipeline` reports a `IllegalStateException`:

```text
Pipeline execution has not started yet.
```

---

`stopPipeline` is used when:

* `SessionHolder` ([Spark Connect]({{ book.spark_connect }}/server/SessionHolder/)) is requested to `removeCachedPipelineExecution`
