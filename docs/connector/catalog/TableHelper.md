# TableHelper Implicit Class

<span id="table" />
`TableHelper` is an implicit class in Scala that extends [Table](Table.md) abstraction.

## <span id="asDeletable"> asDeletable

```scala
asDeletable: SupportsDelete
```

`asDeletable`...FIXME

`asDeletable` is used when...FIXME

## <span id="asReadable"> asReadable

```scala
asReadable: SupportsRead
```

`asReadable`...FIXME

`asReadable` is used when...FIXME

## <span id="asWritable"> asWritable

```scala
asWritable: SupportsWrite
```

`asWritable`...FIXME

`asWritable` is used when...FIXME

## <span id="supports"> supports

```scala
supports(
  capability: TableCapability): Boolean
```

`supports` returns `true` when the given [TableCapability](TableCapability.md) is amongst the [capabilities](Table.md#capabilities) of the [Table](#table). Otherwise, `supports` returns `false`.

`supports` is used when:

* `Table` is requested to [supportsAny](#supportsAny)
* `DataSourceV2Relation` is requested to [skipSchemaResolution](../../logical-operators/DataSourceV2Relation.md#skipSchemaResolution)
* `DataFrameReader` is requested to [load data](../../DataFrameReader.md#load)
* `DataFrameWriter` is requested to [save data](../../DataFrameWriter.md#save)
* [DataSourceV2Strategy](../../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (for [AppendData](../../logical-operators/AppendData.md) and [OverwriteByExpression](../../logical-operators/OverwriteByExpression.md) logical operators)
* [TableCapabilityCheck](../../logical-analysis-rules/TableCapabilityCheck.md) extended analysis check rule is executed
* `MicroBatchExecution` (Spark Structured Streaming) is requested for a `LogicalPlan`
* `ContinuousExecution` (Spark Structured Streaming) is created
* `DataStreamWriter` (Spark Structured Streaming) is requested to start a streaming query

## <span id="supportsAny"> supportsAny

```scala
supportsAny(
  capabilities: TableCapability*): Boolean
```

`supportsAny`...FIXME

`supportsAny` is used when...FIXME
