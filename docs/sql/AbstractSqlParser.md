# AbstractSqlParser

`AbstractSqlParser` is an [extension](#contract) of the [ParserInterface](ParserInterface.md) abstraction for [SQL parsers](#implementations) that delegate parsing to an [AstBuilder](#astBuilder).

## AstBuilder

```scala
astBuilder: AstBuilder
```

[AstBuilder](AstBuilder.md) for parsing SQL statements

Used when:

* `AbstractSqlParser` is requested to [parseDataType](#parseDataType), [parseExpression](#parseExpression), [parseTableIdentifier](#parseTableIdentifier), [parseFunctionIdentifier](#parseFunctionIdentifier), [parseMultipartIdentifier](#parseMultipartIdentifier), [parseTableSchema](#parseTableSchema), [parsePlan](#parsePlan)

## Implementations

* [CatalystSqlParser](CatalystSqlParser.md)
* [SparkSqlParser](SparkSqlParser.md)

## Setting Up SqlBaseLexer and SqlBaseParser for Parsing

```scala
parse[T](
  command: String)(
  toResult: SqlBaseParser => T): T
```

`parse` sets up ANTLR parsing infrastructure with `SqlBaseLexer` and `SqlBaseParser` (which are the ANTLR-specific classes of Spark SQL that are auto-generated at build time from the [SqlBaseParser.g4](AstBuilder.md#grammar) grammar).

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

## <span id="parsePlan"> parsePlan

```scala
parsePlan(
  sqlText: String): LogicalPlan
```

`parsePlan` [parses](#parse) the given SQL text (that requests the [AstBuilder](#astBuilder) to [visitSingleStatement](AstBuilder.md#visitSingleStatement) to produce a [LogicalPlan](../logical-operators/LogicalPlan.md)).

`parsePlan` is part of the [ParserInterface](ParserInterface.md#parsePlan) abstraction.
