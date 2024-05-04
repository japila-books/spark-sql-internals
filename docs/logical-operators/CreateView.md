---
title: CreateView
---

# CreateView Logical Operator

`CreateView` is a `BinaryCommand` logical operator that represents [CREATE VIEW](../sql/SparkSqlAstBuilder.md#visitCreateView) SQL statement to create a persisted (non-temporary) view.

??? note "CreateViewCommand"
    [CreateViewCommand](CreateViewCommand.md) logical operator is used to represent [CREATE TEMPORARY VIEW](../sql/SparkSqlAstBuilder.md#visitCreateView) SQL statements.

`CreateView` is resolved into [CreateViewCommand](CreateViewCommand.md) logical operator by [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical analysis rule.

## Demo

```scala
sql("""
CREATE TEMPORARY VIEW demo_view
    COMMENT 'demo view'
    AS
        SELECT *
        FROM values (1), (2)
""")
```

```text
scala> sql("SHOW VIEWS").show(truncate=false)
+---------+---------+-----------+
|namespace|viewName |isTemporary|
+---------+---------+-----------+
|default  |demo_view|false      |
|         |demo_view|true       |
+---------+---------+-----------+
```

```scala
sql("CREATE OR REPLACE TABLE nums USING delta AS SELECT * FROM values (1), (2) t(n)")
```

```scala
sql("""
CREATE OR REPLACE TEMPORARY VIEW nums_view
    COMMENT 'A view over nums table'
    AS
        SELECT *
        FROM nums
""")
```

```text
scala> sql("DESC EXTENDED nums_view").show(truncate=false)
+--------+---------+-------+
|col_name|data_type|comment|
+--------+---------+-------+
|n       |int      |NULL   |
+--------+---------+-------+
```

```text
scala> sql("SELECT * FROM nums_view").show()
+---+
|  n|
+---+
|  1|
|  2|
+---+
```

Let's cache the view. It does not seem to change anything, though.

"Why?!", you ask? This is _likely_ because of Delta Lake sitting under the covers.

```scala
sql("CACHE TABLE nums_view")
```

```scala
assert(spark.catalog.isCached("nums_view"))
```

```scala
spark.range(3, 5).write.insertInto("nums")
```

```text
scala> sql("SELECT * FROM nums_view ORDER BY n").show()
+---+
|  n|
+---+
|  1|
|  2|
|  3|
|  4|
+---+
```

## Creating Instance

`CreateView` takes the following to be created:

* <span id="child"> Child [LogicalPlan](LogicalPlan.md)
* <span id="userSpecifiedColumns"> User-specified columns (`Seq[(String, Option[String])]`)
* <span id="comment"> Optional Comment
* <span id="properties"> Properties (`Map[String, String]`)
* <span id="originalText"> Optional "Original Text"
* <span id="query"> [Logical Query Plan](LogicalPlan.md)
* <span id="allowExisting"> `allowExisting` flag
* <span id="replace"> `replace` flag

`CreateView` is created when:

* `SparkSqlAstBuilder` is requested to [parse a CREATE VIEW statement](../sql/SparkSqlAstBuilder.md#visitCreateView)
