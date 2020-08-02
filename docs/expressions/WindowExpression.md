title: WindowExpression

# WindowExpression Unevaluable Expression

`WindowExpression` is an [unevaluable expression](Unevaluable.md) that represents a <<windowFunction, window function>> (over some <<windowSpec, WindowSpecDefinition>>).

`WindowExpression` is <<creating-instance, created>> when:

* `WindowSpec` is requested to <<spark-sql-WindowSpec.md#withAggregate, withAggregate>> (when <<spark-sql-Column.md#over, Column.over>> operator is used)

* [WindowsSubstitution](../logical-analysis-rules/WindowsSubstitution.md) logical evaluation rule is executed (with <<spark-sql-LogicalPlan-WithWindowDefinition.md#, WithWindowDefinition>> logical operators with <<spark-sql-Expression-UnresolvedWindowExpression.md#, UnresolvedWindowExpression>> expressions)

* `AstBuilder` is requested to <<spark-sql-AstBuilder.md#visitFunctionCall, parse a function call>> in a SQL statement

NOTE: `WindowExpression` can only be <<creating-instance, created>> with [AggregateExpression](AggregateExpression.md), <<spark-sql-Expression-AggregateWindowFunction.md#, AggregateWindowFunction>> or <<spark-sql-Expression-OffsetWindowFunction.md#, OffsetWindowFunction>> expressions which is enforced at <<spark-sql-Analyzer-CheckAnalysis.md#WindowExpression, analysis>>.

```scala
// Using Catalyst DSL
val wf = 'count.function(star())
val windowSpec = ???
```

NOTE: `WindowExpression` is resolved in [ExtractWindowExpressions](../logical-analysis-rules/ExtractWindowExpressions.md), [ResolveWindowFrame](../logical-analysis-rules/ResolveWindowFrame.md) and [ResolveWindowOrder](../logical-analysis-rules/ResolveWindowOrder.md) logical rules.

```text
import org.apache.spark.sql.catalyst.expressions.WindowExpression
// relation - Dataset as a table to query
val table = spark.emptyDataset[Int]

scala> val windowExpr = table
  .selectExpr("count() OVER (PARTITION BY value) AS count")
  .queryExecution
  .logical      // <1>
  .expressions
  .toList(0)
  .children(0)
  .asInstanceOf[WindowExpression]
windowExpr: org.apache.spark.sql.catalyst.expressions.WindowExpression = 'count() windowspecdefinition('value, UnspecifiedFrame)

scala> windowExpr.sql
res2: String = count() OVER (PARTITION BY `value` UnspecifiedFrame)
```
<1> Use `sqlParser` directly as in spark-sql-LogicalPlan-WithWindowDefinition.md#example[WithWindowDefinition Example]

[[properties]]
.WindowExpression's Properties
[width="100%",cols="1,2",options="header"]
|===
| Name
| Description

| `children`
| Collection of two expressions/Expression.md[expressions], i.e. <<windowFunction, windowFunction>> and <<windowSpec, WindowSpecDefinition>>, for which `WindowExpression` was created.

| `dataType`
| spark-sql-DataType.md[DataType] of <<windowFunction, windowFunction>>

| `foldable`
| Whether or not <<windowFunction, windowFunction>> is foldable.

| `nullable`
| Whether or not <<windowFunction, windowFunction>> is nullable.

| `sql`
| `"[windowFunction].sql OVER [windowSpec].sql"`

| `toString`
| `"[windowFunction] [windowSpec]"`
|===

NOTE: `WindowExpression` is subject to <<spark-sql-Optimizer-NullPropagation.md#, NullPropagation>> and <<spark-sql-Optimizer-DecimalAggregates.md#, DecimalAggregates>> logical optimizations.

NOTE: Distinct window functions are not supported which is enforced at <<spark-sql-Analyzer-CheckAnalysis.md#WindowExpression-AggregateExpression-isDistinct, analysis>>.

NOTE: An offset window function can only be evaluated in an ordered row-based window frame with a single offset which is enforced at <<spark-sql-Analyzer-CheckAnalysis.md#WindowExpression-OffsetWindowFunction, analysis>>.

=== [[catalyst-dsl]][[windowExpr]] Catalyst DSL -- `windowExpr` Operator

[source, scala]
----
windowExpr(
  windowFunc: Expression,
  windowSpec: WindowSpecDefinition): WindowExpression
----

<<spark-sql-catalyst-dsl.md#windowExpr, windowExpr>> operator in Catalyst DSL creates a <<creating-instance, WindowExpression>> expression, e.g. for testing or Spark SQL internals exploration.

[source, scala]
----
// FIXME: DEMO
----

=== [[creating-instance]] Creating WindowExpression Instance

`WindowExpression` takes the following when created:

* [[windowFunction]] Window function <<expressions/Expression.md#, expression>>
* [[windowSpec]] <<spark-sql-Expression-WindowSpecDefinition.md#, WindowSpecDefinition>> expression
