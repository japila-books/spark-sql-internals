---
title: BatchTableWrite
---

# BatchTableWrite Flow Execution

`BatchTableWrite` is a [FlowExecution](FlowExecution.md) that writes a batch `DataFrame` to a [Table](#destination).

## Creating Instance

`BatchTableWrite` takes the following to be created:

* <span id="identifier"> `TableIdentifier`
* <span id="flow"> [ResolvedFlow](ResolvedFlow.md)
* <span id="graph"> [DataflowGraph](DataflowGraph.md)
* <span id="destination"> [Table](Table.md)
* <span id="updateContext"> [PipelineUpdateContext](PipelineUpdateContext.md)
* <span id="sqlConf"> Configuration Properties

`BatchTableWrite` is created when:

* `FlowPlanner` is requested to [plan a CompleteFlow](FlowPlanner.md#plan)

## Execute { #executeInternal }

??? note "FlowExecution"

    ```scala
    executeInternal(): Future[Unit]
    ```

    `executeInternal` is part of the [FlowExecution](FlowExecution.md#executeInternal) abstraction.

`executeInternal` activates the [configuration properties](#sqlConf) in the current [SparkSession](FlowExecution.md#spark).

`executeInternal` requests this [PipelineUpdateContext](#updateContext) for the [FlowProgressEventLogger](PipelineUpdateContext.md#flowProgressEventLogger) to [recordRunning](FlowProgressEventLogger.md#recordRunning) with this [ResolvedFlow](#flow).

`executeInternal` requests this [DataflowGraph](#graph) to [re-analyze](DataflowGraph.md#reanalyzeFlow) this [ResolvedFlow](#flow) to get the [DataFrame](ResolvedFlow.md#df) (the logical query plan)

`executeInternal` executes `append` batch write asynchronously:

1. Creates a [DataFrameWriter](../DataFrameWriter.md) for the batch query's logical plan (the [DataFrame](ResolvedFlow.md#df)).
1. Sets the write format to the [format](Table.md#format) of this [Table](#destination).
1. In the end, `executeInternal` appends the rows to this [Table](#destination) (using [DataFrameWriter.saveAsTable](../DataFrameWriter.md#saveAsTable) operator).

## isStreaming { #isStreaming }

??? note "FlowExecution"

    ```scala
    isStreaming: Boolean
    ```

    `isStreaming` is part of the [FlowExecution](FlowExecution.md#isStreaming) abstraction.

`isStreaming` is always disabled (`false`).
