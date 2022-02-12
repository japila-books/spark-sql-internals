# LogicalRelation Leaf Logical Operator

`LogicalRelation` is a [leaf logical operator](LeafNode.md) that represents a [BaseRelation](#relation) in a [logical query plan](LogicalPlan.md).

`LogicalRelation` is a [MultiInstanceRelation](MultiInstanceRelation.md).

## Creating Instance

`LogicalRelation` takes the following to be created:

* <span id="relation"> [BaseRelation](../BaseRelation.md)
* <span id="output"> Output Schema (`AttributeReference`s)
* <span id="catalogTable"> Optional [CatalogTable](../CatalogTable.md)
* <span id="isStreaming"> `isStreaming` flag

`LogicalRelation` is created using [apply](#apply) factory.

## <span id="apply"> apply Utility

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

`apply` is used when:

* `SparkSession` is requested for a [DataFrame for a BaseRelation](../SparkSession.md#baseRelationToDataFrame)
* [CreateTempViewUsing](CreateTempViewUsing.md) command is executed
* `FallBackFileSourceV2` logical resolution rule is executed
* [ResolveSQLOnFile](../logical-analysis-rules/ResolveSQLOnFile.md) and [FindDataSourceTable](../logical-analysis-rules/FindDataSourceTable.md) logical evaluation rules are executed
* `HiveMetastoreCatalog` is requested to [convert a HiveTableRelation](../hive/HiveMetastoreCatalog.md#convertToLogicalRelation)
* `FileStreamSource` ([Spark Structured Streaming]({{ book.structured_streaming }}/datasources/file/FileStreamSource/)) is requested to `getBatch`

## <span id="refresh"> refresh

```scala
refresh(): Unit
```

`refresh` is part of [LogicalPlan](LogicalPlan.md#refresh) abstraction.

`refresh` requests the [FileIndex](../HadoopFsRelation.md#location) (of the [HadoopFsRelation](#relation)) to refresh.

!!! note
    `refresh` does the work for [HadoopFsRelation](../HadoopFsRelation.md) relations only.

## <span id="simpleString"> Simple Text Representation

```scala
simpleString(
  maxFields: Int): String
```

`simpleString` is part of the [QueryPlan](../catalyst/QueryPlan.md#simpleString) abstraction.

`simpleString` is made up of the [output schema](#output) (truncated to `maxFields`) and the [relation](#relation):

```text
Relation[[output]] [relation]
```

### <span id="simpleString-demo"> Demo

```text
val q = spark.read.text("README.md")
val logicalPlan = q.queryExecution.logical

scala> println(logicalPlan.simpleString)
Relation[value#2] text
```

## <span id="computeStats"> computeStats

```scala
computeStats(): Statistics
```

`computeStats` takes the optional [CatalogTable](#catalogTable).

If available, `computeStats` requests the `CatalogTable` for the [CatalogStatistics](../CatalogTable.md#stats) that, if available, is requested to [toPlanStats](#toPlanStats) (with the `planStatsEnabled` flag enabled when either [spark.sql.cbo.enabled](../SQLConf.md#cboEnabled) or [spark.sql.cbo.planStats.enabled](../SQLConf.md#planStatsEnabled) is enabled).

Otherwise, `computeStats` creates a [Statistics](Statistics.md) with the `sizeInBytes` only to be the [sizeInBytes](../BaseRelation.md#sizeInBytes) of the [BaseRelation](#relation).

`computeStats` is part of the [LeafNode](LeafNode.md#computeStats) abstraction.

## Demo

The following are two logically-equivalent batch queries described using different Spark APIs: Scala and SQL.

```scala
val format = "csv"
val path = "../datasets/people.csv"
```

```scala
val q = spark
  .read
  .option("header", true)
  .format(format)
  .load(path)
```

```text
scala> println(q.queryExecution.logical.numberedTreeString)
00 Relation[id#16,name#17] csv
```

```scala
val q = sql(s"select * from `$format`.`$path`")
```

```text
scala> println(q.queryExecution.optimizedPlan.numberedTreeString)
00 Relation[_c0#74,_c1#75] csv
```
