# SetCatalogAndNamespace Logical Command

`SetCatalogAndNamespace` is a [logical command](Command.md) that represents [UseStatement](UseStatement.md) parsed statement.

!!! info
    `SetCatalogAndNamespace` is resolved to [SetCatalogAndNamespaceExec](../physical-operators/SetCatalogAndNamespaceExec.md) physical command (when [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed).

## Creating Instance

`SetCatalogAndNamespace` takes the following to be created:

* <span id="catalogManager"> [CatalogManager](../connector/catalog/CatalogManager.md)
* <span id="catalogName"> Optional Catalog Name
* <span id="namespace"> Optional Namespace

`SetCatalogAndNamespace` is created when `ResolveCatalogs` logical analyzer rule is executed (and resolves a [UseStatement](UseStatement.md) parsed statement).
