# TableWriteExecHelper Unary Physical Commands

`TableWriteExecHelper` is an extension of the [V2TableWriteExec](V2TableWriteExec.md) and `SupportsV1Write` abstractions for [unary physical commands](#implementations) that can [write to a table](#writeToTable).

## Implementations

* `AtomicCreateTableAsSelectExec`
* `AtomicReplaceTableAsSelectExec`
* [CreateTableAsSelectExec](CreateTableAsSelectExec.md)
* `ReplaceTableAsSelectExec`

## <span id="writeToTable"> writeToTable

```scala
writeToTable(
  catalog: TableCatalog,
  table: Table,
  writeOptions: CaseInsensitiveStringMap,
  ident: Identifier): Seq[InternalRow]
```

`writeToTable`...FIXME

`writeToTable` is used when:

* `CreateTableAsSelectExec` is requested to [run](CreateTableAsSelectExec.md#run)
* `AtomicCreateTableAsSelectExec` is requested to `run`
* `ReplaceTableAsSelectExec` is requested to `run`
* `AtomicReplaceTableAsSelectExec` is requested to `run`
