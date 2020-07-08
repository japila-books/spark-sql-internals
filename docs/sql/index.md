# SQL Parsing Framework

**SQL Parser Framework** in Spark SQL uses ANTLR[^1] to translate a SQL text to relational [data types](../spark-sql-DataType.md), [expressions](../spark-sql-Expression.md), `TableIdentifiers` and [logical operators](../logical-operators/LogicalPlan.md).

!!! note "What is ANTLR?"
    ANTLR (ANother Tool for Language Recognition) is a parser generator used to build languages, tools, and frameworks. From a grammar, ANTLR generates a parser that can build and walk parse trees.

SQL Parser Framework is defined by [ParserInterface](ParserInterface.md) abstraction. This is extended by [AbstractSqlParser](AbstractSqlParser.md) so concrete SQL parsers can focus on a custom [AstBuilder](AstBuilder.md) only.

There are two concrete `AbstractSqlParsers`:

1. [SparkSqlParser](SparkSqlParser.md) that is the default parser of the SQL expressions into Spark SQL types.
1. [CatalystSqlParser](CatalystSqlParser.md) that is used to parse data types from their canonical string representation.

[^1]: [ANTLR's home page](https://www.antlr.org/)
