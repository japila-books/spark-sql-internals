---
title: CreateDataSourceTableAsSelectCommand
---

# CreateDataSourceTableAsSelectCommand Logical Command

`CreateDataSourceTableAsSelectCommand` is a [LeafRunnableCommand](LeafRunnableCommand.md) that [creates a DataSource table](#run) with the data (from a [AS query](#query)).

!!! note
    A [DataSource table](../connectors/DDLUtils.md#isDatasourceTable) is a Spark SQL native table that uses any data source but Hive (per `USING` clause).

??? note "CreateDataSourceTableCommand Logical Operator"
    [CreateDataSourceTableCommand](CreateDataSourceTableCommand.md) is used instead for [CreateTable](CreateTable.md) logical operators with no [AS query](#query).

## Creating Instance

`CreateDataSourceTableAsSelectCommand` takes the following to be created:

* <span id="table"> [CatalogTable](../CatalogTable.md)
* <span id="mode"> [SaveMode](../DataFrameWriter.md#SaveMode)
* <span id="query"> `AS` query ([LogicalPlan](LogicalPlan.md))
* <span id="outputColumnNames"> Output Column Names

`CreateDataSourceTableAsSelectCommand` is created when:

* [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) post-hoc logical resolution rule is executed (to resolve [CreateTable](CreateTable.md) logical operators with a [datasource table](../connectors/DDLUtils.md#isDatasourceTable))

## Executing Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      sparkSession: SparkSession): Seq[Row]
    ```

    `run` is part of the [RunnableCommand](RunnableCommand.md#run) abstraction.

`run`...FIXME
