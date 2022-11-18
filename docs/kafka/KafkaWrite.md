# KafkaWrite

`KafkaWrite` is a [Write](../connector/Write.md) for [Kafka Data Source](index.md).

## Creating Instance

`KafkaWrite` takes the following to be created:

* <span id="topic"> Topic Name
* <span id="producerParams"> Kafka Producer Parameters
* <span id="schema"> Schema ([StructType](../types/StructType.md))

`KafkaWrite` is created when:

* `KafkaTable` is requested to [create a WriteBuilder](KafkaTable.md#newWriteBuilder)

## <span id="description"> Description

```scala
description(): String
```

`description` is part of the [Write](../connector/Write.md#description) abstraction.

---

`description` is `Kafka`.

## <span id="toBatch"> Creating BatchWrite

```scala
toBatch: BatchWrite
```

`toBatch` is part of the [Write](../connector/Write.md#toBatch) abstraction.

---

`toBatch` creates a [KafkaBatchWrite](KafkaBatchWrite.md).

## <span id="toStreaming"> Creating StreamingWrite

```scala
toStreaming: StreamingWrite
```

`toStreaming` is part of the [Write](../connector/Write.md#toStreaming) abstraction.

---

`toStreaming` creates a `KafkaStreamingWrite` ([Spark Structured Streaming]({{ book.structured_streaming }}/kafka/KafkaStreamingWrite)).
