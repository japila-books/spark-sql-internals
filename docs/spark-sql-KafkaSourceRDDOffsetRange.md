# KafkaSourceRDDOffsetRange

`KafkaSourceRDDOffsetRange` is an <<spark-sql-KafkaSourceRDDPartition.md#offsetRange, offset range>> that one  `KafkaSourceRDDPartition` partition of a <<spark-sql-KafkaSourceRDD.md#getPartitions, KafkaSourceRDD>> has to read.

`KafkaSourceRDDOffsetRange` is <<creating-instance, created>> when:

* `KafkaRelation` is requested to <<spark-sql-KafkaRelation.md#buildScan, build a distributed data scan with column pruning>> (as a <<spark-sql-TableScan.md#, TableScan>>) (and creates a <<spark-sql-KafkaSourceRDD.md#offsetRanges, KafkaSourceRDD>>)

* `KafkaSourceRDD` is requested to <<spark-sql-KafkaSourceRDD.md#resolveRange, resolveRange>>

* (Spark Structured Streaming) `KafkaSource` is requested to `getBatch`

[[creating-instance]]
`KafkaSourceRDDOffsetRange` takes the following when created:

* [[topicPartition]] Kafka https://kafka.apache.org/20/javadoc/org/apache/kafka/common/TopicPartition.html[TopicPartition]
* [[fromOffset]] `fromOffset`
* [[untilOffset]] `untilOffset`
* [[preferredLoc]] Preferred location

NOTE: https://kafka.apache.org/20/javadoc/org/apache/kafka/common/TopicPartition.html[TopicPartition] is a topic name and partition number.
