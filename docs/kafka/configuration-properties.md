# Configuration Properties

## <span id="CONSUMER_CACHE_CAPACITY"><span id="spark.kafka.consumer.cache.capacity"> spark.kafka.consumer.cache.capacity

The maximum number of consumers cached. Please note it's a soft limit (check Structured Streaming Kafka integration guide for further details).

Default: `64`

Used in [InternalKafkaConsumerPool](InternalKafkaProducerPool.md)

## <span id="CONSUMER_CACHE_EVICTOR_THREAD_RUN_INTERVAL"><span id="spark.kafka.consumer.cache.evictorThreadRunInterval"> spark.kafka.consumer.cache.evictorThreadRunInterval

The interval of time (in millis) between runs of the idle evictor thread for consumer pool. When non-positive, no idle evictor thread will be run

Default: `1m`

## <span id="CONSUMER_CACHE_JMX_ENABLED"><span id="spark.kafka.consumer.cache.jmx.enable"> spark.kafka.consumer.cache.jmx.enable

Enable or disable JMX for pools created with this configuration instance.

Default: `false`

## <span id="CONSUMER_CACHE_TIMEOUT"><span id="spark.kafka.consumer.cache.timeout"> spark.kafka.consumer.cache.timeout

The minimum amount of time (in millis) a consumer may sit idle in the pool before it is eligible for eviction by the evictor. When non-positive, no consumers will be evicted from the pool due to idle time alone.

Default: `5m`

## <span id="FETCHED_DATA_CACHE_EVICTOR_THREAD_RUN_INTERVAL"><span id="spark.kafka.consumer.cache.evictorThreadRunInterval"> spark.kafka.consumer.cache.evictorThreadRunInterval

The interval of time (in millis) between runs of the idle evictor thread for consumer pool. When non-positive, no idle evictor thread will be run.

Default: `1m`

## <span id="FETCHED_DATA_CACHE_TIMEOUT"><span id="spark.kafka.consumer.fetchedData.cache.timeout"> spark.kafka.consumer.fetchedData.cache.timeout

The minimum amount of time (in millis) a fetched data may sit idle in the pool before it is eligible for eviction by the evictor. When non-positive, no fetched data will be evicted from the pool due to idle time alone.

Default: `5m`

## <span id="PRODUCER_CACHE_EVICTOR_THREAD_RUN_INTERVAL"><span id="spark.kafka.producer.cache.evictorThreadRunInterval"> spark.kafka.producer.cache.evictorThreadRunInterval

The interval of time (in millis) between runs of the idle evictor thread for producer pool. When non-positive, no idle evictor thread will be run.

Default: `1m`

## <span id="PRODUCER_CACHE_TIMEOUT"><span id="spark.kafka.producer.cache.timeout"> spark.kafka.producer.cache.timeout

The expire time (in millis) to remove the unused producers.

Default: `10m`

Used when:

* `InternalKafkaProducerPool` is requested to [acquire a CachedKafkaProducer](InternalKafkaProducerPool.md#acquire)