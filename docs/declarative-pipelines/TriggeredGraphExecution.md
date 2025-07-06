# TriggeredGraphExecution

`TriggeredGraphExecution` is a [GraphExecution](GraphExecution.md) that...FIXME

## Creating Instance

`TriggeredGraphExecution` takes the following to be created:

* <span id="graphForExecution"> [DataflowGraph](DataflowGraph.md)
* <span id="env"> [PipelineUpdateContext](PipelineUpdateContext.md)
* <span id="onCompletion"> `onCompletion` Callback (`RunTerminationReason => Unit`, default: `_ => ()`)
* <span id="clock"> `Clock` (default: `SystemClock`)

`TriggeredGraphExecution` is created when:

* `PipelineExecution` is requested to [startPipeline](PipelineExecution.md#startPipeline)

## Topological Execution Thread { #topologicalExecutionThread }

```scala
topologicalExecutionThread: Option[Thread]
```

`topologicalExecutionThread` is the **Topological Execution** thread of [execution](#start) of this pipeline.

`topologicalExecutionThread` is initialized and started when `TriggeredGraphExecution` is requested to [start](#start).

`topologicalExecutionThread` runs until [awaitCompletion](#awaitCompletion) or [stopInternal](#stopInternal).

## Start Pipeline { #start }

??? note "GraphExecution"

    ```scala
    start(): Unit
    ```

    `start` is part of the [GraphExecution](GraphExecution.md#start) abstraction.

`start`...FIXME

### buildTopologicalExecutionThread { #buildTopologicalExecutionThread }

```scala
buildTopologicalExecutionThread(): Thread
```

`buildTopologicalExecutionThread`...FIXME

### topologicalExecution { #topologicalExecution }

```scala
topologicalExecution(): Unit
```

`topologicalExecution`...FIXME

## Streaming Trigger { #streamTrigger }

??? note "GraphExecution"

    ```scala
    streamTrigger(
      flow: Flow): Trigger
    ```

    `streamTrigger` is part of the [GraphExecution](GraphExecution.md#streamTrigger) abstraction.

`streamTrigger` is `AvailableNowTrigger` ([Spark Structured Streaming]({{ book.structured_streaming }}/Trigger/#AvailableNowTrigger)).

## awaitCompletion { #awaitCompletion }

??? note "GraphExecution"

    ```scala
    awaitCompletion(): Unit
    ```

    `awaitCompletion` is part of the [GraphExecution](GraphExecution.md#awaitCompletion) abstraction.

`awaitCompletion` waits for this [Topological Execution thread](#topologicalExecutionThread) to die.

## stopInternal { #stopInternal }

```scala
stopInternal(
  stopTopologicalExecutionThread: Boolean): Unit
```

`stopInternal`...FIXME

---

`stopInternal` is used when:

* `TriggeredGraphExecution` is requested to [start](#start) and [stop](#stop)

## Stop Execution { #stop }

??? note "GraphExecution"

    ```scala
    stop(): Unit
    ```

    `stop` is part of the [GraphExecution](GraphExecution.md#stop) abstraction.

`stop` [stopInternal](#stopInternal) (with `stopTopologicalExecutionThread` flag enabled).
