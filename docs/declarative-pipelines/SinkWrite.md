---
title: SinkWrite
---

# SinkWrite Flow Execution

`SinkWrite` is a [StreamingFlowExecution](StreamingFlowExecution.md) that writes a streaming `DataFrame` to a [Sink](#destination).

`SinkWrite` represents a [StreamingFlow](StreamingFlow.md) with a [Sink](Sink.md) as the [output destination](ResolutionCompletedFlow.md#destinationIdentifier) at execution.

When [executed](#startStream), `SinkWrite` starts a streaming query to append new rows to an [output table](#destination).

## Creating Instance

`SinkWrite` takes the following to be created:

* <span id="identifier"> [TableIdentifier](FlowExecution.md#identifier)
* <span id="flow"> [ResolvedFlow](StreamingFlowExecution.md#flow)
* <span id="graph"> [DataflowGraph](DataflowGraph.md)
* <span id="updateContext"> [PipelineUpdateContext](FlowExecution.md#updateContext)
* <span id="checkpointPath"> [Checkpoint Location](StreamingFlowExecution.md#checkpointPath)
* <span id="trigger"> [Streaming Trigger](StreamingFlowExecution.md#trigger)
* <span id="destination"> [Destination](FlowExecution.md#destination) ([Sink](Sink.md))
* <span id="sqlConf"> [SQL Configuration](StreamingFlowExecution.md#sqlConf)

`SinkWrite` is created when:

* `FlowPlanner` is requested to [plan a ResolvedFlow](FlowPlanner.md#plan)

## Start Streaming Query { #startStream }

??? note "StreamingFlowExecution"

    ```scala
    startStream(): StreamingQuery
    ```

    `startStream` is part of the [StreamingFlowExecution](StreamingFlowExecution.md#startStream) abstraction.

`startStream` builds the logical query plan of this [flow](#flow)'s structured query (requesting the [DataflowGraph](#graph) to [reanalyze](DataflowGraph.md#reanalyzeFlow) this [flow](#flow)).

`startStream` creates a `DataStreamWriter` ([Spark Structured Streaming]({{ book.structured_streaming }}/DataStreamWriter/)) with the following:

`DataStreamWriter`'s Property | Value
-|-
 `queryName` | This [displayName](FlowExecution.md#displayName)
 `checkpointLocation` option | This [checkpoint path](#checkpointPath)
 `trigger` | This [streaming trigger](#trigger)
 `outputMode` | [Append]({{ book.structured_streaming }}/OutputMode/#append) (always)
 `format` | The [format](Sink.md#format) of this [output sink](#destination)
 `options` | The [options](Sink.md#options) of this [output sink](#destination)

In the end, `startStream` starts the streaming write query to this [output table](#destination).
