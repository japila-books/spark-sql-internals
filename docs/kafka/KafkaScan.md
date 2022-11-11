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
