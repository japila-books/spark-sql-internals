# ShowCreateTable Logical Command

`ShowCreateTable` is a [UnaryCommand](Command.md#UnaryCommand) that represents [SHOW CREATE TABLE](../sql/AstBuilder.md#visitShowCreateTable) SQL statement in a logical query plan.

`ShowCreateTable` is planned as [ShowCreateTableExec](../physical-operators/ShowCreateTableExec.md) physical command at [execution](#execution-planning).

## Creating Instance

`ShowCreateTable` takes the following to be created:

* <span id="child"> Child [LogicalPlan](LogicalPlan.md)
* <span id="asSerde"> `asSerde` flag (default: `false`)
* <span id="output"> Output [Attribute](../expressions/Attribute.md)s

`ShowCreateTable` is created when:

* `AstBuilder` is requested to [parse SHOW CREATE TABLE SQL statement](../sql/AstBuilder.md#visitShowCreateTable)

## Logical Analysis

The [child](#child) (that is initially a [UnresolvedTableOrView](UnresolvedTableOrView.md)) of `ShowCreateTable` is resolved using [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical analysis rule.

Child | ShowCreateTableCommandBase | Note
------|----------------------------|--------
 `ResolvedV1TableOrViewIdentifier` | `ShowCreateTableAsSerdeCommand` | Only when [asSerde](#asSerde) is used (`true`)
 `ResolvedViewIdentifier` | [ShowCreateTableCommand](ShowCreateTableCommand.md) |
 `ResolvedV1TableIdentifier` | [ShowCreateTableCommand](ShowCreateTableCommand.md) | Only with [spark.sql.legacy.useV1Command](../configuration-properties.md#spark.sql.legacy.useV1Command) enabled
 [ResolvedTable](ResolvedTable.md) | [ShowCreateTableCommand](ShowCreateTableCommand.md) | Only for `spark_catalog` session catalog and `hive` tables

## Execution Planning

`ShowCreateTable` (over a [ResolvedTable](ResolvedTable.md)) is planned as [ShowCreateTableExec](../physical-operators/ShowCreateTableExec.md) physical command using [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy.
