# JdbcRelationProvider

`JdbcRelationProvider` is used as a [RelationProvider](#createRelation-RelationProvider) and a [CreatableRelationProvider](#createRelation-CreatableRelationProvider) of the [JDBC Data Source](../../DataFrameReader.md#jdbc).

## <span id="DataSourceRegister"><span id="shortName"> DataSourceRegister

`JdbcRelationProvider` is the [DataSourceRegister](../../DataSourceRegister.md) to handle **jdbc** data source format.

!!! note
    `JdbcRelationProvider` uses `META-INF/services/org.apache.spark.sql.sources.DataSourceRegister` file for registration that is available in the [source code]({{ spark.github }}/sql/core/src/main/resources/META-INF/services/org.apache.spark.sql.sources.DataSourceRegister#L2) of Apache Spark.

## <span id="createRelation-RelationProvider"> Creating BaseRelation

```scala
createRelation(
  sqlContext: SQLContext,
  parameters: Map[String, String]): BaseRelation
```

`createRelation` creates a [JDBCOptions](JDBCOptions.md) (with the given `parameters`).

`createRelation` [gets the schema](JDBCRelation.md#getSchema) (by querying the database system).

`createRelation` [creates column partitions](JDBCRelation.md#columnPartition).

In the end, `createRelation` creates a [JDBCRelation](JDBCRelation.md).

`createRelation` is part of the [RelationProvider](../../RelationProvider.md#createRelation) abstraction.

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

`createRelation`...FIXME

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
