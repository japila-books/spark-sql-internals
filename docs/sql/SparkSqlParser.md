# SparkSqlParser &mdash; Default SQL Parser

`SparkSqlParser` is a [SQL parser](AbstractSqlParser.md) to extract Catalyst expressions, plans, table identifiers from SQL texts using [SparkSqlAstBuilder](SparkSqlAstBuilder.md) (as [AstBuilder](AbstractSqlParser.md#astBuilder)).

`SparkSqlParser` is the [initial SQL parser](../BaseSessionStateBuilder.md#sqlParser) in a `SparkSession`.

`SparkSqlParser` supports [variable substitution](#variable-substitution).

`SparkSqlParser` is used to parse table strings into their corresponding table identifiers in the following:

* `table` methods in [DataFrameReader](../DataFrameReader.md#table) and [SparkSession](../SparkSession.md#table)
* [insertInto](../spark-sql-DataFrameWriter.md#insertInto) and [saveAsTable](../spark-sql-DataFrameWriter.md#saveAsTable) methods of `DataFrameWriter`
* `createExternalTable` and `refreshTable` methods of [Catalog](../spark-sql-Catalog.md) (and [SessionState](../SessionState.md#refreshTable))

## Creating Instance

`SparkSqlParser` takes the following to be created:

* <span id="conf"> [SQLConf](../spark-sql-SQLConf.md)

`SparkSqlParser` is created when:

* `BaseSessionStateBuilder` is requested for a [SQL parser](../BaseSessionStateBuilder.md#sqlParser)

* [expr](../spark-sql-functions.md#expr) standard function is used

## <span id="astBuilder"> SparkSqlAstBuilder

`SparkSqlParser` uses [SparkSqlAstBuilder](SparkSqlAstBuilder.md) (as [AstBuilder](AbstractSqlParser.md#astBuilder)).

## Accessing SparkSqlParser

`SparkSqlParser` is available as [SessionState.sqlParser](../SessionState.md#sqlParser) (unless...FIXME(note)).

```scala
import org.apache.spark.sql.SparkSession
assert(spark.isInstanceOf[SparkSession])

import org.apache.spark.sql.catalyst.parser.ParserInterface
val p = spark.sessionState.sqlParser
assert(p.isInstanceOf[ParserInterface])

import org.apache.spark.sql.execution.SparkSqlParser
assert(spark.sessionState.sqlParser.isInstanceOf[SparkSqlParser])
```

## Translating SQL Statements to Logical Operators

`SparkSqlParser` is used in [SparkSession.sql](../SparkSession.md#sql) to translate a SQL text to a [logical operator](../logical-operators/LogicalPlan.md).

## Translating SQL Statements to Column API

`SparkSqlParser` is used to translate an expression to the corresponding [Column](../spark-sql-Column.md) in the following:

* [expr](../spark-sql-functions.md#expr) standard function
* Dataset operators: [selectExpr](../spark-sql-Dataset.md#selectExpr), [filter](../spark-sql-Dataset.md#filter), [where](../spark-sql-Dataset.md#where)

```text
scala> expr("token = 'hello'")
16/07/07 18:32:53 INFO SparkSqlParser: Parsing command: token = 'hello'
res0: org.apache.spark.sql.Column = (token = hello)
```

## <span id="substitutor"> Variable Substitution

`SparkSqlParser` creates a `VariableSubstitution` when [created](#creating-instance)

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.SparkSqlParser` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.SparkSqlParser=ALL
```

Refer to [Logging](../spark-logging.md).
