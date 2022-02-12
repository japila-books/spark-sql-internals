# CatalystSqlParser

`CatalystSqlParser` is an [AbstractSqlParser](AbstractSqlParser.md) for [DataType](../types/DataType.md)s.

`CatalystSqlParser` uses [AstBuilder](AstBuilder.md) for parsing SQL texts.

```text
import org.apache.spark.sql.catalyst.parser.CatalystSqlParser
import org.apache.spark.sql.internal.SQLConf
val catalystSqlParser = new CatalystSqlParser(SQLConf.get)
scala> :type catalystSqlParser.astBuilder
org.apache.spark.sql.catalyst.parser.AstBuilder
```

`CatalystSqlParser` is used to translate [DataTypes](../types/DataType.md) from their canonical string representation (e.g. when [adding fields to a schema](../types/index.md#add) or [casting column to a different data type](../Column.md#cast)) or [StructTypes](../types/StructType.md).

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

`CatalystSqlParser` takes the following to be created:

* [SQLConf](../SQLConf.md)

`CatalystSqlParser` is created when:

* [SessionCatalog](../SessionCatalog.md#parser) is created

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.catalyst.parser.CatalystSqlParser` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.catalyst.parser.CatalystSqlParser=ALL
```

Refer to [Logging](../spark-logging.md).
