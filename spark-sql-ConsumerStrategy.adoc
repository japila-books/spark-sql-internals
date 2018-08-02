== [[ConsumerStrategy]] ConsumerStrategy Contract for KafkaConsumer Providers

`ConsumerStrategy` is the <<contract, contract>> for components that can <<createConsumer, create a KafkaConsumer>> using the given Kafka parameters.

[[contract]]
[[createConsumer]]
[source, scala]
----
createConsumer(kafkaParams: java.util.Map[String, Object]): Consumer[Array[Byte], Array[Byte]]
----

[[available-consumerstrategies]]
.Available ConsumerStrategies
[cols="1,2",options="header",width="100%"]
|===
| ConsumerStrategy
| createConsumer

| [[AssignStrategy]] `AssignStrategy`
| Uses link:++http://kafka.apache.org/0110/javadoc/org/apache/kafka/clients/consumer/KafkaConsumer.html#assign(java.util.Collection)++[KafkaConsumer.assign(Collection<TopicPartition> partitions)]

| [[SubscribeStrategy]] `SubscribeStrategy`
| Uses link:++http://kafka.apache.org/0110/javadoc/org/apache/kafka/clients/consumer/KafkaConsumer.html#subscribe(java.util.Collection)++[KafkaConsumer.subscribe(Collection<String> topics)]

| [[SubscribePatternStrategy]] `SubscribePatternStrategy`
a| Uses link:++http://kafka.apache.org/0110/javadoc/org/apache/kafka/clients/consumer/KafkaConsumer.html#subscribe(java.util.regex.Pattern,%20org.apache.kafka.clients.consumer.ConsumerRebalanceListener)++[KafkaConsumer.subscribe(Pattern pattern, ConsumerRebalanceListener listener)] with `NoOpConsumerRebalanceListener`.

TIP: Refer to http://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html[java.util.regex.Pattern] for the format of supported topic subscription regex patterns.
|===
