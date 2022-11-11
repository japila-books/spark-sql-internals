# KafkaSourceRDD

`KafkaSourceRDD` is an `RDD` of Kafka's [ConsumerRecords](https://kafka.apache.org/20/javadoc/org/apache/kafka/clients/consumer/ConsumerRecords.html) (with keys and values being collections of bytes, i.e. `Array[Byte]`).

`KafkaSourceRDD` uses [KafkaSourceRDDPartition](KafkaSourceRDDPartition.md) for the <<getPartitions, partitions>>.

`KafkaSourceRDD` has a specialized API for the following RDD operators:

* <<count, count>>

* <<countApprox, countApprox>>

* <<isEmpty, isEmpty>>

* <<persist, persist>>

* <<take, take>>

`KafkaSourceRDD` is <<creating-instance, created>> when:

* `KafkaRelation` is requested to [build a distributed data scan with column pruning](KafkaRelation.md#buildScan) (as a [TableScan](../TableScan.md))

* (Spark Structured Streaming) `KafkaSource` is requested to `getBatch`

=== [[compute]] Computing Partition (in TaskContext) -- `compute` Method

[source, scala]
----
compute(
  thePart: Partition,
  context: TaskContext): Iterator[ConsumerRecord[Array[Byte], Array[Byte]]]
----

NOTE: `compute` is part of Spark Core's `RDD` Contract to compute a partition (in a `TaskContext`).

`compute`...FIXME

=== [[count]] `count` Operator

[source, scala]
----
count(): Long
----

NOTE: `count` is part of Spark Core's `RDD` Contract to...FIXME.

`count`...FIXME

=== [[countApprox]] `countApprox` Operator

[source, scala]
----
countApprox(timeout: Long, confidence: Double): PartialResult[BoundedDouble]
----

NOTE: `countApprox` is part of Spark Core's `RDD` Contract to...FIXME.

`countApprox`...FIXME

=== [[isEmpty]] `isEmpty` Operator

[source, scala]
----
isEmpty(): Boolean
----

NOTE: `isEmpty` is part of Spark Core's `RDD` Contract to...FIXME.

`isEmpty`...FIXME

=== [[persist]] `persist` Operator

[source, scala]
----
persist(newLevel: StorageLevel): this.type
----

NOTE: `persist` is part of Spark Core's `RDD` Contract to...FIXME.

`persist`...FIXME

=== [[getPartitions]] `getPartitions` Method

[source, scala]
----
getPartitions: Array[Partition]
----

NOTE: `getPartitions` is part of Spark Core's `RDD` Contract to...FIXME

=== [[getPreferredLocations]] `getPreferredLocations` Method

[source, scala]
----
getPreferredLocations(split: Partition): Seq[String]
----

NOTE: `getPreferredLocations` is part of the RDD Contract to...FIXME.

`getPreferredLocations`...FIXME

=== [[resolveRange]] `resolveRange` Internal Method

[source, scala]
----
resolveRange(
  consumer: KafkaDataConsumer,
  range: KafkaSourceRDDOffsetRange): KafkaSourceRDDOffsetRange
----

`resolveRange`...FIXME

NOTE: `resolveRange` is used exclusively when `KafkaSourceRDD` is requested to <<compute, compute a partition>>.
