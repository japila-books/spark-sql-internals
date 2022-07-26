# SetCatalogAndNamespace Logical Command

`SetCatalogAndNamespace` is a `UnaryCommand` that represents [USE SQL statement](../sql/AstBuilder.md#visitUse).

## Creating Instance

`SetCatalogAndNamespace` takes the following to be created:

* <span id="child"> Child [LogicalPlan](LogicalPlan.md)

`SetCatalogAndNamespace` is created when:

* `AstBuilder` is requested to [parse USE statement](../sql/AstBuilder.md#visitUse)

## Execution Planning

`SetCatalogAndNamespace` is resolved to [SetCatalogAndNamespaceExec](../physical-operators/SetCatalogAndNamespaceExec.md) physical command by [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy.
