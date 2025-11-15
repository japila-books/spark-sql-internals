# PipelineUpdateContextImpl

`PipelineUpdateContextImpl` is a [PipelineUpdateContext](PipelineUpdateContext.md).

## Creating Instance

`PipelineUpdateContextImpl` takes the following to be created:

* <span id="unresolvedGraph"> [DataflowGraph](PipelineUpdateContext.md#unresolvedGraph)
* <span id="eventCallback"> `PipelineEvent` Callback (`PipelineEvent => Unit`)
* <span id="refreshTables"> `TableFilter` of the tables to be refreshed (default: `AllTables`)
* <span id="fullRefreshTables"> `TableFilter` of the tables to be refreshed (default: `NoTables`)
* <span id="storageRoot"> [Storage root](PipelineUpdateContext.md#storageRoot)

While being created, `PipelineUpdateContextImpl` [validates the storage root](#validateStorageRoot).

`PipelineUpdateContextImpl` is created when:

* `PipelinesHandler` is requested to [run a pipeline](PipelinesHandler.md#startRun)

### Validate Storage Root { #validateStorageRoot }

```scala
validateStorageRoot(
  storageRoot: String): Unit
```

`validateStorageRoot` asserts that the given `storageRoot` meets the following requirements:

1. It is an absolute path
1. The schema is defined

Otherwise, `validateStorageRoot` reports a `SparkException`:

```text
Pipeline storage root must be an absolute path with a URI scheme (e.g., file://, s3a://, hdfs://).
Got: `[storage_root]`.
```
