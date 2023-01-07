# InjectRuntimeFilter Logical Optimization

`InjectRuntimeFilter` is a logical optimization (i.e., a [Rule](../catalyst/Rule.md) of [LogicalPlan](../logical-operators/LogicalPlan.md)).

`InjectRuntimeFilter` is part of [InjectRuntimeFilter](../SparkOptimizer.md#InjectRuntimeFilter) fixed-point batch of rules.

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

---

`apply` [tryInjectRuntimeFilter](#tryInjectRuntimeFilter) unless one of the following holds (and the rule is a _noop_):

* The given query plan is a correlated `Subquery`
* [spark.sql.optimizer.runtimeFilter.semiJoinReduction.enabled](../configuration-properties.md#spark.sql.optimizer.runtimeFilter.semiJoinReduction.enabled) and [spark.sql.optimizer.runtime.bloomFilter.enabled](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.enabled) are both disabled

## <span id="tryInjectRuntimeFilter"> tryInjectRuntimeFilter

```scala
tryInjectRuntimeFilter(
  plan: LogicalPlan): LogicalPlan
```

`tryInjectRuntimeFilter` [finds equi-joins](../ExtractEquiJoinKeys.md#unapply) in the given [LogicalPlan](../logical-operators/LogicalPlan.md).

When _some_ requirements are met, `tryInjectRuntimeFilter` [injectFilter](#injectFilter) on the left side first and on the right side if on the left was not successful.

`tryInjectRuntimeFilter` uses [spark.sql.optimizer.runtimeFilter.number.threshold](../configuration-properties.md#spark.sql.optimizer.runtimeFilter.number.threshold) configuration property.

## <span id="injectFilter"> Injecting Filter Operator

```scala
injectFilter(
  filterApplicationSideExp: Expression,
  filterApplicationSidePlan: LogicalPlan,
  filterCreationSideExp: Expression,
  filterCreationSidePlan: LogicalPlan): LogicalPlan
```

`injectFilter`...FIXME

## <span id="injectBloomFilter"> Injecting BloomFilter

```scala
injectBloomFilter(
  filterApplicationSideExp: Expression,
  filterApplicationSidePlan: LogicalPlan,
  filterCreationSideExp: Expression,
  filterCreationSidePlan: LogicalPlan): LogicalPlan
```

`injectBloomFilter`...FIXME

!!! note
    `injectBloomFilter` is used when `InjectRuntimeFilter` is requested to [inject a Filter](#injectFilter) with [spark.sql.optimizer.runtime.bloomFilter.enabled](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.enabled) configuration properties enabled.

## <span id="injectInSubqueryFilter"> injectInSubqueryFilter

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
