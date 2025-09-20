# PipelineUpdateContextImpl

`PipelineUpdateContextImpl` is a [PipelineUpdateContext](PipelineUpdateContext.md).

## Creating Instance

`PipelineUpdateContextImpl` takes the following to be created:

* <span id="unresolvedGraph"> [DataflowGraph](PipelineUpdateContext.md#unresolvedGraph)
* <span id="eventCallback"> `PipelineEvent` Callback (`PipelineEvent => Unit`)
* <span id="refreshTables"> `TableFilter` of the tables to be refreshed (default: `AllTables`)
* <span id="fullRefreshTables"> `TableFilter` of the tables to be refreshed (default: `NoTables`)

`PipelineUpdateContextImpl` is created when:

* `PipelinesHandler` is requested to [run a pipeline](PipelinesHandler.md#startRun)
