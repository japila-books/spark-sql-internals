# ParserInterface &mdash; SQL Parsers

`ParserInterface` is the [abstraction](#contract) of [SQL parsers](#extensions) that can convert (_parse_) textual representation of SQL statements (_SQL text_) into Spark SQL's relational entities (e.g. [Catalyst expressions](#parseExpression), [logical operators](#parsePlan), [table](#parseTableIdentifier) and [function](#parseFunctionIdentifier) identifiers, [table schema](#parseTableSchema), and [data types](#parseDataType)).

## Accessing ParserInterface

`ParserInterface` is available as [SessionState.sqlParser](../SessionState.md#sqlParser).

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

Parses a SQL text to a [DataType](../spark-sql-DataType.md)

Used when:

* `DataType` utility is requested to <<spark-sql-DataType.md#fromDDL, convert a DDL into a DataType (DataType.fromDDL)>>

* `StructType` is requested to <<spark-sql-StructType.md#add, add a field>>

* <<spark-sql-Column.md#cast, Column.cast>>

* `HiveClientImpl` utility is requested to hive/HiveClientImpl.md#getSparkSQLDataType[getSparkSQLDataType]

* `OrcFileOperator` is requested to `readSchema`

* `PythonSQLUtils` is requested to `parseDataType`

* `SQLUtils` is requested to `createStructField`

* `OrcUtils` is requested to `readSchema`

### parseExpression

```scala
parseExpression(
  sqlText: String): Expression
```

Parses a SQL text to an [Expression](../expressions/Expression.md)

Used in the following:

* Dataset operators: <<spark-sql-dataset-operators.md#selectExpr, Dataset.selectExpr>>, <<spark-sql-dataset-operators.md#filter, Dataset.filter>> and <<spark-sql-dataset-operators.md#where, Dataset.where>>

* <<spark-sql-functions.md#expr, expr>> standard function

### parseFunctionIdentifier

```scala
parseFunctionIdentifier(
  sqlText: String): FunctionIdentifier
```

Parses a SQL text to a `FunctionIdentifier`

Used when:

* `SessionCatalog` is requested to [listFunctions](../SessionCatalog.md#listFunctions)

* `CatalogImpl` is requested to [getFunction](../CatalogImpl.md#getFunction) and [functionExists](../CatalogImpl.md#functionExists)

### parseMultipartIdentifier

```scala
parseMultipartIdentifier(
  sqlText: String): Seq[String]
```

Parses a SQL text to a multi-part identifier

Used when:

* `CatalogV2Implicits` utility is requested to [parseColumnPath](CatalogV2Implicits.md#parseColumnPath)

* `LogicalExpressions` utility is requested to [parseReference](LogicalExpressions.md#parseReference)

* `DataFrameWriter` is requested to [insertInto](../spark-sql-DataFrameWriter.md#insertInto) and [saveAsTable](../spark-sql-DataFrameWriter.md#saveAsTable)

* [DataFrameWriterV2](../new-in-300/DataFrameWriterV2.md) is created (and requested for [tableName](../new-in-300/DataFrameWriterV2.md#tableName))

* `SparkSession` is requested to [table](../SparkSession.md#table)

### parsePlan

```scala
parsePlan(
  sqlText: String): LogicalPlan
```

Parses a SQL text to a [LogicalPlan](../logical-operators/LogicalPlan.md)

Used when:

* `SessionCatalog` is requested to [look up a relation (table or view) in catalogs](../SessionCatalog.md#lookupRelation)

* `SparkSession` is requested to <<SparkSession.md#sql, execute a SQL query (aka SQL Mode)>>

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

* `DataFrameWriter` is requested to <<spark-sql-DataFrameWriter.md#insertInto, insertInto>> and <<spark-sql-DataFrameWriter.md#saveAsTable, saveAsTable>>

* `Dataset` is requested to <<spark-sql-Dataset-basic-actions.md#createTempViewCommand, createTempViewCommand>>

* `SparkSession` is requested to <<SparkSession.md#table, table>>

* `CatalogImpl` is requested to [listColumns](../CatalogImpl.md#listColumns), [getTable](../CatalogImpl.md#getTable), [tableExists](../CatalogImpl.md#tableExists), [createTable](../CatalogImpl.md#createTable), [recoverPartitions](../CatalogImpl.md#recoverPartitions), [uncacheTable](../CatalogImpl.md#uncacheTable), and [refreshTable](../CatalogImpl.md#refreshTable)

* `SessionState` is requested to <<SessionState.md#refreshTable, refreshTable>>

### parseTableSchema

```scala
parseTableSchema(
  sqlText: String): StructType
```

Parses a SQL text to a [StructType](../spark-sql-StructType.md)

Used when:

* `DataType` utility is requested to <<spark-sql-DataType.md#fromDDL, convert a DDL into a DataType (DataType.fromDDL)>>

* `StructType` utility is requested to <<spark-sql-StructType.md#fromDDL, create a StructType for a given DDL-formatted string (StructType.fromDDL)>>

* `JdbcUtils` utility is requested to <<spark-sql-JdbcUtils.md#parseUserSpecifiedCreateTableColumnTypes, parseUserSpecifiedCreateTableColumnTypes>> and <<spark-sql-JdbcUtils.md#getCustomSchema, getCustomSchema>>

## Extensions

[AbstractSqlParser](AbstractSqlParser.md) is the base extension of the `ParserInterface` abstraction.
