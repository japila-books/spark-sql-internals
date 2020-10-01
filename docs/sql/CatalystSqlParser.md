# CatalystSqlParser &mdash; Parser for DataTypes and StructTypes

`CatalystSqlParser` is an [AbstractSqlParser](AbstractSqlParser.md) that uses [AstBuilder](AstBuilder.md) for parsing SQL statements.

```text
import org.apache.spark.sql.catalyst.parser.CatalystSqlParser
import org.apache.spark.sql.internal.SQLConf
val catalystSqlParser = new CatalystSqlParser(SQLConf.get)
scala> :type catalystSqlParser.astBuilder
org.apache.spark.sql.catalyst.parser.AstBuilder
```

`CatalystSqlParser` is used to translate spark-sql-DataType.md[DataTypes] from their canonical string representation (e.g. when spark-sql-schema.md#add[adding fields to a schema] or spark-sql-Column.md#cast[casting column to a different data type]) or [StructTypes](../StructType.md).

```text
import org.apache.spark.sql.types.StructType
scala> val struct = new StructType().add("a", "int")
struct: org.apache.spark.sql.types.StructType = StructType(StructField(a,IntegerType,true))

scala> val asInt = expr("token = 'hello'").cast("int")
asInt: org.apache.spark.sql.Column = CAST((token = hello) AS INT)
```

When parsing, you should see INFO messages in the logs:

```text
Parsing command: int
```

It is also used in `HiveClientImpl` (when converting columns from Hive to Spark) and in `OrcFileOperator` (when inferring the schema for ORC files).

## Creating Instance

CatalystSqlParser takes the following to be created:

* [SQLConf](../SQLConf.md)

CatalystSqlParser is created when:

* [SessionCatalog](../SessionCatalog.md) is created (as the [default ParserInterface](../SessionCatalog.md#parser))

* CatalogV2Implicits utility is requested for a [SQL parser](CatalogV2Implicits.md#catalystSqlParser)

* LogicalExpressions utility is requested for a [SQL parser](LogicalExpressions.md#parser)

## Accessing CatalystSqlParser

```scala
// FIXME:
```

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.catalyst.parser.CatalystSqlParser` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.catalyst.parser.CatalystSqlParser=ALL
```

Refer to [Logging](../spark-logging.md).
