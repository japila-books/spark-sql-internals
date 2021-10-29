# LimitPushDown Logical Optimization

`LimitPushDown` is a logical optimization to [transform](#apply) the following logical operators:

* `LocalLimit` with `Union`
* `LocalLimit` with [Join](../logical-operators/Join.md)

`LimitPushDown` is a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md) (`Rule[LogicalPlan]`).

`LimitPushDown` is part of [Operator Optimization before Inferring Filters](../catalyst/Optimizer.md#operator-optimization-before-inferring-filters) and [Operator Optimization after Inferring Filters](../catalyst/Optimizer.md#operator-optimization-after-inferring-filters) batch of rules of [Logical Optimizer](../catalyst/Optimizer.md).

## Creating Instance

`LimitPushDown` takes no arguments to be created.

`LimitPushDown` is created when [Logical Optimizer](../catalyst/Optimizer.md) is requested for the [default batches of rules](../catalyst/Optimizer.md#defaultBatches).

## <span id="apply"> Executing Rule

```scala
apply(
   plan: LogicalPlan): LogicalPlan
```

`apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

## Demo

```text
// test datasets
scala> val ds1 = spark.range(4)
ds1: org.apache.spark.sql.Dataset[Long] = [value: bigint]

scala> val ds2 = spark.range(2)
ds2: org.apache.spark.sql.Dataset[Long] = [value: bigint]

// Case 1. Rather than `LocalLimit` of `Union` do `Union` of `LocalLimit`
scala> ds1.union(ds2).limit(2).explain(true)
== Parsed Logical Plan ==
GlobalLimit 2
+- LocalLimit 2
   +- Union
      :- Range (0, 4, step=1, splits=Some(8))
      +- Range (0, 2, step=1, splits=Some(8))

== Analyzed Logical Plan ==
id: bigint
GlobalLimit 2
+- LocalLimit 2
   +- Union
      :- Range (0, 4, step=1, splits=Some(8))
      +- Range (0, 2, step=1, splits=Some(8))

== Optimized Logical Plan ==
GlobalLimit 2
+- LocalLimit 2
   +- Union
      :- LocalLimit 2
      :  +- Range (0, 4, step=1, splits=Some(8))
      +- LocalLimit 2
         +- Range (0, 2, step=1, splits=Some(8))

== Physical Plan ==
CollectLimit 2
+- Union
   :- *LocalLimit 2
   :  +- *Range (0, 4, step=1, splits=Some(8))
   +- *LocalLimit 2
      +- *Range (0, 2, step=1, splits=Some(8))
```
