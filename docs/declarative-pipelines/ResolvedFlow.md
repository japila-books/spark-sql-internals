# ResolvedFlow

`ResolvedFlow` is an extension of the [ResolutionCompletedFlow](ResolutionCompletedFlow.md) and [Input](Input.md) abstractions for [resolved flows](#implementations) that are [resolved](FlowFunctionResult.md#resolved) successfully.

`ResolvedFlow`s are [Flow](Flow.md)s with [FlowFunctionResult](ResolutionCompletedFlow.md#funcResult) being [resolved](FlowFunctionResult.md#resolved).

`ResolvedFlow` is a mere wrapper around [FlowFunctionResult](ResolutionCompletedFlow.md#funcResult).

## Implementations

* [AppendOnceFlow](AppendOnceFlow.md)
* [CompleteFlow](CompleteFlow.md)
* [StreamingFlow](StreamingFlow.md)

## Inputs { #inputs }

```scala
inputs: Set[TableIdentifier]
```

`inputs` requests this [FlowFunctionResult](#funcResult) for the [inputs](FlowFunctionResult.md#inputs).

---

`inputs` is used when:

* `DatasetManager` is requested to [materializeViews](DatasetManager.md#materializeViews)
* `GraphOperations` is requested for the [flowNodes](GraphOperations.md#flowNodes)
* `GraphValidations` is requested to [validateGraphIsTopologicallySorted](GraphValidations.md#validateGraphIsTopologicallySorted)
