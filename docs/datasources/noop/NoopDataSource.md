# NoopDataSource

`NoopDataSource` is a [SimpleTableProvider](../../connector/SimpleTableProvider.md) of writable [NoopTable](#getTable)s.

## <span id="DataSourceRegister"><span id="shortName"> Short Name

`NoopDataSource` is registered under **noop** alias.

## <span id="getTable"> Creating Table

```scala
getTable(
  options: CaseInsensitiveStringMap): Table
```

`getTable` simply creates a [NoopTable](NoopTable.md).

`getTable` is part of the [SimpleTableProvider](../../connector/SimpleTableProvider.md#getTable) abstraction.
