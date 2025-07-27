# FlowPlanner

`FlowPlanner` is used to [plan a flow into a FlowExecution](#plan).

`FlowPlanner` is created alongside a [GraphExecution](GraphExecution.md#flowPlanner) (i.e., when [PipelineExecution](PipelineExecution.md) is requested to [start a pipeline](PipelineExecution.md#startPipeline)).

## Creating Instance

`FlowPlanner` takes the following to be created:

* <span id="graph"> [DataflowGraph](DataflowGraph.md)
* <span id="updateContext"> [PipelineUpdateContext](PipelineUpdateContext.md)
* <span id="triggerFor"> [Flow-to-Streaming-Trigger Conversion Function](#triggerFor)

`FlowPlanner` is created alongside a [GraphExecution](GraphExecution.md#flowPlanner).

### Flow-to-Streaming-Trigger Conversion Function { #triggerFor }

```scala
triggerFor: Flow => Trigger
```

`FlowPlanner` is given a function to convert a [Flow](Flow.md) into a streaming `Trigger` ([Spark Structured Streaming]({{ book.structured_streaming }}/Trigger/)) when [created](#creating-instance).

The `triggerFor` function is the [streamTrigger](GraphExecution.md#streamTrigger) function of the owning [GraphExecution](GraphExecution.md).

## Plan DataflowGraph { #plan }

```scala
plan(
  flow: ResolvedFlow): FlowExecution
```

`plan` creates a [FlowExecution](FlowExecution.md) (for the given [ResolvedFlow](ResolvedFlow.md)) as follows:

 FlowExecution | ResolvedFlow
-|-
 [BatchTableWrite](BatchTableWrite.md) | [CompleteFlow](CompleteFlow.md)
 [StreamingTableWrite](StreamingTableWrite.md) | [StreamingFlow](StreamingFlow.md)

---

`plan` is used when:

* `GraphExecution` is requested to [planAndStartFlow](GraphExecution.md#planAndStartFlow)
