# V1WriteBuilder

`V1WriteBuilder` is an [extension](#contract) of the [WriteBuilder](WriteBuilder.md) abstraction for [V1 DataSources](#implementations) that would like to leverage the DataSource V2 write code paths.

## Contract

### <span id="buildForV1Write"> buildForV1Write

```java
InsertableRelation buildForV1Write()
```

[InsertableRelation](../InsertableRelation.md)

Used when:

* [AppendDataExecV1](../physical-operators/AppendDataExecV1.md), [OverwriteByExpressionExecV1](../physical-operators/OverwriteByExpressionExecV1.md), [CreateTableAsSelectExec](../physical-operators/CreateTableAsSelectExec.md), [ReplaceTableAsSelectExec](../physical-operators/ReplaceTableAsSelectExec.md) and [AtomicTableWriteExec](../physical-operators/AtomicTableWriteExec.md) physical commands are executed

## Implementations

No known built-in implementation.
