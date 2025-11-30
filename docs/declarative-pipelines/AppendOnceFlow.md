# AppendOnceFlow

`AppendOnceFlow` is a [ResolvedFlow](ResolvedFlow.md) with [once](#once) flag enabled.

`AppendOnceFlow` is [created](#creating-instance) when [CoreDataflowNodeProcessor](CoreDataflowNodeProcessor.md) is requested to [process](CoreDataflowNodeProcessor.md#processNode) an [UnresolvedFlow](UnresolvedFlow.md) with [once](UnresolvedFlow.md#once) flag enabled (and [FlowResolver](FlowResolver.md) is requested to [convertResolvedToTypedFlow](FlowResolver.md#convertResolvedToTypedFlow)).

`AppendOnceFlow` reads source(s) completely and appends data to the target, [just once](#once).

## Creating Instance

`AppendOnceFlow` takes the following to be created:

* <span id="flow"> [UnresolvedFlow](UnresolvedFlow.md)
* <span id="funcResult"> [FlowFunctionResult](FlowFunctionResult.md)

`AppendOnceFlow` is created when:

* `FlowResolver` is requested to [convertResolvedToTypedFlow](FlowResolver.md#convertResolvedToTypedFlow) (for an [UnresolvedFlow](UnresolvedFlow.md) with [once](UnresolvedFlow.md#once) flag enabled)

## once Flag { #once }

??? note "Flow"

    ```scala
    once: Boolean
    ```

    `once` is part of the [Flow](Flow.md#once) abstraction.

`once` is always enabled (`true`).
