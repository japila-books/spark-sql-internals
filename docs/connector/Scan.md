# Scan

`Scan` is an [abstraction](#contract) of [logical scans](#implementations) over data sources.

## Contract

### <span id="description"> Description

```java
String description()
```

Human-readable description of this scan (e.g. for logging purposes).

default: the fully-qualified class name

Used when:

* `BatchScanExec` physical operator is requested for the [simpleString](../physical-operators/BatchScanExec.md#simpleString)
* `DataSourceV2ScanExecBase` physical operator is requested for the [simpleString](../physical-operators/DataSourceV2ScanExecBase.md#simpleString) and [verboseStringWithOperatorId](../physical-operators/DataSourceV2ScanExecBase.md#verboseStringWithOperatorId)

### <span id="readSchema"> Read Schema

```java
StructType readSchema()
```

[Read schema](../types/StructType.md) of this scan

Used when:

* `FileScan` is requested for the [partition and data filters](../files/FileScan.md#)
* `GroupBasedRowLevelOperationScanPlanning` is executed
* `PushDownUtils` utility is used to [pruneColumns](../PushDownUtils.md#pruneColumns)
* [V2ScanRelationPushDown](../logical-optimizations/V2ScanRelationPushDown.md) logical optimization is executed (and requested to [pushDownAggregates](../logical-optimizations/V2ScanRelationPushDown.md#pushDownAggregates))

### <span id="supportedCustomMetrics"> Supported Custom Metrics

```java
CustomMetric[] supportedCustomMetrics()
```

[CustomMetric](CustomMetric.md)s

Empty by default and expected to be overriden by [implementations](#implementations)

See:

* [KafkaScan](../kafka/KafkaScan.md#supportedCustomMetrics)

Used when:

* `DataSourceV2ScanExecBase` physical operator is requested for the [custom metrics](../physical-operators/DataSourceV2ScanExecBase.md#customMetrics)

### <span id="toBatch"> Physical Representation for Batch Query

```java
Batch toBatch()
```

By default, `toBatch` throws an `UnsupportedOperationException` (with the [description](#description)):

```text
[description]: Batch scan are not supported
```

See:

* [FileScan](../files/FileScan.md#toBatch)

---

Must be implemented (_overriden_), if the [Table](Table.md) that created this `Scan` has [BATCH_READ](TableCapability.md#BATCH_READ) capability (among the [capabilities](Table.md#capabilities)).

---

Used when:

* `BatchScanExec` physical operator is requested for the [Batch](../physical-operators/BatchScanExec.md#batch) and the [filteredPartitions](../physical-operators/BatchScanExec.md#filteredPartitions)

### <span id="toContinuousStream"> Converting to ContinuousStream

```java
ContinuousStream toContinuousStream(
    String checkpointLocation)
```

By default, `toContinuousStream` throws an `UnsupportedOperationException` (with the [description](#description)):

```text
[description]: Continuous scan are not supported
```

---

Must be implemented (_overriden_), if the [Table](Table.md) that created this `Scan` has [CONTINUOUS_READ](TableCapability.md#CONTINUOUS_READ) capability (among the [capabilities](Table.md#capabilities)).

---

Used when:

* `ContinuousExecution` ([Spark Structured Streaming]({{ book.structured_streaming }}/continuous-execution/ContinuousExecution)) is requested for the logical plan ([WriteToContinuousDataSource]({{ book.structured_streaming }}/logical-operators/WriteToContinuousDataSource/))

### <span id="toMicroBatchStream"> Converting to MicroBatchStream

```java
MicroBatchStream toMicroBatchStream(
    String checkpointLocation)
```

By default, `toMicroBatchStream` throws an `UnsupportedOperationException` (with the [description](#description)):

```text
[description]: Micro-batch scan are not supported
```

---

Must be implemented (_overriden_), if the [Table](Table.md) that created this `Scan` has [MICRO_BATCH_READ](TableCapability.md#MICRO_BATCH_READ) capability (among the [capabilities](Table.md#capabilities)).

---

Used when:

* `MicroBatchExecution` ([Spark Structured Streaming]({{ book.structured_streaming }}/micro-batch-execution/MicroBatchExecution)) is requested for the logical plan

## Implementations

* [FileScan](../files/FileScan.md)
* [KafkaScan](../kafka/KafkaScan.md)
* [SupportsReportPartitioning](SupportsReportPartitioning.md)
* [SupportsReportStatistics](SupportsReportStatistics.md)
* [V1Scan](V1Scan.md)
* _others_
