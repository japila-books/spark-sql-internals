# KafkaSourceProvider

`KafkaSourceProvider` is the entry point to the [kafka data source](index.md).

`KafkaSourceProvider` is a [SimpleTableProvider](../connector/SimpleTableProvider.md) (and does not support custom table schema and partitioning).

!!! note
    `KafkaSourceProvider` is also a `StreamSourceProvider` and a `StreamSinkProvider` to be used in Spark Structured Streaming.

    Learn more on [StreamSourceProvider]({{ book.structured_streaming }}/StreamSourceProvider) and [StreamSinkProvider]({{ book.structured_streaming }}/StreamSinkProvider) in [The Internals of Spark Structured Streaming]({{ book.structured_streaming }}) online book.

## <span id="DataSourceRegister"><span id="shortName"> DataSourceRegister

`KafkaSourceProvider` is a [DataSourceRegister](../DataSourceRegister.md) and registers itself as **kafka** format.

`KafkaSourceProvider` uses `META-INF/services/org.apache.spark.sql.sources.DataSourceRegister` file for the registration (available in the [source code]({{ spark.github }}/external/kafka-0-10-sql/src/main/resources/META-INF/services/org.apache.spark.sql.sources.DataSourceRegister) of Apache Spark).

## <span id="getTable"> KafkaTable

```scala
getTable(
  options: CaseInsensitiveStringMap): KafkaTable
```

