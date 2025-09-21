# StreamingFlow

`StreamingFlow` is a [ResolvedFlow](ResolvedFlow.md) that may or may not be [append](#mustBeAppend).

`StreamingFlow` is planned for execution as [StreamingTableWrite](StreamingTableWrite.md) by [FlowPlanner](FlowPlanner.md#plan).

## Creating Instance

`StreamingFlow` takes the following to be created:

* <span id="flow"> [UnresolvedFlow](UnresolvedFlow.md)
* <span id="funcResult"> `FlowFunctionResult`
* <span id="mustBeAppend"> `mustBeAppend` flag (default: `false`)

`StreamingFlow` is created when:

* `FlowResolver` is requested to [convertResolvedToTypedFlow](FlowResolver.md#convertResolvedToTypedFlow) (for [UnresolvedFlow](UnresolvedFlow.md)s with their results being streaming dataframes)
