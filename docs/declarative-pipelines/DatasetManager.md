# DatasetManager

!!! note "Scala object"
    `DatasetManager` is an `object` in Scala which means it is a class that has exactly one instance (itself).
    A Scala `object` is created lazily when it is referenced for the first time.

    Learn more in [Tour of Scala](https://docs.scala-lang.org/tour/singleton-objects.html).

## materializeDatasets { #materializeDatasets }

```scala
materializeDatasets(
  resolvedDataflowGraph: DataflowGraph,
  context: PipelineUpdateContext): DataflowGraph
```

`materializeDatasets`...FIXME

---

`materializeDatasets` is used when:

* `PipelineExecution` is requested to [initialize the dataflow graph](PipelineExecution.md#initializeGraph)

## constructFullRefreshSet { #constructFullRefreshSet }

```scala
constructFullRefreshSet(
  graphTables: Seq[Table],
  context: PipelineUpdateContext): (Seq[Table], Seq[TableIdentifier], Seq[TableIdentifier])
```

`constructFullRefreshSet` gives the following collections:

* [Table](Table.md)s to be refreshed (incl. a full refresh)
* `TableIdentifier`s of the tables to be refreshed (excl. fully refreshed)
* `TableIdentifier`s of the tables to be fully refreshed only

If there are tables to be fully refreshed yet not allowed for a full refresh, `constructFullRefreshSet` prints out the following INFO message to the logs:

```text
Skipping full refresh on some tables because pipelines.reset.allowed was set to false.
Tables: [fullRefreshNotAllowed]
```

`constructFullRefreshSet`...FIXME

---

`constructFullRefreshSet` is used when:

* `PipelineExecution` is requested to [initialize the dataflow graph](PipelineExecution.md#initializeGraph)
