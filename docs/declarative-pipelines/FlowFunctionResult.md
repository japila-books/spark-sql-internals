# FlowFunctionResult

`FlowFunctionResult` is the result of executing a [FlowFunction](FlowFunction.md).

`FlowFunctionResult` is a part of [ResolutionCompletedFlow](ResolutionCompletedFlow.md#funcResult)s.

## Creating Instance

`FlowFunctionResult` takes the following to be created:

* <span id="requestedInputs"> `TableIdentifier`s of the requested inputs
* <span id="batchInputs"> `ResolvedInput`s of the batch inputs
* <span id="streamingInputs"> `ResolvedInput`s of the streaming inputs
* <span id="usedExternalInputs"> `TableIdentifier` of the external inputs
* [DataFrame](#dataFrame)
* <span id="sqlConf"> SQL Configuration
* <span id="analysisWarnings"> `AnalysisWarning` (default: undefined)

`FlowFunctionResult` is created when:

* `FlowAnalysis` is requested to [createFlowFunctionFromLogicalPlan](FlowAnalysis.md#createFlowFunctionFromLogicalPlan)

### DataFrame { #dataFrame }

`FlowFunctionResult` is given a [DataFrame](../DataFrame.md) (produced by the corresponding flow) when [created](#creating-instance).

When this `DataFrame` is streaming, `FlowResolver` [converts](FlowResolver.md#convertResolvedToTypedFlow) an [UnresolvedFlow](UnresolvedFlow.md) to a [StreamingFlow](StreamingFlow.md).

## Inputs { #inputs }

```scala
inputs: Set[TableIdentifier]
```

`inputs` are all the `TableIdentifier`s of the [Input](Input.md)s of this [batchInputs](#batchInputs) and [streamingInputs](#streamingInputs).

---

`inputs` is used when:

* `ResolvedFlow` is requested for the [inputs](ResolvedFlow.md#inputs)
