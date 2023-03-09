# ColumnarToRowExec Physical Operator

`ColumnarToRowExec` is a [ColumnarToRowTransition](ColumnarToRowTransition.md) unary physical operator to [translate an RDD of ColumnarBatches into an RDD of InternalRows](#doExecute) in [Columnar Processing](../columnar-execution/index.md).

`ColumnarToRowExec` supports [Whole-Stage Java Code Generation](CodegenSupport.md).

`ColumnarToRowExec` requires that the [child](#child) physical operator [supports columnar processing](SparkPlan.md#supportsColumnar).

## Creating Instance

`ColumnarToRowExec` takes the following to be created:

* <span id="child"> Child [physical operator](SparkPlan.md)

`ColumnarToRowExec` is created when:

* [ApplyColumnarRulesAndInsertTransitions](../physical-optimizations/ApplyColumnarRulesAndInsertTransitions.md) physical optimization is executed

## <span id="metrics"> Performance Metrics

### <span id="numInputBatches"> number of input batches

Number of input [ColumnarBatch](../vectorized-query-execution/ColumnarBatch.md)es across all partitions (from [columnar execution](SparkPlan.md#executeColumnar) of the [child](#child) physical operator that produces `RDD[ColumnarBatch]` and hence RDD partitions with rows "compressed" into `ColumnarBatch`es)

The number of input [ColumnarBatch](../vectorized-query-execution/ColumnarBatch.md)es is influenced by [spark.sql.parquet.columnarReaderBatchSize](../configuration-properties.md#spark.sql.parquet.columnarReaderBatchSize) configuration property.

### <span id="numOutputRows"> number of output rows

Total of the [number of rows](../vectorized-query-execution/ColumnarBatch.md#numRows) in every [ColumnarBatch](../vectorized-query-execution/ColumnarBatch.md) across all partitions (of [executeColumnar](SparkPlan.md#executeColumnar) of the [child](#child) physical operator)

## <span id="doExecute"> Executing Physical Operator

??? note "Signature"

    ```scala
    doExecute(): RDD[InternalRow]
    ```

    `doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute` requests the [child](#child) physical operator to [executeColumnar](SparkPlan.md#executeColumnar) (which is valid since it does [support columnar processing](SparkPlan.md#supportsColumnar)) and `RDD.mapPartitionsInternal` over partitions of [ColumnarBatch](../vectorized-query-execution/ColumnarBatch.md)es (`Iterator[ColumnarBatch]`) to "unpack" / "uncompress" them to [InternalRow](../InternalRow.md)s.

While "unpacking", `doExecute` updates the [number of input batches](#numInputBatches) and [number of output rows](#numOutputRows) performance metrics.

## <span id="inputRDDs"> Input RDDs

??? note "Signature"

    ```scala
    inputRDDs(): Seq[RDD[InternalRow]]
    ```

    `inputRDDs` is part of the [CodegenSupport](CodegenSupport.md#inputRDDs) abstraction.

`inputRDDs` is the RDD of [ColumnarBatch](../vectorized-query-execution/ColumnarBatch.md)es (`RDD[ColumnarBatch]`) from the [child](#child) physical operator (when requested to [executeColumnar](SparkPlan.md#executeColumnar)).

## <span id="canCheckLimitNotReached"> canCheckLimitNotReached Flag

??? note "Signature"

    ```scala
    canCheckLimitNotReached: Boolean
    ```

    `canCheckLimitNotReached` is part of the [CodegenSupport](CodegenSupport.md#canCheckLimitNotReached) abstraction.

`canCheckLimitNotReached` is always enabled (`true`).
