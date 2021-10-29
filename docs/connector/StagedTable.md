# StagedTable

`StagedTable` is an [extension](#contract) of the [Table](Table.md) abstraction for tables that can [abort](#abortStagedChanges) or [commit](#commitStagedChanges) staged changes.

## Contract

### <span id="abortStagedChanges"> abortStagedChanges

```java
void abortStagedChanges()
```

Used when:

* `AtomicReplaceTableExec` physical command is executed
* `TableWriteExecHelper` is requested to [writeToTable](../physical-operators/TableWriteExecHelper.md#writeToTable)

### <span id="commitStagedChanges"> commitStagedChanges

```java
void commitStagedChanges()
```

Used when:

* `AtomicReplaceTableExec` physical command is `executed`
* `TableWriteExecHelper` is requested to [writeToTable](../physical-operators/TableWriteExecHelper.md#writeToTable)
