# SubqueryExpression Expressions

`SubqueryExpression` is an [extension](#contract) of the [PlanExpression](PlanExpression.md) abstraction for [subquery expressions](#implementations) with [logical plans](#plan) (for a subquery).

## Contract

### withNewPlan

 <span id="withNewPlan">
```scala
withNewPlan(
  plan: LogicalPlan): SubqueryExpression
```

!!! note
    `withNewPlan` is part of the [PlanExpression](PlanExpression.md) abstraction and is defined as follows:
    
    ```scala
    withNewPlan(plan: T): PlanExpression[T]
    ```

    The purpose of this override method is to change the input and output generic types to the concrete [LogicalPlan](../logical-operators/LogicalPlan.md) and `SubqueryExpression`, respectively.

## Implementations

* [DynamicPruningSubquery](DynamicPruningSubquery.md)
* [Exists](Exists.md)
* [ListQuery](ListQuery.md)
* [ScalarSubquery](ScalarSubquery.md)

## Creating Instance

`SubqueryExpression` takes the following to be created:

* <span id="plan"> [Subquery logical plan](../logical-operators/LogicalPlan.md)
* <span id="children"> Child [Expressions](Expression.md)
* <span id="exprId"> Expression ID

!!! note "Abstract Class"
    `SubqueryExpression` is an abstract class and cannot be created directly. It is created indirectly for the [concrete SubqueryExpressions](#implementations).

## References

<span id="references">
```scala
references: AttributeSet
```

`references` is...FIXME

`references` is part of the [Expression](Expression.md#references) abstraction.

## resolved Predicate

<span id="resolved">
```scala
resolved: Boolean
```

`resolved` is `true` when all of the following hold:

* [children are all resolved](Expression.md#childrenResolved)
* [subquery logical plan](#plan) is [resolved](../logical-operators/LogicalPlan.md#resolved)

`resolved` is part of the [Expression](Expression.md#resolved) abstraction.

## hasInOrCorrelatedExistsSubquery Utility

<span id="hasInOrCorrelatedExistsSubquery">
```scala
hasInOrCorrelatedExistsSubquery(
  e: Expression): Boolean
```

`hasInOrCorrelatedExistsSubquery`...FIXME

`hasInOrCorrelatedExistsSubquery` is used when [RewritePredicateSubquery](../logical-optimizations/RewritePredicateSubquery.md) logical optimization is executed.

## hasCorrelatedSubquery Utility

<span id="hasCorrelatedSubquery">
```scala
hasCorrelatedSubquery(
  e: Expression): Boolean
```

`hasCorrelatedSubquery`...FIXME

`hasCorrelatedSubquery` is used when:

* `EliminateOuterJoin` logical optimization is executed
* `Subquery` is created (from an expression)
* `Filter` logical operator is requested for `validConstraints`

## hasSubquery Utility

<span id="hasSubquery">
```scala
hasSubquery(
  e: Expression): Boolean
```

`hasSubquery`...FIXME

`hasSubquery` is used when...FIXME
