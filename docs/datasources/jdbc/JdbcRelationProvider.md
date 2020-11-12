# JdbcRelationProvider

[[shortName]]
`JdbcRelationProvider` is a [DataSourceRegister](../../DataSourceRegister.md) and registers itself to handle *jdbc* data source format.

!!! note
    `JdbcRelationProvider` uses `META-INF/services/org.apache.spark.sql.sources.DataSourceRegister` file for the registration which is available in the [source code](https://github.com/apache/spark/blob/master/sql/core/src/main/resources/META-INF/services/org.apache.spark.sql.sources.DataSourceRegister) of Apache Spark.

`JdbcRelationProvider` is a [RelationProvider](#createRelation-RelationProvider) and a [CreatableRelationProvider](#createRelation-CreatableRelationProvider).

`JdbcRelationProvider` is used when `DataFrameReader` is requested to load data from [jdbc](../../DataFrameReader.md#jdbc) data source.

```text
val table = spark.read.jdbc(...)

// or in a more verbose way
val table = spark.read.format("jdbc").load(...)
```

## <span id="createRelation-RelationProvider"> Loading Data from Table Using JDBC

```scala
createRelation(
  sqlContext: SQLContext,
  parameters: Map[String, String]): BaseRelation
```

`createRelation` is part of the [RelationProvider](../../RelationProvider.md#createRelation) abstraction.

`createRelation` creates a `JDBCPartitioningInfo` (using [JDBCOptions](JDBCOptions.md) and the input `parameters` that correspond to the [Options for JDBC Data Source](JDBCOptions.md#options)).

NOTE: `createRelation` uses [partitionColumn](../../DataFrameReader.md#partitionColumn), [lowerBound](../../DataFrameReader.md#lowerBound), [upperBound](../../DataFrameReader.md#upperBound) and [numPartitions](../../DataFrameReader.md#numPartitions).

In the end, `createRelation` creates a datasources/jdbc/JDBCRelation.md#creating-instance[JDBCRelation] with datasources/jdbc/JDBCRelation.md#columnPartition[column partitions] (and [JDBCOptions](JDBCOptions.md)).

## <span id="createRelation-CreatableRelationProvider"> Writing Rows of Structured Query (DataFrame) to Table Using JDBC

```scala
createRelation(
  sqlContext: SQLContext,
  mode: SaveMode,
  parameters: Map[String, String],
  df: DataFrame): BaseRelation
```

`createRelation` is part of the [CreatableRelationProvider](../../CreatableRelationProvider.md#createRelation) abstraction.

Internally, `createRelation` creates a [JDBCOptions](JDBCOptions.md) (from the input `parameters`).

`createRelation` reads [caseSensitiveAnalysis](../../spark-sql-CatalystConf.md#caseSensitiveAnalysis) (using the input `sqlContext`).

`createRelation` checks whether the table (given `dbtable` and `url` [options](JDBCOptions.md#options) in the input `parameters`) exists.

NOTE: `createRelation` uses a database-specific `JdbcDialect` to [check whether a table exists](JdbcDialect.md#getTableExistsQuery).

`createRelation` branches off per whether the table already exists in the database or not.

If the table *does not* exist, `createRelation` creates the table (by executing `CREATE TABLE` with [createTableColumnTypes](JDBCOptions.md#createTableColumnTypes) and [createTableOptions](JDBCOptions.md#createTableOptions) options from the input `parameters`) and writes the rows to the database in a single transaction.

If however the table *does* exist, `createRelation` branches off per [SaveMode](../../DataFrameWriter.md#SaveMode) (see the following [createRelation and SaveMode](#createRelation-CreatableRelationProvider-SaveMode)).

[[createRelation-CreatableRelationProvider-SaveMode]]
.createRelation and SaveMode
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| [Append](../../DataFrameWriter.md#Append)
| Saves the records to the table.

| [ErrorIfExists](../../DataFrameWriter.md#ErrorIfExists)
a| Throws a `AnalysisException` with the message:

```text
Table or view '[table]' already exists. SaveMode: ErrorIfExists.
```

| [Ignore](../../DataFrameWriter.md#Ignore)
| Does nothing.

| [Overwrite](../../DataFrameWriter.md#Overwrite)
a| Truncates or drops the table

NOTE: `createRelation` truncates the table only when [truncate](JDBCOptions.md#truncate) JDBC option is enabled and JdbcDialect.md#isCascadingTruncateTable[isCascadingTruncateTable] is disabled.
|===

In the end, `createRelation` closes the JDBC connection to the database and [creates a JDBCRelation](#createRelation-RelationProvider).
