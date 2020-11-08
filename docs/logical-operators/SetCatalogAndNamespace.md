# SetCatalogAndNamespace Logical Command

`SetCatalogAndNamespace` is a [logical command](Command.md) that represents [UseStatement](UseStatement.md) parsed statement.

## Creating Instance

`SetCatalogAndNamespace` takes the following to be created:

* <span id="catalogManager"> [CatalogManager](../connector/catalog/CatalogManager.md)
* <span id="catalogName"> Optional Catalog Name
* <span id="namespace"> Optional Namespace

`SetCatalogAndNamespace` is created when [ResolveCatalogs](../logical-analysis-rules/ResolveCatalogs.md) logical analyzer rule is executed (and resolves a [UseStatement](UseStatement.md) parsed statement).

## Execution Planning

`SetCatalogAndNamespace` is resolved to [SetCatalogAndNamespaceExec](../physical-operators/SetCatalogAndNamespaceExec.md) physical command (when [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed).
