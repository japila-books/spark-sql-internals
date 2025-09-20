# TriggeredGraphExecution

`TriggeredGraphExecution` is a [GraphExecution](GraphExecution.md) for the [DataflowGraph](#graphForExecution) and [PipelineUpdateContext](#env).

## Creating Instance

`TriggeredGraphExecution` takes the following to be created:

* <span id="graphForExecution"> [DataflowGraph](DataflowGraph.md)
* <span id="env"> [PipelineUpdateContext](PipelineUpdateContext.md)
* <span id="onCompletion"> `onCompletion` Callback (`RunTerminationReason => Unit`, default: do nothing)
* <span id="clock"> `Clock` (default: `SystemClock`)

`TriggeredGraphExecution` is created when:

* `PipelineExecution` is requested to [run a pipeline update](PipelineExecution.md#startPipeline)

## Topological Execution Thread { #topologicalExecutionThread }

```scala
topologicalExecutionThread: Option[Thread]
```

`topologicalExecutionThread` is the **Topological Execution** thread of [execution](#start) of this pipeline update.

`topologicalExecutionThread` is initialized and started when `TriggeredGraphExecution` is requested to [start](#start).

`topologicalExecutionThread` runs until [awaitCompletion](#awaitCompletion) or [stopInternal](#stopInternal).

## Start Pipeline { #start }

??? note "GraphExecution"

    ```scala
    start(): Unit
    ```

    `start` is part of the [GraphExecution](GraphExecution.md#start) abstraction.

`start` [registers the stream listener](GraphExecution.md#start).

`start` requests this [PipelineUpdateContext](#env) for the [flows to be refreshed](PipelineUpdateContext.md#refreshFlows) and...FIXME

`start` [creates a Topological Execution thread](#buildTopologicalExecutionThread) and [starts its execution](#topologicalExecution).

### Create Topological Execution Thread { #buildTopologicalExecutionThread }

```scala
buildTopologicalExecutionThread(): Thread
```

`buildTopologicalExecutionThread` creates a new thread of execution known as **Topological Execution**.

When started, the thread does [topological execution](#topologicalExecution).

### topologicalExecution { #topologicalExecution }

```scala
topologicalExecution(): Unit
```

`topologicalExecution` [finds the flows](#flowsWithState) in `QUEUED` and `RUNNING` states or [failed but can be re-tried](#flowsQueuedForRetry).

For each flow in `RUNNING` state, `topologicalExecution`...FIXME

`topologicalExecution` checks leaking permits.

!!! note "FIXME Explain"

`topologicalExecution` [starts flows](#startFlow) that are ready to start.

### Start Single Flow { #startFlow }

```scala
startFlow(
  flow: ResolvedFlow): Unit
```

`startFlow` prints out the following INFO message to the logs:

```text
Starting flow [flow_identifier]
```

`startFlow` requests this [PipelineUpdateContext](#env) for the [FlowProgressEventLogger](PipelineUpdateContext.md#flowProgressEventLogger) to [recordPlanningForBatchFlow](FlowProgressEventLogger.md#recordPlanningForBatchFlow).

`startFlow` [planAndStartFlow](#planAndStartFlow).

`startFlow`...FIXME

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
