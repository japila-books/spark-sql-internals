# CatalogV2Util Utility

## <span id="loadTable"> Loading Table

```scala
loadTable(
  catalog: CatalogPlugin,
  ident: Identifier,
  timeTravelSpec: Option[TimeTravelSpec] = None): Option[Table]
```

`loadTable` [getTable](#getTable).

---

`loadTable` is used when:

* [ResolveRelations](../../logical-analysis-rules/ResolveRelations.md) logical analysis rule is executed (and [lookupTableOrView](../../logical-analysis-rules/ResolveRelations.md#lookupTableOrView) and [resolveRelation](../../logical-analysis-rules/ResolveRelations.md#resolveRelation))
* `CatalogV2Util` is requested to [loadRelation](#loadRelation)
* `CatalogImpl` is requested to [load a table](../../CatalogImpl.md#loadTable)

## <span id="getTable"> getTable

```scala
getTable(
  catalog: CatalogPlugin,
  ident: Identifier,
  timeTravelSpec: Option[TimeTravelSpec] = None): Table
```

`getTable` requests the given [CatalogPlugin](CatalogPlugin.md) for the [TableCatalog](CatalogHelper.md#asTableCatalog) to [loadTable](TableCatalog.md#loadTable).

---

`getTable` is used when:

* `CatalogV2Util` is requested to [loadTable](#loadTable)
* `DataSourceV2Utils` is requested to [loadV2Source](../../connectors/DataSourceV2Utils.md#loadV2Source)

## <span id="getTableProviderCatalog"> getTableProviderCatalog

```scala
getTableProviderCatalog(
  provider: SupportsCatalogOptions,
  catalogManager: CatalogManager,
  options: CaseInsensitiveStringMap): TableCatalog
```

`getTableProviderCatalog`...FIXME

`getTableProviderCatalog` is used when:

* `DataFrameReader` is requested to [load](../../DataFrameReader.md#load) (for a data source that is a [SupportsCatalogOptions])

* `DataFrameWriter` is requested to [save](../../DataFrameWriter.md#save) (for a data source that is a [SupportsCatalogOptions])

## <span id="createAlterTable"> Creating AlterTable Logical Command

```scala
createAlterTable(
  originalNameParts: Seq[String],
  catalog: CatalogPlugin,
  tableName: Seq[String],
  changes: Seq[TableChange]): AlterTable
```

`createAlterTable` converts the [CatalogPlugin](CatalogPlugin.md) to a [TableCatalog](CatalogHelper.md#asTableCatalog).

`createAlterTable` creates an [AlterTable](../../logical-operators/AlterTable.md) (with an `UnresolvedV2Relation`).

`createAlterTable` is used when:

* [ResolveCatalogs](../../logical-analysis-rules/ResolveCatalogs.md) and [ResolveSessionCatalog](../../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rules are executed (and resolve `AlterTableAddColumnsStatement`, `AlterTableReplaceColumnsStatement`, `AlterTableAlterColumnStatement`, `AlterTableRenameColumnStatement`, `AlterTableDropColumnsStatement`, `AlterTableSetPropertiesStatement`, `AlterTableUnsetPropertiesStatement`, `AlterTableSetLocationStatement` operators)
