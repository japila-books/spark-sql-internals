---
hide:
    - toc
---

# UnresolvedFlow

`UnresolvedFlow` is a [Flow](Flow.md) that represents flows in the following Python and SQL transformations in [Spark Declarative Pipelines](index.md):

* [register_flow](GraphElementRegistry.md#register_flow) in PySpark's decorators
* [CREATE FLOW ... AS INSERT INTO ... BY NAME](../logical-operators/CreateFlowCommand.md)
* [CREATE MATERIALIZED VIEW](../logical-operators/CreateMaterializedViewAsSelect.md)
* [CREATE STREAMING TABLE ... AS](../logical-operators/CreateStreamingTableAsSelect.md)
* [CREATE VIEW](../logical-operators/CreateView.md) and the other variants of [CREATE VIEW](../logical-operators/CreateViewCommand.md)

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
* `SqlGraphRegistrationContext` is requested to [handle the following logical commands](SqlGraphRegistrationContext.md#processSqlQuery):
    * [CreateFlowCommand](SqlGraphRegistrationContext.md#CreateFlowCommand)
    * [CreateMaterializedViewAsSelect](SqlGraphRegistrationContext.md#CreateMaterializedViewAsSelect)
    * [CreateView](SqlGraphRegistrationContext.md#CreateView)
    * [CreateStreamingTableAsSelect](SqlGraphRegistrationContext.md#CreateStreamingTableAsSelect)
    * [CreateViewCommand](SqlGraphRegistrationContext.md#CreateViewCommand)
