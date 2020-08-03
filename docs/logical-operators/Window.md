title: Window

# Window Unary Logical Operator

`Window` is a spark-sql-LogicalPlan.md#UnaryNode[unary logical operator] that...FIXME

`Window` is <<creating-instance, created>> when:

* [ExtractWindowExpressions](../logical-analysis-rules/ExtractWindowExpressions.md) logical resolution rule is executed

* [CleanupAliases](../logical-analysis-rules/CleanupAliases.md) logical analysis rule is executed

[[output]]
When requested for <<catalyst/QueryPlan.md#output, output schema attributes>>, `Window` requests the <<child, child>> logical operator for them and adds the <<spark-sql-Expression-NamedExpression.md#toAttribute, attributes>> of the <<windowExpressions, window named expressions>>.

NOTE: `Window` logical operator is a subject of pruning unnecessary window expressions in <<spark-sql-Optimizer-ColumnPruning.md#, ColumnPruning>> logical optimization and collapsing window operators in <<spark-sql-Optimizer-CollapseWindow.md#, CollapseWindow>> logical optimization.

!!! note
    `Window` logical operator is resolved to a [WindowExec](../physical-operators/WindowExec.md) in [BasicOperators](../execution-planning-strategies/BasicOperators.md#Window) execution planning strategy.

=== [[catalyst-dsl]] Catalyst DSL -- `window` Operator

[source, scala]
----
window(
  windowExpressions: Seq[NamedExpression],
  partitionSpec: Seq[Expression],
  orderSpec: Seq[SortOrder]): LogicalPlan
----

<<spark-sql-catalyst-dsl.md#window, window>> operator in spark-sql-catalyst-dsl.md[Catalyst DSL] creates a <<creating-instance, Window>> logical operator, e.g. for testing or Spark SQL internals exploration.

[source, scala]
----
// FIXME: DEMO
----

=== [[creating-instance]] Creating Window Instance

`Window` takes the following when created:

* [[windowExpression]] Window spark-sql-Expression-NamedExpression.md[named expressions]
* [[partitionSpec]] Window partition specification expressions/Expression.md[expressions]
* [[orderSpec]] Window order specification (as a collection of `SortOrder` expressions)
* [[child]] Child <<spark-sql-LogicalPlan.md#, logical operator>>

=== [[windowOutputSet]] Creating AttributeSet with Window Expression Attributes -- `windowOutputSet` Method

[source, scala]
----
windowOutputSet: AttributeSet
----

`windowOutputSet` simply creates a `AttributeSet` with the <<spark-sql-Expression-NamedExpression.md#toAttribute, attributes>> of the <<windowExpressions, window named expressions>>.

[NOTE]
====
`windowOutputSet` is used when:

* `ColumnPruning` logical optimization is <<spark-sql-Optimizer-ColumnPruning.md#apply, executed>> (on a <<spark-sql-LogicalPlan-Project.md#, Project>> operator with a `Window` as the <<spark-sql-LogicalPlan-Project.md#child, child operator>>)

* `CollapseWindow` logical optimization is <<spark-sql-Optimizer-CollapseWindow.md#apply, executed>> (on a `Window` operator with another `Window` operator as the <<child, child>>)
====
