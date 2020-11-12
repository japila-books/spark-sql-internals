# AtomicTableWriteExec Physical Commands

`AtomicTableWriteExec` is an extension of the [V2TableWriteExec](V2TableWriteExec.md) abstraction for [physical commands](#implementations) that [writeToStagedTable](#writeToStagedTable) and [support V1 write path](SupportsV1Write.md).

## Implementations

* AtomicCreateTableAsSelectExec
* AtomicReplaceTableAsSelectExec

## <span id="writeToStagedTable"> writeToStagedTable

```scala
writeToStagedTable(
  stagedTable: StagedTable,
  writeOptions: CaseInsensitiveStringMap,
  ident: Identifier): Seq[InternalRow]
```

`writeToStagedTable`...FIXME
