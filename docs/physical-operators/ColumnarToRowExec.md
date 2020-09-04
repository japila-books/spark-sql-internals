# ColumnarToRowExec Physical Operator

`ColumnarToRowExec` is a [unary physical operator](UnaryExecNode.md) with [CodegenSupport](CodegenSupport.md).

`ColumnarToRowExec` requires that the [child](#child) physical operator [supportsColumnar](SparkPlan.md#supportsColumnar).

## Creating Instance

`ColumnarToRowExec` takes the following to be created:

* <span id="child"> Child [physical operator](SparkPlan.md)

`ColumnarToRowExec` is created when [ApplyColumnarRulesAndInsertTransitions](../physical-optimizations/ApplyColumnarRulesAndInsertTransitions.md) physical optimization is executed.

## <span id="metrics"> Performance Metrics

Key             | Name (in web UI)        | Description
----------------|-------------------------|---------
numInputBatches | number of input batches |
numOutputRows   | number of output rows   |

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` requests the [child](#child) physical operator to [executeColumnar](SparkPlan.md#executeColumnar) and `RDD.mapPartitionsInternal` over batches (`Iterator[ColumnarBatch]`) to "unpack" to rows. `doExecute` counts the number of batches and rows (as the [metrics](#metrics)).

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.
