# V1WriteBuilder

`V1WriteBuilder` is an [extension](#contract) of the [WriteBuilder](WriteBuilder.md) abstraction for [V1 DataSources](#implementations) that would like to leverage the DataSource V2 write code paths.

## Contract

### <span id="buildForV1Write"> buildForV1Write

```java
InsertableRelation buildForV1Write()
```

[InsertableRelation](../InsertableRelation.md)

Used when:

* `AppendDataExecV1`, `OverwriteByExpressionExecV1`, [CreateTableAsSelectExec](../physical-operators/CreateTableAsSelectExec.md), `ReplaceTableAsSelectExec` and [AtomicTableWriteExec](../physical-operators/AtomicTableWriteExec.md) physical commands are executed

## Implementations

!!! note
    No known native Spark SQL implementations.
