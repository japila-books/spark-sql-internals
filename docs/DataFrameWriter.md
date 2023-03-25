# DataFrameWriter

`DataFrameWriter[T]` is a high-level API for Spark SQL developers to describe "write path" of a structured query (over rows of `T` type).

`DataFrameWriter` is used to describe an output node in a data processing graph.

`DataFrameWriter` is used to describe the [output data source format](#format) to be used to ["save" data](#save) to a data source (e.g. files, Hive tables, JDBC or `Dataset[String]`).

`DataFrameWriter` ends description of a write specification and does trigger a Spark job (unlike [DataFrameWriter](DataFrameWriter.md)).

`DataFrameWriter` is available using [Dataset.write](Dataset.md#write) operator.

## Creating Instance

`DataFrameWriter` takes the following to be created:

* <span id="ds"> [Dataset](Dataset.md)

### Demo

```text
assert(df.isInstanceOf[Dataset[_]])

val writer = df.write

import org.apache.spark.sql.DataFrameWriter
assert(writer.isInstanceOf[DataFrameWriter])
```

## <span id="df"> DataFrame

When [created](#creating-instance), `DataFrameWriter` converts the [Dataset](#ds) to a [DataFrame](Dataset.md#toDF).

## <span id="source"><span id="format"> Name of Data Source

```scala
source: String
```

`source` is a short name (alias) or a fully-qualified class name to identify the data source to write data to.

`source` can be specified using `format` method:

```scala
format(
  source: String): DataFrameWriter[T]
```

Default: [spark.sql.sources.default](configuration-properties.md#spark.sql.sources.default) configuration property

## <span id="insertInto"> insertInto

```scala
insertInto(
  tableName: String): Unit
```

`insertInto` requests the [DataFrame](#df) for the [SparkSession](Dataset.md#sparkSession).

`insertInto` tries to [look up the TableProvider](#lookupV2Provider) for the [data source](#source).

`insertInto` requests the [ParserInterface](sql/ParserInterface.md) to [parse](sql/ParserInterface.md#parseMultipartIdentifier) the `tableName` identifier (possibly multi-part).

In the end, `insertInto` uses the [modern](#insertInto-CatalogPlugin) or the [legacy](#insertInto-TableIdentifier) insert paths based on...FIXME

![DataFrameWrite.insertInto Executes SQL Command (as a Spark job)](images/spark-sql-DataFrameWrite-insertInto-webui-query-details.png)

`insertInto` [asserts that write is not bucketed](#assertNotBucketed) (with **insertInto** operation name).

!!! note
    [saveAsTable](#saveAsTable) and [insertInto](#insertInto) are structurally alike.

### <span id="insertInto-CatalogPlugin"> Modern Insert Path (CatalogPlugin)

```scala
insertInto(
  catalog: CatalogPlugin,
  ident: Identifier): Unit
```

`insertInto`...FIXME

### <span id="insertInto-TableIdentifier"> Legacy Insert Path (TableIdentifier)

```scala
insertInto(
  tableIdent: TableIdentifier): Unit
```

`insertInto`...FIXME

### <span id="insertInto-AnalysisException"> AnalysisException

`insertInto` throws an `AnalysisException` when the [partitioningColumns](#partitioningColumns) are defined:

```text
insertInto() can't be used together with partitionBy(). Partition columns have already been defined for the table. It is not necessary to use partitionBy().
```

## <span id="saveAsTable"> saveAsTable

```scala
saveAsTable(
  tableName: String): Unit
```

`saveAsTable` requests the [DataFrame](#df) for the [SparkSession](Dataset.md#sparkSession).

`saveAsTable` tries to [look up the TableProvider](#lookupV2Provider) for the [data source](#source).

`saveAsTable` requests the [ParserInterface](sql/ParserInterface.md) to [parse](sql/ParserInterface.md#parseMultipartIdentifier) the `tableName` identifier (possibly multi-part).

In the end, `saveAsTable` uses the [modern](#saveAsTable-TableCatalog) or the [legacy](#saveAsTable-TableIdentifier) save paths based on...FIXME

!!! note
    [saveAsTable](#saveAsTable) and [insertInto](#insertInto) are structurally alike.

### <span id="saveAsTable-TableCatalog"> Modern saveAsTable with TableCatalog

```scala
saveAsTable(
  catalog: TableCatalog,
  ident: Identifier,
  nameParts: Seq[String]): Unit
```

### <span id="saveAsTable-TableIdentifier"> Legacy saveAsTable with TableIdentifier

```scala
saveAsTable(
  tableIdent: TableIdentifier): Unit
```

`saveAsTable` saves the content of a `DataFrame` to the `tableName` table.

### <span id="saveAsTable-AnalysisException"> AnalysisException

`saveAsTable` throws an `AnalysisException` when no catalog could handle the table identifier:

```text
Couldn't find a catalog to handle the identifier [tableName].
```

### Demo

```text
val ids = spark.range(5)
ids.write.
  option("path", "/tmp/five_ids").
  saveAsTable("five_ids")

// Check out if saveAsTable as five_ids was successful
val q = spark.catalog.listTables.filter($"name" === "five_ids")
scala> q.show
+--------+--------+-----------+---------+-----------+
|    name|database|description|tableType|isTemporary|
+--------+--------+-----------+---------+-----------+
|five_ids| default|       null| EXTERNAL|      false|
+--------+--------+-----------+---------+-----------+
```

## <span id="save"> Writing Out Data (save)

```scala
save(): Unit
save(
  path: String): Unit
```

Saves a `DataFrame` (the result of executing a structured query) to a data source.

Internally, `save` uses `DataSource` to [look up the class of the requested data source](DataSource.md#lookupDataSource) (for the [source](#source) option and the [SQLConf](SessionState.md#conf)).

!!! note
    `save` uses [SparkSession](Dataset.md#sparkSession) to access the [SessionState](SparkSession.md#sessionState) and in turn the [SQLConf](SessionState.md#conf).

    ```text
    val df: DataFrame = ???
    df.sparkSession.sessionState.conf
    ```

`save`...FIXME

`save` throws an `AnalysisException` when requested to save to Hive data source (the [source](#source) is `hive`):

```text
Hive data source can only be used with tables, you can not write files of Hive data source directly.
```

`save` throws an `AnalysisException` when [bucketing is used](#assertNotBucketed) (the [numBuckets](#numBuckets) or [sortColumnNames](#sortColumnNames) options are defined):

```text
'[operation]' does not support bucketing right now
```

### <span id="saveInternal"> saveInternal

```scala
saveInternal(
  path: Option[String]): Unit
```

`saveInternal`...FIXME

## <span id="lookupV2Provider"> Looking up TableProvider

```scala
lookupV2Provider(): Option[TableProvider]
```

`lookupV2Provider` tries to [look up a TableProvider](DataSource.md#lookupDataSourceV2) for the [source](#source).

`lookupV2Provider` explicitly excludes [FileDataSourceV2](connectors/FileDataSourceV2.md)-based data sources (due to [SPARK-28396](https://issues.apache.org/jira/browse/SPARK-28396)).

`lookupV2Provider` is used when:

* `DataFrameWriter` is requested to [save](#save), [insertInto](#insertInto) and [saveAsTable](#saveAsTable)

## <span id="SaveMode"><span id="mode"> Save Mode

```scala
mode(
  saveMode: SaveMode): DataFrameWriter[T]
mode(
  saveMode: String): DataFrameWriter[T]
```

`mode` defines the behaviour of [save](#save) when an external file or table Spark writes to already exists.

Name     | Behaviour
---------|----------
 <span id="Append"> Append | Records are appended to an existing data
 <span id="ErrorIfExists"> ErrorIfExists | Exception is thrown if the target exists
 <span id="Ignore"> Ignore | Do not save the records and not change the existing data in any way
 <span id="Overwrite"> Overwrite | Existing data is overwritten by new records

## <span id="getBucketSpec"> Creating BucketSpec

```scala
getBucketSpec: Option[BucketSpec]
```

`getBucketSpec` creates a new [BucketSpec](bucketing/BucketSpec.md) for [numBuckets](#numBuckets) if defined (with [bucketColumnNames](#bucketColumnNames) and [sortColumnNames](#sortColumnNames)).

??? note "IllegalArgumentException"
    `getBucketSpec` throws an `IllegalArgumentException` when [numBuckets](#numBuckets) are not defined but [sortColumnNames](#sortColumnNames) are.

    ```text
    sortBy must be used together with bucketBy
    ```

---

`getBucketSpec` is used when:

* `DataFrameWriter` is requested to [assertNotBucketed](#assertNotBucketed), [createTable](#createTable), [partitioningAsV2](#partitioningAsV2)

## <span id="partitioningAsV2"> partitioningAsV2

```scala
partitioningAsV2: Seq[Transform]
```

`partitioningAsV2` creates [Transform](connector/Transform.md)s based on the [partitioningColumns](#partitioningColumns) (`IdentityTransform`s) and [getBucketSpec](#getBucketSpec) (a `BucketTransform`), if defined.

---

`partitioningAsV2` is used when:

* `DataFrameWriter` is requested to [saveInternal](#saveInternal), [saveAsTable](#saveAsTable), [checkPartitioningMatchesV2Table](#checkPartitioningMatchesV2Table)

## <span id="saveToV1Source"> Executing Logical Command for Writing to Data Source V1

```scala
saveToV1Source(): Unit
```

`saveToV1Source` creates a [DataSource](DataSource.md#apply) (for the [source](#source) class name, the [partitioningColumns](#partitioningColumns) and the [extraOptions](#extraOptions)) and requests it for the [logical command for writing](DataSource.md#planForWriting) (with the [mode](#mode) and the [analyzed logical plan](Dataset.md#logicalPlan) of the structured query).

!!! note
    While requesting the [analyzed logical plan](Dataset.md#logicalPlan) of the structured query, `saveToV1Source` triggers execution of logical commands.

In the end, `saveToV1Source` [runs the logical command for writing](#runCommand).

!!! note
    The [logical command for writing](DataSource.md#planForWriting) can be one of the following:

    * A [SaveIntoDataSourceCommand](logical-operators/SaveIntoDataSourceCommand.md) for [CreatableRelationProviders](CreatableRelationProvider.md)

    * An [InsertIntoHadoopFsRelationCommand](logical-operators/InsertIntoHadoopFsRelationCommand.md) for [FileFormats](connectors/FileFormat.md)

`saveToV1Source` is used when `DataFrameWriter` is requested to [save the rows of a structured query (a DataFrame) to a data source](#save).

## <span id="runCommand"> Executing Logical Command(s)

```scala
runCommand(
  session: SparkSession,
  name: String)(
  command: LogicalPlan): Unit
```

`runCommand` uses the given [SparkSession](SparkSession.md) to access the [SessionState](SparkSession.md#sessionState) that is in turn requested to [execute the logical command](SessionState.md#executePlan) (that creates a [QueryExecution](QueryExecution.md)).

`runCommand` records the current time (start time) and uses the `SQLExecution` helper object to [execute the action (under a new execution id)](SQLExecution.md#withNewExecutionId) that simply requests the `QueryExecution` for the [RDD[InternalRow]](QueryExecution.md#toRdd) (and triggers execution of logical commands).

!!! tip
    Use web UI's SQL tab to see the execution or a `SparkListener` to be notified when the execution is started and finished. The `SparkListener` should intercept `SparkListenerSQLExecutionStart` and `SparkListenerSQLExecutionEnd` events.

`runCommand` records the current time (end time).

In the end, `runCommand` uses the input `SparkSession` to access the [ExecutionListenerManager](SparkSession.md#listenerManager) and requests it to [onSuccess](ExecutionListenerManager.md#onSuccess) (with the input `name`, the `QueryExecution` and the duration).

In case of any exceptions, `runCommand` requests the `ExecutionListenerManager` to [onFailure](ExecutionListenerManager.md#onFailure) (with the exception) and (re)throws it.

`runCommand` is used when:

* `DataFrameWriter` is requested to [save the rows of a structured query (a DataFrame) to a data source](#save) (and indirectly [executing a logical command for writing to a data source V1](#saveToV1Source)), [insert the rows of a structured streaming (a DataFrame) into a table](#insertInto) and [create a table](#createTable) (that is used exclusively for [saveAsTable](#saveAsTable))

## <span id="createTable"> Creating Table

```scala
createTable(
  tableIdent: TableIdentifier): Unit
```

`createTable` [builds a CatalogStorageFormat](DataSource.md#buildStorageFormatFromOptions) per [extraOptions](#extraOptions).

`createTable` assumes the table being [external](CatalogTable.md#CatalogTableType) when [location URI](CatalogStorageFormat.md#locationUri) of `CatalogStorageFormat` is defined, and [managed](CatalogTable.md#CatalogTableType) otherwise.

`createTable` creates a [CatalogTable](CatalogTable.md) (with the [bucketSpec](CatalogTable.md#bucketSpec) per [getBucketSpec](#getBucketSpec)).

In the end, `createTable` creates a [CreateTable](logical-operators/CreateTable.md) logical command (with the `CatalogTable`, [mode](#mode) and the [logical query plan](Dataset.md#planWithBarrier) of the [dataset](#df)) and [runs](#runCommand) it.

`createTable` is used when:

* `DataFrameWriter` is requested to [saveAsTable](#saveAsTable)
