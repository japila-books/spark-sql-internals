---
title: InSubquery
---

# InSubquery Expression

`InSubquery` is a [Predicate](Predicate.md) that represents the following [IN](../sql/AstBuilder.md#withPredicate) SQL predicate in a logical query plan:

```sql
NOT? IN '(' query ')'
```

`InSubquery` can also be used internally for other use cases (e.g., [Runtime Filtering](../runtime-filtering/index.md), [Dynamic Partition Pruning](../dynamic-partition-pruning/index.md)).

## Creating Instance

`InSubquery` takes the following to be created:

* <span id="values"> Values ([Expression](Expression.md)s)
* <span id="query"> [ListQuery](ListQuery.md)

`InSubquery` is created when:

* [InjectRuntimeFilter](../logical-optimizations/InjectRuntimeFilter.md) logical optimization is executed (and [injectInSubqueryFilter](../logical-optimizations/InjectRuntimeFilter.md#injectInSubqueryFilter))
* `AstBuilder` is requested to [withPredicate](../sql/AstBuilder.md#withPredicate) (for `NOT? IN '(' query ')'` SQL predicate)
* [PlanDynamicPruningFilters](../physical-optimizations/PlanDynamicPruningFilters.md) physical optimization is executed (with [spark.sql.optimizer.dynamicPartitionPruning.enabled](../configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.enabled) enabled)
* `RowLevelOperationRuntimeGroupFiltering` logical optimization is executed

## Unevaluable { #Unevaluable }

`InSubquery` is an [Unevaluable](Unevaluable.md) expression.

`InSubquery` can be converted to a [Join](../logical-operators/Join.md) operator at logical optimization using [RewritePredicateSubquery](../logical-optimizations/RewritePredicateSubquery.md):

* [Left-Semi Join](../logical-operators/Join.md) unless it is a `NOT IN` that becomes a [Left-Anti Join](../logical-operators/Join.md) (among the other _less_ important cases)

`InSubquery` can also be converted to [InSubqueryExec](InSubqueryExec.md) expression (over a [SubqueryExec](../physical-operators/SubqueryExec.md)) in [PlanSubqueries](../physical-optimizations/PlanSubqueries.md) physical optimization.

## Logical Analysis

`InSubquery` is resolved using the following logical analysis rules:

* [ResolveSubquery](../logical-analysis-rules/ResolveSubquery.md)
* `InConversion`

## Logical Optimization

`InSubquery` is optimized using the following logical optimizations:

* [NullPropagation](../logical-optimizations/NullPropagation.md) (so `null` values give `null` results)
* [InjectRuntimeFilter](../logical-optimizations/InjectRuntimeFilter.md)
* [RewritePredicateSubquery](../logical-optimizations/RewritePredicateSubquery.md)

## Physical Optimization

`InSubquery` is optimized using the following physical optimizations:

* [PlanSubqueries](../physical-optimizations/PlanSubqueries.md)
* [InsertAdaptiveSparkPlan](../physical-optimizations/InsertAdaptiveSparkPlan.md)
* [PlanAdaptiveSubqueries](../physical-optimizations/PlanAdaptiveSubqueries.md)

## Catalyst DSL

`InSubquery` can be created using [in](#in) operator using [Catalyst DSL](../catalyst-dsl/index.md) (via `ImplicitOperators`).

## nodePatterns { #nodePatterns }

??? note "TreeNode"

    ```scala
    nodePatterns: Seq[TreePattern]
    ```

    `nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.

`nodePatterns` is [IN_SUBQUERY](../catalyst/TreePattern.md#IN_SUBQUERY).
