# ResolveSubquery Logical Resolution Rule

`ResolveSubquery` is a **logical resolution rule** that [resolves SubqueryExpressions](#apply) in the following logical operators:

* `Filter`s with a child [Aggregate](../logical-operators/Aggregate.md)
* [Unary operators](../logical-operators/LogicalPlan.md#UnaryNode)
* [Join](../logical-operators/Join.md)
* [SupportsSubquery](../logical-operators/SupportsSubquery.md)

`ResolveSubquery` resolves subqueries ([logical query plans](../logical-operators/LogicalPlan.md)) in the following [SubqueryExpressions](../expressions/SubqueryExpression.md):

* [ScalarSubquery](../expressions/ExecSubqueryExpression-ScalarSubquery.md)
* [Exists](../expressions/Exists.md)
* [ListQuery](../expressions/ListQuery.md) (in `InSubquery` expressions)

`ResolveSubquery` is part of [Resolution](../Analyzer.md#Resolution) rule batch of the [Logical Analyzer](../Analyzer.md).

`ResolveSubquery` is a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md) (`Rule[LogicalPlan]`).

## Example

```text
// Use Catalyst DSL
import org.apache.spark.sql.catalyst.expressions._
val a = 'a.int

import org.apache.spark.sql.catalyst.plans.logical.LocalRelation
val rel = LocalRelation(a)

import org.apache.spark.sql.catalyst.expressions.Literal
val list = Seq[Literal](1)

// FIXME Use a correct query to demo ResolveSubquery
import org.apache.spark.sql.catalyst.plans.logical.Filter
import org.apache.spark.sql.catalyst.expressions.In
val plan = Filter(condition = In(value = a, list), child = rel)

scala> println(plan.numberedTreeString)
00 Filter a#9 IN (1)
01 +- LocalRelation <empty>, [a#9]

import spark.sessionState.analyzer.ResolveSubquery
val analyzedPlan = ResolveSubquery(plan)
scala> println(analyzedPlan.numberedTreeString)
00 Filter a#9 IN (1)
01 +- LocalRelation <empty>, [a#9]
```

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` [resolves SubqueryExpressions](#resolveSubQueries) in the following logical operators in the given [logical plan](../logical-operators/LogicalPlan.md):

* `Filter`s with a child [Aggregate](../logical-operators/Aggregate.md)

* [Unary operators](../logical-operators/LogicalPlan.md#UnaryNode)

* [Join](../logical-operators/Join.md)

* [SupportsSubquery](../logical-operators/SupportsSubquery.md)

`apply` resolves logical operators that have their [children all resolved](../logical-operators/LogicalPlan.md#childrenResolved) already.

`apply` is part of [Rule](../catalyst/Rule.md#apply) abstraction.

## <span id="resolveSubQueries"> Resolving SubqueryExpressions

```scala
resolveSubQueries(
  plan: LogicalPlan,
  plans: Seq[LogicalPlan]): LogicalPlan
```

`resolveSubQueries` [resolves subquery plans](#resolveSubQuery) in the following [SubqueryExpression](../expressions/SubqueryExpression.md) expressions (by [transforming expressions](../catalyst/QueryPlan.md#transformExpressions) down the operator tree) in the given [logical plan](../logical-operators/LogicalPlan.md):

* [ScalarSubquery](../expressions/ExecSubqueryExpression-ScalarSubquery.md)
* [Exists](../expressions/Exists.md)
* [ListQuery](../expressions/ListQuery.md) (in `InSubquery` expressions)

`resolveSubQueries` is used when `ResolveSubquery` is [executed](#apply).

## <span id="resolveSubQuery"> Resolving Subquery Plan

```scala
resolveSubQuery(
  e: SubqueryExpression,
  plans: Seq[LogicalPlan])(
  f: (LogicalPlan, Seq[Expression]) => SubqueryExpression): SubqueryExpression
```

`resolveSubQuery` [resolves outer references](#resolveOuterReferences) in the [logical plan](../expressions/SubqueryExpression.md#plan) of the given [SubqueryExpression](../expressions/SubqueryExpression.md) (and all sub-`SubqueryExpression`s).

In the end, `resolveSubQuery` executes the given `f` function with the logical plan (of the `SubqueryExpression`) and all `OuterReference` leaf expressions when the logical plan has been fully resolved. Otherwise, `resolveSubQuery` requests the `SubqueryExpression` to [withNewPlan](../expressions/SubqueryExpression.md#withNewPlan).

`resolveSubQuery` is used when `ResolveSubquery` is requested to [resolve subquery expressions](#resolveSubQueries).

## <span id="resolveOuterReferences"> Resolving Outer References (in Subquery Plan)

```scala
resolveOuterReferences(
  plan: LogicalPlan,
  outer: LogicalPlan): LogicalPlan
```

`resolveOuterReferences` uses the `outer` [logical plan](../logical-operators/LogicalPlan.md) to resolve [UnresolvedAttribute](../expressions/UnresolvedAttribute.md) expressions in the `plan` [logical operator](../logical-operators/LogicalPlan.md).

`resolveOuterReferences` translates resolved [NamedExpression](../expressions/NamedExpression.md) expressions to `OuterReference` leaf expressions.

`resolveOuterReferences` is used when `ResolveSubquery` is requested to [resolve a SubqueryExpression](#resolveSubQuery).
