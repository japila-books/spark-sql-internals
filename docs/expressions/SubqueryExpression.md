---
title: SubqueryExpression
---

# SubqueryExpression Expressions

`SubqueryExpression` is an [extension](#contract) of the [PlanExpression](PlanExpression.md) abstraction for [subquery expressions](#implementations) with [logical plans](#plan) (for a subquery).

## Contract

## hint

```scala
hint: Option[HintInfo]
```

Used when:

* [EliminateResolvedHint](../logical-optimizations/EliminateResolvedHint.md) logical optimization is executed (and [pullHintsIntoSubqueries](../logical-optimizations/EliminateResolvedHint.md#pullHintsIntoSubqueries))

## withNewHint { #withNewHint }

```scala
withNewHint(
  hint: Option[HintInfo]): SubqueryExpression
```

Used when:

* [EliminateResolvedHint](../logical-optimizations/EliminateResolvedHint.md) logical optimization is executed (and [pullHintsIntoSubqueries](../logical-optimizations/EliminateResolvedHint.md#pullHintsIntoSubqueries))

### withNewPlan { #withNewPlan }

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
* `LateralSubquery`
* [ListQuery](ListQuery.md)
* [ScalarSubquery](ScalarSubquery.md)

## Creating Instance

`SubqueryExpression` takes the following to be created:

* <span id="plan"> [Subquery logical plan](../logical-operators/LogicalPlan.md)
* <span id="outerAttrs"> Outer Attributes ([Expression](Expression.md)s)
* <span id="exprId"> Expression ID
* <span id="joinCond"> Join Condition ([Expression](Expression.md)s)
* <span id="hint"> [HintInfo](../hints/HintInfo.md)

!!! note "Abstract Class"
    `SubqueryExpression` is an abstract class and cannot be created directly. It is created indirectly for the [concrete SubqueryExpressions](#implementations).

## References

??? note "Expression"

    ```scala
    references: AttributeSet
    ```

    `references` is part of the [Expression](Expression.md#references) abstraction.

`references` is...FIXME

## resolved

??? note "Expression"

    ```scala
    resolved: Boolean
    ```

    `resolved` is part of the [Expression](Expression.md#resolved) abstraction.

`resolved` is `true` when all of the following hold:

* [children are all resolved](Expression.md#childrenResolved)
* [subquery logical plan](#plan) is [resolved](../logical-operators/LogicalPlan.md#resolved)

## hasInOrCorrelatedExistsSubquery { #hasInOrCorrelatedExistsSubquery }

```scala
hasInOrCorrelatedExistsSubquery(
  e: Expression): Boolean
```

`hasInOrCorrelatedExistsSubquery`...FIXME

---

`hasInOrCorrelatedExistsSubquery` is used when:

* [RewritePredicateSubquery](../logical-optimizations/RewritePredicateSubquery.md) logical optimization is executed

## hasCorrelatedSubquery { #hasCorrelatedSubquery }

```scala
hasCorrelatedSubquery(
  e: Expression): Boolean
```

`hasCorrelatedSubquery` is `true` when the given [Expression](Expression.md) contains a correlated subquery (there is a `SubqueryExpression` with [isCorrelated](#isCorrelated) flag enabled).

!!! note "Correlated Subquery"
    **Correlated Subquery** is a subquery with outer references.

---

`hasCorrelatedSubquery` is used when:

* [CombineUnions](../logical-optimizations/CombineUnions.md) logical optimization is executed
* `EliminateOuterJoin` logical optimization is executed
* `OptimizeOneRowRelationSubquery` logical optimization is executed
* `Subquery` is created (from an expression)
* `Filter` logical operator is requested for `validConstraints`

## hasSubquery { #hasSubquery }

```scala
hasSubquery(
  e: Expression): Boolean
```

`hasSubquery` is `true` when the given [Expression](Expression.md) contains a subquery (there is a `SubqueryExpression`).

## isCorrelated { #isCorrelated }

```scala
isCorrelated: Boolean
```

`isCorrelated` is `true` when there is at least one outer attribute (among the [outerAttrs](#outerAttrs)).

---

`isCorrelated` is used when:

* `SubqueryExpression` is requested to [hasInOrCorrelatedExistsSubquery](#hasInOrCorrelatedExistsSubquery), [hasCorrelatedSubquery](#hasCorrelatedSubquery)
* `ScalarSubquery` is requested to [hasCorrelatedScalarSubquery](ScalarSubquery.md#hasCorrelatedScalarSubquery)
* `MergeScalarSubqueries` logical optimization is executed
