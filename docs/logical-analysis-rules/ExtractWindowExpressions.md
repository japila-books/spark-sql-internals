---
title: ExtractWindowExpressions
---

# ExtractWindowExpressions Logical Resolution Rule

`ExtractWindowExpressions` is a [logical resolution rule](../Analyzer.md#batches) that <<apply, transforms a logical query plan>> and replaces (extracts) <<spark-sql-Expression-WindowExpression.md#, WindowExpression>> expressions with <<Window.md#, Window>> logical operators.

`ExtractWindowExpressions` is part of the [Resolution](../Analyzer.md#Resolution) fixed-point batch in the standard batches of the [Analyzer](../Analyzer.md).

`ExtractWindowExpressions` is simply a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md), i.e. `Rule[LogicalPlan]`.

```text
import spark.sessionState.analyzer.ExtractWindowExpressions

// Example 1: Filter + Aggregate with WindowExpressions in aggregateExprs
val q = ???
val plan = q.queryExecution.logical
val afterExtractWindowExpressions = ExtractWindowExpressions(plan)

// Example 2: Aggregate with WindowExpressions in aggregateExprs
val q = ???
val plan = q.queryExecution.logical
val afterExtractWindowExpressions = ExtractWindowExpressions(plan)

// Example 3: Project with WindowExpressions in projectList
val q = ???
val plan = q.queryExecution.logical
val afterExtractWindowExpressions = ExtractWindowExpressions(plan)
```

=== [[apply]] Executing Rule

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

`apply` [transforms the logical operators downwards](../catalyst/TreeNode.md#transformDown) in the input <<spark-sql-LogicalPlan.md#, logical plan>> as follows:

* For `Filter` unary operators with [Aggregate](../logical-operators/Aggregate.md) operator that <<hasWindowFunction, has a window function>> in the <<Aggregate.md#aggregateExpressions, aggregateExpressions>>, `apply`...FIXME

* For <<Aggregate.md#, Aggregate>> logical operators that <<hasWindowFunction, have a window function>> in the <<Aggregate.md#aggregateExpressions, aggregateExpressions>>, `apply`...FIXME

* For <<Project.md#, Project>> logical operators that <<hasWindowFunction, have a window function>> in the <<Project.md#projectList, projectList>>, `apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

=== [[hasWindowFunction]] `hasWindowFunction` Internal Method

[source, scala]
----
hasWindowFunction(projectList: Seq[NamedExpression]): Boolean // <1>
hasWindowFunction(expr: NamedExpression): Boolean
----
<1> Executes the other `hasWindowFunction` on every `NamedExpression` in the `projectList`

`hasWindowFunction` is positive (`true`) when the input `expr` <<expressions/NamedExpression.md#, named expression>> is a <<spark-sql-Expression-WindowExpression.md#, WindowExpression>> expression. Otherwise, `hasWindowFunction` is negative (`false`).

NOTE: `hasWindowFunction` is used when `ExtractWindowExpressions` logical resolution rule is requested to <<extract, extract>> and <<apply, execute>>.

=== [[extract]] `extract` Internal Method

[source, scala]
----
extract(expressions: Seq[NamedExpression]): (Seq[NamedExpression], Seq[NamedExpression])
----

`extract`...FIXME

NOTE: `extract` is used exclusively when `ExtractWindowExpressions` logical resolution rule is <<apply, executed>>.

=== [[addWindow]] Adding Project and Window Logical Operators to Logical Plan -- `addWindow` Internal Method

[source, scala]
----
addWindow(
  expressionsWithWindowFunctions: Seq[NamedExpression],
  child: LogicalPlan): LogicalPlan
----

`addWindow` adds a <<Project.md#, Project>> logical operator with one or more <<Window.md#, Window>> logical operators (for every <<spark-sql-Expression-WindowExpression.md#, WindowExpression>> in the input <<expressions/NamedExpression.md#, named expressions>>) to the input <<spark-sql-LogicalPlan.md#, logical plan>>.

Internally, `addWindow`...FIXME

NOTE: `addWindow` is used exclusively when `ExtractWindowExpressions` logical resolution rule is <<apply, executed>>.
