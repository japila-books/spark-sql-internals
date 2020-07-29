# PreWriteCheck Extended Analysis Check

`PreWriteCheck` is an *extended analysis check* that verifies correctness of a <<spark-sql-LogicalPlan.md#, logical query plan>> with regard to <<InsertIntoTable.md#, InsertIntoTable>> unary logical operator (right before analysis can be considered complete).

`PreWriteCheck` is part of the <<spark-sql-Analyzer-CheckAnalysis.md#extendedCheckRules, extended analysis check rules>> of the logical <<spark-sql-Analyzer.md#, Analyzer>> in <<BaseSessionStateBuilder.md#analyzer, BaseSessionStateBuilder>> and hive/HiveSessionStateBuilder.md#analyzer[HiveSessionStateBuilder].

`PreWriteCheck` is simply a <<apply, function>> of <<spark-sql-LogicalPlan.md#, LogicalPlan>> that...FIXME

=== [[apply]] Executing Function -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): Unit
----

NOTE: `apply` is part of Scala's https://www.scala-lang.org/api/2.11.12/index.html#scala.Function1[scala.Function1] contract to create a function of one parameter.

`apply` [traverses](catalyst/TreeNode.md#foreach) the input <<spark-sql-LogicalPlan.md#, logical query plan>> and finds <<InsertIntoTable.md#, InsertIntoTable>> unary logical operators.

* [[apply-InsertableRelation]] For an `InsertIntoTable` with a <<spark-sql-LogicalPlan-LogicalRelation.md#, LogicalRelation>>...FIXME

* For any `InsertIntoTable`, `apply` throws a `AnalysisException` if the <<InsertIntoTable.md#table, logical plan for the table to insert into>> is neither a <<spark-sql-LogicalPlan-LeafNode.md#, LeafNode>> nor one of the following leaf logical operators: <<spark-sql-LogicalPlan-Range.md#, Range>>, <<spark-sql-LogicalPlan-OneRowRelation.md#, OneRowRelation>>, <<spark-sql-LogicalPlan-LocalRelation.md#, LocalRelation>>.
+
```
Inserting into an RDD-based table is not allowed.
```
