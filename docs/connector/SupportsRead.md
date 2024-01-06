---
title: SupportsRead
---

# SupportsRead Tables

`SupportsRead` is an [extension](#contract) of the [Table](Table.md) abstraction for [readable tables](#implementations).

## Contract

### <span id="newScanBuilder"> Creating ScanBuilder

```java
ScanBuilder newScanBuilder(
  CaseInsensitiveStringMap options)
```

Creates a [ScanBuilder](ScanBuilder.md)

See:

* [ParquetTable](../parquet/ParquetTable.md#newScanBuilder)

Used when:

* `DataSourceV2Relation` logical operator is requested to [computeStats](../logical-operators/DataSourceV2Relation.md#computeStats)
* [GroupBasedRowLevelOperationScanPlanning](../logical-optimizations/GroupBasedRowLevelOperationScanPlanning.md) logical optimization is executed
* [V2ScanRelationPushDown](../logical-optimizations/V2ScanRelationPushDown.md) logical optimization is executed
* `MicroBatchExecution` ([Spark Structured Streaming]({{ book.structured_streaming }}/micro-batch-execution/MicroBatchExecution#logicalPlan)) is requested for a logical query plan
* `ContinuousExecution` ([Spark Structured Streaming]({{ book.structured_streaming }}/continuous-execution/ContinuousExecution)) is created (and initializes a logical query plan)

## Implementations

* [FileTable](../files/FileTable.md)
* `JDBCTable`
* [KafkaTable](../kafka/KafkaTable.md)
* `MemoryStreamTable` ([Spark Structured Streaming]({{ book.structured_streaming }}/connectors/memory))
* `RatePerMicroBatchTable` ([Spark Structured Streaming]({{ book.structured_streaming }}/connectors/rate-per-microbatch))
* `RateStreamTable` ([Spark Structured Streaming]({{ book.structured_streaming }}/connectors/rate))
* `RowLevelOperationTable`
* `TextSocketTable` ([Spark Structured Streaming]({{ book.structured_streaming }}/connectors/socket))
