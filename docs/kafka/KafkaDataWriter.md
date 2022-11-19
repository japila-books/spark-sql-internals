# KafkaDataWriter

`KafkaDataWriter` is a [DataWriter](../connector/DataWriter.md).

## <span id="KafkaRowWriter"> KafkaRowWriter

`KafkaDataWriter` is a [KafkaRowWriter](KafkaRowWriter.md) (for the [input schema](#inputSchema) and [topic](#targetTopic)).

## Creating Instance

`KafkaDataWriter` takes the following to be created:

* <span id="targetTopic"> Optional Topic Name (_target topic_)
* <span id="producerParams"> Kafka Producer Parameters
* <span id="inputSchema"> Input Schema ([Attribute](../expressions/Attribute.md)s)

`KafkaDataWriter` is created when:

* `KafkaBatchWriterFactory` is requested for a [DataWriter](KafkaBatchWriterFactory.md#createWriter)
* `KafkaStreamWriterFactory` ([Spark Structured Streaming]({{ book.structured_streaming }}/kafka/KafkaStreamWriterFactory)) is requested for a `DataWriter`

## <span id="producer"> Cached KafkaProducer

```scala
producer: Option[CachedKafkaProducer] = None
```

`KafkaDataWriter` defines `producer` internal registry for a `CachedKafkaProducer`:

* `producer` is undefined when `KafkaDataWriter` is [created](#creating-instance)
* `CachedKafkaProducer` is created (_aquired_) when [writing out a row](#write)
* `producer` is cleared (_dereferenced_) in [close](#close)

Once defined, `KafkaDataWriter` uses the `KafkaProducer` to [send a row](#sendRow) (when [writing out a row](#write)).

`KafkaDataWriter` requests the `KafkaProducer` to flush out rows in [commit](#commit).

!!! note "FIXME: Why is InternalKafkaProducerPool required?"
