---
title: AstBuilder
---

# AstBuilder &mdash; ANTLR-based SQL Parser

`AstBuilder` converts ANTLR `ParseTree`s into Catalyst entities using [visit callbacks](#visit-callbacks).

`AstBuilder` is the only requirement of the [AbstractSqlParser](AbstractSqlParser.md#astBuilder) abstraction (and used by [CatalystSqlParser](CatalystSqlParser.md) directly while [SparkSqlParser](SparkSqlParser.md) uses [SparkSqlAstBuilder](SparkSqlAstBuilder.md) instead).

## <span id="grammar"><span id="SqlBaseParserBaseVisitor"> SqlBaseParser.g4 &mdash; ANTLR Grammar

`AstBuilder` is an ANTLR `AbstractParseTreeVisitor` (as `SqlBaseParserBaseVisitor`) that is generated from the ANTLR grammar of Spark SQL.

`SqlBaseParserBaseVisitor` is a ANTLR-specific base class that is generated at build time from the ANTLR grammar of Spark SQL. The Spark SQL grammar is available in the Apache Spark repository at [SqlBaseParser.g4]({{ spark.github }}/sql/catalyst/src/main/antlr4/org/apache/spark/sql/catalyst/parser/SqlBaseParser.g4).

`SqlBaseParserBaseVisitor` is an [AbstractParseTreeVisitor](http://www.antlr.org/api/Java/org/antlr/v4/runtime/tree/AbstractParseTreeVisitor.html) in ANTLR.

!!! note "Spark 3.3.0"
    As of Spark 3.3.0 ([SPARK-38378]({{ spark.jira }}/SPARK-38378)) the ANTLR grammar is in two separate files for the parser and the lexer, `SqlBaseParser.g4` and `SqlBaseLexer.g4`, respectively:

    > By separating the lexer and parser, we will be able to use the full power of ANTLR parser and lexer grammars. e.g. lexer mode. This will give us more flexibility when implementing new SQL features.

## Visit Callbacks

### <span id="visitAddTableColumns"> visitAddTableColumns

Creates an [AddColumns](../logical-operators/AddColumns.md) logical operator

```text
ALTER TABLE multipartIdentifier
  ADD (COLUMN | COLUMNS)
  '(' columns=qualifiedColTypeWithPositionList ')'

qualifiedColTypeWithPositionList
    : qualifiedColTypeWithPosition (',' qualifiedColTypeWithPosition)*
    ;

qualifiedColTypeWithPosition
    : name=multipartIdentifier dataType (NOT NULL)? commentSpec? colPosition?
    ;

commentSpec
    : COMMENT text
    ;

colPosition
    : position=FIRST | position=AFTER afterCol=errorCapturingIdentifier
    ;
```

ANTLR labeled alternative: `#addTableColumns`

### <span id="visitAnalyze"> visitAnalyze

Creates an [AnalyzeColumn](../logical-operators/AnalyzeColumn.md) or [AnalyzeTable](../logical-operators/AnalyzeTable.md) logical operators

```text
ANALYZE TABLE multipartIdentifier partitionSpec? COMPUTE STATISTICS
  (NOSCAN | FOR COLUMNS identifierSeq | FOR ALL COLUMNS)?

partitionSpec
    : PARTITION '(' partitionVal (',' partitionVal)* ')'
    ;

partitionVal
    : identifier (EQ constant)?
    ;

EQ  : '=' | '==';
```

`visitAnalyze` creates an [AnalyzeColumn](../logical-operators/AnalyzeColumn.md) when one of the following is used:

* `FOR COLUMNS identifierSeq`
* `FOR ALL COLUMNS`

ANTLR labeled alternative: `#analyze`

### <span id="visitBucketSpec"> visitBucketSpec

Creates a [BucketSpec](../bucketing/BucketSpec.md)

```antlr
bucketSpec
  : CLUSTERED BY '(' identifierList ')'
    (SORTED BY '(' orderedIdentifierList ')' )?
    INTO digit BUCKETS
  ;
```

Column ordering must be `ASC`

### <span id="visitCommentTable"> visitCommentTable

Creates a [CommentOnTable](../logical-operators/CommentOnTable.md) logical command

```text
COMMENT ON TABLE tableIdentifier IS ('text' | NULL)
```

ANTLR labeled alternative: `#commentTable`

### visitCommonSelectQueryClausePlan { #visitCommonSelectQueryClausePlan }

Used when:

* [withSelectQuerySpecification](#withSelectQuerySpecification)
* [withTransformQuerySpecification](#withTransformQuerySpecification)

### <span id="visitCreateTable"> visitCreateTable

Creates a [CreateTableAsSelect](../logical-operators/CreateTableAsSelect.md) (for CTAS queries with `AS` clause) or [CreateTable](../logical-operators/CreateTable.md) logical operator

```text
CREATE TEMPORARY? EXTERNAL? TABLE (IF NOT EXISTS)? [multipartIdentifier]
  ('(' [colType] (',' [colType])* ')')?
  (USING [provider])?
  [createTableClauses]
  (AS? query)?

colType
  : colName dataType (NOT NULL)? (COMMENT [comment])?
  ;

createTableClauses:
  ((OPTIONS options=propertyList) |
  (PARTITIONED BY partitioning=partitionFieldList) |
  skewSpec |
  bucketSpec |
  rowFormat |
  createFileFormat |
  locationSpec |
  commentSpec |
  (TBLPROPERTIES tableProps=propertyList))*
```

ANTLR labeled alternative: `#createTable`

### <span id="visitDeleteFromTable"> visitDeleteFromTable

Creates a [DeleteFromTable](../logical-operators/DeleteFromTable.md) logical command

```text
DELETE FROM multipartIdentifier tableAlias whereClause?
```

ANTLR labeled alternative: `#deleteFromTable`

### <span id="visitDescribeRelation"> visitDescribeRelation

Creates a `DescribeColumnStatement` or [DescribeRelation](../logical-operators/DescribeRelation.md)

```text
(DESC | DESCRIBE) TABLE? option=(EXTENDED | FORMATTED)?
  multipartIdentifier partitionSpec? describeColName?
```

ANTLR labeled alternative: `#describeRelation`

### <span id="visitExists"> visitExists

Creates an [Exists](../expressions/Exists.md) expression

ANTLR labeled alternative: `#exists`

### <span id="visitExplain"> visitExplain

Creates a [ExplainCommand](../logical-operators/ExplainCommand.md)

ANTLR rule: `explain`

### <span id="visitFirst"> visitFirst

Creates a [First](../expressions/First.md) aggregate function expression

```text
FIRST '(' expression (IGNORE NULLS)? ')'
```

ANTLR labeled alternative: `#first`

### <span id="visitFromClause"> visitFromClause

Creates a [LogicalPlan](../logical-operators/LogicalPlan.md)

```text
FROM relation (',' relation)* lateralView* pivotClause?
```

Supports multiple comma-separated relations (that all together build a condition-less [INNER JOIN](#withJoinRelations)) with optional [LATERAL VIEW](../expressions/Generator.md#lateral-view).

A relation can be one of the following or a combination thereof:

* Table identifier
* Inline table using `VALUES exprs AS tableIdent`
* Table-valued function (currently only `range` is supported)

ANTLR rule: `fromClause`

### visitFromStatement { #visitFromStatement }

```antlr
fromStatement
    : fromClause fromStatementBody+
    ;

fromClause
    : FROM relation (COMMA relation)* lateralView* pivotClause? unpivotClause?
    ;

fromStatementBody
    : transformClause
      whereClause?
      queryOrganization
    | selectClause
      lateralView*
      whereClause?
      aggregationClause?
      havingClause?
      windowClause?
      queryOrganization
    ;
```

### <span id="visitFunctionCall"> visitFunctionCall

Creates one of the following:

* [UnresolvedFunction](../expressions/UnresolvedFunction.md) for a bare function (with no window specification)

* `UnresolvedWindowExpression` for a function evaluated in a windowed context with a `WindowSpecReference`

* [WindowExpression](../expressions/WindowExpression.md) for a function over a window

ANTLR rule: `functionCall`

```text
import spark.sessionState.sqlParser

scala> sqlParser.parseExpression("foo()")
res0: org.apache.spark.sql.catalyst.expressions.Expression = 'foo()

scala> sqlParser.parseExpression("foo() OVER windowSpecRef")
res1: org.apache.spark.sql.catalyst.expressions.Expression = unresolvedwindowexpression('foo(), WindowSpecReference(windowSpecRef))

scala> sqlParser.parseExpression("foo() OVER (CLUSTER BY field)")
res2: org.apache.spark.sql.catalyst.expressions.Expression = 'foo() windowspecdefinition('field, UnspecifiedFrame)
```

### <span id="visitInlineTable"> visitInlineTable

Creates a `UnresolvedInlineTable` unary logical operator (as the child of [SubqueryAlias](../logical-operators/SubqueryAlias.md) for `tableAlias`)

```text
VALUES expression (',' expression)* tableAlias
```

`expression` can be as follows:

* [CreateNamedStruct](../expressions/CreateNamedStruct.md) expression for multiple-column tables

* Any [Catalyst expression](../expressions/Expression.md) for one-column tables

`tableAlias` can be specified explicitly or defaults to `colN` for every column (starting from `1` for `N`).

ANTLR rule: `inlineTable`

### <span id="visitInsertIntoTable"> visitInsertIntoTable

Creates a [InsertIntoTable](../logical-operators/InsertIntoTable.md) (indirectly)

A 3-element tuple with a `TableIdentifier`, optional partition keys and the `exists` flag disabled

```text
INSERT INTO TABLE? tableIdentifier partitionSpec?
```

ANTLR labeled alternative: `#insertIntoTable`

!!! note
    `insertIntoTable` is part of `insertInto` that is in turn used only as a helper labeled alternative in [singleInsertQuery](#singleInsertQuery) and [multiInsertQueryBody](#multiInsertQueryBody) ANTLR rules.

### <span id="visitInsertOverwriteTable"> visitInsertOverwriteTable

Creates a [InsertIntoTable](../logical-operators/InsertIntoTable.md) (indirectly)

A 3-element tuple with a `TableIdentifier`, optional partition keys and the `exists` flag

```text
INSERT OVERWRITE TABLE tableIdentifier (partitionSpec (IF NOT EXISTS)?)?
```

In a way, `visitInsertOverwriteTable` is simply a more general version of the [visitInsertIntoTable](#visitInsertIntoTable) with the `exists` flag on or off based on existence of `IF NOT EXISTS`. The main difference is that [dynamic partitions](../dynamic-partition-inserts.md#dynamic-partitions) are used with no `IF NOT EXISTS`.

ANTLR labeled alternative: `#insertOverwriteTable`

!!! note
    `insertIntoTable` is part of `insertInto` that is in turn used only as a helper labeled alternative in [singleInsertQuery](#singleInsertQuery) and [multiInsertQueryBody](#multiInsertQueryBody) ANTLR rules.

### <span id="visitInterval"> visitInterval

Creates a [Literal](../expressions/Literal.md) expression to represent an interval type

```antlr
INTERVAL (MultiUnitsInterval | UnitToUnitInterval)?
```

ANTLR rule: `interval`

---

`visitInterval` [creates a CalendarInterval](#parseIntervalLiteral).

`visitInterval` parses `UnitToUnitInterval` if specified first (and [spark.sql.legacy.interval.enabled](../configuration-properties.md#spark.sql.legacy.interval.enabled) configuration property turned off).

```antlr
unitToUnitInterval
    : value from TO to
    ;
```

`month` in `to` leads to a `YearMonthIntervalType` while other identifiers lead to a `DayTimeIntervalType`.

```text
INTERVAL '0-0' YEAR TO MONTH        // YearMonthIntervalType
INTERVAL '0 00:00:00' DAY TO SECOND // DayTimeIntervalType
```

`visitInterval` parses `MultiUnitsInterval` if specified (and [spark.sql.legacy.interval.enabled](../configuration-properties.md#spark.sql.legacy.interval.enabled) configuration property turned off).

```antlr
multiUnitsInterval
    : (intervalValue unit)+
    ;
```

### visitMergeIntoTable { #visitMergeIntoTable }

```scala
visitMergeIntoTable(
  ctx: MergeIntoTableContext): LogicalPlan
```

Creates a [MergeIntoTable](../logical-operators/MergeIntoTable.md) logical command for a `MERGE INTO` DML statement

```antlr
MERGE INTO target targetAlias
USING (source | (sourceQuery)) sourceAlias
ON mergeCondition
matchedClause*
notMatchedClause*
notMatchedBySourceClause*

matchedClause
  : WHEN MATCHED (AND matchedCond)? THEN matchedAction
  ;

notMatchedClause
  : WHEN NOT MATCHED (BY TARGET)? (AND notMatchedCond)? THEN notMatchedAction
  ;

notMatchedBySourceClause
  : WHEN NOT MATCHED BY SOURCE (AND notMatchedBySourceCond)? THEN notMatchedBySourceAction
  ;

matchedAction
  : DELETE
  | UPDATE SET *
  | UPDATE SET assignment (',' assignment)*

notMatchedAction
  : INSERT *
  | INSERT '(' columns ')'
    VALUES '(' expression (',' expression)* ')'

notMatchedBySourceAction
  : DELETE
  | UPDATE SET assignment (',' assignment)*
  ;
```

Requirements:

1. There must be at least one `WHEN` clause
1. When there are more than one `MATCHED` clauses, only the last `MATCHED` clause can omit the condition
1. When there are more than one `NOT MATCHED` clauses, only the last `NOT MATCHED` clause can omit the condition

ANTLR labeled alternative: `#mergeIntoTable`

### visitMultiInsertQuery { #visitMultiInsertQuery }

Creates a logical operator with a [InsertIntoTable](../logical-operators/InsertIntoTable.md) (and `UnresolvedRelation` leaf operator)

```text
FROM relation (',' relation)* lateralView*
INSERT OVERWRITE TABLE ...

FROM relation (',' relation)* lateralView*
INSERT INTO TABLE? ...
```

ANTLR rule: `multiInsertQueryBody`

### <span id="visitNamedExpression"> visitNamedExpression

Creates one of the following Catalyst expressions:

* `Alias` (for a single alias)
* `MultiAlias` (for a parenthesis enclosed alias list)
* a bare [Expression](../expressions/Expression.md)

ANTLR rule: `namedExpression`

### <span id="visitNamedQuery"> visitNamedQuery

Creates a [SubqueryAlias](../logical-operators/SubqueryAlias.md)

### <span id="visitPrimitiveDataType"> visitPrimitiveDataType

Creates a primitive [DataType](../types/DataType.md) from SQL type representation.

SQL Type | DataType
---------|----------
`boolean` | BooleanType
`tinyint`, `byte` | ByteType
`smallint`, `short` | ShortType
`int`, `integer` | IntegerType
`bigint`, `long` | LongType
`float`, `real` | FloatType
`double` | DoubleType
`date` | DateType
`timestamp` | TimestampType
`string` | StringType
`character`, `char` | CharType
`varchar` | VarcharType
`binary` | BinaryType
`decimal`, `dec`, `numeric` | DecimalType
`void` | NullType
`interval` | CalendarIntervalType

### <span id="visitPredicated"> visitPredicated

Creates an [Expression](../expressions/Expression.md)

ANTLR rule: `predicated`

### <span id="visitQuerySpecification"> visitQuerySpecification

Creates `OneRowRelation` or [LogicalPlan](../logical-operators/LogicalPlan.md)

??? note "OneRowRelation"
    `visitQuerySpecification` creates a `OneRowRelation` for a `SELECT` without a `FROM` clause.

    ```text
    val q = sql("select 1")
    scala> println(q.queryExecution.logical.numberedTreeString)
    00 'Project [unresolvedalias(1, None)]
    01 +- OneRowRelation$
    ```

ANTLR rule: `querySpecification`

### visitRegularQuerySpecification { #visitRegularQuerySpecification }

[withSelectQuerySpecification](#withSelectQuerySpecification) with a [from](#visitFromClause) relation

```antlr
querySpecification
    : ...                        #transformQuerySpecification
    | selectClause
      fromClause?
      lateralView*
      whereClause?
      aggregationClause?
      havingClause?
      windowClause?              #regularQuerySpecification
    ;

havingClause
    : HAVING booleanExpression
    ;

windowClause
    : WINDOW namedWindow (COMMA namedWindow)*
    ;
```

ANTLR rule: `regularQuerySpecification`

!!! note "aggregationClause"
    `aggregationClause` is handled by [withAggregationClause](#withAggregationClause).

??? note "transformQuerySpecification"
    The other rule `transformQuerySpecification` is handled by [withTransformQuerySpecification](#withTransformQuerySpecification).

### <span id="visitRelation"> visitRelation

Creates a [LogicalPlan](../logical-operators/LogicalPlan.md) for a `FROM` clause.

ANTLR rule: `relation`

### <span id="visitRenameTableColumn"> visitRenameTableColumn

Creates a [RenameColumn](../logical-operators/AlterTableCommand.md#RenameColumn) for the following SQL statement:

```text
ALTER TABLE table
RENAME COLUMN from TO to
```

ANTLR labeled alternative: `#renameTableColumn`

### <span id="visitRepairTable"> visitRepairTable

Creates a `RepairTable` unary logical command for the following SQL statement:

```text
MSCK REPAIR TABLE multipartIdentifier
```

ANTLR labeled alternative: `#repairTable`

### visitShowColumns { #visitShowColumns }

Creates a [ShowColumns](../logical-operators/ShowColumns.md) logical command for the following SQL statement:

```antlr
SHOW COLUMNS
  (FROM | IN) [table]
  ((FROM | IN) [ns])?
```

ANTLR labeled alternative: `#showColumns`

### <span id="visitShowCreateTable"> visitShowCreateTable

Creates a [ShowCreateTable](../logical-operators/ShowCreateTable.md) logical command for the following SQL statement:

```text
SHOW CREATE TABLE multipartIdentifier (AS SERDE)?
```

ANTLR labeled alternative: `#showCreateTable`

### <span id="visitShowCurrentNamespace"> visitShowCurrentNamespace

Creates a `ShowCurrentNamespaceCommand` logical command for the following SQL statement:

```text
SHOW CURRENT NAMESPACE
```

ANTLR labeled alternative: `#showCurrentNamespace`

### <span id="visitShowTables"> visitShowTables

Creates a [ShowTables](../logical-operators/ShowTables.md) for the following SQL statement:

```text
SHOW TABLES ((FROM | IN) multipartIdentifier)?
  (LIKE? pattern=STRING)?
```

ANTLR labeled alternative: `#showTables`

### <span id="visitShowTblProperties"> visitShowTblProperties

Creates a [ShowTableProperties](../logical-operators/ShowTableProperties.md) logical command

```text
SHOW TBLPROPERTIES [multi-part table identifier]
  ('(' [dot-separated table property key] ')')?
```

ANTLR labeled alternative: `#showTblProperties`

### <span id="visitSingleDataType"> visitSingleDataType

Creates a [DataType](../types/DataType.md)

ANTLR rule: `singleDataType`

### <span id="visitSingleExpression"> visitSingleExpression

Creates an [Expression](../expressions/Expression.md)

Takes the named expression and relays to [visitNamedExpression](#visitNamedExpression)

ANTLR rule: `singleExpression`

### <span id="visitSingleInsertQuery"> visitSingleInsertQuery

Calls [withInsertInto](#withInsertInto) (with an `InsertIntoContext`) for the following SQLs:

```sql
INSERT OVERWRITE TABLE? multipartIdentifier
(partitionSpec (IF NOT EXISTS)?)?
identifierList?
```

```sql
INSERT INTO TABLE? multipartIdentifier
partitionSpec?
(IF NOT EXISTS)?
identifierList?
```

```sql
INSERT OVERWRITE LOCAL? DIRECTORY path=STRING rowFormat? createFileFormat?
```

```sql
INSERT OVERWRITE LOCAL? DIRECTORY (path=STRING)?
tableProvider
(OPTIONS options=tablePropertyList)?
```

ANTLR labeled alternative: `#singleInsertQuery`

### <span id="visitSingleStatement"> visitSingleStatement

Creates a [LogicalPlan](../logical-operators/LogicalPlan.md) from a single SQL statement

ANTLR rule: `singleStatement`

### <span id="visitSortItem"> visitSortItem

Creates a [SortOrder](../expressions/SortOrder.md) unary expression

```text
sortItem
    : expression ordering=(ASC | DESC)? (NULLS nullOrder=(LAST | FIRST))?
    ;

// queryOrganization
ORDER BY order+=sortItem (',' order+=sortItem)*
SORT BY sort+=sortItem (',' sort+=sortItem)*

// windowSpec
(ORDER | SORT) BY sortItem (',' sortItem)*)?
```

ANTLR rule: `sortItem`

### <span id="visitStar"> visitStar

Creates a [UnresolvedStar](../expressions/UnresolvedStar.md)

ANTLR labeled alternative: `#star`

### <span id="visitSubqueryExpression"> visitSubqueryExpression

Creates a [ScalarSubquery](../expressions/ScalarSubquery.md)

ANTLR labeled alternative: `#subqueryExpression`

### <span id="visitTableValuedFunction"> visitTableValuedFunction

Creates a [UnresolvedTableValuedFunction](../logical-operators/UnresolvedTableValuedFunction.md)

```antlr
relationPrimary
  :
  ...
  | functionTable                                         #tableValuedFunction
  ;

functionTable
  : funcName '(' (expression (',' expression)*)? ')' tableAlias
  ;
```

ANTLR labeled alternative: `#tableValuedFunction`

### <span id="visitUpdateTable"> visitUpdateTable

Creates an [UpdateTable](../logical-operators/UpdateTable.md) logical operator

```text
UPDATE multipartIdentifier tableAlias setClause whereClause?
```

ANTLR labeled alternative: `#updateTable`

### <span id="visitUse"> visitUse

Creates a [SetCatalogAndNamespace](../logical-operators/SetCatalogAndNamespace.md)

```text
USE NAMESPACE? multipartIdentifier
```

ANTLR labeled alternative: `#use`

### <span id="visitWindowDef"> visitWindowDef

Creates a [WindowSpecDefinition](../expressions/WindowSpecDefinition.md)

```antlr
windowSpec
    : '('
      ( CLUSTER BY partition (',' partition)*
      | ((PARTITION | DISTRIBUTE) BY partition (',' partition)*)?
        ((ORDER | SORT) BY sortItem (',' sortItem)*)?)
      windowFrame?
      ')'
    ;

windowFrame
    : RANGE start
    | ROWS start
    | RANGE BETWEEN start AND end
    | ROWS BETWEEN start AND end
    ;

// start and end bounds of windowFrames
frameBound
    : UNBOUNDED (PRECEDING | FOLLOWING)
    | CURRENT ROW
    | literal (PRECEDING | FOLLOWING)
    ;
```

ANTLR rule: `windowDef`

## Parsing Handlers

### withAggregationClause { #withAggregationClause }

Creates an [Aggregate](../logical-operators/Aggregate.md) logical operator with one of the following [grouping expressions](../logical-operators/Aggregate.md#groupingExpressions) (to indicate the aggregation kind):

* [GroupingSets](../logical-operators/GroupingSets.md) for `GROUP BY ... GROUPING SETS`
* `Cube` for `GROUP BY ... WITH CUBE`
* `Rollup` for `GROUP BY ... WITH ROLLUP`
* `GROUP BY ...`

```antlr
aggregationClause
    : GROUP BY groupingExpressionsWithGroupingAnalytics+=groupByClause
        (COMMA groupingExpressionsWithGroupingAnalytics+=groupByClause)*
    | GROUP BY groupingExpressions+=expression (COMMA groupingExpressions+=expression)* (
      WITH kind=ROLLUP
    | WITH kind=CUBE
    | kind=GROUPING SETS LEFT_PAREN groupingSet (COMMA groupingSet)* RIGHT_PAREN)?
    ;

groupByClause
    : groupingAnalytics
    | expression
    ;

groupingAnalytics
    : (ROLLUP | CUBE) LEFT_PAREN groupingSet (COMMA groupingSet)* RIGHT_PAREN
    | GROUPING SETS LEFT_PAREN groupingElement (COMMA groupingElement)* RIGHT_PAREN
    ;

groupingElement
    : groupingAnalytics
    | groupingSet
    ;

groupingSet
    : LEFT_PAREN (expression (COMMA expression)*)? RIGHT_PAREN
    | expression
    ;
```

Used in [visitCommonSelectQueryClausePlan](#visitCommonSelectQueryClausePlan)

### withCTE { #withCTE }

Creates an [UnresolvedWith](../logical-operators/UnresolvedWith.md) logical operator for [Common Table Expressions](../common-table-expressions/index.md) (in [visitQuery](#visitQuery) and [visitDmlStatement](#visitDmlStatement))

```text
WITH namedQuery (',' namedQuery)*

namedQuery
    : name (columnAliases)? AS? '(' query ')'
    ;
```

### withFromStatementBody { #withFromStatementBody }

Used in [visitFromStatement](#visitFromStatement) and [visitMultiInsertQuery](#visitMultiInsertQuery)

### withGenerate { #withGenerate }

```scala
withGenerate(
  query: LogicalPlan,
  ctx: LateralViewContext): LogicalPlan
```

Creates a [Generate](../logical-operators/Generate.md) logical operator (with an [UnresolvedGenerator](../expressions/UnresolvedGenerator.md)) to represent `LATERAL VIEW`s in [SELECT](#visitCommonSelectQueryClausePlan) and [FROM](#visitFromClause) clauses.

```antlr
lateralView
  : LATERAL VIEW (OUTER)? qualifiedName '(' (expression (',' expression)*)? ')' tblName (AS? colName (',' colName)*)?
  ;
```

### withHavingClause { #withHavingClause }

Creates an [UnresolvedHaving](../logical-operators/UnresolvedHaving.md) for the following:

```text
HAVING booleanExpression
```

### withHints { #withHints }

Adds an [UnresolvedHint](../logical-operators/UnresolvedHint.md) for `/*+ hint */` in `SELECT` queries.

!!! note
    Note `+` (plus) between `/*` and `*/`

`hint` is of the format `name` or `name (param1, param2, ...)`.

```text
/*+ BROADCAST (table) */
```

### <span id="withInsertInto"> withInsertInto

Creates one of the following logical operators:

* [InsertIntoStatement](../logical-operators/InsertIntoStatement.md)
* [InsertIntoDir](../logical-operators/InsertIntoDir.md)

Used in [visitMultiInsertQuery](#visitMultiInsertQuery) and [visitSingleInsertQuery](#visitSingleInsertQuery)

### <span id="withJoinRelations"> withJoinRelations

Creates one or more [Join](../logical-operators/Join.md) logical operators for a [FROM](#visitFromClause) clause and [relation](#visitRelation).

The following join types are supported:

* `INNER` (default)
* `CROSS`
* `LEFT` (with optional `OUTER`)
* `LEFT SEMI`
* `RIGHT` (with optional `OUTER`)
* `FULL` (with optional `OUTER`)
* `ANTI` (optionally prefixed with `LEFT`)

The following join criteria are supported:

* `ON booleanExpression`
* `USING '(' identifier (',' identifier)* ')'`

Joins can be `NATURAL` (with no join criteria)

### <span id="withQuerySpecification"> withQuerySpecification

Adds a query specification to a logical operator

For transform `SELECT` (with `TRANSFORM`, `MAP` or `REDUCE` qualifiers), `withQuerySpecification` does...FIXME

For regular `SELECT` (no `TRANSFORM`, `MAP` or `REDUCE` qualifiers), `withQuerySpecification` adds (in that order):

1. [Generate](#withGenerate) unary logical operators (if used in the parsed SQL text)

1. `Filter` unary logical plan (if used in the parsed SQL text)

1. [GroupingSets or Aggregate](#withAggregation) unary logical operators (if used in the parsed SQL text)

1. `Project` and/or `Filter` unary logical operators

1. [WithWindowDefinition](#withWindows) unary logical operator (if used in the parsed SQL text)

1. [UnresolvedHint](#withHints) unary logical operator (if used in the parsed SQL text)

### withPredicate { #withPredicate }

Creates a [InSubquery](../expressions/InSubquery.md) over a [ListQuery](../expressions/ListQuery.md) (possibly "inverted" using `Not` unary expression)

```sql
NOT? IN '(' query ')'
```

### withPivot { #withPivot }

Creates a [Pivot](../logical-operators/Pivot.md) unary logical operator for the following SQL clause:

```sql
PIVOT '(' aggregates FOR pivotColumn IN '(' pivotValue (',' pivotValue)* ')' ')'
```

Used in [visitFromClause](#visitFromClause)

### <span id="withRepartitionByExpression"> withRepartitionByExpression

`withRepartitionByExpression` throws a `ParseException`:

```text
DISTRIBUTE BY is not supported
```

Used in [withQueryResultClauses](#withQueryResultClauses)

### withSelectQuerySpecification { #withSelectQuerySpecification }

[visitCommonSelectQueryClausePlan](#visitCommonSelectQueryClausePlan) followed by [withHints](#withHints) if there are hints

Used when:

* [visitRegularQuerySpecification](#visitRegularQuerySpecification)
* [withFromStatementBody](#withFromStatementBody)

### withTimeTravel { #withTimeTravel }

`withTimeTravel` creates a [RelationTimeTravel](../logical-operators/RelationTimeTravel.md) for the following in a SQL query:

```antlr
temporalClause
    : FOR? (SYSTEM_VERSION | VERSION) AS OF version
    | FOR? (SYSTEM_TIME | TIMESTAMP) AS OF timestamp
    ;

relationPrimary
    : identifierReference temporalClause?
      sample? tableAlias                                    #tableName
    ...
```

!!! note "ParseException"
    `timestamp` expression cannot refer to any columns.

Used in [visitTableName](#visitTableName) (to handle the optional `temporalClause`).

### withTransformQuerySpecification { #withTransformQuerySpecification }

!!! warning "Skip it and pay attention to `regularQuerySpecification` rule"
    `transformQuerySpecification` is one of the two ANTLR rules of `querySpecification` (beside `regularQuerySpecification`) and, as a Hive-style transform, of less importance IMHO 😎

    Pay more attention to the other [regularQuerySpecification](#visitRegularQuerySpecification) rule.

Creates `ScriptTransformation` unary logical operator for a Hive-style transform (`SELECT TRANSFORM/MAP/REDUCE`) query specification

```antlr
querySpecification
    : transformClause
      fromClause?
      lateralView*
      whereClause?
      aggregationClause?
      havingClause?
      windowClause?                                 #transformQuerySpecification
    | ...                                           #regularQuerySpecification
    ;
```

Used when:

* [visitTransformQuerySpecification](#visitTransformQuerySpecification)
* [withFromStatementBody](#withFromStatementBody)

### <span id="withWindows"> withWindows

Adds a [WithWindowDefinition](../logical-operators/WithWindowDefinition.md) for [window aggregates](../spark-sql-functions-windows.md) (given `WINDOW` definitions).

```text
WINDOW identifier AS windowSpec
  (',' identifier AS windowSpec)*
```

Used in [withQueryResultClauses](#withQueryResultClauses) and [withQuerySpecification](#withQuerySpecification)

## <span id="parseIntervalLiteral"> parseIntervalLiteral

```scala
parseIntervalLiteral(
  ctx: IntervalContext): CalendarInterval
```

`parseIntervalLiteral` creates a [CalendarInterval](../types/CalendarInterval.md) (using [visitMultiUnitsInterval](#visitMultiUnitsInterval) and [visitUnitToUnitInterval](#visitUnitToUnitInterval)).

`parseIntervalLiteral` is used when:

* `AstBuilder` is requested to [visitInterval](#visitInterval)
* `SparkSqlAstBuilder` is requested to [visitSetTimeZone](SparkSqlAstBuilder.md#visitSetTimeZone)
