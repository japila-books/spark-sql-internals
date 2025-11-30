# CompleteFlow

`CompleteFlow` is a [ResolvedFlow](ResolvedFlow.md) that may or may not be [append](#mustBeAppend).

`CompleteFlow` is planned for execution as [BatchTableWrite](BatchTableWrite.md) by [FlowPlanner](FlowPlanner.md#plan).

## Creating Instance

`CompleteFlow` takes the following to be created:

* <span id="flow"> [UnresolvedFlow](UnresolvedFlow.md)
* <span id="funcResult"> [FlowFunctionResult](FlowFunctionResult.md)
* <span id="mustBeAppend"> `mustBeAppend` flag (default: `false`)

`CompleteFlow` is created when:

* `FlowResolver` is requested to [convertResolvedToTypedFlow](FlowResolver.md#convertResolvedToTypedFlow) (for [UnresolvedFlow](UnresolvedFlow.md)s that are neither [once](UnresolvedFlow.md#once) nor their results are streaming dataframes)
