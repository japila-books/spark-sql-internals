# ParserInterface &mdash; SQL Parsers

`ParserInterface` is the [abstraction](#contract) of [SQL parsers](#extensions) that can convert (_parse_) textual representation of SQL statements (_SQL text_) into [Catalyst expressions](#parseExpression), [logical operators](#parsePlan), [table](#parseTableIdentifier) and [function](#parseFunctionIdentifier) identifiers, [table schema](#parseTableSchema), and [data types](#parseDataType).

## Accessing ParserInterface

`ParserInterface` is available as [SessionState.sqlParser](../spark-sql-SessionState.md#sqlParser).

```
scala> :type spark
org.apache.spark.sql.SparkSession

scala> :type spark.sessionState.sqlParser
org.apache.spark.sql.catalyst.parser.ParserInterface
```

## Contract

### parseDataType

```scala
parseDataType(
  sqlText: String): DataType
```

Parses a SQL text to an [DataType](../spark-sql-DataType.md)

Used when:

* `DataType` utility is requested to <<spark-sql-DataType.adoc#fromDDL, convert a DDL into a DataType (DataType.fromDDL)>>

* `StructType` is requested to <<spark-sql-StructType.adoc#add, add a field>>

* <<spark-sql-Column.adoc#cast, Column.cast>>

* `HiveClientImpl` utility is requested to link:hive/HiveClientImpl.adoc#getSparkSQLDataType[getSparkSQLDataType]

* `OrcFileOperator` is requested to `readSchema`

* `PythonSQLUtils` is requested to `parseDataType`

* `SQLUtils` is requested to `createStructField`

* `OrcUtils` is requested to `readSchema`

### parseExpression

```scala
parseExpression(
  sqlText: String): Expression
```

Parses a SQL text to an [Expression](../spark-sql-Expression.md)

Used in the following:

* Dataset operators: <<spark-sql-dataset-operators.adoc#selectExpr, Dataset.selectExpr>>, <<spark-sql-dataset-operators.adoc#filter, Dataset.filter>> and <<spark-sql-dataset-operators.adoc#where, Dataset.where>>

* <<spark-sql-functions.adoc#expr, expr>> standard function

### parseFunctionIdentifier

```scala
parseFunctionIdentifier(
  sqlText: String): FunctionIdentifier
```

Parses a SQL text to an `FunctionIdentifier`

Used when:

* `SessionCatalog` is requested to <<spark-sql-SessionCatalog.adoc#listFunctions, listFunctions>>

* `CatalogImpl` is requested to <<spark-sql-CatalogImpl.adoc#getFunction, getFunction>> and <<spark-sql-CatalogImpl.adoc#functionExists, functionExists>>

### parseMultipartIdentifier

```scala
parseMultipartIdentifier(
  sqlText: String): Seq[String]
```

Used when...FIXME

### parsePlan

```scala
parsePlan(
  sqlText: String): LogicalPlan
```

Parses a SQL text to a [LogicalPlan](../logical-operators/LogicalPlan.md)

Used when:

* `SessionCatalog` is requested to <<spark-sql-SessionCatalog.adoc#lookupRelation, look up a relation (table or view) in catalogs>>

* `SparkSession` is requested to <<spark-sql-SparkSession.adoc#sql, execute a SQL query (aka SQL Mode)>>

### parseRawDataType

```scala
parseRawDataType(
  sqlText: String): DataType
```

Used when...FIXME

### parseTableIdentifier

```scala
parseTableIdentifier(
  sqlText: String): TableIdentifier
```

Parses a SQL text to a `TableIdentifier`

Used when:

* `DataFrameWriter` is requested to <<spark-sql-DataFrameWriter.adoc#insertInto, insertInto>> and <<spark-sql-DataFrameWriter.adoc#saveAsTable, saveAsTable>>

* `Dataset` is requested to <<spark-sql-Dataset-basic-actions.adoc#createTempViewCommand, createTempViewCommand>>

* `SparkSession` is requested to <<spark-sql-SparkSession.adoc#table, table>>

* `CatalogImpl` is requested to <<spark-sql-CatalogImpl.adoc#listColumns, listColumns>>, <<spark-sql-CatalogImpl.adoc#getTable, getTable>>, <<spark-sql-CatalogImpl.adoc#tableExists, tableExists>>, <<spark-sql-CatalogImpl.adoc#createTable, createTable>>, <<spark-sql-CatalogImpl.adoc#recoverPartitions, recoverPartitions>>, <<spark-sql-CatalogImpl.adoc#uncacheTable, uncacheTable>>, and <<spark-sql-CatalogImpl.adoc#refreshTable, refreshTable>>

* `SessionState` is requested to <<spark-sql-SessionState.adoc#refreshTable, refreshTable>>

### parseTableSchema

```scala
parseTableSchema(
  sqlText: String): StructType
```

Parses a SQL text to a [StructType](../spark-sql-StructType.md)

Used when:

* `DataType` utility is requested to <<spark-sql-DataType.adoc#fromDDL, convert a DDL into a DataType (DataType.fromDDL)>>

* `StructType` utility is requested to <<spark-sql-StructType.adoc#fromDDL, create a StructType for a given DDL-formatted string (StructType.fromDDL)>>

* `JdbcUtils` utility is requested to <<spark-sql-JdbcUtils.adoc#parseUserSpecifiedCreateTableColumnTypes, parseUserSpecifiedCreateTableColumnTypes>> and <<spark-sql-JdbcUtils.adoc#getCustomSchema, getCustomSchema>>

## Extensions

[AbstractSqlParser](AbstractSqlParser.md) is the base extension of the `ParserInterface` abstraction.