`getTable` is part of the [SimpleTableProvider](../connector/SimpleTableProvider.md#getTable) abstraction.

`getTable` creates a [KafkaTable](KafkaTable.md) with the `includeHeaders` flag based on [includeHeaders](options.md#includeHeaders) option.

## <span id="createRelation-RelationProvider"><span id="createRelation"> Creating Relation for Reading (RelationProvider)

```scala
createRelation(
  sqlContext: SQLContext,
  parameters: Map[String, String]): BaseRelation
```

`createRelation` is part of the [RelationProvider](../RelationProvider.md#createRelation) abstraction.

`createRelation` starts by <<validateBatchOptions, validating the Kafka options (for batch queries)>> in the input `parameters`.

`createRelation` collects all ``kafka.``-prefixed key options (in the input `parameters`) and creates a local `specifiedKafkaParams` with the keys without the `kafka.` prefix (e.g. `kafka.whatever` is simply `whatever`).

`createRelation` <<getKafkaOffsetRangeLimit, gets the desired KafkaOffsetRangeLimit>> with the `startingoffsets` offset option key (in the given `parameters`) and [EarliestOffsetRangeLimit](KafkaOffsetRangeLimit.md#EarliestOffsetRangeLimit) as the default offsets.

`createRelation` makes sure that the [KafkaOffsetRangeLimit](KafkaOffsetRangeLimit.md) is not [EarliestOffsetRangeLimit](KafkaOffsetRangeLimit.md#EarliestOffsetRangeLimit) or throws an `AssertionError`.

`createRelation` <<getKafkaOffsetRangeLimit, gets the desired KafkaOffsetRangeLimit>>, but this time with the `endingoffsets` offset option key (in the given `parameters`) and [LatestOffsetRangeLimit](KafkaOffsetRangeLimit.md#LatestOffsetRangeLimit) as the default offsets.

`createRelation` makes sure that the [KafkaOffsetRangeLimit](KafkaOffsetRangeLimit.md) is not [EarliestOffsetRangeLimit](KafkaOffsetRangeLimit.md#EarliestOffsetRangeLimit) or throws a `AssertionError`.

In the end, `createRelation` creates a [KafkaRelation](KafkaRelation.md) with the <<strategy, subscription strategy>> (in the given `parameters`), <<failOnDataLoss, failOnDataLoss>> option, and the starting and ending offsets.

## <span id="createRelation-CreatableRelationProvider"> Creating Relation for Writing (CreatableRelationProvider)

```scala
createRelation(
  sqlContext: SQLContext,
  mode: SaveMode,
  parameters: Map[String, String],
  df: DataFrame): BaseRelation
```

`createRelation` is part of the [CreatableRelationProvider](../CreatableRelationProvider.md#createRelation) abstraction.

`createRelation` gets the [topic](options.md#topic) option from the input `parameters`.

`createRelation` gets the <<kafkaParamsForProducer, Kafka-specific options for writing>> from the input `parameters`.

`createRelation` then uses the `KafkaWriter` helper object to [write the rows of the DataFrame to the Kafka topic](KafkaWriter.md#write).

In the end, `createRelation` creates a fake [BaseRelation](../BaseRelation.md) that simply throws an `UnsupportedOperationException` for all its methods.

`createRelation` supports [Append](../CreatableRelationProvider.md#Append) and [ErrorIfExists](../CreatableRelationProvider.md#ErrorIfExists) only. `createRelation` throws an `AnalysisException` for the other save modes:

```text
Save mode [mode] not allowed for Kafka. Allowed save modes are [Append] and [ErrorIfExists] (default).
```

## <span id="kafkaParamsForDriver"> Kafka Configuration Properties for Driver

```scala
kafkaParamsForDriver(
  specifiedKafkaParams: Map[String, String]): ju.Map[String, Object]
```

`kafkaParamsForDriver` is a utility to define required Kafka configuration parameters for the driver.

`kafkaParamsForDriver` is used when:

* `KafkaBatch` is requested to [planInputPartitions](KafkaBatch.md#planInputPartitions)
* `KafkaRelation` is requested to [buildScan](KafkaRelation.md#buildScan)
* `KafkaSourceProvider` to `createSource` (for Spark Structured Streaming)
* `KafkaScan` is requested to `toMicroBatchStream` and `toContinuousStream` (for Spark Structured Streaming)

### <span id="auto.offset.reset"> auto.offset.reset

What to do when there is no initial offset in Kafka or if the current offset does not exist any more on the server (e.g. because that data has been deleted):

* `earliest` - automatically reset the offset to the earliest offset

* `latest` - automatically reset the offset to the latest offset

* `none` - throw an exception to the Kafka consumer if no previous offset is found for the consumer's group

* _anything else_ - throw an exception to the Kafka consumer

Value: `earliest`

ConsumerConfig.AUTO_OFFSET_RESET_CONFIG

### <span id="enable.auto.commit"> enable.auto.commit

If `true` the Kafka consumer's offset will be periodically committed in the background

Value: `false`

ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG

### <span id="key.deserializer"> key.deserializer

Deserializer class for keys that implements the Kafka `Deserializer` interface.

Value: [org.apache.kafka.common.deserialization.ByteArrayDeserializer]({{ kafka.api }})

ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG

### <span id="max.poll.records"> max.poll.records

The maximum number of records returned in a single call to `Consumer.poll()`

Value: `1`

ConsumerConfig.MAX_POLL_RECORDS_CONFIG

### <span id="receive.buffer.bytes"> receive.buffer.bytes

Only set if not set already

Value: `65536`

ConsumerConfig.MAX_POLL_RECORDS_CONFIG

### <span id="value.deserializer"> value.deserializer

Deserializer class for values that implements the Kafka `Deserializer` interface.

Value: [org.apache.kafka.common.serialization.ByteArrayDeserializer]({{ kafka.api }})

ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG

!!! tip
    Enable `ALL` logging level for `org.apache.spark.sql.kafka010.KafkaSourceProvider.ConfigUpdater` logger to see updates of Kafka configuration parameters.

    Add the following line to `conf/log4j2.properties`:

    ```
    log4j.logger.org.apache.spark.sql.kafka010.KafkaSourceProvider.ConfigUpdater=ALL
    ```

    Refer to [Logging](../spark-logging.md).

## <span id="kafkaParamsForExecutors"> kafkaParamsForExecutors

```scala
kafkaParamsForExecutors(
  specifiedKafkaParams: Map[String, String],
  uniqueGroupId: String): ju.Map[String, Object]
```

`kafkaParamsForExecutors`...FIXME

`kafkaParamsForExecutors` is used when:

* `KafkaBatch` is requested to [planInputPartitions](KafkaBatch.md#planInputPartitions)
* `KafkaRelation` is requested to [buildScan](KafkaRelation.md#buildScan)
* `KafkaSourceProvider` to `createSource` (for Spark Structured Streaming)
* `KafkaScan` is requested to `toMicroBatchStream` and `toContinuousStream` (for Spark Structured Streaming)

## <span id="kafkaParamsForProducer"> kafkaParamsForProducer

```scala
kafkaParamsForProducer(
  params: CaseInsensitiveMap[String]): ju.Map[String, Object]
```

`kafkaParamsForProducer`...FIXME

`kafkaParamsForProducer` is used when:

* KafkaSourceProvider is requested to [create a relation for writing](#createRelation-CreatableRelationProvider) (and `createSink` for Spark Structured Streaming)
* `KafkaTable` is requested for a [WriteBuilder](KafkaTable.md#newWriteBuilder)

## <span id="validateBatchOptions"> Validating Kafka Options for Batch Queries

```scala
validateBatchOptions(
  params: CaseInsensitiveMap[String]): Unit
```

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

`validateBatchOptions` is used when:

* `KafkaSourceProvider` is requested for a [relation for reading](#createRelation-RelationProvider)
* `KafkaScan` is requested for a [Batch](KafkaScan.md#toBatch)

## <span id="getKafkaOffsetRangeLimit"> Getting Desired KafkaOffsetRangeLimit (for Offset Option)

```scala
getKafkaOffsetRangeLimit(
  params: Map[String, String],
  offsetOptionKey: String,
  defaultOffsets: KafkaOffsetRangeLimit): KafkaOffsetRangeLimit
```

`getKafkaOffsetRangeLimit` tries to find the given `offsetOptionKey` in the input `params` and converts the value found to a [KafkaOffsetRangeLimit](KafkaOffsetRangeLimit.md) as follows:

* `latest` becomes [LatestOffsetRangeLimit](KafkaOffsetRangeLimit.md#LatestOffsetRangeLimit)

* `earliest` becomes [EarliestOffsetRangeLimit](KafkaOffsetRangeLimit.md#EarliestOffsetRangeLimit)

* For a JSON text, `getKafkaOffsetRangeLimit` uses the `JsonUtils` helper object to [read per-TopicPartition offsets from it](JsonUtils.md#partitionOffsets) and creates a [SpecificOffsetRangeLimit](KafkaOffsetRangeLimit.md#SpecificOffsetRangeLimit)

When the input `offsetOptionKey` was not found, `getKafkaOffsetRangeLimit` returns the input `defaultOffsets`.

`getKafkaOffsetRangeLimit` is used when:

* `KafkaSourceProvider` is requested for a [relation for reading](#createRelation-RelationProvider) and `createSource` (Spark Structured Streaming)
* `KafkaScan` is requested for a [Batch](KafkaScan.md#toBatch), `toMicroBatchStream` (Spark Structured Streaming) and `toContinuousStream` (Spark Structured Streaming)

## <span id="strategy"> ConsumerStrategy

```scala
strategy(
  params: CaseInsensitiveMap[String]): ConsumerStrategy
```

`strategy` finds one of the strategy options: [subscribe](options.md#subscribe), [subscribepattern](options.md#subscribepattern) and [assign](options.md#assign).

For [assign](options.md#assign), `strategy` uses the `JsonUtils` helper object to [deserialize TopicPartitions from JSON](JsonUtils.md#partitions-String-Array) (e.g. `{"topicA":[0,1],"topicB":[0,1]}`) and returns a new [AssignStrategy](ConsumerStrategy.md#AssignStrategy).

For [subscribe](options.md#subscribe), `strategy` splits the value by `,` (comma) and returns a new [SubscribeStrategy](ConsumerStrategy.md#SubscribeStrategy).

For [subscribepattern](options.md#subscribepattern), `strategy` returns a new [SubscribePatternStrategy](ConsumerStrategy.md#SubscribePatternStrategy)

`strategy` is used when:

* `KafkaSourceProvider` is requested for a [relation for reading](#createRelation-RelationProvider) and `createSource` (Spark Structured Streaming)
* `KafkaScan` is requested for a [Batch](KafkaScan.md#toBatch), `toMicroBatchStream` (Spark Structured Streaming) and `toContinuousStream` (Spark Structured Streaming)

## <span id="failOnDataLoss"><span id="FAIL_ON_DATA_LOSS_OPTION_KEY"> failOnDataLoss Option

```scala
failOnDataLoss(
  params: CaseInsensitiveMap[String]): Boolean
```

`failOnDataLoss` is the value of `failOnDataLoss` key in the given case-insensitive parameters (_options_) if available or `true`.

* `KafkaSourceProvider` is requested for a [relation for reading](#createRelation-RelationProvider) (and `createSource` for Spark Structured Streaming)
* `KafkaScan` is requested for a [Batch](KafkaScan.md#toBatch) (and `toMicroBatchStream` and `toContinuousStream` for Spark Structured Streaming)
