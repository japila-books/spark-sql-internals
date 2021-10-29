# ColumnarToRowExec Physical Operator

`ColumnarToRowExec` is a [unary physical operator](UnaryExecNode.md) for [Columnar Processing](../new-and-noteworthy/columnar-processing.md).

`ColumnarToRowExec` supports [Whole-Stage Java Code Generation](CodegenSupport.md).

## Creating Instance

`ColumnarToRowExec` takes the following to be created:

* <span id="child"> Child [physical operator](SparkPlan.md)

`ColumnarToRowExec` requires that the [child](#child) physical operator [supportsColumnar](SparkPlan.md#supportsColumnar).

`ColumnarToRowExec` is created when [ApplyColumnarRulesAndInsertTransitions](../physical-optimizations/ApplyColumnarRulesAndInsertTransitions.md) physical optimization is executed.

## <span id="metrics"> Performance Metrics

Key             | Name (in web UI)        | Description
----------------|-------------------------|---------
numInputBatches | number of input batches | Number of input batches
numOutputRows   | number of output rows   | Number of output rows (across all input batches)

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute` requests the [child](#child) physical operator to [executeColumnar](SparkPlan.md#executeColumnar) and `RDD.mapPartitionsInternal` over batches (`Iterator[ColumnarBatch]`) to "unpack" to rows. `doExecute` counts the number of batches and rows (as the [metrics](#metrics)).

## <span id="inputRDDs"> Input RDDs

```scala
inputRDDs(): Seq[RDD[InternalRow]]
```

`inputRDDs` is a single `RDD[ColumnarBatch]` that the [child](#child) physical operator gives when requested to [executeColumnar](SparkPlan.md#executeColumnar).

`inputRDDs` is part of the [CodegenSupport](CodegenSupport.md#inputRDDs) abstraction.

## <span id="canCheckLimitNotReached"> canCheckLimitNotReached Flag

```scala
canCheckLimitNotReached: Boolean
```

`canCheckLimitNotReached` is always `true`.

`canCheckLimitNotReached` is part of the [CodegenSupport](CodegenSupport.md#canCheckLimitNotReached) abstraction.
