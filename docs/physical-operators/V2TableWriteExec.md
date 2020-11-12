# V2TableWriteExec Physical Commands

`V2TableWriteExec` is an [extension](#contract) of the [V2CommandExec](V2CommandExec.md) abstraction for [unary physical operators](#implementations) that [writeWithV2](#writeWithV2).

## Contract

### <span id="query"> Physical Query Plan

```scala
query: SparkPlan
```

[SparkPlan](SparkPlan.md) for the data to be written out

## Implementations

* [AppendDataExec](AppendDataExec.md)
* [AtomicTableWriteExec](AtomicTableWriteExec.md)
* [CreateTableAsSelectExec](CreateTableAsSelectExec.md)
* [OverwriteByExpressionExec](OverwriteByExpressionExec.md)
* [OverwritePartitionsDynamicExec](OverwritePartitionsDynamicExec.md)
* [ReplaceTableAsSelectExec](ReplaceTableAsSelectExec.md)
* [WriteToDataSourceV2Exec](WriteToDataSourceV2Exec.md)

## <span id="writeWithV2"> writeWithV2

```scala
writeWithV2(
  batchWrite: BatchWrite): Seq[InternalRow]
```

`writeWithV2`...FIXME
