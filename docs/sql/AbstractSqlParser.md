# AbstractSqlParser &mdash; Base SQL Parsing Infrastructure

`AbstractSqlParser` is an [extension](#contract) of the [ParserInterface](ParserInterface.md) abstraction for [SQL parsers](#implementations) that delegate parsing to an [AstBuilder](#astBuilder).

`AbstractSqlParser` is the foundation of the [SQL Parsing Framework](index.md).

## AstBuilder

```scala
astBuilder: AstBuilder
```

[AstBuilder](AstBuilder.md) for parsing SQL statements

## Implementations

* [CatalystSqlParser](CatalystSqlParser.md) for parsing canonical textual representation of [data types](../spark-sql-DataType.md) and [schema](../spark-sql-StructType.md)

* [SparkSqlParser](SparkSqlParser.md) that is the default SQL parser in [SessionState](../SessionState.md#sqlParser)

## Setting Up SqlBaseLexer and SqlBaseParser for Parsing

```scala
parse[T](
  command: String)(
  toResult: SqlBaseParser => T): T
```

`parse` sets up ANTLR parsing infrastructure with `SqlBaseLexer` and `SqlBaseParser` (which are the ANTLR-specific classes of Spark SQL that are auto-generated at build time from the [SqlBase.g4](AstBuilder.md#grammar) grammar).

Internally, `parse` first prints out the following INFO message to the logs:

```text
Parsing command: [command]
```

!!! tip
    Enable `INFO` logging level for the [custom `AbstractSqlParser`s](#implementations) to see the above and other INFO messages.

`parse` then creates and sets up a `SqlBaseLexer` and `SqlBaseParser` that in turn passes the latter on to the input `toResult` function where the parsing finally happens.

`parse` uses `SLL` prediction mode for parsing first before falling back to `LL` mode.

In case of parsing errors, `parse` reports a `ParseException`.

`parse` is used in all the `parse` methods.
