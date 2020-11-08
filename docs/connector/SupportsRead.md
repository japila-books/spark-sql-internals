# SupportsRead

`SupportsRead` is an [extension](#contract) of the [Table](Table.md) abstraction for [readable tables](#implementations).

## Contract

### <span id="newScanBuilder"> Creating ScanBuilder

```java
ScanBuilder newScanBuilder(
  CaseInsensitiveStringMap options)
```

Creates a [ScanBuilder](ScanBuilder.md)

Used when:

* `DataSourceV2Relation` logical operator is requested to [computeStats](../logical-operators/DataSourceV2Relation.md#computeStats)
* [V2ScanRelationPushDown](../logical-optimizations/V2ScanRelationPushDown.md) logical optimization is executed
* `MicroBatchExecution` (Spark Structured Streaming) is requested for a logical query plan
* `ContinuousExecution` (Spark Structured Streaming) is created (and initializes a logical query plan)

## Implementations

* [FileTable](FileTable.md)
* [KafkaTable](../datasources/kafka/KafkaTable.md)
* MemoryStreamTable (Spark Structured Streaming)
* RateStreamTable (Spark Structured Streaming)
* TextSocketTable (Spark Structured Streaming)
