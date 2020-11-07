# Kafka Data Source

Spark SQL supports <<reading, reading>> data from or <<writing, writing>> data to one or more topics in Apache Kafka.

!!! note
    **Apache Kafka** is a storage of records in a format-independent and fault-tolerant durable way.

    Learn more about Apache Kafka in the [official documentation](http://kafka.apache.org/documentation/) or in [Mastering Apache Kafka]({{ book.kafka }}).

Kafka Data Source supports [options](options.md) to get better performance of structured queries that use it.

## Reading Data from Kafka Topic(s)

[DataFrameReader.format](../../DataFrameReader.md#format) method is used to specify Apache Kafka as the external data source to load data from.

You use [kafka](../../spark-sql-KafkaSourceProvider.md#shortName) (or `org.apache.spark.sql.kafka010.KafkaSourceProvider`) as the input data source format.

```text
val kafka = spark.read.format("kafka").load

// Alternatively
val kafka = spark.read.format("org.apache.spark.sql.kafka010.KafkaSourceProvider").load
```

These one-liners create a [DataFrame](../../spark-sql-DataFrame.md) that represents the distributed process of loading data from one or many Kafka topics (with additional properties).

## Writing Data to Kafka Topic(s)

As a Spark developer,...FIXME
