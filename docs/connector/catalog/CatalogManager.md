# CatalogManager

## Creating Instance

`CatalogManager` takes the following to be created:

* <span id="conf"> [SQLConf](../../SQLConf.md)
* [Default Session Catalog](#defaultSessionCatalog)
* <span id="v1SessionCatalog"> [SessionCatalog](../../SessionCatalog.md)

`CatalogManager` is created when:

* `BaseSessionStateBuilder` is requested for a [CatalogManager](../../BaseSessionStateBuilder.md#catalogManager)

## Default Session Catalog { #defaultSessionCatalog }

```scala
defaultSessionCatalog: CatalogPlugin
```

`CatalogManager` is given a [CatalogPlugin](CatalogPlugin.md) when [created](#creating-instance) for the **default session catalog** (which is a [V2SessionCatalog](../../BaseSessionStateBuilder.md#v2SessionCatalog)).

`defaultSessionCatalog` is used as the [delegate catalog](CatalogExtension.md#setDelegateCatalog) when `CatalogManager` is requested to [load a V2SessionCatalog](#loadV2SessionCatalog).

`defaultSessionCatalog` is used as the fallback catalog when `CatalogManager` is requested to [load a custom V2CatalogPlugin](#v2SessionCatalog).

## spark_catalog Default Catalog Name { #SESSION_CATALOG_NAME }

`CatalogManager` defines `spark_catalog` as the name of the default catalog ([V2SessionCatalog](../../V2SessionCatalog.md)).

`spark_catalog` is used as the default value of [spark.sql.defaultCatalog](../../configuration-properties.md#spark.sql.defaultCatalog) configuration property.

## Current Catalog Name { #_currentCatalogName }

```scala
_currentCatalogName: Option[String]
```

`_currentCatalogName` is the name of the [current catalog](#currentCatalog) and is undefined by default (`None`).

`_currentCatalogName` can be changed using [setCurrentCatalog](#setCurrentCatalog).

## Current CatalogPlugin { #currentCatalog }

```scala
currentCatalog: CatalogPlugin
```

`currentCatalog` uses the [current CatalogPlugin](#_currentCatalogName) if defined or falls back on [spark.sql.defaultCatalog](../../configuration-properties.md#spark.sql.defaultCatalog) configuration property.

`currentCatalog` is used when:

* `CatalogManager` is requested for the [current namespace](#currentNamespace), [setCurrentNamespace](#setCurrentNamespace) or [setCurrentCatalog](#setCurrentCatalog)

* `LookupCatalog` is requested to `currentCatalog`

* `ViewHelper` utility is requested to `generateViewProperties`

## Current Namespace { #currentNamespace }

```scala
currentNamespace: Array[String]
```

`currentNamespace`...FIXME

---

`currentNamespace` is used when:

* `ResolveNamespace` analysis rule is executed
* `GetCurrentDatabase` analysis rule is executed
* `CatalogAndIdentifier` extractor utility is requested to `unapply`
* `ViewHelper` utility is requested to `generateViewProperties`

## Setting Current Namespace { #setCurrentNamespace }

```scala
setCurrentNamespace(
  namespace: Array[String]): Unit
```

`setCurrentNamespace`...FIXME

---

`setCurrentNamespace` is used when:

* `SetCatalogAndNamespaceExec` physical command is executed

## Changing Current Catalog Name { #setCurrentCatalog }

```scala
setCurrentCatalog(
  catalogName: String): Unit
```

`setCurrentCatalog` checks out whether the given catalog name is different from the [currentCatalog](#currentCatalog)'s.

Only if the names are different, `setCurrentCatalog` makes it [_currentCatalogName](#_currentCatalogName) and "resets" [_currentNamespace](#_currentNamespace) (`None`). In the end, `setCurrentCatalog` requests the [SessionCatalog](#v1SessionCatalog) to [setCurrentDatabase](../../SessionCatalog.md#setCurrentDatabase) as [default](../../SessionCatalog.md#DEFAULT_DATABASE).

---

`setCurrentCatalog` is used when:

* `SetCatalogCommand` logical command is executed
* [SetCatalogAndNamespaceExec](../../physical-operators/SetCatalogAndNamespaceExec.md) physical command is executed

## Finding CatalogPlugin by Name { #catalog }

```scala
catalog(
  name: String): CatalogPlugin
```

`catalog` returns the [v2 session catalog](#v2SessionCatalog) when the given name is [spark_catalog](#SESSION_CATALOG_NAME).

Otherwise, `catalog` looks up the name in [catalogs](#catalogs) internal registry. When not found, `catalog` tries to [load a CatalogPlugin by name](Catalogs.md#load) (and registers it in [catalogs](#catalogs) internal registry).

---

`catalog` is used when:

* `CatalogManager` is requested to [isCatalogRegistered](#isCatalogRegistered) and [currentCatalog](#currentCatalog)
* `CatalogV2Util` utility is requested to [getTableProviderCatalog](CatalogV2Util.md#getTableProviderCatalog)
* `CatalogAndMultipartIdentifier`, `CatalogAndNamespace` and `CatalogAndIdentifier` utilities are requested to extract a [CatalogPlugin](CatalogPlugin.md) (`unapply`)

## isCatalogRegistered { #isCatalogRegistered }

```scala
isCatalogRegistered(
  name: String): Boolean
```

`isCatalogRegistered`...FIXME

`isCatalogRegistered` is used when `Analyzer` is requested to [expandRelationName](../../Analyzer.md#expandRelationName).

## v2SessionCatalog { #v2SessionCatalog }

```scala
v2SessionCatalog: CatalogPlugin
```

`v2SessionCatalog`...FIXME

---

`v2SessionCatalog` is used when:

* `CatalogManager` is requested to [look up a CatalogPlugin by name](#catalog)
* `CatalogV2Util` is requested to `getTableProviderCatalog`
* `CatalogAndIdentifier` utility is requested to extract a CatalogPlugin and an identifier from a multi-part name (`unapply`)

## loadV2SessionCatalog { #loadV2SessionCatalog }

```scala
loadV2SessionCatalog(): CatalogPlugin
```

`loadV2SessionCatalog` [loads](Catalogs.md#load) the default [CatalogPlugin](CatalogPlugin.md) that handles [spark_catalog](#SESSION_CATALOG_NAME) catalog.

!!! note "spark.sql.catalog.spark_catalog"
    [spark.sql.catalog.spark_catalog](../../configuration-properties.md#spark.sql.catalog.spark_catalog) configuration property is used to specify the fully-qualified class name of the session [CatalogPlugin](CatalogPlugin.md).

Only if the `CatalogPlugin` is a [CatalogExtension](CatalogExtension.md), `loadV2SessionCatalog` assigns this [default session CatalogPlugin](#defaultSessionCatalog) to be the [delegate CatalogPlugin](CatalogExtension.md#setDelegateCatalog).

---

`loadV2SessionCatalog` is used when:

* `CatalogManager` is requested for the [user-specified v2 session catalog](#v2SessionCatalog)
