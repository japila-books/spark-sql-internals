# Dataset API and SQL

Spark SQL supports two "modes" to write structured queries: spark-sql-dataset-operators.md[Dataset API] and SparkSession.md#sql[SQL].

*SQL Mode* is used to express structured queries using SQL statements using SparkSession.md#sql[SparkSession.sql] operator, [expr](functions/index.md#expr) standard function and `spark-sql` command-line tool.

Some structured queries can be expressed much easier using Dataset API, but there are some that are only possible in SQL. In other words, you may find mixing Dataset API and SQL modes challenging yet rewarding.

What is important, and one of the reasons why Spark SQL has been so successful, is that there is no performance difference between the modes. Whatever mode you use to write your structured queries, they all end up as a tree of [Catalyst relational data structures](catalyst/index.md). And, yes, you could consider writing structured queries using Catalyst directly, but that could quickly become unwieldy for maintenance (i.e. finding Spark SQL developers who could be comfortable with it as well as being fairly low-level and therefore possibly too dependent on a specific Spark SQL version).

The takeaway is that SQL queries in Spark SQL are translated to Command.md[Catalyst logical commands].

This section describes the differences between Spark SQL features to develop Spark applications using Dataset API and SQL mode.

. spark-sql-Expression-RuntimeReplaceable.md#implementations[RuntimeReplaceable Expressions] are only available using SQL mode by means of SQL functions like `nvl`, `nvl2`, `ifnull`, `nullif`, etc.

. <<spark-sql-column-operators.md#isin, Column.isin>> and sql/AstBuilder.md#withPredicate[SQL IN predicate with a subquery] (and spark-sql-Expression-In.md[In Predicate Expression])
