# Kafka Data Source

**Kafka Data Source** allows Spark SQL (and Spark Structured Streaming) to [load](#reading) data from and [write](#writing) data to topics in Apache Kafka.

Kafka Data Source is available as [kafka](KafkaSourceProvider.md#shortName) format.

The entry point is [KafkaSourceProvider](KafkaSourceProvider.md).

!!! note
    **Apache Kafka** is a storage of records in a format-independent and fault-tolerant durable way.

    Learn more about Apache Kafka in the [official documentation](http://kafka.apache.org/documentation/) or in [Mastering Apache Kafka]({{ book.kafka }}).

Kafka Data Source supports [options](options.md) to fine-tune structured queries.

## Reading Data from Kafka Topics

In order to load Kafka records use **kafka** as the input data source format.

```scala
val records = spark.read.format("kafka").load
```

Alternatively, use `org.apache.spark.sql.kafka010.KafkaSourceProvider`.

```scala
val records = spark
  .read
  .format("org.apache.spark.sql.kafka010.KafkaSourceProvider")
  .load
```

## Writing Data to Kafka Topics

In order to save a `DataFrame` to Kafka topics use **kafka** as the output data source format.

```text
import org.apache.spark.sql.DataFrame
val records: DataFrame = ...
records.format("kafka").save
```
