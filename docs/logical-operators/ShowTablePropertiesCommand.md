# ShowTablePropertiesCommand Logical Command

`ShowTablePropertiesCommand` is a [RunnableCommand](RunnableCommand.md) that represents [ShowTableProperties](ShowTableProperties.md) logical operator with the following logical operators at execution:

* [ResolvedTable](ResolvedTable.md) for [V1Table](../connector/V1Table.md) in [SessionCatalog](../connector/catalog/CatalogV2Util.md#isSessionCatalog)
* `ResolvedView`

!!! note
    [ShowTableProperties](ShowTableProperties.md) logical operator can also be planned to [ShowTablePropertiesExec](../physical-operators/ShowTablePropertiesExec.md) physical command for the other cases.

## Creating Instance

`ShowTablePropertiesCommand` takes the following to be created:

* <span id="table"> `TableIdentifier`
* <span id="propertyKey"> (optional) Property Key

`ShowTablePropertiesCommand` is created when:

* [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule is executed (and resolves a [ShowTableProperties](ShowTableProperties.md) logical operator with a v1 catalog table or a view)
