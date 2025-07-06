# BatchTableWrite

`BatchTableWrite` is a [FlowExecution](FlowExecution.md) that writes a batch `DataFrame` to a [Table](#destination).

## Creating Instance

`BatchTableWrite` takes the following to be created:

* <span id="identifier"> `TableIdentifier`
* <span id="flow"> `ResolvedFlow`
* <span id="graph"> [DataflowGraph](DataflowGraph.md)
* <span id="destination"> [Table](Table.md)
* <span id="updateContext"> [PipelineUpdateContext](PipelineUpdateContext.md)
* <span id="sqlConf"> Configuration Properties

`BatchTableWrite` is created when:

* FIXME

## executeInternal { #executeInternal }

```scala
executeInternal(): Future[Unit]
```

`executeInternal`...FIXME

---

`executeInternal` is used when:

* FIXME
