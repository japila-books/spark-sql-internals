# TableWriteExecHelper Unary Physical Commands

`TableWriteExecHelper` is an extension of the [V2TableWriteExec](V2TableWriteExec.md) and [SupportsV1Write](SupportsV1Write.md) abstractions for [unary physical commands](#implementations) that can [write to a table](#writeToTable).

## Implementations

* [AtomicCreateTableAsSelectExec](AtomicCreateTableAsSelectExec.md)
* [AtomicReplaceTableAsSelectExec](AtomicReplaceTableAsSelectExec.md)
* [CreateTableAsSelectExec](CreateTableAsSelectExec.md)
* [ReplaceTableAsSelectExec](ReplaceTableAsSelectExec.md)

## <span id="writeToTable"> Writing to Table

```scala
writeToTable(
  catalog: TableCatalog,
  table: Table,
  writeOptions: CaseInsensitiveStringMap,
  ident: Identifier): Seq[InternalRow]
```

`writeToTable`...FIXME
