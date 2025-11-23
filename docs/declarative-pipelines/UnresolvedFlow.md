# UnresolvedFlow

`UnresolvedFlow` is a [Flow](Flow.md) that represents a flow in the Python and SQL transformations in [Spark Declarative Pipelines](index.md):

* [register_flow](GraphElementRegistry.md#register_flow) in PySpark's decorators
* [CREATE FLOW AS INSERT INTO BY NAME](../logical-operators/CreateFlowCommand.md)
* [CREATE MATERIALIZED VIEW](../logical-operators/CreateMaterializedViewAsSelect.md)
* [CREATE STREAMING TABLE AS](../logical-operators/CreateStreamingTableAsSelect.md)
* [CREATE VIEW](../logical-operators/CreateView.md) and the other variants of [CREATE VIEW](../logical-operators/CreateViewCommand.md)

`UnresolvedFlow` is registered to a [GraphRegistrationContext](GraphRegistrationContext.md) with [register a flow](GraphRegistrationContext.md#registerFlow).

`UnresolvedFlow` is analyzed and resolved to [ResolvedFlow](ResolvedFlow.md) (by [FlowResolver](FlowResolver.md#attemptResolveFlow) when [DataflowGraph](DataflowGraph.md) is requested to [resolve](DataflowGraph.md#resolve)).

`UnresolvedFlow` [must have unique identifiers](GraphRegistrationContext.md#assertFlowIdentifierIsUnique) (or an `AnalysisException` is reported).

## Creating Instance

`UnresolvedFlow` takes the following to be created:

* <span id="identifier"> `TableIdentifier`
* <span id="destinationIdentifier"> Flow destination (`TableIdentifier`)
* <span id="func"> `FlowFunction`
* <span id="queryContext"> `QueryContext`
* <span id="sqlConf"> SQL Config
* [once](#once) flag
* <span id="origin"> `QueryOrigin`

`UnresolvedFlow` is created when:

* `PipelinesHandler` is requested to [define a flow](PipelinesHandler.md#defineFlow)
* `SqlGraphRegistrationContext` is requested to [handle the following SQL queries](SqlGraphRegistrationContext.md#processSqlQuery):
    * [CreateFlowCommand](SqlGraphRegistrationContext.md#CreateFlowCommand)
    * [CreateMaterializedViewAsSelect](SqlGraphRegistrationContext.md#CreateMaterializedViewAsSelect)
    * [CreateView](SqlGraphRegistrationContext.md#CreateView)
    * [CreateStreamingTableAsSelect](SqlGraphRegistrationContext.md#CreateStreamingTableAsSelect)
    * [CreateViewCommand](SqlGraphRegistrationContext.md#CreateViewCommand)

### once Flag { #once }

`UnresolvedFlow` is given the [once](Flow.md#once) flag when [created](#creating-instance).

`once` flag is disabled (`false`) explicitly for the following:

* [CreateFlowHandler](SqlGraphRegistrationContext.md#CreateFlowHandler)
* [CreateMaterializedViewAsSelectHandler](SqlGraphRegistrationContext.md#CreateMaterializedViewAsSelectHandler)
* [CreatePersistedViewCommandHandler](SqlGraphRegistrationContext.md#CreatePersistedViewCommandHandler)
* [CreateStreamingTableAsSelectHandler](SqlGraphRegistrationContext.md#CreateStreamingTableAsSelectHandler)
* [CreateTemporaryViewHandler](SqlGraphRegistrationContext.md#CreateTemporaryViewHandler)
* `PipelinesHandler` is requested to [define a flow](PipelinesHandler.md#defineFlow)

!!! note "No ONCE UnresolvedFlows"
    It turns out that all `UnresolvedFlow`s created are not [ONCE flows](Flow.md#once).

    As per [this commit]({{ spark.commit }}/4a4505457544e2402bd5f0fbd31eb6ca7ad611d4), it is said that:

    > However, the server does not currently implement this behavior yet.
    > To avoid accidentally releasing APIs that don't actually work, we should take these arguments out for now.
    > And add them back in when we actually support this functionality.
