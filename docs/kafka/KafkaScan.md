# KafkaScan

`KafkaScan` is a [Scan](../connector/Scan.md) (_a logical scan over data in Apache Kafka_).

## Creating Instance

`KafkaScan` takes the following to be created:

* <span id="options"> Case-Insensitive Options

`KafkaScan` is created when:

* `KafkaTable` is requested for a [ScanBuilder](KafkaTable.md#newScanBuilder)

## <span id="readSchema"> Read Schema

```scala
readSchema(): StructType
```

`readSchema` is part of the [Scan](../connector/Scan.md#readSchema) abstraction.

---

`readSchema` [builds the read schema](KafkaRecordToRowConverter.md#kafkaSchema) (possibly with records headers based on [includeHeaders](options.md#includeHeaders) option).

## <span id="supportedCustomMetrics"> Supported Custom Metrics

```scala
supportedCustomMetrics(): Array[CustomMetric]
```

`supportedCustomMetrics` is part of the [Scan](../connector/Scan.md#supportedCustomMetrics) abstraction.

---

`supportedCustomMetrics` gives the following [CustomMetric](../connector/CustomMetric.md)s:

* `OffsetOutOfRangeMetric`
* `DataLossMetric`

## <span id="toMicroBatchStream"> toMicroBatchStream

```scala
toMicroBatchStream(
  checkpointLocation: String): MicroBatchStream
```

`toMicroBatchStream` is part of the [Scan](../connector/Scan.md#toMicroBatchStream) abstraction.

---

`toMicroBatchStream` [validateStreamOptions](KafkaSourceProvider.md#validateStreamOptions).

`toMicroBatchStream` [streamingUniqueGroupId](KafkaSourceProvider.md#streamingUniqueGroupId).

`toMicroBatchStream` [convertToSpecifiedParams](#convertToSpecifiedParams).

`toMicroBatchStream` [determines KafkaOffsetRangeLimit](KafkaSourceProvider.md#getKafkaOffsetRangeLimit) based on the following options (with `LatestOffsetRangeLimit` as the default):

* [startingTimestamp](options.md#STARTING_TIMESTAMP_OPTION_KEY)
* [startingOffsetsByTimestamp](options.md#STARTING_OFFSETS_BY_TIMESTAMP_OPTION_KEY)
* [startingOffsets](options.md#STARTING_OFFSETS_OPTION_KEY)

`toMicroBatchStream` [builds a KafkaOffsetReader](KafkaOffsetReader.md#build) for the following:

Argument | Value
---------|------
 [ConsumerStrategy](ConsumerStrategy.md) | [strategy](KafkaSourceProvider.md#strategy)
 `driverKafkaParams` | [Kafka Configuration Properties for Driver](KafkaSourceProvider.md#kafkaParamsForDriver)
 `readerOptions` | [options](#options)
 `driverGroupIdPrefix` | [streamingUniqueGroupId](KafkaSourceProvider.md#streamingUniqueGroupId) with `-driver` suffix

In the end, `toMicroBatchStream` creates a `KafkaMicroBatchStream` ([Spark Structured Streaming]({{ book.structured_streaming }}/datasources/kafka/KafkaMicroBatchStream)) with the following:

* [KafkaOffsetReader](KafkaOffsetReader.md)
* [kafkaParamsForExecutors](KafkaSourceProvider.md#kafkaParamsForExecutors)
* [KafkaOffsetRangeLimit](KafkaOffsetRangeLimit.md)
* [failOnDataLoss](options.md#failOnDataLoss)
