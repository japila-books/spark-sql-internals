# DataflowGraph

## Creating Instance

`DataflowGraph` takes the following to be created:

* <span id="flows"> [Flow](Flow.md)s
* <span id="tables"> [Table](Table.md)s
* <span id="views"> [View](View.md)s

`DataflowGraph` is created when:

* `DataflowGraph` is requested to [reanalyzeFlow](#reanalyzeFlow)
* `GraphRegistrationContext` is requested to [toDataflowGraph](GraphRegistrationContext.md#toDataflowGraph)

## reanalyzeFlow { #reanalyzeFlow }

```scala
reanalyzeFlow(
  srcFlow: Flow): ResolvedFlow
```

`reanalyzeFlow`...FIXME

---

`reanalyzeFlow` is used when:

* `BatchTableWrite` is requested to [executeInternal](BatchTableWrite.md#executeInternal)
* `StreamingTableWrite` is requested to [startStream](StreamingTableWrite.md#startStream)

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
