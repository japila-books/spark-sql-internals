# AppendOnceFlow

`AppendOnceFlow` is a [ResolvedFlow](ResolvedFlow.md) with [once](Flow.md#once) enabled.

`AppendOnceFlow` is [created](#creating-instance) for an [UnresolvedFlow](UnresolvedFlow.md) with [once](UnresolvedFlow.md#once) flag enabled.

## Creating Instance

`AppendOnceFlow` takes the following to be created:

* <span id="flow"> [UnresolvedFlow](UnresolvedFlow.md)
* <span id="funcResult"> `FlowFunctionResult`

`AppendOnceFlow` is created when:

* `FlowResolver` is requested to [convertResolvedToTypedFlow](FlowResolver.md#convertResolvedToTypedFlow) (for an [UnresolvedFlow](UnresolvedFlow.md) with [once](UnresolvedFlow.md#once) flag enabled)

## once Flag { #once }

??? note "Flow"

    ```scala
    once: Boolean
    ```

    `once` is part of the [Flow](Flow.md#once) abstraction.

`once` is always enabled (`true`).
