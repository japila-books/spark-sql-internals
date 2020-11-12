# JdbcUtils Utility

`JdbcUtils` is an utility to support [JDBCRDD](JDBCRDD.md), [JDBCRelation](JDBCRelation.md) and [JdbcRelationProvider](JdbcRelationProvider.md).

[[methods]]
.JdbcUtils API
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| <<createConnectionFactory, createConnectionFactory>>
a| Used when:

* `JDBCRDD` is requested to [scanTable](JDBCRDD.md#scanTable) and [resolveTable](JDBCRDD.md#resolveTable)

* `JdbcRelationProvider` is requested to [write the rows of a structured query (a DataFrame) to a table](JdbcRelationProvider.md#createRelation-CreatableRelationProvider)

| <<createTable, createTable>>
|

| <<dropTable, dropTable>>
|

| <<getCommonJDBCType, getCommonJDBCType>>
|

| <<getCustomSchema, getCustomSchema>>
| Replaces data types in a table schema

Used exclusively when `JDBCRelation` is datasources/jdbc/JDBCRelation.md#schema[created] (and JDBCOptions.md#customSchema[customSchema] JDBC option was defined)

| <<getInsertStatement, getInsertStatement>>
|

| <<getSchema, getSchema>>
| Used when `JDBCRDD` is requested to [resolveTable](JDBCRDD.md#resolveTable)

| <<getSchemaOption, getSchemaOption>>
| Used when `JdbcRelationProvider` is requested to [write the rows of a structured query (a DataFrame) to a table](JdbcRelationProvider.md#createRelation-CreatableRelationProvider)

| <<resultSetToRows, resultSetToRows>>
| Used when...FIXME

| <<resultSetToSparkInternalRows, resultSetToSparkInternalRows>>
| Used when `JDBCRDD` is requested to [compute a partition](JDBCRDD.md#compute)

| <<schemaString, schemaString>>
|

| <<saveTable, saveTable>>
|

| <<tableExists, tableExists>>
| Used when `JdbcRelationProvider` is requested to [write the rows of a structured query (a DataFrame) to a table](JdbcRelationProvider.md#createRelation-CreatableRelationProvider)

| <<truncateTable, truncateTable>>
| Used when...FIXME
|===

## <span id="createConnectionFactory"> createConnectionFactory

```scala
createConnectionFactory(options: JDBCOptions): () => Connection
```

`createConnectionFactory`...FIXME

`createConnectionFactory` is used when:

* `JDBCRDD` is requested to [scanTable](JDBCRDD.md#scanTable) (and in turn creates a [JDBCRDD](JDBCRDD.md)) and [resolveTable](JDBCRDD.md#resolveTable)

* `JdbcRelationProvider` is requested to [create a BaseRelation](JdbcRelationProvider.md#createRelation)

* `JdbcUtils` is requested to [saveTable](#saveTable)

=== [[getCommonJDBCType]] `getCommonJDBCType` Method

[source, scala]
----
getCommonJDBCType(dt: DataType): Option[JdbcType]
----

`getCommonJDBCType`...FIXME

NOTE: `getCommonJDBCType` is used when...FIXME

=== [[getCatalystType]] `getCatalystType` Internal Method

[source, scala]
----
getCatalystType(
  sqlType: Int,
  precision: Int,
  scale: Int,
  signed: Boolean): DataType
----

`getCatalystType`...FIXME

NOTE: `getCatalystType` is used when...FIXME

=== [[getSchemaOption]] `getSchemaOption` Method

[source, scala]
----
getSchemaOption(conn: Connection, options: JDBCOptions): Option[StructType]
----

`getSchemaOption`...FIXME

NOTE: `getSchemaOption` is used when...FIXME

=== [[getSchema]] `getSchema` Method

[source, scala]
----
getSchema(
  resultSet: ResultSet,
  dialect: JdbcDialect,
  alwaysNullable: Boolean = false): StructType
----

`getSchema`...FIXME

NOTE: `getSchema` is used when...FIXME

=== [[resultSetToRows]] `resultSetToRows` Method

[source, scala]
----
resultSetToRows(resultSet: ResultSet, schema: StructType): Iterator[Row]
----

`resultSetToRows`...FIXME

NOTE: `resultSetToRows` is used when...FIXME

=== [[resultSetToSparkInternalRows]] `resultSetToSparkInternalRows` Method

[source, scala]
----
resultSetToSparkInternalRows(
  resultSet: ResultSet,
  schema: StructType,
  inputMetrics: InputMetrics): Iterator[InternalRow]
----

`resultSetToSparkInternalRows`...FIXME

NOTE: `resultSetToSparkInternalRows` is used when...FIXME

=== [[schemaString]] `schemaString` Method

[source, scala]
----
schemaString(
  df: DataFrame,
  url: String,
  createTableColumnTypes: Option[String] = None): String
----

`schemaString`...FIXME

NOTE: `schemaString` is used exclusively when `JdbcUtils` is requested to <<createTable, create a table>>.

=== [[parseUserSpecifiedCreateTableColumnTypes]] `parseUserSpecifiedCreateTableColumnTypes` Internal Method

[source, scala]
----
parseUserSpecifiedCreateTableColumnTypes(
  df: DataFrame,
  createTableColumnTypes: String): Map[String, String]
----

`parseUserSpecifiedCreateTableColumnTypes`...FIXME

NOTE: `parseUserSpecifiedCreateTableColumnTypes` is used exclusively when `JdbcUtils` is requested to <<schemaString, schemaString>>.

=== [[saveTable]] `saveTable` Method

[source, scala]
----
saveTable(
  df: DataFrame,
  tableSchema: Option[StructType],
  isCaseSensitive: Boolean,
  options: JDBCOptions): Unit
----

`saveTable` takes the [url](JDBCOptions.md#url), [table](JDBCOptions.md#table), [batchSize](JDBCOptions.md#batchSize), [isolationLevel](JDBCOptions.md#isolationLevel) options and [createConnectionFactory](#createConnectionFactory).

`saveTable` <<getInsertStatement, getInsertStatement>>.

`saveTable` takes the [numPartitions](JDBCOptions.md#numPartitions) option and applies [coalesce](../../spark-sql-dataset-operators.md#coalesce) operator to the input `DataFrame` if the number of partitions of its [RDD](../../Dataset.md#rdd) is less than the `numPartitions` option.

In the end, `saveTable` requests the possibly-repartitioned `DataFrame` for its <<Dataset.md#rdd, RDD>> (it may have changed after the <<spark-sql-dataset-operators.md#coalesce, coalesce>> operator) and executes <<savePartition, savePartition>> for every partition (using `RDD.foreachPartition`).

`saveTable` is used when `JdbcRelationProvider` is requested to [write the rows of a structured query (a DataFrame) to a table](JdbcRelationProvider.md#createRelation-CreatableRelationProvider).

=== [[getCustomSchema]] Replacing Data Types In Table Schema -- `getCustomSchema` Method

[source, scala]
----
getCustomSchema(
  tableSchema: StructType,
  customSchema: String,
  nameEquality: Resolver): StructType
----

`getCustomSchema` replaces the data type of the fields in the input `tableSchema` [schema](../../StructType.md) that are included in the input `customSchema` (if defined).

Internally, `getCustomSchema` branches off per the input `customSchema`.

If the input `customSchema` is undefined or empty, `getCustomSchema` simply returns the input `tableSchema` unchanged.

Otherwise, if the input `customSchema` is not empty, `getCustomSchema` requests `CatalystSqlParser` to spark-sql-AbstractSqlParser.md#parseTableSchema[parse it] (i.e. create a new [StructType](../../StructType.md) for the given `customSchema` canonical schema representation).

`getCustomSchema` then uses `SchemaUtils` to spark-sql-SchemaUtils.md#checkColumnNameDuplication[checkColumnNameDuplication] (in the column names of the user-defined `customSchema` schema with the input `nameEquality`).

In the end, `getCustomSchema` replaces the data type of the fields in the input `tableSchema` that are included in the input `userSchema`.

NOTE: `getCustomSchema` is used exclusively when `JDBCRelation` is datasources/jdbc/JDBCRelation.md#schema[created] (and JDBCOptions.md#customSchema[customSchema] JDBC option was defined).

=== [[dropTable]] `dropTable` Method

[source, scala]
----
dropTable(conn: Connection, table: String): Unit
----

`dropTable`...FIXME

NOTE: `dropTable` is used when...FIXME

=== [[createTable]] Creating Table Using JDBC -- `createTable` Method

[source, scala]
----
createTable(
  conn: Connection,
  df: DataFrame,
  options: JDBCOptions): Unit
----

`createTable` <<schemaString, builds the table schema>> (given the input `DataFrame` with the <<JDBCOptions.md#url, url>> and <<JDBCOptions.md#createTableColumnTypes, createTableColumnTypes>> options).

`createTable` uses the <<JDBCOptions.md#table, table>> and <<JDBCOptions.md#createTableOptions, createTableOptions>> options.

In the end, `createTable` concatenates all the above texts into a `CREATE TABLE [table] ([strSchema]) [createTableOptions]` SQL DDL statement followed by executing it (using the input JDBC `Connection`).

`createTable` is used when `JdbcRelationProvider` is requested to [write the rows of a structured query (a DataFrame) to a table](JdbcRelationProvider.md#createRelation-CreatableRelationProvider).

=== [[getInsertStatement]] `getInsertStatement` Method

[source, scala]
----
getInsertStatement(
  table: String,
  rddSchema: StructType,
  tableSchema: Option[StructType],
  isCaseSensitive: Boolean,
  dialect: JdbcDialect): String
----

`getInsertStatement`...FIXME

NOTE: `getInsertStatement` is used when...FIXME

=== [[getJdbcType]] `getJdbcType` Internal Method

[source, scala]
----
getJdbcType(dt: DataType, dialect: JdbcDialect): JdbcType
----

`getJdbcType`...FIXME

NOTE: `getJdbcType` is used when...FIXME

=== [[tableExists]] `tableExists` Method

[source, scala]
----
tableExists(conn: Connection, options: JDBCOptions): Boolean
----

`tableExists`...FIXME

`tableExists` is used when `JdbcRelationProvider` is requested to [write the rows of a structured query (a DataFrame) to a table](JdbcRelationProvider.md#createRelation-CreatableRelationProvider).

=== [[truncateTable]] `truncateTable` Method

[source, scala]
----
truncateTable(conn: Connection, options: JDBCOptions): Unit
----

`truncateTable`...FIXME

`truncateTable` is used when `JdbcRelationProvider` is requested to [write the rows of a structured query (a DataFrame) to a table](JdbcRelationProvider.md#createRelation-CreatableRelationProvider).

=== [[savePartition]] Saving Rows (Per Partition) to Table -- `savePartition` Method

[source, scala]
----
savePartition(
  getConnection: () => Connection,
  table: String,
  iterator: Iterator[Row],
  rddSchema: StructType,
  insertStmt: String,
  batchSize: Int,
  dialect: JdbcDialect,
  isolationLevel: Int): Iterator[Byte]
----

`savePartition` creates a JDBC `Connection` using the input `getConnection` function.

`savePartition` tries to set the input `isolationLevel` if it is different than `TRANSACTION_NONE` and the database supports transactions.

`savePartition` then writes rows (in the input `Iterator[Row]`) using batches that are submitted after `batchSize` rows where added.

NOTE: `savePartition` is used exclusively when `JdbcUtils` is requested to <<saveTable, saveTable>>.
