# ResolvedTable Leaf Logical Operator

`ResolvedTable` is a [leaf logical operator](LeafNode.md).

## Creating Instance

`ResolvedTable` takes the following to be created:

* <span id="catalog"> [TableCatalog](../connector/catalog/TableCatalog.md)
* <span id="identifier"> `Identifier`
* <span id="table"> [Table](../connector/Table.md)

`ResolvedTable` is created when:

* [ResolveTables](../logical-analysis-rules/ResolveTables.md) logical resolution rule is executed (for [UnresolvedTable](UnresolvedTable.md) and [UnresolvedTableOrView](UnresolvedTableOrView.md))
* [ResolveRelations](../logical-analysis-rules/ResolveRelations.md) logical resolution rule is executed ([lookupTableOrView](../logical-analysis-rules/ResolveRelations.md#lookupTableOrView))
* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (for `RenameTable`)
