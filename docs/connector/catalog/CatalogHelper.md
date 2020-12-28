# CatalogHelper

`CatalogHelper` is a Scala implicit class that adds extensions methods to [CatalogPlugin](#plugin).

!!! tip
    Learn more on [implicit classes]({{ scala.docs }}/overviews/core/implicit-classes.html) in the official documentation of Scala 2.

## Creating Instance

`CatalogHelper` takes the following to be created:

* <span id="plugin"> [CatalogPlugin](CatalogPlugin.md)

## <span id="asNamespaceCatalog"> asNamespaceCatalog

```scala
asNamespaceCatalog: SupportsNamespaces
```

`asNamespaceCatalog` returns the [CatalogPlugin](#plugin) if it is a [SupportsNamespaces](SupportsNamespaces.md) or throws an `AnalysisException` otherwise:

```text
Cannot use catalog [name]: does not support namespaces
```

`asNamespaceCatalog` is used when:

* [ResolveCatalogs](../../logical-analysis-rules/ResolveCatalogs.md) logical resolution rule is executed
* [DataSourceV2Strategy](../../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed
* [DropNamespaceExec](../../physical-operators/DropNamespaceExec.md) physical command is executed

## <span id="asTableCatalog"> asTableCatalog

```scala
asTableCatalog: TableCatalog
```

`asTableCatalog` returns the [CatalogPlugin](#plugin) if it is a [TableCatalog](TableCatalog.md) or throws an `AnalysisException` otherwise:

```text
Cannot use catalog [name]: not a TableCatalog
```

`asTableCatalog` is used when:

* [ResolveTables](../../logical-analysis-rules/ResolveTables.md), [ResolveRelations](../../logical-analysis-rules/ResolveRelations.md), [ResolveCatalogs](../../logical-analysis-rules/ResolveCatalogs.md) and [ResolveSessionCatalog](../../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rules are executed
* `CatalogV2Util` utility is used to [load a table](CatalogV2Util.md#loadTable), [createAlterTable](CatalogV2Util.md#createAlterTable) and [getTableProviderCatalog](CatalogV2Util.md#getTableProviderCatalog)
* `DataFrameWriter` is requested to [insertInto](../../DataFrameWriter.md#insertInto) and [saveAsTable](../../DataFrameWriter.md#saveAsTable)
* `DataFrameWriterV2` is [created](../../DataFrameWriterV2.md#catalog)
* [DataSourceV2Strategy](../../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed
* [DropNamespaceExec](../../physical-operators/DropNamespaceExec.md) physical command is executed
