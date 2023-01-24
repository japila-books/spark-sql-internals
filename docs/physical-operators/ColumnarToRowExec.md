# ColumnarToRowExec Physical Operator

`ColumnarToRowExec` is a [ColumnarToRowTransition](ColumnarToRowTransition.md) unary physical operator to [translate an `RDD[ColumnarBatch]` into an `RDD[InternalRow]`](#doExecute) in [Columnar Processing](../columnar-processing/index.md).

`ColumnarToRowExec` supports [Whole-Stage Java Code Generation](CodegenSupport.md).

`ColumnarToRowExec` requires that the [child](#child) physical operator [supports columnar processing](SparkPlan.md#supportsColumnar).

## Creating Instance

`ColumnarToRowExec` takes the following to be created:

* <span id="child"> Child [physical operator](SparkPlan.md)

`ColumnarToRowExec` is created when:

* [ApplyColumnarRulesAndInsertTransitions](../physical-optimizations/ApplyColumnarRulesAndInsertTransitions.md) physical optimization is executed

## <span id="metrics"> Performance Metrics

### <span id="numInputBatches"> number of input batches

Number of input [ColumnarBatch](../ColumnarBatch.md)es across all partitions (from [columnar execution](SparkPlan.md#executeColumnar) of the [child](#child) physical operator that produces `RDD[ColumnarBatch]` and hence RDD partitions with `ColumnarBatch`es)

The number of input [ColumnarBatch](../ColumnarBatch.md)es is influenced by [spark.sql.parquet.columnarReaderBatchSize](../configuration-properties.md#spark.sql.parquet.columnarReaderBatchSize) configuration property.

### <span id="numOutputRows"> number of output rows

Total of the [number of rows](../ColumnarBatch.md#numRows) in every [ColumnarBatch](../ColumnarBatch.md) across all partitions (of [executeColumnar](SparkPlan.md#executeColumnar) of the [child](#child) physical operator)

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

---

`doExecute` requests the [child](#child) physical operator to [executeColumnar](SparkPlan.md#executeColumnar) (which is valid since it does [support columnar processing](SparkPlan.md#supportsColumnar)) and `RDD.mapPartitionsInternal` over partition [ColumnarBatch](../ColumnarBatch.md)es (`Iterator[ColumnarBatch]`) to "unpack" to [InternalRow](../InternalRow.md)s.

While unpacking, `doExecute` updates the [number of input batches](#numInputBatches) and [number of output rows](#numOutputRows) performance metrics.

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

`canCheckLimitNotReached` is `true`.
