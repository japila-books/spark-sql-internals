# HadoopFsRelation

`HadoopFsRelation` is a [BaseRelation](BaseRelation.md) and [FileRelation](spark-sql-FileRelation.md).

## Creating Instance

`HadoopFsRelation` takes the following to be created:

* <span id="location"> [FileIndex](FileIndex.md)
* <span id="partitionSchema"> Partition Schema ([StructType](StructType.md))
* <span id="dataSchema"> Data Schema ([StructType](StructType.md))
* Optional [bucketing specification](#bucketSpec)
* <span id="fileFormat"> [FileFormat](FileFormat.md)
* <span id="options"> Options (`Map[String, String]`)
* <span id="sparkSession"> [SparkSession](SparkSession.md)

`HadoopFsRelation` is created when:

* `DataSource` is requested to [resolve a relation](DataSource.md#resolveRelation) for [file-based data sources](FileFormat.md)
* `HiveMetastoreCatalog` is requested to [convert a HiveTableRelation to a LogicalRelation over a HadoopFsRelation](hive/HiveMetastoreCatalog.md#convertToLogicalRelation) (for [RelationConversions](hive/RelationConversions.md) logical post-hoc evaluation rule for `parquet` or `native` and `hive` ORC formats)

## <span id="bucketSpec"> Bucketing Specification

`HadoopFsRelation` can be given a [bucketing specification](spark-sql-BucketSpec.md) when [created](#creating-instance).

The bucketing specification is defined for [non-streaming file-based data sources](DataSource.md) and used for the following:

* [Output partitioning scheme](physical-operators/FileSourceScanExec.md#outputPartitioning) and [output data ordering](physical-operators/FileSourceScanExec.md#outputOrdering) of the corresponding [FileSourceScanExec](physical-operators/FileSourceScanExec.md) physical operator

* [DataSourceAnalysis](logical-analysis-rules/DataSourceAnalysis.md) post-hoc logical resolution rule (when executed on a [InsertIntoTable](logical-operators/InsertIntoTable.md) logical operator over a [LogicalRelation](logical-operators/LogicalRelation.md) with `HadoopFsRelation` relation)

## <span id="inputFiles"> Files to Scan (Input Files)

```scala
inputFiles: Array[String]
```

`inputFiles` requests the [FileIndex](#location) for the [inputFiles](FileIndex.md#inputFiles).

`inputFiles` is part of the [FileRelation](spark-sql-FileRelation.md#inputFiles) abstraction.

## <span id="sizeInBytes"> Estimated Size

```scala
sizeInBytes: Long
```

`sizeInBytes` requests the [FileIndex](#location) for the [size](FileIndex.md#sizeInBytes) and multiplies it by the value of [spark.sql.sources.fileCompressionFactor](configuration-properties.md#spark.sql.sources.fileCompressionFactor) configuration property.

`sizeInBytes` is part of the [BaseRelation](BaseRelation.md#sizeInBytes) abstraction.

## <span id="toString"> Human-Friendly Textual Representation

```scala
toString: String
```

`toString` is the following text based on the [FileFormat](#fileFormat):

* [shortName](DataSourceRegister.md#shortName) for [DataSourceRegister](DataSourceRegister.md) data sources

* **HadoopFiles** otherwise

## Demo

```text
// Demo the different cases when `HadoopFsRelation` is created

import org.apache.spark.sql.execution.datasources.{HadoopFsRelation, LogicalRelation}

// Example 1: spark.table for DataSource tables (provider != hive)
import org.apache.spark.sql.catalyst.TableIdentifier
val t1ID = TableIdentifier(tableName = "t1")
spark.sessionState.catalog.dropTable(name = t1ID, ignoreIfNotExists = true, purge = true)
spark.range(5).write.saveAsTable("t1")

val metadata = spark.sessionState.catalog.getTableMetadata(t1ID)
scala> println(metadata.provider.get)
parquet

assert(metadata.provider.get != "hive")

val q = spark.table("t1")
// Avoid dealing with UnresolvedRelations and SubqueryAliases
// Hence going stright for optimizedPlan
val plan1 = q.queryExecution.optimizedPlan

scala> println(plan1.numberedTreeString)
00 Relation[id#7L] parquet

val LogicalRelation(rel1, _, _, _) = plan1.asInstanceOf[LogicalRelation]
val hadoopFsRel = rel1.asInstanceOf[HadoopFsRelation]

// Example 2: spark.read with format as a `FileFormat`
val q = spark.read.text("README.md")
val plan2 = q.queryExecution.logical

scala> println(plan2.numberedTreeString)
00 Relation[value#2] text

val LogicalRelation(relation, _, _, _) = plan2.asInstanceOf[LogicalRelation]
val hadoopFsRel = relation.asInstanceOf[HadoopFsRelation]

// Example 3: Bucketing specified
val tableName = "bucketed_4_id"
spark
  .range(100000000)
  .write
  .bucketBy(4, "id")
  .sortBy("id")
  .mode("overwrite")
  .saveAsTable(tableName)

val q = spark.table(tableName)
// Avoid dealing with UnresolvedRelations and SubqueryAliases
// Hence going stright for optimizedPlan
val plan3 = q.queryExecution.optimizedPlan

scala> println(plan3.numberedTreeString)
00 Relation[id#52L] parquet

val LogicalRelation(rel3, _, _, _) = plan3.asInstanceOf[LogicalRelation]
val hadoopFsRel = rel3.asInstanceOf[HadoopFsRelation]
val bucketSpec = hadoopFsRel.bucketSpec.get

// Exercise 3: spark.table for Hive tables (provider == hive)
```
