# FlowResolver

## Creating Instance

`FlowResolver` takes the following to be created:

* <span id="rawGraph"> [DataflowGraph](DataflowGraph.md)

`FlowResolver` is created alongside a [CoreDataflowNodeProcessor](CoreDataflowNodeProcessor.md).

## attemptResolveFlow { #attemptResolveFlow }

```scala
attemptResolveFlow(
  flowToResolve: UnresolvedFlow,
  allInputs: Set[TableIdentifier],
  availableResolvedInputs: Map[TableIdentifier, Input]): ResolvedFlow
```

`attemptResolveFlow`...FIXME

---

`attemptResolveFlow` is used when:

* `CoreDataflowNodeProcessor` is requested to [processUnresolvedFlow](CoreDataflowNodeProcessor.md#processUnresolvedFlow)

### convertResolvedToTypedFlow { #convertResolvedToTypedFlow }

```scala
convertResolvedToTypedFlow(
  flow: UnresolvedFlow,
  funcResult: FlowFunctionResult): ResolvedFlow
```

`convertResolvedToTypedFlow` converts the given [UnresolvedFlow](UnresolvedFlow.md) as follows (and in that order):

* [AppendOnceFlow](AppendOnceFlow.md) for a [once flow](UnresolvedFlow.md#once)
* [StreamingFlow](StreamingFlow.md) for the given [FlowFunctionResult](FlowFunctionResult.md) with a streaming `DataFrame`
* [CompleteFlow](CompleteFlow.md), otherwise
