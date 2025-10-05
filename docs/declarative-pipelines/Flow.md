# Flow

`Flow` is an [extension](#contract) of the [GraphElement](GraphElement.md) abstraction for [flows](#implementations) in dataflow graphs.

Flows must be successfully analyzed, thus resolved, in order to determine whether they are streaming or not.

## Contract (Subset)

### FlowFunction { #func }

```scala
func: FlowFunction
```

[FlowFunction](FlowFunction.md) of this `Flow`

Used to create an [UnresolvedFlow](UnresolvedFlow.md#func)

See:

* [ResolutionCompletedFlow](ResolutionCompletedFlow.md#func)
* [UnresolvedFlow](UnresolvedFlow.md#func)

### once

```scala
once: Boolean
```

Indicates whether this is a **ONCE flow** or not. ONCE flows can only be run once per full refresh.

* ONCE flows are planned for execution as [AppendOnceFlow](AppendOnceFlow.md)s ([FlowResolver](FlowResolver.md#convertResolvedToTypedFlow))
* ONCE flows are marked as IDLE when `TriggeredGraphExecution` is requested to start flows in [topologicalExecution](TriggeredGraphExecution.md#topologicalExecution).
* [ONCE flows must be batch (not streaming)](GraphValidations.md#validateFlowStreamingness).
* For ONCE flows or when the [logical plan for the flow](ResolvedFlow.md#df) is streaming, `GraphElementTypeUtils` considers a [ResolvedFlow](ResolvedFlow.md) as a `STREAMING_TABLE` (in [getDatasetTypeForMaterializedViewOrStreamingTable](GraphElementTypeUtils.md#getDatasetTypeForMaterializedViewOrStreamingTable)).

Default: `false`

See:

* [AppendOnceFlow](AppendOnceFlow.md#once)
* [UnresolvedFlow](UnresolvedFlow.md#once)

Used when:

* `TriggeredGraphExecution` is requested to [topologicalExecution](TriggeredGraphExecution.md#topologicalExecution)
* `PipelinesErrors` is requested to [checkStreamingErrorsAndRetry](PipelinesErrors.md#checkStreamingErrorsAndRetry) (to skip ONCE flows with no exception)
* `GraphValidations` is requested to [validateFlowStreamingness](GraphValidations.md#validateFlowStreamingness)
* `GraphElementTypeUtils` is requested to [getDatasetTypeForMaterializedViewOrStreamingTable](GraphElementTypeUtils.md#getDatasetTypeForMaterializedViewOrStreamingTable)
* `FlowResolver` is requested to [convertResolvedToTypedFlow](FlowResolver.md#convertResolvedToTypedFlow)

## Implementations

* [ResolutionCompletedFlow](ResolutionCompletedFlow.md)
* [UnresolvedFlow](UnresolvedFlow.md)
