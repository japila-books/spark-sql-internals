# Options

## <span id="includeHeaders"><span id="INCLUDE_HEADERS"> includeHeaders

default: `false`

<!---
## Review Me

[[options]]
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

| endingoffsets
|
| [[endingoffsets]]

| failondataloss
|
| [[failondataloss]]

| kafkaConsumer.pollTimeoutMs
|
| [[kafkaConsumer.pollTimeoutMs]] See [kafkaConsumer.pollTimeoutMs](KafkaRelation.md#pollTimeoutMs)

| startingoffsets
|
| [[startingoffsets]]

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
