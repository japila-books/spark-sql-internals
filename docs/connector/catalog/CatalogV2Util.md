# CatalogV2Util

## Load Table { #loadTable }

```scala
loadTable(
  catalog: CatalogPlugin,
  ident: Identifier,
  timeTravelSpec: Option[TimeTravelSpec] = None,
  writePrivilegesString: Option[String] = None): Option[Table]
```

`loadTable` [loads a table](#getTable) (by the given `Identifier` and the optional [TimeTravelSpec](../../time-travel/TimeTravelSpec.md) using the given [CatalogPlugin](CatalogPlugin.md)).

!!! note
    `loadTable` is a Scala `Option`-aware wrapper around [CatalogV2Util.getTable](#getTable).

---

`loadTable` is used when:

* [ResolveRelations](../../logical-analysis-rules/ResolveRelations.md) logical analysis rule is executed (and [lookupTableOrView](../../logical-analysis-rules/ResolveRelations.md#lookupTableOrView) and [resolveRelation](../../logical-analysis-rules/ResolveRelations.md#resolveRelation))
* `CatalogV2Util` is requested to [loadRelation](#loadRelation)
* `CatalogImpl` is requested to [load a table](../../CatalogImpl.md#loadTable)

## Load Table { #getTable }

```scala
getTable(
  catalog: CatalogPlugin,
  ident: Identifier,
  timeTravelSpec: Option[TimeTravelSpec] = None,
  writePrivilegesString: Option[String] = None): Table
```

`getTable` assumes the given [CatalogPlugin](CatalogPlugin.md) to be a [TableCatalog](CatalogHelper.md#asTableCatalog) to [load a table](TableCatalog.md#loadTable) (by the given `Identifier`).

---

`getTable` requests the given [CatalogPlugin](CatalogPlugin.md) for the [TableCatalog](CatalogHelper.md#asTableCatalog) to [load a table](TableCatalog.md#loadTable) (possibly versioned based on the [TimeTravelSpec](../../time-travel/TimeTravelSpec.md)).

!!! note
    It is not allowed for `getTable` to be called with both `timeTravelSpec` and `writePrivilegesString` defined.

!!! note "NoSuchTableException for versioned tables"
    [TableCatalog](TableCatalog.md) throws a `NoSuchTableException` exception for versioned tables by default (and leaves other behaviour to custom [TableCatalog](TableCatalog.md#implementations)s, e.g. [Delta Lake]({{ book.delta }}/DeltaCatalog)).

---

`getTable` is used when:

* `CatalogV2Util` is requested to [load a table](#loadTable)
* `DataSourceV2Utils` is requested to [loadV2Source](../../connectors/DataSourceV2Utils.md#loadV2Source)

## getTableProviderCatalog { #getTableProviderCatalog }

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
