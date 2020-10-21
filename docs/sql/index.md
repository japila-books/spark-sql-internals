# SQL Parsing Framework

**SQL Parser Framework** in Spark SQL uses ANTLR[^1] to translate SQL statements to relational entities (e.g. [data types](../DataType.md), [Catalyst expressions](../expressions/Expression.md), [logical operators](../logical-operators/LogicalPlan.md)).

[^1]: [ANTLR's home page](https://www.antlr.org/)

!!! note "What is ANTLR?"
    ANTLR (ANother Tool for Language Recognition) is a parser generator used to build languages, tools, and frameworks. From a grammar, ANTLR generates a parser that can build and walk parse trees.

SQL Parser Framework is defined by [ParserInterface](ParserInterface.md) abstraction. This is extended by [AbstractSqlParser](AbstractSqlParser.md) so concrete SQL parsers can focus on a custom [AstBuilder](AstBuilder.md) only.

There are two concrete `AbstractSqlParsers`:

1. [SparkSqlParser](SparkSqlParser.md) that is the default parser of the SQL expressions into Spark SQL types.
1. [CatalystSqlParser](CatalystSqlParser.md) that is used to parse data types from their canonical string representation.

## MERGE INTO SQL Statement

Let's take a look at `MERGE INTO` SQL statement to deep dive into how Spark SQL handles this and other SQL statements.

!!! warning "MERGE INTO and UPDATE SQL Statements Not Supported"
    Partial support for `MERGE INTO` went into Apache Spark 3.0.0 (as part of [SPARK-28893](https://issues.apache.org/jira/browse/SPARK-28893)).

    It is not finished yet since [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy throws an `UnsupportedOperationException` for `MERGE INTO` and `UPDATE` SQL statements.

`MERGE INTO` is described in [SqlBase.g4](AstBuilder.md#grammar) grammar (in `#mergeIntoTable` labeled alternative) as follows:

```text
MERGE INTO target=multipartIdentifier targetAlias=tableAlias
    USING (source=multipartIdentifier |
        '(' sourceQuery=query')') sourceAlias=tableAlias
    ON mergeCondition=booleanExpression
    matchedClause*
    notMatchedClause*

matchedClause
    : WHEN MATCHED (AND matchedCond=booleanExpression)? THEN matchedAction
    ;
notMatchedClause
    : WHEN NOT MATCHED (AND notMatchedCond=booleanExpression)? THEN notMatchedAction
    ;

matchedAction
    : DELETE
    | UPDATE SET ASTERISK
    | UPDATE SET assignmentList
    ;

notMatchedAction
    : INSERT ASTERISK
    | INSERT '(' columns=multipartIdentifierList ')'
        VALUES '(' expression (',' expression)* ')'
    ;
```

`AstBuilder` [translates a `MERGE INTO` SQL query into a MergeIntoTable logical command](AstBuilder.md#visitMergeIntoTable).

[ResolveReferences](../logical-analysis-rules/ResolveReferences.md) logical resolution rule is used to resolve references of `MergeIntoTables` (for a merge condition and matched and not-matched actions).

In the end, [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy throws an `UnsupportedOperationException`:

```text
MERGE INTO TABLE is not supported temporarily.
```
