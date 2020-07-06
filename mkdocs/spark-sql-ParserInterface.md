title: ParserInterface

# ParserInterface -- SQL Parsers

`ParserInterface` is the <<contract, abstraction>> of <<extensions, SQL parsers>> that can convert (_parse_) textual representation of SQL statements into <<parseExpression, Expressions>>, <<parsePlan, LogicalPlans>>, <<parseTableIdentifier, TableIdentifiers>>, <<parseFunctionIdentifier, FunctionIdentifier>>, <<parseTableSchema, StructType>>, and <<parseDataType, DataType>>.

[[contract]]
.ParserInterface Contract
[cols="30m,70",options="header",width="100%"]
|===
| Method
| Description

| parseDataType
a| [[parseDataType]]

[source, scala]
----
parseDataType(
  sqlText: String): DataType
----

Parses a SQL text to an <<spark-sql-DataType.adoc#, DataType>>

Used when:

* `DataType` utility is requested to <<spark-sql-DataType.adoc#fromDDL, convert a DDL into a DataType (DataType.fromDDL)>>

* `StructType` is requested to <<spark-sql-StructType.adoc#add, add a field>>

* <<spark-sql-Column.adoc#cast, Column.cast>>

* `HiveClientImpl` utility is requested to link:hive/HiveClientImpl.adoc#getSparkSQLDataType[getSparkSQLDataType]

* `OrcFileOperator` is requested to `readSchema`

* `PythonSQLUtils` is requested to `parseDataType`

* `SQLUtils` is requested to `createStructField`

* `OrcUtils` is requested to `readSchema`

| parseExpression
a| [[parseExpression]]

[source, scala]
----
parseExpression(
  sqlText: String): Expression
----

Parses a SQL text to an <<spark-sql-Expression.adoc#, Expression>>

Used in the following:

* Dataset operators: <<spark-sql-dataset-operators.adoc#selectExpr, Dataset.selectExpr>>, <<spark-sql-dataset-operators.adoc#filter, Dataset.filter>> and <<spark-sql-dataset-operators.adoc#where, Dataset.where>>

* <<spark-sql-functions.adoc#expr, expr>> standard function

| parseFunctionIdentifier
a| [[parseFunctionIdentifier]]

[source, scala]
----
parseFunctionIdentifier(
  sqlText: String): FunctionIdentifier
----

Parses a SQL text to an `FunctionIdentifier`

Used when:

* `SessionCatalog` is requested to <<spark-sql-SessionCatalog.adoc#listFunctions, listFunctions>>

* `CatalogImpl` is requested to <<spark-sql-CatalogImpl.adoc#getFunction, getFunction>> and <<spark-sql-CatalogImpl.adoc#functionExists, functionExists>>

| parsePlan
a| [[parsePlan]]

[source, scala]
----
parsePlan(
  sqlText: String): LogicalPlan
----

Parses a SQL text to a <<spark-sql-LogicalPlan.adoc#, LogicalPlan>>

Used when:

* `SessionCatalog` is requested to <<spark-sql-SessionCatalog.adoc#lookupRelation, look up a relation (table or view) in catalogs>>

* `SparkSession` is requested to <<spark-sql-SparkSession.adoc#sql, execute a SQL query (aka SQL Mode)>>

| parseTableIdentifier
a| [[parseTableIdentifier]]

[source, scala]
----
parseTableIdentifier(
  sqlText: String): TableIdentifier
----

Parses a SQL text to a `TableIdentifier`

Used when:

* `DataFrameWriter` is requested to <<spark-sql-DataFrameWriter.adoc#insertInto, insertInto>> and <<spark-sql-DataFrameWriter.adoc#saveAsTable, saveAsTable>>

* `Dataset` is requested to <<spark-sql-Dataset-basic-actions.adoc#createTempViewCommand, createTempViewCommand>>

* `SparkSession` is requested to <<spark-sql-SparkSession.adoc#table, table>>

* `CatalogImpl` is requested to <<spark-sql-CatalogImpl.adoc#listColumns, listColumns>>, <<spark-sql-CatalogImpl.adoc#getTable, getTable>>, <<spark-sql-CatalogImpl.adoc#tableExists, tableExists>>, <<spark-sql-CatalogImpl.adoc#createTable, createTable>>, <<spark-sql-CatalogImpl.adoc#recoverPartitions, recoverPartitions>>, <<spark-sql-CatalogImpl.adoc#uncacheTable, uncacheTable>>, and <<spark-sql-CatalogImpl.adoc#refreshTable, refreshTable>>

* `SessionState` is requested to <<spark-sql-SessionState.adoc#refreshTable, refreshTable>>

| parseTableSchema
a| [[parseTableSchema]]

[source, scala]
----
parseTableSchema(
  sqlText: String): StructType
----

Parses a SQL text to a schema (<<spark-sql-StructType.adoc#, StructType>>)

Used when:

* `DataType` utility is requested to <<spark-sql-DataType.adoc#fromDDL, convert a DDL into a DataType (DataType.fromDDL)>>

* `StructType` utility is requested to <<spark-sql-StructType.adoc#fromDDL, create a StructType for a given DDL-formatted string (StructType.fromDDL)>>

* `JdbcUtils` utility is requested to <<spark-sql-JdbcUtils.adoc#parseUserSpecifiedCreateTableColumnTypes, parseUserSpecifiedCreateTableColumnTypes>> and <<spark-sql-JdbcUtils.adoc#getCustomSchema, getCustomSchema>>

|===

[[extensions]]
NOTE: <<spark-sql-AbstractSqlParser.adoc#, AbstractSqlParser>> is the base extension of the `ParserInterface` contract in Spark SQL.

`ParserInterface` is available as <<spark-sql-SessionState.adoc#sqlParser, sqlParser>> property of <<spark-sql-SessionState.adoc#, SessionState>>.

[source, scala]
----
scala> :type spark
org.apache.spark.sql.SparkSession

scala> :type spark.sessionState.sqlParser
org.apache.spark.sql.catalyst.parser.ParserInterface
----
