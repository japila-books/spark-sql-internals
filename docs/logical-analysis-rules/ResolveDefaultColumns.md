---
title: ResolveDefaultColumns
---

# ResolveDefaultColumns Logical Resolution Rule

`ResolveDefaultColumns` is a logical resolution rule (a [Rule](../catalyst/Rule.md) to transform a [LogicalPlan](../logical-operators/LogicalPlan.md)) that resolves the following operators (top-down):

* [InsertIntoStatement](#InsertIntoStatement)s
* [UpdateTable](#UpdateTable)s
* [MergeIntoTable](#MergeIntoTable)s

`ResolveDefaultColumns` is executed only when [spark.sql.defaultColumn.enabled](../configuration-properties.md#spark.sql.defaultColumn.enabled) is enabled.

`ResolveDefaultColumns` is part of the [Resolution](../Analyzer.md#Resolution) fixed-point rule batch of the [Analyzer](../Analyzer.md).

## Creating Instance

`ResolveDefaultColumns` takes the following to be created:

* <span id="catalog"> [SessionCatalog](../SessionCatalog.md)

`ResolveDefaultColumns` is created when:

* `Analyzer` is requested for the [batches](../Analyzer.md#batches)

## Executing Rule { #apply }

??? note "Rule"

    ```scala
    apply(
      plan: LogicalPlan): LogicalPlan
    ```

    `apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

??? note "Noop with `spark.sql.defaultColumn.enabled` disabled"
    `ResolveDefaultColumns` does nothing and returns the logical plan in-tact when [spark.sql.defaultColumn.enabled](../configuration-properties.md#spark.sql.defaultColumn.enabled) is disabled.

With [spark.sql.defaultColumn.enabled](../configuration-properties.md#spark.sql.defaultColumn.enabled) enabled, `apply` resolves the following operators (top-down):

* [InsertIntoStatement](#InsertIntoStatement)s
* [UpdateTable](#UpdateTable)s
* [MergeIntoTable](#MergeIntoTable)s

### InsertIntoStatement { #InsertIntoStatement }

For [InsertIntoStatement](../logical-operators/InsertIntoStatement.md)s that [insertsFromInlineTable](#insertsFromInlineTable), `apply` [resolveDefaultColumnsForInsertFromInlineTable](#resolveDefaultColumnsForInsertFromInlineTable).

For [InsertIntoStatement](../logical-operators/InsertIntoStatement.md)s with a [Project](../logical-operators/Project.md) query that is not a `Star`, `apply` [resolveDefaultColumnsForInsertFromProject](#resolveDefaultColumnsForInsertFromProject).

### UpdateTable { #UpdateTable }

For [UpdateTable](../logical-operators/UpdateTable.md)s, `apply` [resolveDefaultColumnsForUpdate](#resolveDefaultColumnsForUpdate).

### MergeIntoTable { #MergeIntoTable }

For [MergeIntoTable](../logical-operators/MergeIntoTable.md)s, `apply` [resolveDefaultColumnsForMerge](#resolveDefaultColumnsForMerge).

## constantFoldCurrentDefaultsToExistDefaults { #constantFoldCurrentDefaultsToExistDefaults }

```scala
constantFoldCurrentDefaultsToExistDefaults(
  tableSchema: StructType,
  statementType: String): StructType
```

Only with [spark.sql.defaultColumn.enabled](../configuration-properties.md#spark.sql.defaultColumn.enabled) enabled, `constantFoldCurrentDefaultsToExistDefaults`...FIXME

Otherwise, `constantFoldCurrentDefaultsToExistDefaults` does nothing (a _noop_) and returns the given [table schema](../types/StructType.md) intact.

---

`constantFoldCurrentDefaultsToExistDefaults` is used when:

* `CatalogV2Util` is requested to [addField](../connector/catalog/CatalogV2Util.md#addField)
* [AlterTableAddColumnsCommand](../logical-operators/AlterTableAddColumnsCommand.md) logical command is executed (to [constantFoldCurrentDefaultsToExistDefaults](../logical-operators/AlterTableAddColumnsCommand.md#constantFoldCurrentDefaultsToExistDefaults))
* [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) logical resolution rule is executed (to resolve a [CreateTable](../logical-operators/CreateTable.md) logical operator with a [DataSource table](../connectors/DDLUtils.md#isDatasourceTable))
* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (to resolve [CreateTable](../logical-operators/CreateTable.md) and `ReplaceTable` logical operators)
