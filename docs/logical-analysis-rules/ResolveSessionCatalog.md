---
title: ResolveSessionCatalog
---

# ResolveSessionCatalog Logical Resolution Rule

`ResolveSessionCatalog` is a logical resolution rule (`Rule[LogicalPlan]`).

## Creating Instance

`ResolveSessionCatalog` takes the following to be created:

* <span id="catalogManager"> [CatalogManager](../connector/catalog/CatalogManager.md)
* <span id="conf"> [SQLConf](../SQLConf.md)
* <span id="isTempView"> `isTempView` Function (`Seq[String] => Boolean`)
* <span id="isTempFunction"> `isTempFunction` Function (`String => Boolean`)

`ResolveSessionCatalog` is created as an extended resolution rule when [HiveSessionStateBuilder](../hive/HiveSessionStateBuilder.md#analyzer) and [BaseSessionStateBuilder](../BaseSessionStateBuilder.md#analyzer) are requested for the analyzer.

## Executing Rule { #apply }

??? note "Rule"

    ```scala
    apply(
      plan: LogicalPlan): LogicalPlan
    ```

    `apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply` resolves the following logical operators:

* [AddColumns](../logical-operators/AddColumns.md)
* [CreateTable](../logical-operators/CreateTable.md) with the default [session catalog](../connector/catalog/CatalogV2Util.md#isSessionCatalog) (`spark_catalog`) and the [table provider not v2](#isV2Provider)
* [CreateTableAsSelect](../logical-operators/CreateTableAsSelect.md) with the default [session catalog](../connector/catalog/CatalogV2Util.md#isSessionCatalog) (`spark_catalog`) and the [table provider not v2](#isV2Provider)
* _others_

### constructV1TableCmd { #constructV1TableCmd }

```scala
constructV1TableCmd(
  query: Option[LogicalPlan],
  tableSpec: TableSpecBase,
  ident: TableIdentifier,
  tableSchema: StructType,
  partitioning: Seq[Transform],
  ignoreIfExists: Boolean,
  storageFormat: CatalogStorageFormat,
  provider: String): CreateTable
```

`constructV1TableCmd` [buildCatalogTable](#buildCatalogTable) and creates a new [CreateTable](../logical-operators/CreateTable.md) logical operator.

### isV2Provider { #isV2Provider }

```scala
isV2Provider(
  provider: String): Boolean
```

`isV2Provider` [looks up the DataSourceV2 implementation](../DataSource.md#lookupDataSourceV2) (the [TableProvider](../connector/TableProvider.md)) for the given `provider`.

!!! note "provider"
    The `provider` name can be an alias (a short name) or a fully-qualified class name.

`isV2Provider` is `true` for all the [connectors](../connector/index.md) but [FileDataSourceV2](../files/FileDataSourceV2.md). Otherwise, `isV2Provider` is `false`.
