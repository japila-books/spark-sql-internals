# UnaryExecNode Physical Operators

`UnaryExecNode` is an [extension](#contract) of the [SparkPlan](SparkPlan.md) abstraction for [unary physical operators](#implementations) (with one [child physical operator](#child) only).

## Contract

### <span id="child"> Child Physical Operator

```scala
child: SparkPlan
```

The one and only child [physical operator](SparkPlan.md)

Used when:

* `UnaryExecNode` is requested for the [children](../catalyst/TreeNode.md#children)
* _others_

## Implementations

* AggregateInPandasExec ([PySpark]({{ book.pyspark }}/sql/AggregateInPandasExec))
* [PartitioningPreservingUnaryExecNode](PartitioningPreservingUnaryExecNode.md)
* [BaseAggregateExec](BaseAggregateExec.md)
* [CoalesceExec](CoalesceExec.md)
* [CollectMetricsExec](CollectMetricsExec.md)
* [ColumnarToRowExec](ColumnarToRowExec.md)
* [DataWritingCommandExec](DataWritingCommandExec.md)
* [DebugExec](DebugExec.md)
* [EvalPythonExec](EvalPythonExec.md)
* [Exchange](Exchange.md)
* [FilterExec](FilterExec.md)
* FlatMapGroupsInPandasExec ([PySpark]({{ book.pyspark }}/sql/FlatMapGroupsInPandasExec))
* FlatMapGroupsWithStateExec ([Structured Streaming]({{ book.structured_streaming }}/FlatMapGroupsWithStateExec))
* [GenerateExec](GenerateExec.md)
* [InputAdapter](InputAdapter.md)
* [ObjectConsumerExec](ObjectConsumerExec.md)
* [ProjectExec](ProjectExec.md)
* [SortExec](SortExec.md)
* [SubqueryExec](SubqueryExec.md)
* [V2TableWriteExec](V2TableWriteExec.md)
* [WholeStageCodegenExec](WholeStageCodegenExec.md)
* _others_
