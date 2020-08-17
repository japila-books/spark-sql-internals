# PlanExpression Expressions

`PlanExpression` is an [extension](#contract) of the [Expression](Expression.md) abstraction for [subquery expressions](#implementations) (that are expressions with [query plans](#plan)).

## Contract

### exprId

 <span id="exprId">
```scala
exprId: ExprId
```

Expression ID

### plan

 <span id="plan">
```scala
plan: T
```

[Query plan](../catalyst/QueryPlan.md) of a subquery

### withNewPlan

 <span id="withNewPlan">
```scala
withNewPlan(
  plan: T): PlanExpression[T]
```

Updates the expression with a new plan

## Implementations

* [ExecSubqueryExpression](ExecSubqueryExpression.md)
* [SubqueryExpression](SubqueryExpression.md)

## conditionString

<span id="conditionString">
```scala
conditionString: String
```

`conditionString` simply concatenates all children's text representation between `[` and `]` characters, separated by `&&`.

`conditionString` is used when [DynamicPruningSubquery](DynamicPruningSubquery.md#toString), [ScalarSubquery](ScalarSubquery.md#toString), [ListQuery](ListQuery.md#toString) and [Exists](Exists.md#toString) expressions are requested for a text representation.
