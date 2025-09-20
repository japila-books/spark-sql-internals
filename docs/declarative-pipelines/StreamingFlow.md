# StreamingFlow

`StreamingFlow` is a [ResolvedFlow](ResolvedFlow.md).

`StreamingFlow` is [planned for execution](FlowPlanner.md#plan) as a [StreamingTableWrite](StreamingTableWrite.md).

## Creating Instance

`StreamingFlow` takes the following to be created:

* <span id="flow"> [UnresolvedFlow](UnresolvedFlow.md)
* <span id="funcResult"> `FlowFunctionResult`
* <span id="mustBeAppend"> `mustBeAppend` flag (default: `false`)

`StreamingFlow` is created when:

* `FlowResolver` is requested to [convertResolvedToTypedFlow](FlowResolver.md#convertResolvedToTypedFlow)
