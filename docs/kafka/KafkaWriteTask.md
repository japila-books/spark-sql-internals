# KafkaWriteTask

`KafkaWriteTask` is used to <<execute, write rows>> (from a structured query) to Apache Kafka.

`KafkaWriteTask` is <<creating-instance, created>> exclusively when `KafkaWriter` is requested to [write the rows of a structured query to a Kafka topic](KafkaWriter.md#write).

`KafkaWriteTask` <<execute, writes>> keys and values in their binary format (as JVM's bytes) and so uses the [raw-memory unsafe row format](../UnsafeRow.md) only (i.e. `UnsafeRow`). That is supposed to save time for reconstructing the rows to very tiny JVM objects (i.e. byte arrays).

[[internal-properties]]
.KafkaWriteTask's Internal Properties
[cols="1m,2",options="header",width="100%"]
|===
| Name
| Description

| callback
| [[callback]]

| failedWrite
| [[failedWrite]]

| projection
| [[projection]] [UnsafeProjection](../expressions/UnsafeProjection.md)

<<createProjection, Created>> once when `KafkaWriteTask` is created.
|===

=== [[execute]] Writing Rows to Kafka Asynchronously -- `execute` Method

[source, scala]
----
execute(iterator: Iterator[InternalRow]): Unit
----

`execute` uses Apache Kafka's Producer API to create a https://kafka.apache.org/0101/javadoc/index.html?org/apache/kafka/clients/producer/KafkaProducer.html[KafkaProducer] and https://kafka.apache.org/0101/javadoc/index.html?org/apache/kafka/clients/producer/KafkaProducer.html[ProducerRecord] for every row in `iterator`, and sends the rows to Kafka in batches asynchronously.

Internally, `execute` creates a `KafkaProducer` using `Array[Byte]` for the keys and values, and `producerConfiguration` for the producer's configuration.

NOTE: `execute` creates a single `KafkaProducer` for all rows.

For every row in the `iterator`, `execute` uses the internal <<projection, UnsafeProjection>> to _project_ (aka _convert_) [InternalRow](../InternalRow.md) to an [UnsafeRow](../UnsafeRow.md) object and take 0th, 1st and 2nd fields for a topic, key and value, respectively.

`execute` then creates a `ProducerRecord` and sends it to Kafka (using the `KafkaProducer`). `execute` registers a asynchronous `Callback` to monitor the writing.

[NOTE]
====
From https://kafka.apache.org/0101/javadoc/index.html?org/apache/kafka/clients/producer/KafkaProducer.html[KafkaProducer's documentation]:

> The `send()` method is asynchronous. When called it adds the record to a buffer of pending record sends and immediately returns. This allows the producer to batch together individual records for efficiency.
====

=== [[createProjection]] Creating UnsafeProjection -- `createProjection` Internal Method

[source, scala]
----
createProjection: UnsafeProjection
----

`createProjection` creates a [UnsafeProjection](../expressions/UnsafeProjection.md) with `topic`, `key` and `value` expressions/Expression.md[expressions] and the `inputSchema`.

`createProjection` makes sure that the following holds (and reports an `IllegalStateException` otherwise):

* `topic` was defined (either as the input `topic` or in `inputSchema`) and is of type `StringType`
* Optional `key` is of type `StringType` or `BinaryType` if defined
* `value` was defined (in `inputSchema`) and is of type `StringType` or `BinaryType`

`createProjection` casts `key` and `value` expressions to `BinaryType` in [UnsafeProjection](../expressions/UnsafeProjection.md).

NOTE: `createProjection` is used exclusively when `KafkaWriteTask` is created (as <<projection, projection>>).

=== [[close]] `close` Method

[source, scala]
----
close(): Unit
----

`close`...FIXME

NOTE: `close` is used when...FIXME

=== [[creating-instance]] Creating KafkaWriteTask Instance

`KafkaWriteTask` takes the following when created:

* [[producerConfiguration]] Kafka Producer configuration (as `Map[String, Object]`)
* [[inputSchema]] Input schema (as `Seq[Attribute]`)
* [[topic]] Topic name

`KafkaWriteTask` initializes the <<internal-registries, internal registries and counters>>.
