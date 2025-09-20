# CoreDataflowNodeProcessor

## Creating Instance

`CoreDataflowNodeProcessor` takes the following to be created:

* <span id="rawGraph"> [DataflowGraph](DataflowGraph.md)

`CoreDataflowNodeProcessor` is created when:

* `DataflowGraph` is requested to [resolve](DataflowGraph.md#resolve)

## FlowResolver { #flowResolver }

`CoreDataflowNodeProcessor` creates a [FlowResolver](FlowResolver.md) when [created](#creating-instance).

The `FlowResolver` is used to [process an UnresolvedFlow](#processUnresolvedFlow).

## processNode { #processNode }

```scala
processNode(
  node: GraphElement,
  upstreamNodes: Seq[GraphElement]): Seq[GraphElement]
```

`processNode`...FIXME

---

`processNode` is used when:

* `DataflowGraph` is requested to [resolve](DataflowGraph.md#resolve)

### processUnresolvedFlow { #processUnresolvedFlow }

```scala
processUnresolvedFlow(
  flow: UnresolvedFlow): ResolvedFlow
```

`processUnresolvedFlow`...FIXME
