# Bloom Filter Join

**Bloom Filter Join** is an optimization of join queries by pre-filtering one side of a join using [BloomFilter](BloomFilter.md) or `InSubquery` predicate based on the values from the other side of the join.

Bloom Filter Join uses [BloomFilter](BloomFilter.md)s as runtime filters when [spark.sql.optimizer.runtime.bloomFilter.enabled](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.enabled) configuration property is enabled.

Bloom Filter Join uses [InjectRuntimeFilter](../logical-optimizations/InjectRuntimeFilter.md) logical optimization to inject up to [spark.sql.optimizer.runtimeFilter.number.threshold](../configuration-properties.md#spark.sql.optimizer.runtimeFilter.number.threshold) filters ([BloomFilter](BloomFilter.md)s or `InSubquery`s).

??? note "SPARK-32268"
    Bloom Filter Join was introduced in [SPARK-32268]({{ spark.jira }}/SPARK-32268).

## Configuration Properties

* [spark.sql.optimizer.runtime.bloomFilter.enabled](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.enabled)
* [spark.sql.optimizer.runtime.bloomFilter.creationSideThreshold](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.creationSideThreshold)
* [spark.sql.optimizer.runtimeFilter.number.threshold](../configuration-properties.md#spark.sql.optimizer.runtimeFilter.number.threshold)
