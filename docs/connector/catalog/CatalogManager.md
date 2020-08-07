# CatalogManager

## Creating Instance

`CatalogManager` takes the following to be created:

* <span id="conf"> [SQLConf](../../SQLConf.md)
* <span id="defaultSessionCatalog"> [CatalogPlugin](CatalogPlugin.md)
* <span id="v1SessionCatalog"> [SessionCatalog](../../SessionCatalog.md)

`CatalogManager` is created when `BaseSessionStateBuilder` is requested for a [CatalogManager](../../BaseSessionStateBuilder.md#catalogManager).

## <span id="SESSION_CATALOG_NAME"> Default Catalog Name

`CatalogManager` defines `spark_catalog` as the name of the default catalog ([V2SessionCatalog](../../V2SessionCatalog.md)).

`spark_catalog` is used as the default value of [spark.sql.defaultCatalog](../../spark-sql-properties.md#spark.sql.defaultCatalog) configuration property.

## <span id="_currentCatalogName"> Current Catalog Name

```scala
_currentCatalogName: Option[String]
```

`_currentCatalogName` is the name of the [current catalog](#currentCatalog) and is undefined by default (`None`).

`_currentCatalogName` can be changed using [setCurrentCatalog](#setCurrentCatalog).

## <span id="currentCatalog"> Current CatalogPlugin

```scala
currentCatalog: CatalogPlugin
```

`currentCatalog` uses the [current CatalogPlugin](#_currentCatalogName) if defined or falls back on [spark.sql.defaultCatalog](../../spark-sql-properties.md#spark.sql.defaultCatalog) configuration property.

`currentCatalog` is used when:

* `CatalogManager` is requested for the [current namespace](#currentNamespace), [setCurrentNamespace](#setCurrentNamespace) or [setCurrentCatalog](#setCurrentCatalog)

* `ShowCurrentNamespaceExec` physical command is executed

* `LookupCatalog` is requested to `currentCatalog`

* `ViewHelper` utility is requested to `generateViewProperties`

## <span id="currentNamespace"> Current Namespace

```scala
currentNamespace: Array[String]
```

`currentNamespace`...FIXME

`currentNamespace` is used when:

* `ShowCurrentNamespaceExec` physical command is executed

* `ResolveNamespace` analysis rule is executed

* `GetCurrentDatabase` analysis rule is executed

* `CatalogAndIdentifier` extractor utility is requested to `unapply`

* `ViewHelper` utility is requested to `generateViewProperties`

## <span id="setCurrentNamespace"> Setting Current Namespace

```scala
setCurrentNamespace(
  namespace: Array[String]): Unit
```

`setCurrentNamespace`...FIXME

`setCurrentNamespace` is used when `SetCatalogAndNamespaceExec` physical command is executed.

## <span id="setCurrentCatalog"> Changing Current Catalog Name

```scala
setCurrentCatalog(
  catalogName: String): Unit
```

`setCurrentCatalog` checks out whether the given catalog name is different from the [currentCatalog](#currentCatalog)'s.

Only if the names are different, `setCurrentCatalog` makes it [_currentCatalogName](#_currentCatalogName) and "resets" [_currentNamespace](#_currentNamespace) (`None`). In the end, `setCurrentCatalog` requests the [SessionCatalog](#v1SessionCatalog) to [setCurrentDatabase](../../SessionCatalog.md#setCurrentDatabase) as [default](../../SessionCatalog.md#DEFAULT_DATABASE).

`setCurrentCatalog` is used when [SetCatalogAndNamespaceExec](../../physical-operators/SetCatalogAndNamespaceExec.md) physical command is executed.

## <span id="catalog"> Looking Up CatalogPlugin by Name

```scala
catalog(
  name: String): CatalogPlugin
```

`catalog` returns the [v2 session catalog](#v2SessionCatalog) when the given name is [spark_catalog](#SESSION_CATALOG_NAME).

Otherwise, `catalog` looks up the name in [catalogs](#catalogs) internal registry. When not found, `catalog` tries to [load a CatalogPlugin by name](Catalogs.md#load) (and registers it in [catalogs](#catalogs) internal registry).

`catalog` is used when:

* `CatalogManager` is requested to [isCatalogRegistered](#isCatalogRegistered) and [currentCatalog](#currentCatalog)

* `CatalogV2Util` utility is requested to [getTableProviderCatalog](CatalogV2Util.md#getTableProviderCatalog)

* `CatalogAndMultipartIdentifier`, `CatalogAndNamespace` and `CatalogAndIdentifier` utilities are requested to extract a [CatalogPlugin](CatalogPlugin.md) (`unapply`)

## <span id="isCatalogRegistered"> isCatalogRegistered

```scala
isCatalogRegistered(
  name: String): Boolean
```

`isCatalogRegistered`...FIXME

`isCatalogRegistered` is used when `Analyzer` is requested to [expandRelationName](../../Analyzer.md#expandRelationName).

## <span id="v2SessionCatalog"> v2SessionCatalog Method

```scala
v2SessionCatalog: CatalogPlugin
```

`v2SessionCatalog`...FIXME

`v2SessionCatalog` is used when:

* `CatalogManager` is requested to [look up a CatalogPlugin by name](#catalog)

* `CatalogV2Util` is requested to `getTableProviderCatalog`

* `CatalogAndIdentifier` utility is requested to extract a CatalogPlugin and an identifier from a multi-part name (`unapply`)

## <span id="loadV2SessionCatalog"> loadV2SessionCatalog Internal Method

```scala
loadV2SessionCatalog(): CatalogPlugin
```

`loadV2SessionCatalog`...FIXME

`loadV2SessionCatalog` is used when `CatalogManager` is requested for a [CatalogPlugin](#v2SessionCatalog).
