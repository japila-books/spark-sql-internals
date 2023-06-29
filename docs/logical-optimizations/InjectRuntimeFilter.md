# InjectRuntimeFilter Logical Optimization

`InjectRuntimeFilter` is a logical optimization (i.e., a [Rule](../catalyst/Rule.md) of [LogicalPlan](../logical-operators/LogicalPlan.md)).

`InjectRuntimeFilter` is part of [InjectRuntimeFilter](../SparkOptimizer.md#InjectRuntimeFilter) fixed-point batch of rules.

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

## <span id="tryInjectRuntimeFilter"> tryInjectRuntimeFilter

```scala
tryInjectRuntimeFilter(
  plan: LogicalPlan): LogicalPlan
```

`tryInjectRuntimeFilter` [finds equi-joins](../ExtractEquiJoinKeys.md#unapply) in the given [LogicalPlan](../logical-operators/LogicalPlan.md).

When _some_ requirements are met, `tryInjectRuntimeFilter` [injectFilter](#injectFilter) on the left side first and on the right side if on the left was not successful.

`tryInjectRuntimeFilter` uses [spark.sql.optimizer.runtimeFilter.number.threshold](../configuration-properties.md#spark.sql.optimizer.runtimeFilter.number.threshold) configuration property.

## Injecting Filter Operator { #injectFilter }

```scala
injectFilter(
  filterApplicationSideExp: Expression,
  filterApplicationSidePlan: LogicalPlan,
  filterCreationSideExp: Expression,
  filterCreationSidePlan: LogicalPlan): LogicalPlan
```

`injectFilter`...FIXME

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

`injectInSubqueryFilter`...FIXME

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
