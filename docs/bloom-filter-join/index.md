# Bloom Filter Join

**Bloom Filter Join** is an optimization of join queries by pre-filtering one side of a join using a Bloom filter and IN predicate based on the values from the other side of the join.

??? note "SPARK-32268"
    Bloom Filter Join was introduced in [SPARK-32268]({{ spark.jira }}/SPARK-32268).

Bloom Filter Join uses [InjectRuntimeFilter](../logical-optimizations/InjectRuntimeFilter.md) logical optimization to...FIXME

## Configuration Properties

* [spark.sql.optimizer.runtime.bloomFilter.enabled](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.enabled)
* [spark.sql.optimizer.runtime.bloomFilter.creationSideThreshold](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.creationSideThreshold)
* [spark.sql.optimizer.runtimeFilter.number.threshold](../configuration-properties.md#spark.sql.optimizer.runtimeFilter.number.threshold)
