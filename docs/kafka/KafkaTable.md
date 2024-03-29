# KafkaTable

`KafkaTable` is a [Table](../connector/Table.md) with [read](../connector/SupportsRead.md) and [write](../connector/SupportsWrite.md) support for [Kafka Data Source](index.md).

## Name

`KafkaTable` uses **KafkaTable** name.

## <span id="capabilities"> Capabilities

```scala
capabilities(): ju.Set[TableCapability]
```

`capabilities` is part of the [Table](../connector/Table.md#capabilities) abstraction.

---

`capabilities` is the following table capabilities:

* [BATCH_READ](../connector/TableCapability.md#BATCH_READ)
* [BATCH_WRITE](../connector/TableCapability.md#BATCH_WRITE)
* [MICRO_BATCH_READ](../connector/TableCapability.md#MICRO_BATCH_READ)
* [CONTINUOUS_READ](../connector/TableCapability.md#CONTINUOUS_READ)
* [STREAMING_WRITE](../connector/TableCapability.md#STREAMING_WRITE)
* [ACCEPT_ANY_SCHEMA](../connector/TableCapability.md#ACCEPT_ANY_SCHEMA)

## <span id="newScanBuilder"> Creating ScanBuilder

```scala
newScanBuilder(
  options: CaseInsensitiveStringMap): ScanBuilder
```

`newScanBuilder` is part of the [SupportsRead](../connector/SupportsRead.md#newScanBuilder) abstraction.

---

`newScanBuilder` creates a [ScanBuilder](../connector/ScanBuilder.md) that can create a [KafkaScan](KafkaScan.md).

## <span id="newWriteBuilder"> Creating WriteBuilder

```scala
newWriteBuilder(
  info: LogicalWriteInfo): WriteBuilder
```

`newWriteBuilder` is part of the [SupportsWrite](../connector/SupportsWrite.md#newWriteBuilder) abstraction.

---

`newWriteBuilder` creates a custom [WriteBuilder](../connector/WriteBuilder.md) with support for [truncate](../connector/SupportsTruncate.md) and [update](../connector/SupportsStreamingUpdate.md).

### <span id="buildForBatch"><span id="newWriteBuilder-buildForBatch"> buildForBatch

```scala
buildForBatch(): BatchWrite
```

`buildForBatch` is part of the [WriteBuilder](../connector/WriteBuilder.md#buildForBatch) abstraction.

---

`buildForBatch` creates a [KafkaBatchWrite](KafkaBatchWrite.md).
