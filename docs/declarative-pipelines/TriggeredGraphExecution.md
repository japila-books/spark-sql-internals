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
