---
title: CreateDataSourceTableCommand
---

# CreateDataSourceTableCommand Logical Command

`CreateDataSourceTableCommand` is a [LeafRunnableCommand](LeafRunnableCommand.md) that represents a [CreateTable](CreateTable.md) logical operator (with [DataSource Tables](../connectors/DDLUtils.md#isDatasourceTable)) at execution.

`CreateDataSourceTableCommand` uses the [SessionCatalog](../SessionState.md#catalog) to [create a table](../SessionCatalog.md#createTable) when [executed](#run).

## Creating Instance

`CreateDataSourceTableCommand` takes the following to be created:

* <span id="table"> [CatalogTable](../CatalogTable.md)
* <span id="ignoreIfExists"> `ignoreIfExists` flag

`CreateDataSourceTableCommand` is created when:

* [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) posthoc logical resolution rule is executed (to resolve [CreateTable](CreateTable.md) logical operators with [DataSource Tables](../connectors/DDLUtils.md#isDatasourceTable))

## Executing Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      sparkSession: SparkSession): Seq[Row]
    ```

    `run` is part of the [RunnableCommand](RunnableCommand.md#run) abstraction.

`run` requests the [SessionCatalog](../SessionState.md#catalog) to [tableExists](../SessionCatalog.md#tableExists). With `ignoreIfExists` flag enabled, `run` exits. Otherwise, `run` reports a `TableAlreadyExistsException`.

`run` uses the [locationUri](../CatalogStorageFormat.md#locationUri) as the `path` option.

`run` uses the [current database](../SessionCatalog.md#getCurrentDatabase) (of the [SessionCatalog](../SessionState.md#catalog)) unless defined.

`run` sets the [tracksPartitionsInCatalog](../CatalogTable.md#tracksPartitionsInCatalog) to the value of [spark.sql.hive.manageFilesourcePartitions](../configuration-properties.md#spark.sql.hive.manageFilesourcePartitions) configuration property.

`run` creates a [DataSource](../DataSource.md) to [resolveRelation](../DataSource.md#resolveRelation).

In the end, `run` requests the [SessionCatalog](../SessionState.md#catalog) to [create a table](../SessionCatalog.md#createTable).

??? note "AssertionError"

    `run` expects the following (or reports an `AssertionError`):

    * The [tableType](../CatalogTable.md#tableType) of the [CatalogTable](#table) is not `view`
    * The [provider](../CatalogTable.md#provider) of the [CatalogTable](#table) is defined
