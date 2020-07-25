# CatalogManager

## Creating Instance

`CatalogManager` takes the following to be created:

* <span id="conf"> [SQLConf](../../SQLConf.md)
* <span id="defaultSessionCatalog"> [CatalogPlugin](CatalogPlugin.md)
* <span id="v1SessionCatalog"> [SessionCatalog](../../spark-sql-SessionCatalog.md)

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
