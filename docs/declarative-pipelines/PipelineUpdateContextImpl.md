# PipelineUpdateContextImpl

`PipelineUpdateContextImpl` is a [PipelineUpdateContext](PipelineUpdateContext.md).

## Creating Instance

`PipelineUpdateContextImpl` takes the following to be created:

* <span id="unresolvedGraph"> [DataflowGraph](DataflowGraph.md)
* <span id="eventCallback"> `PipelineEvent` Callback (`PipelineEvent => Unit`)

`PipelineUpdateContextImpl` is created when:

* `PipelinesHandler` ([Spark Connect]({{ book.spark_connect }})) is requested to [startRun](PipelinesHandler.md#startRun)
