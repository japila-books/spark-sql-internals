# CollectLimitExec Physical Operator

`CollectLimitExec` is a [unary physical operator](LimitExec.md) that represents `GlobalLimit` unary logical operator at execution time.

## Creating Instance

`CollectLimitExec` takes the following to be created:

* <span id="limit"> Number of rows (to collect from the [child](#child) operator)
* <span id="child"> [Physical operator](SparkPlan.md)

`CollectLimitExec` is created when [SpecialLimits](../execution-planning-strategies/SpecialLimits.md) execution planning strategy is executed (and plans a `GlobalLimit` unary logical operator).

## <span id="doExecute"> Executing Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` requests the [child operator](#child) to [execute](SparkPlan.md#execute) and (maps over every partition to) takes the given [number of rows](#limit) from every partition. That gives a `RDD[InternalRow]`.

`doExecute` [prepares a ShuffleDependency](ShuffleExchangeExec.md#prepareShuffleDependency) (for the `RDD[InternalRow]` and `SinglePartition` partitioning) and creates a [ShuffledRowRDD](../ShuffledRowRDD.md).

In the end, `doExecute` (maps over every partition to) takes the given [number of rows](#limit) from the single partition.

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.
