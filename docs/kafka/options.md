# Options

## <span id="includeHeaders"><span id="INCLUDE_HEADERS"> includeHeaders

default: `false`

## <span id="startingOffsets"><span id="STARTING_OFFSETS_OPTION_KEY"> startingOffsets

Specifies where to start reading records

Only applies to new streaming queries that start from scratch (resuming will always pick up from where a query left off)

default: `false`

Supported values:

* `earliest`
* `latest`

Used when:

* `KafkaSourceProvider` is requested to [createSource](KafkaSourceProvider.md#createSource) (to [getKafkaOffsetRangeLimit](KafkaSourceProvider.md#getKafkaOffsetRangeLimit)), [createRelation](KafkaSourceProvider.md#createRelation), [validateBatchOptions](KafkaSourceProvider.md#validateBatchOptions)
* `KafkaScan` is requested to [toBatch](KafkaScan.md#toBatch), [toMicroBatchStream](KafkaScan.md#toMicroBatchStream), [toContinuousStream](KafkaScan.md#toContinuousStream)

<!---
## Review Me

.Kafka Data Source Options
[cols="1m,1,2",options="header",width="100%"]
|===
| Option
| Default
| Description

| assign
|
| [[assign]] One of the three subscription strategy options (with [subscribe](options.md#subscribe) and [subscribepattern](options.md#subscribepattern))

See [KafkaSourceProvider.strategy](KafkaSourceProvider.md#strategy)

| kafkaConsumer.pollTimeoutMs
|
| [[kafkaConsumer.pollTimeoutMs]] See [kafkaConsumer.pollTimeoutMs](KafkaRelation.md#pollTimeoutMs)

| subscribe
|
| [[subscribe]] One of the three subscription strategy options (with [subscribepattern](options.md#subscribepattern) and [assign](options.md#assign))

See [KafkaSourceProvider.strategy](KafkaSourceProvider.md#strategy)

| subscribepattern
|
| [[subscribepattern]] One of the three subscription strategy options (with [subscribe](options.md#subscribe) and [assign](options.md#assign))

See [KafkaSourceProvider.strategy](KafkaSourceProvider.md#strategy)

| topic
|
a| [[topic]] *Required* for writing a DataFrame to Kafka

Used when:

* `KafkaSourceProvider` is requested to [write a DataFrame to a Kafka topic and create a BaseRelation afterwards](KafkaSourceProvider.md#createRelation-CreatableRelationProvider)

* (Spark Structured Streaming) `KafkaSourceProvider` is requested to `createStreamWriter` and `createSink`
|===
-->
