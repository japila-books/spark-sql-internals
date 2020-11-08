# KafkaSourceProvider

`KafkaSourceProvider` is the entry point to the [kafka data source](index.md).

`KafkaSourceProvider` is a [SimpleTableProvider](../../connector/SimpleTableProvider.md).

!!! note
    `KafkaSourceProvider` is also a `StreamSourceProvider` and a `StreamSinkProvider` to be used in Spark Structured Streaming.

    Learn more on [StreamSourceProvider]({{ book.structured_streaming }}/StreamSourceProvider) and [StreamSinkProvider]({{ book.structured_streaming }}/StreamSinkProvider) in [The Internals of Spark Structured Streaming]({{ book.structured_streaming }}) online book.

## <span id="getTable"> getTable

```scala
getTable(
  options: CaseInsensitiveStringMap): KafkaTable
```

`getTable` is part of the [SimpleTableProvider](../../connector/SimpleTableProvider.md#getTable) abstraction.

`getTable` creates a [KafkaTable](KafkaTable.md) with the `includeHeaders` flag based on [includeHeaders](options.md#includeHeaders) option.

## <span id="DataSourceRegister"><span id="shortName"> DataSourceRegister

`KafkaSourceProvider` is a [DataSourceRegister](../../DataSourceRegister.md) and registers itself as **kafka** format.

`KafkaSourceProvider` uses `META-INF/services/org.apache.spark.sql.sources.DataSourceRegister` file for the registration (available in the [source code]({{ spark.github }}/external/kafka-0-10-sql/src/main/resources/META-INF/services/org.apache.spark.sql.sources.DataSourceRegister) of Apache Spark).

## <span id="createRelation-RelationProvider"><span id="createRelation"> Creating BaseRelation (as RelationProvider)

```scala
createRelation(
  sqlContext: SQLContext,
  parameters: Map[String, String]): BaseRelation
```

`createRelation` is part of the [RelationProvider](../../RelationProvider.md#createRelation) abstraction.

`createRelation` starts by <<validateBatchOptions, validating the Kafka options (for batch queries)>> in the input `parameters`.

`createRelation` collects all ``kafka.``-prefixed key options (in the input `parameters`) and creates a local `specifiedKafkaParams` with the keys without the `kafka.` prefix (e.g. `kafka.whatever` is simply `whatever`).

`createRelation` <<getKafkaOffsetRangeLimit, gets the desired KafkaOffsetRangeLimit>> with the `startingoffsets` offset option key (in the given `parameters`) and [EarliestOffsetRangeLimit](KafkaOffsetRangeLimit.md#EarliestOffsetRangeLimit) as the default offsets.

`createRelation` makes sure that the [KafkaOffsetRangeLimit](KafkaOffsetRangeLimit.md) is not [EarliestOffsetRangeLimit](KafkaOffsetRangeLimit.md#EarliestOffsetRangeLimit) or throws an `AssertionError`.

`createRelation` <<getKafkaOffsetRangeLimit, gets the desired KafkaOffsetRangeLimit>>, but this time with the `endingoffsets` offset option key (in the given `parameters`) and [LatestOffsetRangeLimit](KafkaOffsetRangeLimit.md#LatestOffsetRangeLimit) as the default offsets.

`createRelation` makes sure that the [KafkaOffsetRangeLimit](KafkaOffsetRangeLimit.md) is not [EarliestOffsetRangeLimit](KafkaOffsetRangeLimit.md#EarliestOffsetRangeLimit) or throws a `AssertionError`.

In the end, `createRelation` creates a [KafkaRelation](KafkaRelation.md) with the <<strategy, subscription strategy>> (in the given `parameters`), <<failOnDataLoss, failOnDataLoss>> option, and the starting and ending offsets.

=== [[validateBatchOptions]] Validating Kafka Options (for Batch Queries) -- `validateBatchOptions` Internal Method

[source, scala]
----
validateBatchOptions(caseInsensitiveParams: Map[String, String]): Unit
----

`validateBatchOptions` <<getKafkaOffsetRangeLimit, gets the desired KafkaOffsetRangeLimit>> for the [startingoffsets](options.md#startingoffsets) option in the input `caseInsensitiveParams` and with [EarliestOffsetRangeLimit](KafkaOffsetRangeLimit.md#EarliestOffsetRangeLimit) as the default `KafkaOffsetRangeLimit`.

`validateBatchOptions` then matches the returned [KafkaOffsetRangeLimit](KafkaOffsetRangeLimit.md) as follows:

* [EarliestOffsetRangeLimit](KafkaOffsetRangeLimit.md#EarliestOffsetRangeLimit) is acceptable and `validateBatchOptions` simply does nothing

* [LatestOffsetRangeLimit](KafkaOffsetRangeLimit.md#LatestOffsetRangeLimit) is not acceptable and `validateBatchOptions` throws an `IllegalArgumentException`:

    ```text
    starting offset can't be latest for batch queries on Kafka
    ```

* [SpecificOffsetRangeLimit](KafkaOffsetRangeLimit.md#SpecificOffsetRangeLimit) is acceptable unless one of the offsets is [-1L](KafkaOffsetRangeLimit.md#LATEST) for which `validateBatchOptions` throws an `IllegalArgumentException`:

    ```text
    startingOffsets for [tp] can't be latest for batch queries on Kafka
    ```

`validateBatchOptions` is used when `KafkaSourceProvider` is requested to [create a BaseRelation](#createRelation-RelationProvider) (as a [RelationProvider](../../RelationProvider.md#createRelation)).

## <span id="createRelation-CreatableRelationProvider"> Writing DataFrame to Kafka Topic (as CreatableRelationProvider)

```scala
createRelation(
  sqlContext: SQLContext,
  mode: SaveMode,
  parameters: Map[String, String],
  df: DataFrame): BaseRelation
```

`createRelation` is part of the [CreatableRelationProvider](../../CreatableRelationProvider.md#createRelation) abstraction.

`createRelation` gets the [topic](options.md#topic) option from the input `parameters`.

`createRelation` gets the <<kafkaParamsForProducer, Kafka-specific options for writing>> from the input `parameters`.

`createRelation` then uses the `KafkaWriter` helper object to [write the rows of the DataFrame to the Kafka topic](KafkaWriter.md#write).

In the end, `createRelation` creates a fake [BaseRelation](../../spark-sql-BaseRelation.md) that simply throws an `UnsupportedOperationException` for all its methods.

`createRelation` supports [Append](../../CreatableRelationProvider.md#Append) and [ErrorIfExists](../../CreatableRelationProvider.md#ErrorIfExists) only. `createRelation` throws an `AnalysisException` for the other save modes:

```text
Save mode [mode] not allowed for Kafka. Allowed save modes are [Append] and [ErrorIfExists] (default).
```

## Fixed Schema

`KafkaSourceProvider` <<sourceSchema, uses a fixed schema>> (and makes sure that a user did not set a custom one).

```text
import org.apache.spark.sql.types.StructType
val schema = new StructType().add($"id".int)
scala> spark
  .read
  .format("kafka")
  .option("subscribe", "topic1")
  .option("kafka.bootstrap.servers", "localhost:9092")
  .schema(schema) // <-- defining a custom schema is not supported
  .load
org.apache.spark.sql.AnalysisException: kafka does not allow user-specified schemas.;
  at org.apache.spark.sql.execution.datasources.DataSource.resolveRelation(DataSource.scala:307)
  at org.apache.spark.sql.DataFrameReader.load(DataFrameReader.scala:178)
  at org.apache.spark.sql.DataFrameReader.load(DataFrameReader.scala:146)
  ... 48 elided
```

=== [[sourceSchema]] `sourceSchema` Method

[source, scala]
----
sourceSchema(
  sqlContext: SQLContext,
  schema: Option[StructType],
  providerName: String,
  parameters: Map[String, String]): (String, StructType)
----

`sourceSchema`...FIXME

[source, scala]
----
val fromKafka = spark.read.format("kafka")...
scala> fromKafka.printSchema
root
 |-- key: binary (nullable = true)
 |-- value: binary (nullable = true)
 |-- topic: string (nullable = true)
 |-- partition: integer (nullable = true)
 |-- offset: long (nullable = true)
 |-- timestamp: timestamp (nullable = true)
 |-- timestampType: integer (nullable = true)
----

NOTE: `sourceSchema` is part of Structured Streaming's `StreamSourceProvider` Contract.

=== [[getKafkaOffsetRangeLimit]] Getting Desired KafkaOffsetRangeLimit (for Offset Option) -- `getKafkaOffsetRangeLimit` Object Method

[source, scala]
----
getKafkaOffsetRangeLimit(
  params: Map[String, String],
  offsetOptionKey: String,
  defaultOffsets: KafkaOffsetRangeLimit): KafkaOffsetRangeLimit
----

`getKafkaOffsetRangeLimit` tries to find the given `offsetOptionKey` in the input `params` and converts the value found to a [KafkaOffsetRangeLimit](KafkaOffsetRangeLimit.md) as follows:

* `latest` becomes [LatestOffsetRangeLimit](KafkaOffsetRangeLimit.md#LatestOffsetRangeLimit)

* `earliest` becomes [EarliestOffsetRangeLimit](KafkaOffsetRangeLimit.md#EarliestOffsetRangeLimit)

* For a JSON text, `getKafkaOffsetRangeLimit` uses the `JsonUtils` helper object to [read per-TopicPartition offsets from it](JsonUtils.md#partitionOffsets) and creates a [SpecificOffsetRangeLimit](KafkaOffsetRangeLimit.md#SpecificOffsetRangeLimit)

When the input `offsetOptionKey` was not found, `getKafkaOffsetRangeLimit` returns the input `defaultOffsets`.

`getKafkaOffsetRangeLimit` is used when:

* `KafkaSourceProvider` is requested to [validate Kafka options (for batch queries)](#validateBatchOptions) and [create a BaseRelation](#createRelation-RelationProvider) (as a [RelationProvider](../../RelationProvider.md#createRelation))

* (Spark Structured Streaming) `KafkaSourceProvider` is requested to `createSource` and `createContinuousReader`

=== [[strategy]] Getting ConsumerStrategy per Subscription Strategy Option -- `strategy` Internal Method

[source, scala]
----
strategy(caseInsensitiveParams: Map[String, String]): ConsumerStrategy
----

`strategy` finds one of the strategy options: [subscribe](options.md#subscribe), [subscribepattern](options.md#subscribepattern) and [assign](options.md#assign).

For [assign](options.md#assign), `strategy` uses the `JsonUtils` helper object to [deserialize TopicPartitions from JSON](JsonUtils.md#partitions-String-Array) (e.g. `{"topicA":[0,1],"topicB":[0,1]}`) and returns a new [AssignStrategy](ConsumerStrategy.md#AssignStrategy).

For [subscribe](options.md#subscribe), `strategy` splits the value by `,` (comma) and returns a new [SubscribeStrategy](ConsumerStrategy.md#SubscribeStrategy).

For [subscribepattern](options.md#subscribepattern), `strategy` returns a new [SubscribePatternStrategy](ConsumerStrategy.md#SubscribePatternStrategy)

`strategy` is used when:

* `KafkaSourceProvider` is requested to [create a BaseRelation](#createRelation-RelationProvider) (as a [RelationProvider](../../RelationProvider.md#createRelation))

* (Spark Structured Streaming) `KafkaSourceProvider` is requested to `createSource` and `createContinuousReader`

=== [[failOnDataLoss]] `failOnDataLoss` Internal Method

[source, scala]
----
failOnDataLoss(caseInsensitiveParams: Map[String, String]): Boolean
----

`failOnDataLoss`...FIXME

NOTE: `failOnDataLoss` is used when `KafkaSourceProvider` is requested to <<createRelation-RelationProvider, create a BaseRelation>> (and also in `createSource` and `createContinuousReader` for Spark Structured Streaming).

=== [[kafkaParamsForDriver]] Setting Kafka Configuration Parameters for Driver -- `kafkaParamsForDriver` Object Method

[source, scala]
----
kafkaParamsForDriver(specifiedKafkaParams: Map[String, String]): java.util.Map[String, Object]
----

`kafkaParamsForDriver` simply sets the <<kafkaParamsForDriver-Kafka-parameters, additional Kafka configuration parameters>> for the driver.

[[kafkaParamsForDriver-Kafka-parameters]]
.Driver's Kafka Configuration Parameters
[cols="1m,1m,1m,2",options="header",width="100%"]
|===
| Name
| Value
| ConsumerConfig
| Description

| key.deserializer
| org.apache.kafka.common.serialization.ByteArrayDeserializer
| KEY_DESERIALIZER_CLASS_CONFIG
| [[key.deserializer]] Deserializer class for keys that implements the Kafka `Deserializer` interface.

| value.deserializer
| org.apache.kafka.common.serialization.ByteArrayDeserializer
| VALUE_DESERIALIZER_CLASS_CONFIG
| [[value.deserializer]] Deserializer class for values that implements the Kafka `Deserializer` interface.

| auto.offset.reset
| earliest
| AUTO_OFFSET_RESET_CONFIG
a| [[auto.offset.reset]] What to do when there is no initial offset in Kafka or if the current offset does not exist any more on the server (e.g. because that data has been deleted):

* `earliest` -- automatically reset the offset to the earliest offset

* `latest` -- automatically reset the offset to the latest offset

* `none` -- throw an exception to the Kafka consumer if no previous offset is found for the consumer's group

* _anything else_ -- throw an exception to the Kafka consumer

| enable.auto.commit
| false
| ENABLE_AUTO_COMMIT_CONFIG
| [[enable.auto.commit]] If `true` the Kafka consumer's offset will be periodically committed in the background

| max.poll.records
| 1
| MAX_POLL_RECORDS_CONFIG
| [[max.poll.records]] The maximum number of records returned in a single call to `Consumer.poll()`

| receive.buffer.bytes
| 65536
| MAX_POLL_RECORDS_CONFIG
| [[receive.buffer.bytes]] Only set if not set already
|===

[[ConfigUpdater-logging]]
[TIP]
====
Enable `DEBUG` logging level for `org.apache.spark.sql.kafka010.KafkaSourceProvider.ConfigUpdater` logger to see updates of Kafka configuration parameters.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.kafka010.KafkaSourceProvider.ConfigUpdater=DEBUG
```

Refer to spark-logging.md[Logging].
====

`kafkaParamsForDriver` is used when:

* `KafkaRelation` is requested to [build a distributed data scan with column pruning](KafkaRelation.md#buildScan) (as a [TableScan](../../spark-sql-TableScan.md))

* (Spark Structured Streaming) `KafkaSourceProvider` is requested to `createSource` and `createContinuousReader`

=== [[kafkaParamsForExecutors]] `kafkaParamsForExecutors` Object Method

[source, scala]
----
kafkaParamsForExecutors(
  specifiedKafkaParams: Map[String, String],
  uniqueGroupId: String): java.util.Map[String, Object]
----

`kafkaParamsForExecutors`...FIXME

NOTE: `kafkaParamsForExecutors` is used when...FIXME

=== [[kafkaParamsForProducer]] `kafkaParamsForProducer` Object Method

[source, scala]
----
kafkaParamsForProducer(parameters: Map[String, String]): Map[String, String]
----

`kafkaParamsForProducer`...FIXME

NOTE: `kafkaParamsForProducer` is used when...FIXME
