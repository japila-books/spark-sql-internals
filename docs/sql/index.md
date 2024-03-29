# SQL Parsing Framework

Spark SQL supports SQL language using SQL Parser Framework.

**SQL Parser Framework** translates SQL statements to corresponding relational entities using ANTLR[^1].

[^1]: [ANTLR's home page](https://www.antlr.org/)

!!! note "What is ANTLR?"
    ANTLR (ANother Tool for Language Recognition) is a parser generator used to build languages, tools, and frameworks. From a grammar, ANTLR generates a parser that can build and walk parse trees.

The main abstraction is [ParserInterface](ParserInterface.md) that is extended by [AbstractSqlParser](AbstractSqlParser.md) so SQL parsers can focus on a custom [AstBuilder](AstBuilder.md) only.

There are two concrete `AbstractSqlParsers`:

1. [SparkSqlParser](SparkSqlParser.md) that is the default parser of the SQL expressions into Spark SQL types.
1. [CatalystSqlParser](CatalystSqlParser.md) that is used to parse data types from their canonical string representation.

## Example

Let's take a look at `MERGE INTO` SQL statement to deep dive into how Spark SQL handles this and other SQL statements.

!!! warning "MERGE INTO and UPDATE SQL Statements Not Supported"
    Partial support for `MERGE INTO` went into Apache Spark 3.0.0 (as part of [SPARK-28893](https://issues.apache.org/jira/browse/SPARK-28893)).

    It is not finished yet since [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy throws an `UnsupportedOperationException` for `MERGE INTO` and `UPDATE` SQL statements.

`MERGE INTO` is described in [SqlBaseParser.g4](AstBuilder.md#grammar) grammar (in `#mergeIntoTable` labeled alternative).

`AstBuilder` [translates](AstBuilder.md#visitMergeIntoTable) a `MERGE INTO` SQL query into a [MergeIntoTable](../logical-operators/MergeIntoTable.md) logical command.

[ResolveReferences](../logical-analysis-rules/ResolveReferences.md) logical resolution rule is used to resolve references of `MergeIntoTables` (for a merge condition and matched and not-matched actions).

In the end, [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy throws an `UnsupportedOperationException`:

```text
MERGE INTO TABLE is not supported temporarily.
```
