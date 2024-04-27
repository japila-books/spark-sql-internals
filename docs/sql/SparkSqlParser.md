# SparkSqlParser &mdash; Default SQL Parser

`SparkSqlParser` is a [SQL parser](AbstractSqlParser.md) to extract Catalyst expressions, plans, table identifiers from SQL texts using [SparkSqlAstBuilder](SparkSqlAstBuilder.md) (as [AstBuilder](AbstractSqlParser.md#astBuilder)).

`SparkSqlParser` is the [initial SQL parser](../BaseSessionStateBuilder.md#sqlParser) in a `SparkSession`.

`SparkSqlParser` supports [variable substitution](#variable-substitution).

`SparkSqlParser` is used to parse table strings into their corresponding table identifiers in the following:

* `table` methods in [DataFrameReader](../DataFrameReader.md#table) and [SparkSession](../SparkSession.md#table)
* [insertInto](../DataFrameWriter.md#insertInto) and [saveAsTable](../DataFrameWriter.md#saveAsTable) methods of `DataFrameWriter`
* `createExternalTable` and `refreshTable` methods of [Catalog](../Catalog.md) (and [SessionState](../SessionState.md#refreshTable))

## Creating Instance

`SparkSqlParser` takes the following to be created:

* <span id="conf"> [SQLConf](../SQLConf.md)

`SparkSqlParser` is created when:

* `BaseSessionStateBuilder` is requested for a [SQL parser](../BaseSessionStateBuilder.md#sqlParser)

* [expr](../standard-functions/index.md#expr) standard function is used

## <span id="parse"> Parsing Command

```scala
parse[T](
  command: String)(
  toResult: SqlBaseParser => T): T
```

`parse` is part of the [AbstractSqlParser](AbstractSqlParser.md#parse) abstraction.

---

!!! note
    The only reason for overriding `parse` method is to allow for [VariableSubstitution](#substitutor) to [substitute variables](VariableSubstitution.md#substitute).

`parse` requests the [VariableSubstitution](#substitutor) to [substitute variables](VariableSubstitution.md#substitute) before requesting the default (parent) parser to [parse the command](AbstractSqlParser.md#parse).

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

`SparkSqlParser` is used to translate an expression to the corresponding [Column](../Column.md) in the following:

* [expr](../standard-functions/index.md#expr) standard function
* Dataset operators: [selectExpr](../Dataset.md#selectExpr), [filter](../Dataset.md#filter), [where](../Dataset.md#where)

```text
scala> expr("token = 'hello'")
16/07/07 18:32:53 INFO SparkSqlParser: Parsing command: token = 'hello'
res0: org.apache.spark.sql.Column = (token = hello)
```

## <span id="substitutor"><span id="VariableSubstitution"> Variable Substitution

`SparkSqlParser` creates a [VariableSubstitution](VariableSubstitution.md) when [created](#creating-instance).

The `VariableSubstitution` is used while [parsing a SQL command](#parse).

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.SparkSqlParser` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.SparkSqlParser=ALL
```

Refer to [Logging](../spark-logging.md).
