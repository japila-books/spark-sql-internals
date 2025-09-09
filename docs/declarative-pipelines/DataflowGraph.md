# DataflowGraph

`DataflowGraph` is a [GraphRegistrationContext](GraphRegistrationContext.md) with [tables](#tables), [views](#views) and [flows](#flows) fully-qualified, resolved and de-duplicated.

## Creating Instance

`DataflowGraph` takes the following to be created:

* <span id="flows"> [Flow](Flow.md)s
* <span id="tables"> [Table](Table.md)s
* <span id="views"> [View](View.md)s

`DataflowGraph` is created when:

* `DataflowGraph` is requested to [reanalyzeFlow](#reanalyzeFlow)
* `GraphRegistrationContext` is requested to [convert to a DataflowGraph](GraphRegistrationContext.md#toDataflowGraph)

## reanalyzeFlow { #reanalyzeFlow }

```scala
reanalyzeFlow(
  srcFlow: Flow): ResolvedFlow
```

`reanalyzeFlow` [finds the upstream datasets](GraphOperations.md#dfsInternal).

`reanalyzeFlow` finds the upstream flows (for the upstream datasets that could be found in the [resolvedFlows](#resolvedFlows) registry).

`reanalyzeFlow` finds the upstream views (for the upstream datasets that could be found in the [view](#view) registry).

`reanalyzeFlow` creates a new (sub)[DataflowGraph](#creating-instance) for the upstream flows, views and a single table (the [destination](Flow.md#identifier) of the given [Flow](Flow.md)).

`reanalyzeFlow` requests the subgraph to [resolve](#resolve) and returns the [ResolvedFlow](ResolvedFlow.md) for the given [Flow](Flow.md).

---

`reanalyzeFlow` is used when:

* `BatchTableWrite` is requested to [executeAsync](FlowExecution.md#executeAsync) (and [executeInternal](BatchTableWrite.md#executeInternal))
* `StreamingTableWrite` is requested to [executeAsync](FlowExecution.md#executeAsync) (and [startStream](StreamingTableWrite.md#startStream))

## Resolve { #resolve }

```scala
resolve(): DataflowGraph
```

`resolve`...FIXME

---

`resolve` is used when:

* `DataflowGraph` is requested to [reanalyzeFlow](#reanalyzeFlow)
* `PipelineExecution` is requested to [initializeGraph](PipelineExecution.md#initializeGraph)

## Validate { #validate }

```scala
validate(): DataflowGraph
```

`validate`...FIXME

---

`validate` is used when:

* `PipelineExecution` is requested to [initialize the dataflow graph](PipelineExecution.md#initializeGraph)
