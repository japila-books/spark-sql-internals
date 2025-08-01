# PipelineUpdateContext

`PipelineUpdateContext` is an [abstraction](#contract) of [pipeline update contexts](#implementations) that can [refreshTables](#refreshTables) (_among other things_).

## Contract (Subset) { #contract }

### refreshTables { #refreshTables }

```scala
refreshTables: TableFilter
```

Used when:

* `DatasetManager` is requested to [constructFullRefreshSet](DatasetManager.md#constructFullRefreshSet)
* `PipelineUpdateContext` is requested to [refreshFlows](PipelineUpdateContext.md#refreshFlows)

### Unresolved Dataflow Graph { #unresolvedGraph }

```scala
unresolvedGraph: DataflowGraph
```

The unresolved [DataflowGraph](DataflowGraph.md) of this pipeline update

Used when:

* `PipelineUpdateContext` is requested to [initializeGraph](#initializeGraph)

## Implementations

* [PipelineUpdateContextImpl](PipelineUpdateContextImpl.md)

## PipelineExecution { #pipelineExecution }

```scala
pipelineExecution: PipelineExecution
```

`PipelineUpdateContext` creates a [PipelineExecution](PipelineExecution.md) when created.

The `PipelineExecution` is created for this `PipelineUpdateContext`.

## refreshFlows { #refreshFlows }

```scala
refreshFlows: FlowFilter
```

??? note "Final Method"
    `refreshFlows` is a Scala **final method** and may not be overridden in [subclasses](#implementations).

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#final).

`refreshFlows`...FIXME

---

`refreshFlows` is used when:

* `TriggeredGraphExecution` is requested to [start](TriggeredGraphExecution.md#start)

## Initialize Dataflow Graph { #initializeGraph }

```scala
initializeGraph(): DataflowGraph
```

`initializeGraph`...FIXME

---

`initializeGraph` is used when:

* `PipelineExecution` is requested to [start the pipeline](PipelineExecution.md#startPipeline)
