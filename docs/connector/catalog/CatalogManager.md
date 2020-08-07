# CatalogManager

## Creating Instance

`CatalogManager` takes the following to be created:

* <span id="conf"> [SQLConf](../../SQLConf.md)
* <span id="defaultSessionCatalog"> [CatalogPlugin](CatalogPlugin.md)
* <span id="v1SessionCatalog"> [SessionCatalog](../../SessionCatalog.md)

`CatalogManager` is created when `BaseSessionStateBuilder` is requested for a [CatalogManager](../../BaseSessionStateBuilder.md#catalogManager).

## <span id="currentCatalog"> CatalogPlugin

```scala
currentCatalog: CatalogPlugin
```

`currentCatalog`...FIXME

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

## <span id="setCurrentCatalog"> Setting Current Catalog

```scala
setCurrentCatalog(
  catalogName: String): Unit
```

`setCurrentCatalog`...FIXME

`setCurrentCatalog` is used when `SetCatalogAndNamespaceExec` physical command is executed.

## <span id="catalog"> catalog

```scala
catalog(
  name: String): CatalogPlugin
```

`catalog`...FIXME

`catalog` is used when:

* `CatalogManager` is requested to [isCatalogRegistered](#isCatalogRegistered) and [currentCatalog](#currentCatalog)

* `CatalogV2Util` is requested to `getTableProviderCatalog`

* `CatalogAndMultipartIdentifier`, `CatalogAndNamespace` and `CatalogAndIdentifier` utilities are requested to extract a CatalogPlugin (`unapply`)

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
