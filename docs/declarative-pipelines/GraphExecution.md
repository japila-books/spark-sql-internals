# GraphExecution

`GraphExecution` is an [abstraction](#contract) of [graph executors](#implementations) that can...FIXME

## Contract (Subset) { #contract }

### awaitCompletion { #awaitCompletion }

```scala
awaitCompletion(): Unit
```

See:

* [TriggeredGraphExecution](TriggeredGraphExecution.md#awaitCompletion)

Used when:

* `PipelineExecution` is requested to [await completion](PipelineExecution.md#awaitCompletion)

### streamTrigger { #streamTrigger }

```scala
streamTrigger(
  flow: Flow): Trigger
```

See:

* [TriggeredGraphExecution](TriggeredGraphExecution.md#streamTrigger)

Used when:

* `GraphExecution` is [created](#creating-instance) (to create the [FlowPlanner](#flowPlanner))

## Implementations

* [TriggeredGraphExecution](TriggeredGraphExecution.md)

## Creating Instance

`GraphExecution` takes the following to be created:

* <span id="graphForExecution"> [DataflowGraph](DataflowGraph.md)
* <span id="env"> [PipelineUpdateContext](PipelineUpdateContext.md)

??? note "Abstract Class"
    `GraphExecution` is an abstract class and cannot be created directly.
    It is created indirectly for the [concrete graph executors](#implementations).

## FlowPlanner { #flowPlanner }

`GraphExecution` creates a [FlowPlanner](FlowPlanner.md) when [created](#creating-instance).

This `FlowPlanner` is created for this [DataflowGraph](#graphForExecution) and this [PipelineUpdateContext](#env), with a [Trigger](#streamTrigger) (that is supposed to be defined by the [implementations](#implementations)).

This `FlowPlanner` is used when `GraphExecution` is requested to [plan and start a flow](#planAndStartFlow).

## Start { #start }

```scala
start(): Unit
```

`start` requests the session-bound [ExecutionListenerManager](../SparkSession.md#listenerManager) to [remove all QueryExecutionListeners](../ExecutionListenerManager.md#clear).

In the end, `start` registers this [StreamListener](#streamListener) with the session-bound [StreamingQueryManager](../SparkSession.md#streams).

---

`start` is used when:

* `PipelineExecution` is requested to [start the pipeline](PipelineExecution.md#startPipeline)

## planAndStartFlow { #planAndStartFlow }

```scala
planAndStartFlow(
    flow: ResolvedFlow): Option[FlowExecution]
```

`planAndStartFlow`...FIXME

---

`planAndStartFlow` is used when:

* `TriggeredGraphExecution` is requested to [topologicalExecution](TriggeredGraphExecution.md#topologicalExecution)

## StreamListener { #streamListener }

`GraphExecution` creates a new [StreamListener](StreamListener.md) when [created](#creating-instance).

The `StreamListener` is created for this [PipelineUpdateContext](#env) and [DataflowGraph](#graphForExecution).

The `StreamListener` is registered (_added_) to the session-bound [StreamingQueryManager](../SparkSession.md#streams) when [started](#start), and deregistered (_removed_) when [stopped](#stop).

## Stop { #stop }

```scala
stop(): Unit
```

`stop` requests this session-bound [StreamingQueryManager](../SparkSession.md#streams) to remove this [StreamListener](#streamListener).

---

`stop` is used when:

* `PipelineExecution` is requested to [stop the pipeline](PipelineExecution.md#stopPipeline)
* `TriggeredGraphExecution` is requested to [create the Topological Execution thread](TriggeredGraphExecution.md#buildTopologicalExecutionThread) and [stopInternal](TriggeredGraphExecution.md#stopInternal)
