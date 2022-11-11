# KafkaRelation

`KafkaRelation` is a [BaseRelation](../BaseRelation.md) with a [TableScan](../TableScan.md).

`KafkaRelation` is <<creating-instance, created>> exclusively when `KafkaSourceProvider` is requested to [create a BaseRelation](KafkaSourceProvider.md#createRelation-RelationProvider) (as a [RelationProvider](../RelationProvider.md#createRelation)).

[[schema]]
`KafkaRelation` uses the fixed [schema](../BaseRelation.md#schema).

[[schema]]
.KafkaRelation's Schema (in the positional order)
[cols="1m,2",options="header",width="100%"]
|===
| Field Name
| Data Type

| `key`
| `BinaryType`

| `value`
| `BinaryType`

| `topic`
| `StringType`

| `partition`
| `IntegerType`

| `offset`
| `LongType`

| `timestamp`
| `TimestampType`

| `timestampType`
| `IntegerType`
|===

[[toString]]
`KafkaRelation` uses the following human-readable text representation:

```
KafkaRelation(strategy=[strategy], start=[startingOffsets], end=[endingOffsets])
```

[[internal-registries]]
.KafkaRelation's Internal Properties (e.g. Registries, Counters and Flags)
[cols="1m,2",options="header",width="100%"]
|===
| Name
| Description

| pollTimeoutMs
a| [[pollTimeoutMs]] Timeout (in milliseconds) to poll data from Kafka ([pollTimeoutMs](KafkaSourceRDD.md#pollTimeoutMs) for `KafkaSourceRDD`)

Initialized with the value of the following configuration properties (in the order until one found):

. `kafkaConsumer.pollTimeoutMs` in the <<sourceOptions, source options>>

. `spark.network.timeout` in the `SparkConf`

If neither is set, defaults to `120s`.

Used exclusively when `KafkaRelation` is requested to <<buildScan, build a distributed data scan with column pruning>> (and creates a [KafkaSourceRDD](KafkaSourceRDD.md#pollTimeoutMs)).
|===

[[logging]]
[TIP]
====
Enable `INFO` or `DEBUG` logging level for `org.apache.spark.sql.kafka010.KafkaRelation` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.kafka010.KafkaRelation=DEBUG
```

Refer to spark-logging.md[Logging].
====

=== [[creating-instance]] Creating KafkaRelation Instance

`KafkaRelation` takes the following when created:

* [[sqlContext]] `SQLContext`
* [[strategy]] `ConsumerStrategy`
* [[sourceOptions]] Source options (as `Map[String, String]`) that directly correspond to the options of [DataFrameReader](../DataFrameReader.md#option)
* [[specifiedKafkaParams]] User-defined Kafka parameters (as `Map[String, String]`)
* [[failOnDataLoss]] `failOnDataLoss` flag
* [[startingOffsets]] Starting offsets (as [KafkaOffsetRangeLimit](KafkaOffsetRangeLimit.md))
* [[endingOffsets]] Ending offsets (as [KafkaOffsetRangeLimit](KafkaOffsetRangeLimit.md))

=== [[buildScan]] Building Distributed Data Scan with Column Pruning (as TableScan) -- `buildScan` Method

[source, scala]
----
buildScan(): RDD[Row]
----

`buildScan` is part of [TableScan](../TableScan.md#buildScan) abstraction.

`buildScan` [kafkaParamsForDriver](KafkaSourceProvider.md#kafkaParamsForDriver) from the <<specifiedKafkaParams, user-defined Kafka parameters>> and uses it to create a [KafkaOffsetReader](KafkaOffsetReader.md) (together with the <<strategy, ConsumerStrategy>>, the <<sourceOptions, source options>> and a unique group ID of the format `spark-kafka-relation-[randomUUID]-driver`).

`buildScan` then uses the `KafkaOffsetReader` to <<getPartitionOffsets, getPartitionOffsets>> for the starting and ending offsets and [closes](KafkaOffsetReader.md#close) it right after.

`buildScan`...FIXME

`buildScan` prints out the following INFO message to the logs:

```
GetBatch generating RDD of offset range: [comma-separated offsetRanges]
```

`buildScan` then [kafkaParamsForExecutors](KafkaSourceProvider.md#kafkaParamsForExecutors) and uses it to create a `KafkaSourceRDD` (with the <<pollTimeoutMs, pollTimeoutMs>>) and maps over all the elements (using `RDD.map` operator that creates a `MapPartitionsRDD`).

TIP: Use `RDD.toDebugString` to see the two RDDs, i.e. `KafkaSourceRDD` and `MapPartitionsRDD`, in the RDD lineage.

In the end, `buildScan` requests the <<sqlContext, SQLContext>> to <<SparkSession.md#internalCreateDataFrame, create a DataFrame>> from the `KafkaSourceRDD` and the <<schema, schema>>.

`buildScan` throws an `IllegalStateException` when the topic partitions for starting offsets are different from the ending offsets topics:

```
different topic partitions for starting offsets topics[[fromTopics]] and ending offsets topics[[untilTopics]]
```

=== [[getPartitionOffsets]] `getPartitionOffsets` Internal Method

[source, scala]
----
getPartitionOffsets(
  kafkaReader: KafkaOffsetReader,
  kafkaOffsets: KafkaOffsetRangeLimit): Map[TopicPartition, Long]
----

`getPartitionOffsets` requests the input `KafkaOffsetReader` to [fetchTopicPartitions](KafkaOffsetReader.md#fetchTopicPartitions).

`getPartitionOffsets` uses the input [KafkaOffsetRangeLimit](KafkaOffsetRangeLimit.md) to return the mapping of offsets per Kafka `TopicPartition` fetched:

. For `EarliestOffsetRangeLimit`, `getPartitionOffsets` returns a map with every `TopicPartition` and `-2L` (as the offset)

. For `LatestOffsetRangeLimit`, `getPartitionOffsets` returns a map with every `TopicPartition` and `-1L` (as the offset)

. For `SpecificOffsetRangeLimit`, `getPartitionOffsets` returns a map from <<validateTopicPartitions, validateTopicPartitions>>

NOTE: `getPartitionOffsets` is used exclusively when `KafkaRelation` is requested to <<buildScan, build a distributed data scan with column pruning>> (as a [TableScan](../TableScan.md)).

==== [[getPartitionOffsets-validateTopicPartitions]] Validating TopicPartitions (Against Partition Offsets) -- `validateTopicPartitions` Inner Method

[source, scala]
----
validateTopicPartitions(
  partitions: Set[TopicPartition],
  partitionOffsets: Map[TopicPartition, Long]): Map[TopicPartition, Long]
----

NOTE: `validateTopicPartitions` is a Scala inner method of <<getPartitionOffsets, getPartitionOffsets>>, i.e. `validateTopicPartitions` is defined within the body of `getPartitionOffsets` and so is visible and can only be used in `getPartitionOffsets`.

`validateTopicPartitions` asserts that the input set of Kafka `TopicPartitions` is exactly the set of the keys in the input `partitionOffsets`.

`validateTopicPartitions` prints out the following DEBUG message to the logs:

```
Partitions assigned to consumer: [partitions]. Seeking to [partitionOffsets]
```

In the end, `validateTopicPartitions` returns the input `partitionOffsets`.

If the input set of Kafka `TopicPartitions` is not the set of the keys in the input `partitionOffsets`, `validateTopicPartitions` throws an `AssertionError`:

```
assertion failed: If startingOffsets contains specific offsets, you must specify all TopicPartitions.
Use -1 for latest, -2 for earliest, if you don't care.
Specified: [partitionOffsets] Assigned: [partitions]
```
