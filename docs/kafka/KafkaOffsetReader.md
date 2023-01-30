# KafkaOffsetReader

`KafkaOffsetReader` is used to query a Kafka cluster for partition offsets.

<!---
## Review Me

`KafkaOffsetReader` is <<creating-instance, created>> when:

* `KafkaRelation` is requested to [build a distributed data scan with column pruning](KafkaRelation.md#buildScan) (as a [TableScan](../TableScan.md)) (to [get the initial partition offsets](KafkaRelation.md#getPartitionOffsets))

* (Spark Structured Streaming) `KafkaSourceProvider` is requested to `createSource` and `createContinuousReader`

[[toString]]
When requested for the human-readable text representation (aka `toString`), `KafkaOffsetReader` simply requests the <<consumerStrategy, ConsumerStrategy>> for one.

[[options]]
.KafkaOffsetReader's Options
[cols="1,1,2",options="header",width="100%"]
|===
| Name
| Default Value
| Description

| [[fetchOffset.numRetries]] `fetchOffset.numRetries`
| `3`
|

| [[fetchOffset.retryIntervalMs]] `fetchOffset.retryIntervalMs`
| `1000`
| How long to wait before retries.
|===

[[internal-registries]]
.KafkaOffsetReader's Internal Registries and Counters
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| `consumer`
a| [[consumer]] Kafka's https://kafka.apache.org/0110/javadoc/org/apache/kafka/clients/consumer/Consumer.html[Consumer] (with keys and values of `Array[Byte]` type)

<<createConsumer, Initialized>> when `KafkaOffsetReader` is <<creating-instance, created>>.

Used when `KafkaOffsetReader`:

* <<fetchTopicPartitions, fetchTopicPartitions>>
* <<fetchEarliestOffsets, fetchEarliestOffsets>>
* <<fetchLatestOffsets, fetchLatestOffsets>>
* <<resetConsumer, resetConsumer>>
* <<close, is closed>>
|===

[TIP]
====
Enable `INFO` or `DEBUG` logging levels for `org.apache.spark.sql.kafka010.KafkaOffsetReader` to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```
log4j.logger.org.apache.spark.sql.kafka010.KafkaOffsetReader=DEBUG
```

Refer to spark-sql-streaming-logging.md[Logging].
====

=== [[createConsumer]] Creating Kafka Consumer -- `createConsumer` Internal Method

[source, scala]
----
createConsumer(): Consumer[Array[Byte], Array[Byte]]
----

`createConsumer` requests the <<consumerStrategy, ConsumerStrategy>> to [create a Kafka Consumer](ConsumerStrategy.md#createConsumer) with <<driverKafkaParams, driverKafkaParams>> and <<nextGroupId, new generated group.id Kafka property>>.

`createConsumer` is used when `KafkaOffsetReader` is <<creating-instance, created>> (and initializes <<consumer, consumer>>) and <<resetConsumer, resetConsumer>>

## Creating Instance

`KafkaOffsetReader` takes the following to be created:

* [[consumerStrategy]] [ConsumerStrategy](ConsumerStrategy.md)
* [[driverKafkaParams]] Kafka parameters (as `Map[String, Object]`)
* [[readerOptions]] Reader options (as `Map[String, String]`)
* [[driverGroupIdPrefix]] Prefix for the group id

=== [[fetchTopicPartitions]] Fetching (and Pausing) Assigned Kafka TopicPartitions -- `fetchTopicPartitions` Method

[source, scala]
----
fetchTopicPartitions(): Set[TopicPartition]
----

`fetchTopicPartitions` <<runUninterruptibly, uses an UninterruptibleThread thread>> to do the following:

. Requests the <<consumer, Kafka Consumer>> to ++https://kafka.apache.org/20/javadoc/org/apache/kafka/clients/consumer/Consumer.html#poll-long-++[poll] (fetch data) for the topics and partitions (with `0` timeout)

. Requests the <<consumer, Kafka Consumer>> to ++https://kafka.apache.org/20/javadoc/org/apache/kafka/clients/consumer/KafkaConsumer.html#assignment--++[get the set of partitions currently assigned]

. Requests the <<consumer, Kafka Consumer>> to ++https://kafka.apache.org/20/javadoc/org/apache/kafka/clients/consumer/KafkaConsumer.html#pause-java.util.Collection-++[suspend fetching from the partitions assigned]

In the end, `fetchTopicPartitions` returns the `TopicPartitions` assigned (and paused).

`fetchTopicPartitions` is used when `KafkaRelation` is requested to [build a distributed data scan with column pruning](#buildScan) (as a [TableScan](../TableScan.md)) through [getPartitionOffsets](KafkaRelation.md#getPartitionOffsets).
-->
