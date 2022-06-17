# AstBuilder &mdash; ANTLR-based SQL Parser

`AstBuilder` converts ANTLR `ParseTree`s into Catalyst entities using [visit callbacks](#visit-callbacks).

`AstBuilder` is the only requirement of the [AbstractSqlParser](AbstractSqlParser.md#astBuilder) abstraction (and used by [CatalystSqlParser](CatalystSqlParser.md) directly while [SparkSqlParser](SparkSqlParser.md) uses [SparkSqlAstBuilder](SparkSqlAstBuilder.md) instead).

## <span id="grammar"> SqlBase.g4 &mdash; ANTLR Grammar

`AstBuilder` is a ANTLR `AbstractParseTreeVisitor` (as `SqlBaseBaseVisitor`) that is generated from the ANTLR grammar of Spark SQL.

`SqlBaseBaseVisitor` is a ANTLR-specific base class that is generated at build time from the ANTLR grammar of Spark SQL is available in the Apache Spark repository at [SqlBase.g4]({{ spark.github }}/sql/catalyst/src/main/antlr4/org/apache/spark/sql/catalyst/parser/SqlBase.g4).

`SqlBaseBaseVisitor` is an [AbstractParseTreeVisitor](http://www.antlr.org/api/Java/org/antlr/v4/runtime/tree/AbstractParseTreeVisitor.html) in ANTLR.

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

### <span id="visitCommentTable"> visitCommentTable

Creates a [CommentOnTable](../logical-operators/CommentOnTable.md) logical command

```text
COMMENT ON TABLE tableIdentifier IS ('text' | NULL)
```

ANTLR labeled alternative: `#commentTable`

### <span id="visitCommonSelectQueryClausePlan"> visitCommonSelectQueryClausePlan

Used in [withTransformQuerySpecification](#withTransformQuerySpecification) and [withSelectQuerySpecification](#withSelectQuerySpecification)

### <span id="visitCreateTable"> visitCreateTable

Creates a [CreateTableAsSelectStatement](../logical-operators/CreateTableAsSelectStatement.md) or a [CreateTableStatement](../logical-operators/CreateTableStatement.md) logical command

```text
CREATE TEMPORARY? EXTERNAL? TABLE (IF NOT EXISTS)? [multipartIdentifier]
  ('(' [colType] (',' [colType])* ')')?
  (USING [multipartIdentifier])?
  [createTableClauses]
  (AS? query)?
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

### <span id="visitMergeIntoTable"> visitMergeIntoTable

Creates a [MergeIntoTable](../logical-operators/MergeIntoTable.md) logical command

```text
MERGE INTO target targetAlias
USING (source | '(' sourceQuery ')') sourceAlias
ON mergeCondition
matchedClause*
notMatchedClause*

matchedClause
  : WHEN MATCHED (AND matchedCond)? THEN matchedAction

notMatchedClause
  : WHEN NOT MATCHED (AND notMatchedCond)? THEN notMatchedAction

matchedAction
  : DELETE
  | UPDATE SET *
  | UPDATE SET assignment (',' assignment)*

notMatchedAction
  : INSERT *
  | INSERT '(' columns ')'
    VALUES '(' expression (',' expression)* ')'
```

Requirements:

1. There must be at least one `WHEN` clause
1. When there are more than one `MATCHED` clauses, only the last `MATCHED` clause can omit the condition
1. When there are more than one `NOT MATCHED` clauses, only the last `NOT MATCHED` clause can omit the condition

ANTLR labeled alternative: `#mergeIntoTable`

### <span id="visitMultiInsertQuery"> visitMultiInsertQuery

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

Creates a [RepairTableStatement](../logical-operators/RepairTableStatement.md) for the following SQL statement:

```text
MSCK REPAIR TABLE multipartIdentifier
```

ANTLR labeled alternative: `#repairTable`

### <span id="visitShowCurrentNamespace"> visitShowCurrentNamespace

Creates a [ShowCurrentNamespaceStatement](../logical-operators/ShowCurrentNamespaceStatement.md) for the following SQL statement:

```text
SHOW CURRENT NAMESPACE
```

ANTLR labeled alternative: `#showCurrentNamespace`

### <span id="visitShowTblProperties"> visitShowTblProperties

Creates a [ShowTableProperties](../logical-operators/ShowTableProperties.md) logical command

```text
SHOW TBLPROPERTIES [multi-part table identifier]
  ('(' [dot-separated table property key] ')')?
```

ANTLR labeled alternative: `#showTblProperties`

### <span id="visitShowTables"> visitShowTables

Creates a [ShowTables](../logical-operators/ShowTables.md) for the following SQL statement:

```text
SHOW TABLES ((FROM | IN) multipartIdentifier)?
  (LIKE? pattern=STRING)?
```

ANTLR labeled alternative: `#showTables`

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

### <span id="visitSingleStatement"> visitSingleStatement

Creates a [LogicalPlan](../logical-operators/LogicalPlan.md) from a single SQL statement

ANTLR rule: `singleStatement`

### <span id="visitStar"> visitStar

Creates a [UnresolvedStar](../expressions/UnresolvedStar.md)

ANTLR labeled alternative: `#star`

### <span id="visitSubqueryExpression"> visitSubqueryExpression

Creates a [ScalarSubquery](../expressions/ScalarSubquery.md)

ANTLR labeled alternative: `#subqueryExpression`

### <span id="visitUpdateTable"> visitUpdateTable

Creates an [UpdateTable](../logical-operators/UpdateTable.md) logical operator

```text
UPDATE multipartIdentifier tableAlias setClause whereClause?
```

ANTLR labeled alternative: `#updateTable`

### <span id="visitUse"> visitUse

Creates a [UseStatement](../logical-operators/UseStatement.md)

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

### <span id="withAggregationClause"> withAggregationClause

Creates one of the following logical operators:

* [GroupingSets](../logical-operators/GroupingSets.md) for `GROUP BY ... GROUPING SETS (...)`

* [Aggregate](../logical-operators/Aggregate.md) for `GROUP BY ... (WITH CUBE | WITH ROLLUP)?`

### <span id="withCTE"> withCTE

Creates an [UnresolvedWith](../logical-operators/UnresolvedWith.md) logical operator for [Common Table Expressions](../common-table-expressions.md) (in [visitQuery](#visitQuery) and [visitDmlStatement](#visitDmlStatement))

```text
WITH namedQuery (',' namedQuery)*

namedQuery
    : name (columnAliases)? AS? '(' query ')'
    ;
```

### <span id="withFromStatementBody"> withFromStatementBody

Used in [visitFromStatement](#visitFromStatement) and [visitMultiInsertQuery](#visitMultiInsertQuery)

### <span id="withGenerate"> withGenerate

Adds a [Generate](../logical-operators/Generate.md) with a [UnresolvedGenerator](../expressions/UnresolvedGenerator.md) and [join](../logical-operators/Generate.md#join) flag enabled for `LATERAL VIEW` (in `SELECT` or `FROM` clauses).

### <span id="withHavingClause"> withHavingClause

Creates an [UnresolvedHaving](../logical-operators/UnresolvedHaving.md) for the following:

```text
HAVING booleanExpression
```

### <span id="withHints"> withHints

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

### withPredicate

* `NOT? IN '(' query ')'` adds an [In](../expressions/In.md) predicate expression with a [ListQuery](../expressions/ListQuery.md) subquery expression

* `NOT? IN '(' expression (',' expression)* ')'` adds an [In](../expressions/In.md) predicate expression

### <span id="withPivot"> withPivot

Creates a [Pivot](../logical-operators/Pivot.md) unary logical operator for the following SQL clause:

```text
PIVOT '(' aggregates FOR pivotColumn IN '(' pivotValue (',' pivotValue)* ')' ')'
```

Used in [visitFromClause](#visitFromClause)

### <span id="withRepartitionByExpression"> withRepartitionByExpression

`withRepartitionByExpression` throws a `ParseException`:

```text
DISTRIBUTE BY is not supported
```

Used in [withQueryResultClauses](#withQueryResultClauses)

### <span id="withSelectQuerySpecification"> withSelectQuerySpecification

Used in [withFromStatementBody](#withFromStatementBody) and [visitRegularQuerySpecification](#visitRegularQuerySpecification)

### <span id="withTransformQuerySpecification"> withTransformQuerySpecification

Used in [withFromStatementBody](#withFromStatementBody) and [visitTransformQuerySpecification](#visitTransformQuerySpecification)

### <span id="withWindows"> withWindows

Adds a [WithWindowDefinition](../logical-operators/WithWindowDefinition.md) for [window aggregates](../spark-sql-functions-windows.md) (given `WINDOW` definitions).

```text
WINDOW identifier AS windowSpec
  (',' identifier AS windowSpec)*
```

Used in [withQueryResultClauses](#withQueryResultClauses) and [withQuerySpecification](#withQuerySpecification)
