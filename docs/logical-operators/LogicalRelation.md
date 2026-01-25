---
title: LogicalRelation
---

# LogicalRelation Leaf Logical Operator

`LogicalRelation` is a [leaf logical operator](LeafNode.md) that represents a [BaseRelation](#relation) in a [logical query plan](LogicalPlan.md).

`LogicalRelation` is a [ExposesMetadataColumns](ExposesMetadataColumns.md) and [can add extra metadata columns to the output columns](#withMetadataColumns).

`LogicalRelation` is a [MultiInstanceRelation](MultiInstanceRelation.md).

## Creating Instance

`LogicalRelation` takes the following to be created:

* <span id="relation"> [BaseRelation](../BaseRelation.md)
* <span id="output"> Output Schema (`AttributeReference`s)
* <span id="catalogTable"> Optional [CatalogTable](../CatalogTable.md)
* <span id="isStreaming"> `isStreaming` flag

`LogicalRelation` is created using [apply](#apply) utility.

## Create LogicalRelation { #apply }

```scala
apply(
  relation: BaseRelation,
  isStreaming: Boolean = false): LogicalRelation
apply(
  relation: BaseRelation,
  table: CatalogTable): LogicalRelation
```

`apply` wraps the given [BaseRelation](../BaseRelation.md) into a `LogicalRelation` (so it could be used in a [logical query plan](LogicalPlan.md)).

`apply` creates a [LogicalRelation](#creating-instance) for the given [BaseRelation](../BaseRelation.md) (with a [CatalogTable](../CatalogTable.md) and `isStreaming` flag).

```text
import org.apache.spark.sql.sources.BaseRelation
val baseRelation: BaseRelation = ???

val data = spark.baseRelationToDataFrame(baseRelation)
```

---

`apply` is used when:

* [CreateTempViewUsing](CreateTempViewUsing.md) command is executed
* `FallBackFileSourceV2` logical resolution rule is executed
* `FileStreamSource` ([Spark Structured Streaming]({{ book.structured_streaming }}/datasources/file/FileStreamSource/#getBatch)) is requested to `getBatch`
* `HiveMetastoreCatalog` is requested to [convert a HiveTableRelation](../hive/HiveMetastoreCatalog.md#convertToLogicalRelation)
* [ResolveDataSource](../logical-analysis-rules/ResolveDataSource.md) logical analysis rule is executed (to [resolve a V1BatchSource](../logical-analysis-rules/ResolveDataSource.md#loadV1BatchSource))
* [ResolveSQLOnFile](../logical-analysis-rules/ResolveSQLOnFile.md) and [FindDataSourceTable](../logical-analysis-rules/FindDataSourceTable.md) logical evaluation rules are executed
* `SparkSession` is requested for a [DataFrame for a BaseRelation](../SparkSession.md#baseRelationToDataFrame)

## Refresh (Files of HadoopFsRelation) { #refresh }

??? note "LogicalPlan"

    ```scala
    refresh(): Unit
    ```

    `refresh` is part of [LogicalPlan](LogicalPlan.md#refresh) abstraction.

`refresh` requests the [FileIndex](../files/HadoopFsRelation.md#location) (of the [HadoopFsRelation](#relation)) to refresh.

??? note "HadoopFsRelation Supported Only"
    `refresh` does the work for [HadoopFsRelation](../files/HadoopFsRelation.md) relations only.

## Simple Text Representation { #simpleString }

??? note "QueryPlan"

    ```scala
    simpleString(
      maxFields: Int): String
    ```

    `simpleString` is part of the [QueryPlan](../catalyst/QueryPlan.md#simpleString) abstraction.

`simpleString` is made up of the [output schema](#output) (truncated to `maxFields`) and the [relation](#relation):

```text
Relation[[output]] [relation]
```

### Demo { #simpleString-demo }

```text
val q = spark.read.text("README.md")
val logicalPlan = q.queryExecution.logical

scala> println(logicalPlan.simpleString)
Relation[value#2] text
```

## Statistics { #computeStats }

??? note "LeafNode"

    ```scala
    computeStats(): Statistics
    ```

    `computeStats` is part of the [LeafNode](LeafNode.md#computeStats) abstraction.

`computeStats` takes the optional [CatalogTable](#catalogTable).

If available, `computeStats` requests the `CatalogTable` for the [CatalogStatistics](../CatalogTable.md#stats) that, if available, is requested to [toPlanStats](#toPlanStats) (with the `planStatsEnabled` flag enabled when either [spark.sql.cbo.enabled](../SQLConf.md#cboEnabled) or [spark.sql.cbo.planStats.enabled](../SQLConf.md#planStatsEnabled) is enabled).

Otherwise, `computeStats` creates a [Statistics](../cost-based-optimization/Statistics.md) with the `sizeInBytes` only to be the [sizeInBytes](../BaseRelation.md#sizeInBytes) of the [BaseRelation](#relation).

## Metadata Output Columns { #metadataOutput }

??? note "LogicalPlan"

    ```scala
    metadataOutput: Seq[AttributeReference]
    ```

    `metadataOutput` is part of the [LogicalPlan](LogicalPlan.md#metadataOutput) abstraction.

`metadataOutput` checks out whether this [BaseRelation](#relation) is a [HadoopFsRelation](../files/HadoopFsRelation.md).
If so, `metadataOutput` requests the [FileFormat](../files/HadoopFsRelation.md#fileFormat) (of this [BaseRelation](#relation)) for [metadata columns](../files/FileFormat.md#createFileMetadataCol).

Otherwise, `metadataOutput` returns no metadata columns (`Nil`).

??? note "Lazy Value"
    `metadataOutput` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

## Add Metadata Columns to Output Columns { #withMetadataColumns }

??? note "ExposesMetadataColumns"

    ```scala
    withMetadataColumns(): LogicalRelation
    ```

    `withMetadataColumns` is part of the [ExposesMetadataColumns](ExposesMetadataColumns.md#withMetadataColumns) abstraction.

`withMetadataColumns` creates a new `LogicalRelation` with the extra [metadata columns](#metadataOutput) added (if there are any) to this [output columns](#output).

Otherwise, `withMetadataColumns` does nothing.

## Demo

The following are two logically-equivalent batch queries described using different Spark APIs: Scala and SQL.

```scala
val format = "csv"
val path = "../datasets/people.csv"
```

```scala
val loadQuery = spark
  .read
  .format(format)
  .option("header", true)
  .load(path)
```

```text
scala> println(loadQuery.queryExecution.logical.numberedTreeString)
00 UnresolvedDataSource format: csv, isStreaming: false, paths: 1 provided
```

```scala
val selectQuery = sql(s"select * from `$format`.`$path`")
```

```text
scala> println(selectQuery.queryExecution.optimizedPlan.numberedTreeString)
00 Relation [_c0#75,_c1#76] csv
```
