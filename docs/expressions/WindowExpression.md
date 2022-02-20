# WindowExpression

`WindowExpression` is an [unevaluable expression](Unevaluable.md) that represents a [window function](#windowFunction) (over some [WindowSpecDefinition](#windowSpec)).

`WindowExpression` is [created](#creating-instance) when:

* `WindowSpec` is requested to [withAggregate](../window-functions/WindowSpec.md#withAggregate) (when [Column.over](../Column.md#over) operator is used)

* [WindowsSubstitution](../logical-analysis-rules/WindowsSubstitution.md) logical evaluation rule is executed (with [WithWindowDefinition](../logical-operators/WithWindowDefinition.md) logical operators with `UnresolvedWindowExpression` expressions)

* `AstBuilder` is requested to [parse a function call](../sql/AstBuilder.md#visitFunctionCall) in a SQL statement

`WindowExpression` can only be with [AggregateExpression](AggregateExpression.md), [AggregateWindowFunction](AggregateWindowFunction.md) or [OffsetWindowFunction](OffsetWindowFunction.md) expressions which is enforced at [analysis](../CheckAnalysis.md#WindowExpression).

```scala
// Using Catalyst DSL
val wf = 'count.function(star())
val windowSpec = ???
```

`WindowExpression` is resolved in [ExtractWindowExpressions](../logical-analysis-rules/ExtractWindowExpressions.md), [ResolveWindowFrame](../logical-analysis-rules/ResolveWindowFrame.md) and [ResolveWindowOrder](../logical-analysis-rules/ResolveWindowOrder.md) logical rules.

`WindowExpression` is subject to [NullPropagation](../logical-optimizations/NullPropagation.md) and [DecimalAggregates](../logical-optimizations/DecimalAggregates.md) logical optimizations.

Distinct window functions are not supported which is enforced at [analysis](../CheckAnalysis.md#WindowExpression-AggregateExpression-isDistinct).

An offset window function can only be evaluated in an ordered row-based window frame with a single offset which is enforced at [analysis](../CheckAnalysis.md#WindowExpression-OffsetWindowFunction).

## <span id="catalyst-dsl"><span id="windowExpr"> Catalyst DSL

```scala
windowExpr(
  windowFunc: Expression,
  windowSpec: WindowSpecDefinition): WindowExpression
```

[windowExpr](../catalyst-dsl/index.md#windowExpr) operator in [Catalyst DSL](../catalyst-dsl/index.md) creates a [WindowExpression](#creating-instance) expression, e.g. for testing or Spark SQL internals exploration.

## Creating Instance

`WindowExpression` takes the following when created:

* <span id="windowFunction"> Window function [expression](Expression.md)
* <span id="windowSpec"> [WindowSpecDefinition](WindowSpecDefinition.md) expression

## Demo

```text
import org.apache.spark.sql.catalyst.expressions.WindowExpression
// relation - Dataset as a table to query
val table = spark.emptyDataset[Int]

scala> val windowExpr = table
  .selectExpr("count() OVER (PARTITION BY value) AS count")
  .queryExecution
  .logical      // (1)!
  .expressions
  .toList(0)
  .children(0)
  .asInstanceOf[WindowExpression]
windowExpr: org.apache.spark.sql.catalyst.expressions.WindowExpression = 'count() windowspecdefinition('value, UnspecifiedFrame)

scala> windowExpr.sql
res2: String = count() OVER (PARTITION BY `value` UnspecifiedFrame)
```

1. Use `sqlParser` directly as in [WithWindowDefinition Example](../logical-operators/WithWindowDefinition.md#example)
