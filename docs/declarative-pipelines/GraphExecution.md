# GraphExecution

`GraphExecution` is an [abstraction](#contract) of [graph executors](#implementations) that can...FIXME

## Contract

### streamTrigger { #streamTrigger }

```scala
streamTrigger(
  flow: Flow): Trigger
```

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
