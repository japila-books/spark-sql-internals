# AppendOnceFlow

`AppendOnceFlow` is a [ResolvedFlow](ResolvedFlow.md) with [once](Flow.md#once) enabled.

## Creating Instance

`AppendOnceFlow` takes the following to be created:

* <span id="flow"> [UnresolvedFlow](UnresolvedFlow.md)
* <span id="funcResult"> `FlowFunctionResult`

`AppendOnceFlow` is created when:

* `FlowResolver` is requested to [convertResolvedToTypedFlow](FlowResolver.md#convertResolvedToTypedFlow) (for [UnresolvedFlow](UnresolvedFlow.md)s with [once](UnresolvedFlow.md#once) enabled)
