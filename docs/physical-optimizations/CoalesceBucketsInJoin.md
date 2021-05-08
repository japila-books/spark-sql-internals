# CoalesceBucketsInJoin Physical Optimization

`CoalesceBucketsInJoin` is a physical query optimization (aka _physical query preparation rule_ or simply _preparation rule_).

`CollapseCodegenStages` is a [Catalyst rule](../catalyst/Rule.md) for transforming [physical query plans](../physical-operators/SparkPlan.md) (`Rule[SparkPlan]`).

`CoalesceBucketsInJoin` is part of the [preparations](../QueryExecution.md#preparations) batch of physical query plan rules and is executed when `QueryExecution` is requested for the [optimized physical query plan](../QueryExecution.md#executedPlan) (in **executedPlan** phase of a query execution).

## <span id="spark.sql.bucketing.coalesceBucketsInJoin.enabled"> spark.sql.bucketing.coalesceBucketsInJoin.enabled

`CoalesceBucketsInJoin` uses the [spark.sql.bucketing.coalesceBucketsInJoin.enabled](configuration-properties.md#spark.sql.bucketing.coalesceBucketsInJoin.enabled) configuration property.

## <span id="apply"> Executing Rule

```scala
apply(
  plan: SparkPlan): SparkPlan
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply` is a noop with the [spark.sql.bucketing.coalesceBucketsInJoin.enabled](configuration-properties.md#spark.sql.bucketing.coalesceBucketsInJoin.enabled) configuration property turned off.

`apply` uses [ExtractJoinWithBuckets](../ExtractJoinWithBuckets.md) to match on [BaseJoinExec](../physical-operators/BaseJoinExec.md) physical operators.

`apply`...FIXME
