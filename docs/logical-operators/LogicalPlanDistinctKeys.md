---
title: LogicalPlanDistinctKeys
---

# LogicalPlanDistinctKeys Logical Operators

`LogicalPlanDistinctKeys` is an extension of the [LogicalPlan](LogicalPlan.md) abstraction for logical operators that know their [distinct keys](#distinctKeys).

All [logical operators](LogicalPlan.md) are `LogicalPlanDistinctKeys`.

## Distinct Keys { #distinctKeys }

```scala
distinctKeys: Set[ExpressionSet]
```

??? note "Lazy Value"
    `distinctKeys` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`distinctKeys` uses [DistinctKeyVisitor](../DistinctKeyVisitor.md) to [determine the distinct keys](../cost-based-optimization/LogicalPlanVisitor.md#visit) of this [logical operator](LogicalPlan.md) when [spark.sql.optimizer.propagateDistinctKeys.enabled](../configuration-properties.md#spark.sql.optimizer.propagateDistinctKeys.enabled) configuration property is enabled.

Otherwise, `distinctKeys` is always empty.

---

`distinctKeys` is used when:

* `EliminateOuterJoin` logical optimization is executed
* `EliminateDistinct` logical optimization is executed
* `RemoveRedundantAggregates` logical optimization is executed
* `JoinEstimation` is requested to [estimateInnerOuterJoin](../cost-based-optimization/JoinEstimation.md#estimateInnerOuterJoin)
* `SizeInBytesOnlyStatsPlanVisitor` is requested to [visitJoin](../cost-based-optimization/SizeInBytesOnlyStatsPlanVisitor.md#visitJoin)
