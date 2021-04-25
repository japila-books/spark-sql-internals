# AlterTable Logical Command

`AlterTable` is a [Command](Command.md) for `ALTER TABLE` SQL commands:

* `ALTER TABLE ADD COLUMNS`
* `ALTER TABLE REPLACE COLUMNS`
* `ALTER TABLE CHANGE COLUMN`
* `ALTER TABLE RENAME COLUMN`
* `ALTER TABLE DROP COLUMNS`
* `ALTER TABLE SET TBLPROPERTIES`
* `ALTER TABLE UNSET TBLPROPERTIES`
* `ALTER TABLE SET LOCATION`

## Creating Instance

`AlterTable` takes the following to be created:

* <span id="catalog"> [TableCatalog](../connector/catalog/TableCatalog.md)
* <span id="ident"> `Identifier`
* <span id="table"> [NamedRelation](NamedRelation.md) for the table
* <span id="changes"> [TableChange](../connector/catalog/TableChange.md)s

`AlterTable` is created when:

* `CatalogV2Util` is requested to [createAlterTable](../connector/catalog/CatalogV2Util.md#createAlterTable)

## Execution Planning

`AlterTable` is resolved to [AlterTableExec](../physical-operators/AlterTableExec.md) by [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy.
