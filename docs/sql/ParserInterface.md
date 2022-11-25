# ParserInterface

`ParserInterface` is the [abstraction](#contract) of [SQL parsers](#implementations) that can convert (_parse_) textual representation of SQL statements (_SQL text_) into Spark SQL's relational entities (e.g. [Catalyst expressions](#parseExpression), [logical operators](#parsePlan), [table](#parseTableIdentifier) and [function](#parseFunctionIdentifier) identifiers, [table schema](#parseTableSchema), and [data types](#parseDataType)).

## Accessing ParserInterface

`ParserInterface` is available as [SessionState.sqlParser](../SessionState.md#sqlParser).

```text
scala> :type spark
org.apache.spark.sql.SparkSession

scala> :type spark.sessionState.sqlParser
org.apache.spark.sql.catalyst.parser.ParserInterface
```

## Contract

### <span id="parseDataType"> parseDataType

```scala
parseDataType(
  sqlText: String): DataType
```

Creates a [DataType](../types/DataType.md) from the given SQL text

### <span id="parseExpression"> parseExpression

```scala
parseExpression(
  sqlText: String): Expression
```

Creates an [Expression](../expressions/Expression.md) from the given SQL text

Used when:

* `Dataset` is requested to [selectExpr](../spark-sql-dataset-operators.md#selectExpr), [filter](../spark-sql-dataset-operators.md#filter), [where](../spark-sql-dataset-operators.md#where)
* [expr](../functions.md#expr) standard function is used

### <span id="parseFunctionIdentifier"> parseFunctionIdentifier

```scala
parseFunctionIdentifier(
  sqlText: String): FunctionIdentifier
```

Creates a `FunctionIdentifier` from the given SQL text

Used when:

* `SessionCatalog` is requested to [listFunctions](../SessionCatalog.md#listFunctions)

* `CatalogImpl` is requested to [getFunction](../CatalogImpl.md#getFunction) and [functionExists](../CatalogImpl.md#functionExists)

### <span id="parseMultipartIdentifier"> parseMultipartIdentifier

```scala
parseMultipartIdentifier(
  sqlText: String): Seq[String]
```

Creates a multi-part identifier from the given SQL text

Used when:

* `CatalogV2Implicits` utility is requested to `parseColumnPath`
* `LogicalExpressions` utility is requested to `parseReference`
* `DataFrameWriter` is requested to [insertInto](../DataFrameWriter.md#insertInto) and [saveAsTable](../DataFrameWriter.md#saveAsTable)

* [DataFrameWriterV2](../DataFrameWriterV2.md) is created (and requested for [tableName](../DataFrameWriterV2.md#tableName))

* `SparkSession` is requested to [table](../SparkSession.md#table)

### <span id="parsePlan"> parsePlan

```scala
parsePlan(
  sqlText: String): LogicalPlan
```

Creates a [LogicalPlan](../logical-operators/LogicalPlan.md) from the given SQL text

Used when:

* `SessionCatalog` is requested to [fromCatalogTable](../SessionCatalog.md#fromCatalogTable)
* `SparkSession` is requested to [execute a SQL query](../SparkSession.md#sql)

### <span id="parseTableIdentifier"> parseTableIdentifier

```scala
parseTableIdentifier(
  sqlText: String): TableIdentifier
```

Creates a `TableIdentifier` from the given SQL text

Used when:

* `DataFrameWriter` is requested to [insertInto](../DataFrameWriter.md#insertInto) and [saveAsTable](../DataFrameWriter.md#saveAsTable)

* `Dataset` is requested to [createTempViewCommand](../spark-sql-Dataset-basic-actions.md#createTempViewCommand)

* `SparkSession` is requested to [table](../SparkSession.md#table)

* `CatalogImpl` is requested to [listColumns](../CatalogImpl.md#listColumns), [getTable](../CatalogImpl.md#getTable), [tableExists](../CatalogImpl.md#tableExists), [createTable](../CatalogImpl.md#createTable), [recoverPartitions](../CatalogImpl.md#recoverPartitions), [uncacheTable](../CatalogImpl.md#uncacheTable), and [refreshTable](../CatalogImpl.md#refreshTable)

* `SessionState` is requested to <<SessionState.md#refreshTable, refreshTable>>

### <span id="parseTableSchema"> parseTableSchema

```scala
parseTableSchema(
  sqlText: String): StructType
```

Creates a [StructType](../types/StructType.md) from the given SQL text

## Implementations

* [AbstractSqlParser](AbstractSqlParser.md)
