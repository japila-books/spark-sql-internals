# TableChange

`TableChange` is an abstraction of [changes to a table](#implementations) (when `TableCatalog` is requested to [alter one](TableCatalog.md#alterTable)).

## Implementations

### <span id="ColumnChange"> ColumnChange

`ColumnChange` is an extension of the `TableChange` abstraction for the column changes:

* `AddColumn`
* `DeleteColumn`
* [RenameColumn](#RenameColumn)
* `UpdateColumnComment`
* `UpdateColumnNullability`
* `UpdateColumnPosition`
* `UpdateColumnType`

#### <span id="RenameColumn"> RenameColumn

`RenameColumn` is a `TableChange` to rename a field.

`RenameColumn` is created when `TableChange` is requested for [one](#renameColumn)

### RemoveProperty

### SetProperty

## <span id="renameColumn"> Creating RenameColumn

```java
TableChange renameColumn(
  String[] fieldNames,
  String newName)
```

??? note "Static Method"
    `renameColumn` is declared as **static** that is invoked without a reference to a particular object.

    Learn more in the [Java Language Specification]({{ java.spec }}/jls-8.html#jls-8.4.3.2).

`renameColumn` creates a [RenameColumn](#RenameColumn) table change.

`renameColumn` is used when:

* `RenameColumn` logical command is requested for the [table changes](../../logical-operators/AlterTableCommand.md#RenameColumn)
