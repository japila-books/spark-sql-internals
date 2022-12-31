# ColumnarToRowExec Physical Operator

`ColumnarToRowExec` is a [ColumnarToRowTransition](ColumnarToRowTransition.md) unary physical operator to [translate an `RDD[ColumnarBatch]` into an `RDD[InternalRow]`](#doExecute) in [Columnar Processing](../new-and-noteworthy/columnar-processing.md).

`ColumnarToRowExec` supports [Whole-Stage Java Code Generation](CodegenSupport.md).

## Creating Instance

`ColumnarToRowExec` takes the following to be created:

* <span id="child"> Child [physical operator](SparkPlan.md)

`ColumnarToRowExec` requires that the [child](#child) physical operator [supportsColumnar](SparkPlan.md#supportsColumnar).

`ColumnarToRowExec` is created when:

* [ApplyColumnarRulesAndInsertTransitions](../physical-optimizations/ApplyColumnarRulesAndInsertTransitions.md) physical optimization is executed

## <span id="metrics"> Performance Metrics

### <span id="numInputBatches"> number of input batches

Number of input batches across all partitions (of [executeColumnar](SparkPlan.md#executeColumnar) of the [child](#child) physical operator)

### <span id="numOutputRows"> number of output rows

Total of the [number of rows](../ColumnarBatch.md#numRows) in every [ColumnarBatch](../ColumnarBatch.md) across all partitions (of [executeColumnar](SparkPlan.md#executeColumnar) of the [child](#child) physical operator)

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

---

`doExecute` requests the [child](#child) physical operator to [executeColumnar](SparkPlan.md#executeColumnar) (which is valid since it [supportsColumnar](SparkPlan.md#supportsColumnar)) and `RDD.mapPartitionsInternal` over partition [ColumnarBatch](../ColumnarBatch.md)es (`Iterator[ColumnarBatch]`) to "unpack" to [InternalRow](../InternalRow.md)s.

While unpacking, `doExecute` counts the [number of input batches](#numInputBatches) and [number of output rows](#numOutputRows) performance metrics.

## <span id="inputRDDs"> Input RDDs

```scala
inputRDDs(): Seq[RDD[InternalRow]]
```

`inputRDDs` is part of the [CodegenSupport](CodegenSupport.md#inputRDDs) abstraction.

---

`inputRDDs` is a single `RDD[ColumnarBatch]` that the [child](#child) physical operator gives when requested to [executeColumnar](SparkPlan.md#executeColumnar).

## <span id="canCheckLimitNotReached"> canCheckLimitNotReached Flag

```scala
canCheckLimitNotReached: Boolean
```

`canCheckLimitNotReached` is part of the [CodegenSupport](CodegenSupport.md#canCheckLimitNotReached) abstraction.

---

`canCheckLimitNotReached` is always `true`.
