# InternalKafkaProducerPool

## <span id="cacheExpireTimeoutMillis"><span id="spark.kafka.producer.cache.timeout"> spark.kafka.producer.cache.timeout

`InternalKafkaProducerPool` uses [spark.kafka.producer.cache.timeout](configuration-properties.md#spark.kafka.producer.cache.timeout) when requested to [acquire a CachedKafkaProducer](#acquire).

## <span id="acquire"> Acquiring CachedKafkaProducer

```scala
acquire(
  kafkaParams: ju.Map[String, Object]): CachedKafkaProducer
```

`acquire`...FIXME

`acquire` is used when...FIXME
