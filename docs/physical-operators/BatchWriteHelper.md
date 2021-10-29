# BatchWriteHelper Physical Operators

`BatchWriteHelper` is an [abstraction](#contract) of [physical operators](#implementations) that [build batch writes](#newWriteBuilder).

## Contract

### <span id="query"> Physical Query Plan

```scala
query: SparkPlan
```

[SparkPlan](SparkPlan.md)

Used when:

* `BatchWriteHelper` is requested for a [WriteBuilder](#newWriteBuilder)

### <span id="table"> Writable Table

```scala
table: SupportsWrite
```

[SupportsWrite](../connector/SupportsWrite.md)

Used when:

* `BatchWriteHelper` is requested for a [WriteBuilder](#newWriteBuilder)

### <span id="writeOptions"> Write Options

```scala
writeOptions: CaseInsensitiveStringMap
```

Used when:

* `BatchWriteHelper` is requested for a [WriteBuilder](#newWriteBuilder)

## Implementations

* `AppendDataExec`
* [OverwriteByExpressionExec](OverwriteByExpressionExec.md)
* `OverwritePartitionsDynamicExec`

## <span id="newWriteBuilder"> Creating WriteBuilder

```scala
newWriteBuilder(): WriteBuilder
```

`newWriteBuilder` requests the [table](#table) for a [WriteBuilder](../connector/SupportsWrite.md#newWriteBuilder) (with a new `LogicalWriteInfoImpl` with the [query schema](#query) and [write options](#writeOptions)).

`newWriteBuilder` is used when:

* `AppendDataExec`, [OverwriteByExpressionExec](OverwriteByExpressionExec.md) and `OverwritePartitionsDynamicExec` physical operators are executed
