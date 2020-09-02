# UnaryExecNode Physical Operators

`UnaryExecNode` is an [extension](#contract) of the [SparkPlan](SparkPlan.md) abstraction for [physical operators](#implementations) that have one [child physical operator](#child).

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

* AggregateInPandasExec
* AliasAwareOutputPartitioning
* AppendColumnsExec
* BaseAggregateExec
* [CoalesceExec](CoalesceExec.md)
* CollectMetricsExec
* ColumnarToRowExec
* [CustomShuffleReaderExec](CustomShuffleReaderExec.md)
* [DataWritingCommandExec](DataWritingCommandExec.md)
* [DebugExec](DebugExec.md)
* [DeserializeToObjectExec](DeserializeToObjectExec.md)
* [EvalPythonExec](EvalPythonExec.md)
* [Exchange](Exchange.md)
* [ExpandExec](ExpandExec.md)
* [FilterExec](FilterExec.md)
* FlatMapGroupsInPandasExec
* FlatMapGroupsWithStateExec
* [GenerateExec](GenerateExec.md)
* [InputAdapter](InputAdapter.md)
* [LimitExec](LimitExec.md)
* MapGroupsExec
* MapInPandasExec
* [ObjectConsumerExec](ObjectConsumerExec.md)
* [ProjectExec](ProjectExec.md)
* RowToColumnarExec
* [SampleExec](SampleExec.md)
* ScriptTransformationExec
* [SortExec](SortExec.md)
* [SubqueryBroadcastExec](SubqueryBroadcastExec.md)
* [SubqueryExec](SubqueryExec.md)
* [TakeOrderedAndProjectExec](TakeOrderedAndProjectExec.md)
* V2TableWriteExec
* [WholeStageCodegenExec](WholeStageCodegenExec.md)
* WindowExecBase
* _others_

## <span id="verboseStringWithOperatorId"> verboseStringWithOperatorId

```scala
verboseStringWithOperatorId(): String
```

`verboseStringWithOperatorId`...FIXME

`verboseStringWithOperatorId` is part of the [QueryPlan](../catalyst/QueryPlan.md#verboseStringWithOperatorId) abstraction.
