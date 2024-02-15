---
title: CreateTableAsSelect
---

# CreateTableAsSelect Logical Command

`CreateTableAsSelect` is a `BinaryCommand` with [V2CreateTablePlan](V2CreateTablePlan.md) that represents the following high-level operators in a logical query plan:

* [CREATE TABLE AS SELECT](../sql/AstBuilder.md#visitCreateTable) SQL statement
* [DataFrameWriter.save](../DataFrameWriter.md#save)
* [DataFrameWriter.saveAsTable](../DataFrameWriter.md#saveAsTable)
* [DataFrameWriterV2.create](../DataFrameWriterV2.md#create)

`CreateTableAsSelect` is planned as `AtomicCreateTableAsSelectExec` or [CreateTableAsSelectExec](../physical-operators/CreateTableAsSelectExec.md) physical command at [execution](#execution-planning).

## Creating Instance

`CreateTableAsSelect` takes the following to be created:

* <span id="name"> Name [LogicalPlan](LogicalPlan.md)
* <span id="partitioning"> Partitioning [Transform](../connector/Transform.md)s
* <span id="query"> Query [LogicalPlan](LogicalPlan.md)
* <span id="tableSpec"> `TableSpec`
* <span id="writeOptions"> Write Options
* <span id="ignoreIfExists"> `ignoreIfExists` flag

`CreateTableAsSelect` is created when:

* `AstBuilder` is requested to [parse CREATE TABLE SQL statement](../sql/AstBuilder.md#visitCreateTable) (CREATE TABLE AS SELECT (CTAS))
* `DataFrameWriter` is requested to [save](../DataFrameWriter.md#save) (and [saveInternal](../DataFrameWriter.md#saveInternal)) and [saveAsTable](../DataFrameWriter.md#saveAsTable)
* `DataFrameWriterV2` is requested to [create a table](../DataFrameWriterV2.md#create)

## Execution Planning

`CreateTableAsSelect` is planned to one of the following by [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy (based on a [CatalogPlugin](../connector/catalog/CatalogPlugin.md) this `CreateTableAsSelect` is executed against):

* `AtomicCreateTableAsSelectExec` unary physical command on a [StagingTableCatalog](../connector/catalog/StagingTableCatalog.md)
* [CreateTableAsSelectExec](../physical-operators/CreateTableAsSelectExec.md) physical command, otherwise

## (Legacy) Logical Resolution

`CreateTableAsSelect` can be resolved to a `CreateTableV1` logical operator by [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule (for non-[isV2Provider](../logical-analysis-rules/ResolveSessionCatalog.md#isV2Provider) legacy providers).
