# InjectRuntimeFilter Logical Optimization

`InjectRuntimeFilter` is a logical optimization (i.e., a [Rule](../catalyst/Rule.md) of [LogicalPlan](../logical-operators/LogicalPlan.md)).

`InjectRuntimeFilter` is part of [InjectRuntimeFilter](../SparkOptimizer.md#InjectRuntimeFilter) fixed-point batch of rules.

!!! note "Runtime Filter"
    **Runtime Filter** can be a [BloomFilter](#hasBloomFilter) (with [spark.sql.optimizer.runtime.bloomFilter.enabled](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.enabled) enabled) or [InSubquery](#hasInSubquery) filter.

!!! note "Noop"
    `InjectRuntimeFilter` is a _noop_ (and does nothing) for the following cases:

    1. The [query plan to optimize](#apply) is a correlated `Subquery` (to be rewritten into a join later)
    1. Neither [spark.sql.optimizer.runtimeFilter.semiJoinReduction.enabled](../configuration-properties.md#spark.sql.optimizer.runtimeFilter.semiJoinReduction.enabled) nor [spark.sql.optimizer.runtime.bloomFilter.enabled](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.enabled) are enabled

## Executing Rule { #apply }

??? note "Rule"

    ```scala
    apply(
      plan: LogicalPlan): LogicalPlan
    ```

    `apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply` [tryInjectRuntimeFilter](#tryInjectRuntimeFilter).

With [runtimeFilterSemiJoinReductionEnabled](../SQLConf.md#runtimeFilterSemiJoinReductionEnabled) enabled and the new and the initial logical plans not equal, `apply` executes [RewritePredicateSubquery](RewritePredicateSubquery.md) logical optimization with the new logical plan. Otherwise, `apply` returns the new logical plan.

## tryInjectRuntimeFilter { #tryInjectRuntimeFilter }

```scala
tryInjectRuntimeFilter(
  plan: LogicalPlan): LogicalPlan
```

`tryInjectRuntimeFilter` transforms the given [LogicalPlan](../logical-operators/LogicalPlan.md) with regards to [equi-joins](../ExtractEquiJoinKeys.md#unapply).

For every equi-join, `tryInjectRuntimeFilter` [injects a runtime filter](#injectFilter) (on the left side first and on the right side if on the left was not successful) when all the following requirements are met:

1. A join side has no [DynamicPruningSubquery](#hasDynamicPruningSubquery) filter already
1. A join side has no [RuntimeFilter](#hasRuntimeFilter)
1. The left and right keys (pair-wise) are [simple expression](#isSimpleExpression)s
1. [canPruneLeft](../JoinSelectionHelper.md#canPruneLeft) or [canPruneRight](../JoinSelectionHelper.md#canPruneRight)
1. [filteringHasBenefit](#filteringHasBenefit)

`tryInjectRuntimeFilter` tries to inject up to [spark.sql.optimizer.runtimeFilter.number.threshold](../configuration-properties.md#spark.sql.optimizer.runtimeFilter.number.threshold) filters.

## Injecting Filter Operator { #injectFilter }

```scala
injectFilter(
  filterApplicationSideExp: Expression,
  filterApplicationSidePlan: LogicalPlan,
  filterCreationSideExp: Expression,
  filterCreationSidePlan: LogicalPlan): LogicalPlan
```

With [spark.sql.optimizer.runtime.bloomFilter.enabled](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.enabled), `injectFilter` [injects a filter using BloomFilter](#injectBloomFilter).

Otherwise, `injectFilter` [injects a filter using InSubquery](#injectInSubqueryFilter).

### Injecting BloomFilter { #injectBloomFilter }

```scala
injectBloomFilter(
  filterApplicationSideExp: Expression,
  filterApplicationSidePlan: LogicalPlan,
  filterCreationSideExp: Expression,
  filterCreationSidePlan: LogicalPlan): LogicalPlan
```

!!! note
    `injectBloomFilter` returns the given `filterApplicationSidePlan` logical plan unchanged when the [size](../cost-based-optimization/Statistics.md#sizeInBytes) of the given `filterCreationSidePlan` logical plan is above [spark.sql.optimizer.runtime.bloomFilter.creationSideThreshold](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.creationSideThreshold).

`injectBloomFilter` creates a [BloomFilterAggregate](../expressions/BloomFilterAggregate.md) expression with a `XxHash64` child expression (with the given `filterCreationSideExp` expression), possibly with the [row count](../cost-based-optimization/Statistics.md#rowCount) statistic of the given `filterCreationSidePlan` logical plan, if available.

`injectBloomFilter` creates an `Alias` expression with the [BloomFilterAggregate converted to an AggregateExpression](../expressions/AggregateFunction.md#toAggregateExpression) and **bloomFilter** name.

`injectBloomFilter` creates an [Aggregate](../logical-operators/Aggregate.md) logical operator with the following:

* No Grouping Expressions
* Aliased `BloomFilterAggregate`
* The given `filterCreationSidePlan` logical plan

`injectBloomFilter` executes the following logical optimization on the `Aggregate` logical operator:

1. [ColumnPruning](../logical-optimizations/ColumnPruning.md)
1. [ConstantFolding](../logical-optimizations/ConstantFolding.md)

`injectBloomFilter` creates a [ScalarSubquery](../expressions/ScalarSubquery.md) expression with the `Aggregate` logical operator (`bloomFilterSubquery`).

`injectBloomFilter` creates a [BloomFilterMightContain](../expressions/BloomFilterMightContain.md) expression.

Property | Value
---------|------
[bloomFilterExpression](../expressions/BloomFilterMightContain.md#bloomFilterExpression) | The [ScalarSubquery](../expressions/ScalarSubquery.md)
[valueExpression](../expressions/BloomFilterMightContain.md#valueExpression) | A `XxHash64` expression with the given `filterApplicationSideExp`

In the end, `injectBloomFilter` creates a `Filter` logical operator with the `BloomFilterMightContain` expression and the given `filterApplicationSidePlan` logical plan.

### injectInSubqueryFilter { #injectInSubqueryFilter }

```scala
injectInSubqueryFilter(
  filterApplicationSideExp: Expression,
  filterApplicationSidePlan: LogicalPlan,
  filterCreationSideExp: Expression,
  filterCreationSidePlan: LogicalPlan): LogicalPlan
```

!!! note "The same `DataType`s"
    `injectInSubqueryFilter` requires that the [DataType](../expressions/Expression.md#dataType)s of the given `filterApplicationSideExp` and `filterCreationSideExp` are the same.

`injectInSubqueryFilter` creates an [Aggregate](../logical-operators/Aggregate.md) logical operator with the following:

Property | Value
---------|------
[Grouping Expressions](../logical-operators/Aggregate.md#groupingExpressions) | The given `filterCreationSideExp` expression
[Aggregate Expressions](../logical-operators/Aggregate.md#aggregateExpressions) | An `Alias` expression for the `filterCreationSideExp` expression (possibly [mayWrapWithHash](#mayWrapWithHash))
[Child Logical Operator](../logical-operators/Aggregate.md#child) | The given `filterCreationSidePlan` expression

`injectInSubqueryFilter` executes [ColumnPruning](../logical-optimizations/ColumnPruning.md) logical optimization on the `Aggregate` logical operator.

Unless the `Aggregate` logical operator [canBroadcastBySize](../JoinSelectionHelper.md#canBroadcastBySize), `injectInSubqueryFilter` returns the given `filterApplicationSidePlan` logical plan (and basically throws away all the work so far).

!!! note
    `injectInSubqueryFilter` skips the `InSubquery` filter if the size of the `Aggregate` is beyond [broadcast join threshold](../JoinSelectionHelper.md#canBroadcastBySize) and the semi-join will be a shuffle join, which is not worthwhile.

`injectInSubqueryFilter` creates an `InSubquery` logical operator with the following:

* The given `filterApplicationSideExp` (possibly [mayWrapWithHash](#mayWrapWithHash))
* [ListQuery](../expressions/ListQuery.md) expression with the `Aggregate`

In the end, `injectInSubqueryFilter` creates a `Filter` logical operator with the `InSubquery` logical operator and the given `filterApplicationSidePlan` expression.

!!! note
    `injectInSubqueryFilter` is used when `InjectRuntimeFilter` is requested to [injectFilter](#injectFilter) with [spark.sql.optimizer.runtime.bloomFilter.enabled](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.enabled) configuration properties disabled (unlike [spark.sql.optimizer.runtimeFilter.semiJoinReduction.enabled](../configuration-properties.md#spark.sql.optimizer.runtimeFilter.semiJoinReduction.enabled)).

## isSimpleExpression { #isSimpleExpression }

```scala
isSimpleExpression(
  e: Expression): Boolean
```

`isSimpleExpression` is an [Expression](../expressions/Expression.md) that does not [contains any of the following patterns](../catalyst/TreePatternBits.md#containsAnyPattern):

* `PYTHON_UDF`
* `SCALA_UDF`
* `INVOKE`
* `JSON_TO_STRUCT`
* `LIKE_FAMLIY`
* `REGEXP_EXTRACT_FAMILY`
* `REGEXP_REPLACE`

## hasDynamicPruningSubquery { #hasDynamicPruningSubquery }

```scala
hasDynamicPruningSubquery(
  left: LogicalPlan,
  right: LogicalPlan,
  leftKey: Expression,
  rightKey: Expression): Boolean
```

`hasDynamicPruningSubquery` checks if there is a `Filter` logical operator with a [DynamicPruningSubquery](../expressions/DynamicPruningSubquery.md) expression on the `left` or `right` side (of a join).

## hasRuntimeFilter { #hasRuntimeFilter }

```scala
hasRuntimeFilter(
  left: LogicalPlan,
  right: LogicalPlan,
  leftKey: Expression,
  rightKey: Expression): Boolean
```

`hasRuntimeFilter` checks if there is [hasBloomFilter](#hasBloomFilter) (with [spark.sql.optimizer.runtime.bloomFilter.enabled](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.enabled) enabled) or [hasInSubquery](#hasInSubquery) filter on the `left` or `right` side (of a join).

## hasBloomFilter { #hasBloomFilter }

```scala
hasBloomFilter(
  left: LogicalPlan,
  right: LogicalPlan,
  leftKey: Expression,
  rightKey: Expression): Boolean
```

`hasBloomFilter` checks if there is [findBloomFilterWithExp](#findBloomFilterWithExp) on the `left` or `right` side (of a join).

## findBloomFilterWithExp { #findBloomFilterWithExp }

```scala
findBloomFilterWithExp(
  plan: LogicalPlan,
  key: Expression): Boolean
```

`findBloomFilterWithExp` tries to find a `Filter` logical operator with a [BloomFilterMightContain](../expressions/BloomFilterMightContain.md) expression (and `XxHash64`) among the nodes of the given [LogicalPlan](../logical-operators/LogicalPlan.md).
