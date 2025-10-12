# StreamingFlow

`StreamingFlow` is a [ResolvedFlow](ResolvedFlow.md) that may or may not be [append](#mustBeAppend).

`StreamingFlow` represents an [UnresolvedFlow](UnresolvedFlow.md) with a [streaming dataframe](FlowFunctionResult.md#dataFrame) in a dataflow graph.

`StreamingFlow` is [planned for execution](FlowPlanner.md#plan) as [StreamingTableWrite](StreamingTableWrite.md) (assuming that the [Output](DataflowGraph.md#output) of [this flow](#flow)'s [destination](ResolutionCompletedFlow.md#destinationIdentifier) is a [Table](Table.md)).

## Creating Instance

`StreamingFlow` takes the following to be created:

* <span id="flow"> [UnresolvedFlow](ResolutionCompletedFlow.md#flow)
* <span id="funcResult"> [FlowFunctionResult](ResolutionCompletedFlow.md#funcResult)
* [mustBeAppend](#mustBeAppend) flag

`StreamingFlow` is created when:

* `FlowResolver` is requested to [convertResolvedToTypedFlow](FlowResolver.md#convertResolvedToTypedFlow) (for an [UnresolvedFlow](UnresolvedFlow.md) with a [streaming dataframe](FlowFunctionResult.md#dataFrame))

### mustBeAppend Flag { #mustBeAppend }

```scala
mustBeAppend: Boolean
```

`StreamingFlow` is given `mustBeAppend` flag when [created](#creating-instance).

Default: `false`

The value of `mustBeAppend` flag is based on whether there are more than one flow to [this flow](#flow)'s [destination](UnresolvedFlow.md#destinationIdentifier) in a dataflow graph or not.

When enabled (`true`), [this UnresolvedFlow](#flow) is planned for execution with the `Append` output mode (as the other flows will then get their results overwritten).

!!! note "StreamingTableWrite ignores mustBeAppend"
    `StreamingFlow` is planned for execution as [StreamingTableWrite](StreamingTableWrite.md) with no execution differences based on the `mustBeAppend` flag.
