# ResolvedFlow

`ResolvedFlow` is a marker extension of the [ResolutionCompletedFlow](ResolutionCompletedFlow.md) and [Input](Input.md) abstractions for [resolved flows](#implementations) that are [resolved](FlowFunctionResult.md#resolved) successfully.

`ResolvedFlow`s are [Flow](Flow.md)s with [FlowFunctionResult](ResolutionCompletedFlow.md#funcResult) being [resolved](FlowFunctionResult.md#resolved).

`ResolvedFlow` is a mere wrapper around [FlowFunctionResult](ResolutionCompletedFlow.md#funcResult).

## Implementations

* [AppendOnceFlow](AppendOnceFlow.md)
* [CompleteFlow](CompleteFlow.md)
* [StreamingFlow](StreamingFlow.md)
