# Kafka Data Source

**Kafka Data Source** allows Spark SQL (and [Spark Structured Streaming]({{ book.structured_streaming }})) to read data from and write data to topics in Apache Kafka.

Kafka Data Source is available as [kafka](KafkaSourceProvider.md#shortName) format alias.

The entry point is [KafkaSourceProvider](KafkaSourceProvider.md).

!!! note
    **Apache Kafka** is a storage of records in a format-independent and fault-tolerant durable way.

    Learn more about Apache Kafka in the [official documentation](http://kafka.apache.org/documentation/) or [The Internals of Apache Kafka]({{ book.kafka }}).

Kafka Data Source supports [options](options.md) to fine-tune structured queries.
