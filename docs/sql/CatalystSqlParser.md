# CatalystSqlParser &mdash; Parser for DataTypes and StructTypes

[[astBuilder]]
`CatalystSqlParser` is a link:spark-sql-AbstractSqlParser.adoc[AbstractSqlParser] with link:spark-sql-AstBuilder.adoc[AstBuilder] as the required `astBuilder`.

```scala
import org.apache.spark.sql.catalyst.parser.CatalystSqlParser
import org.apache.spark.sql.internal.SQLConf
val catalystSqlParser = new CatalystSqlParser(SQLConf.get)
```

`CatalystSqlParser` is used to translate link:spark-sql-DataType.adoc[DataTypes] from their canonical string representation (e.g. when link:spark-sql-schema.adoc#add[adding fields to a schema] or link:spark-sql-Column.adoc#cast[casting column to a different data type]) or link:spark-sql-StructType.adoc[StructTypes].

```
import org.apache.spark.sql.types.StructType
scala> val struct = new StructType().add("a", "int")
struct: org.apache.spark.sql.types.StructType = StructType(StructField(a,IntegerType,true))

scala> val asInt = expr("token = 'hello'").cast("int")
asInt: org.apache.spark.sql.Column = CAST((token = hello) AS INT)
```

When parsing, you should see INFO messages in the logs:

```
Parsing command: int
```

It is also used in `HiveClientImpl` (when converting columns from Hive to Spark) and in `OrcFileOperator` (when inferring the schema for ORC files).

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
