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

## Implementations

* [PipelineUpdateContextImpl](PipelineUpdateContextImpl.md)

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
