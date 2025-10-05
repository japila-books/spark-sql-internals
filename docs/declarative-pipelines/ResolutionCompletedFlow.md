# ResolutionCompletedFlow

`ResolutionCompletedFlow` is an [extension](#contract) of the [Flow](Flow.md) abstraction for [flows](#implementations) with a [flow function executed](#funcResult) successfully or not ([ResolvedFlow](ResolvedFlow.md#funcResult) and [ResolutionFailedFlow](ResolutionFailedFlow.md#funcResult), respectively).

## Contract

### UnresolvedFlow { #flow }

```scala
flow: UnresolvedFlow
```

[UnresolvedFlow](UnresolvedFlow.md)

Used when:

* `CoreDataflowNodeProcessor` is requested to [processNode](CoreDataflowNodeProcessor.md#processNode)
* `DataflowGraph` is requested to [reanalyzeFlow](DataflowGraph.md#reanalyzeFlow)
* This `ResolutionCompletedFlow` is requested for the [destination identifier](#destinationIdentifier), [FlowFunction](#func), [identifier](#identifier), [QueryOrigin](#origin), [QueryContext](#queryContext)

### FlowFunctionResult { #funcResult }

```scala
funcResult: FlowFunctionResult
```

[FlowFunctionResult](FlowFunctionResult.md)

!!! note "FlowFunctionResult"
    `FlowFunctionResult` is used to assert that [ResolvedFlow](ResolvedFlow.md#funcResult) and [ResolutionFailedFlow](ResolutionFailedFlow.md#funcResult) are in proper state.

Used when:

* This `ResolutionCompletedFlow` is requested for the [sqlConf](#sqlConf)
* `ResolutionFailedFlow` is requested for the [failure](ResolutionFailedFlow.md#failure)
* `ResolvedFlow` is requested for the [logical query plan](ResolvedFlow.md#df) and [inputs](ResolvedFlow.md#inputs)
* `GraphValidations` is requested to [validatePersistedViewSources](GraphValidations.md#validatePersistedViewSources), [validateSuccessfulFlowAnalysis](GraphValidations.md#validateSuccessfulFlowAnalysis)

## Implementations

* [ResolutionFailedFlow](ResolutionFailedFlow.md)
* [ResolvedFlow](ResolvedFlow.md)
