---
title: Untyped Transformations
---

# Dataset API &mdash; Untyped Transformations

**Untyped transformations** are part of the Dataset API for transforming a `Dataset` to a [DataFrame](DataFrame.md), a [Column](Column.md), a [RelationalGroupedDataset](RelationalGroupedDataset.md), a [DataFrameNaFunctions](DataFrameNaFunctions.md) or a [DataFrameStatFunctions](DataFrameStatFunctions.md) (and hence _untyped_).

!!! note
    Untyped transformations are the methods in the `Dataset` Scala class that are grouped in `untypedrel` group name, i.e. `@group untypedrel`.

<!---
## Review Me

=== [[apply]] `apply` Untyped Transformation

[source, scala]
----
apply(colName: String): Column
----

`apply` selects a column based on the column name (i.e. maps a `Dataset` onto a `Column`).

=== [[col]] `col` Untyped Transformation

```scala
col(
  colName: String): Column
```

`col` selects a column based on the column name (i.e. maps a `Dataset` onto a `Column`).

Internally, `col` branches off per the input column name.

If the column name is `*` (a star), `col` simply creates a [Column](Column.md#apply) with `ResolvedStar` expression (with the [schema output attributes](catalyst/QueryPlan.md#output) of the [analyzed logical plan](QueryExecution.md#analyzed) of the [QueryExecution](Dataset.md#queryExecution)).

Otherwise, `col` uses [colRegex](#colRegex) untyped transformation when [spark.sql.parser.quotedRegexColumnNames](configuration-properties.md#spark.sql.parser.quotedRegexColumnNames) configuration property is enabled.

In the case when the column name is not `*` and [spark.sql.parser.quotedRegexColumnNames](configuration-properties.md#spark.sql.parser.quotedRegexColumnNames) configuration property is disabled, `col` creates a [Column](Column.md#apply) with the column name [resolved](Dataset.md#resolve) (as a [NamedExpression](expressions/NamedExpression.md)).

=== [[colRegex]] `colRegex` Untyped Transformation

```scala
colRegex(
  colName: String): Column
```

`colRegex` selects a column based on the column name specified as a regex (i.e. maps a `Dataset` onto a `Column`).

!!! NOTE
    `colRegex` is used in [col](#col) when [spark.sql.parser.quotedRegexColumnNames](configuration-properties.md#spark.sql.parser.quotedRegexColumnNames) configuration property is enabled (and the column name is not `*`).

Internally, `colRegex` matches the input column name to different regular expressions (in the order):

1. For column names with quotes without a qualifier, `colRegex` simply creates a [Column](Column.md#apply) with a `UnresolvedRegex` (with no table)

1. For column names with quotes with a qualifier, `colRegex` simply creates a [Column](Column.md#apply) with a `UnresolvedRegex` (with a table specified)

1. For other column names, `colRegex` (behaves like [col](#col) and) creates a [Column](Column.md#apply) with the column name [resolved](Dataset.md#resolve) (as a [NamedExpression](expressions/NamedExpression.md))

=== [[na]] `na` Untyped Transformation

[source, scala]
----
na: DataFrameNaFunctions
----

`na` creates a <<DataFrameNaFunctions.md#, DataFrameNaFunctions>> to work with missing data.

=== [[selectExpr]] Projecting Columns using SQL Statements -- `selectExpr` Untyped Transformation

```scala
selectExpr(
  exprs: String*): DataFrame
```

`selectExpr` is like `select`, but accepts SQL statements.

```text
val ds = spark.range(5)

scala> ds.selectExpr("rand() as random").show
16/04/14 23:16:06 INFO HiveSqlParser: Parsing command: rand() as random
+-------------------+
|             random|
+-------------------+
|  0.887675894185651|
|0.36766085091074086|
| 0.2700020856675186|
| 0.1489033635529543|
| 0.5862990791950973|
+-------------------+
```

Internally, it executes `select` with every expression in `exprs` mapped to [Column](Column.md) (using [SparkSqlParser.parseExpression](sql/SparkSqlParser.md#parseExpression)).

```text
scala> ds.select(expr("rand() as random")).show
+------------------+
|            random|
+------------------+
|0.5514319279894851|
|0.2876221510433741|
|0.4599999092045741|
|0.5708558868374893|
|0.6223314406247136|
+------------------+
```
-->
