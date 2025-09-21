# UnresolvedFlow

`UnresolvedFlow` is a [Flow](Flow.md).

`UnresolvedFlow` is registered to a [GraphRegistrationContext](GraphRegistrationContext.md) with [registerFlow](GraphRegistrationContext.md#registerFlow).

`UnresolvedFlow` is analyzed and resolved to [ResolvedFlow](ResolvedFlow.md) (by [FlowResolver](FlowResolver.md#attemptResolveFlow) when [DataflowGraph](DataflowGraph.md) is requested to [resolve](DataflowGraph.md#resolve)).

`UnresolvedFlow` [must have unique identifiers](GraphRegistrationContext.md#assertFlowIdentifierIsUnique) (or an `AnalysisException` is reported).

## Creating Instance

`UnresolvedFlow` takes the following to be created:

* <span id="identifier"> `TableIdentifier`
* <span id="destinationIdentifier"> Flow destination (`TableIdentifier`)
* <span id="func"> `FlowFunction`
* <span id="queryContext"> `QueryContext`
* <span id="sqlConf"> SQL Config
* <span id="once"> `once` flag
* <span id="origin"> `QueryOrigin`

`UnresolvedFlow` is created when:

* `PipelinesHandler` is requested to [define a flow](PipelinesHandler.md#defineFlow)
* `SqlGraphRegistrationContext` is requested to [handle the following pipeline commands](SqlGraphRegistrationContext.md#processSqlQuery):
    * [CreateFlowCommand](SqlGraphRegistrationContext.md#CreateFlowCommand)
    * [CreateMaterializedViewAsSelect](SqlGraphRegistrationContext.md#CreateMaterializedViewAsSelect)
    * [CreateView](SqlGraphRegistrationContext.md#CreateView)
    * [CreateStreamingTableAsSelect](SqlGraphRegistrationContext.md#CreateStreamingTableAsSelect)
    * [CreateViewCommand](SqlGraphRegistrationContext.md#CreateViewCommand)
