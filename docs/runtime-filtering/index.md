# Runtime Filtering

**Runtime Filtering** is an optimization of join queries by pre-filtering one side of a join using [Bloom Filter](../bloom-filter-join/index.md) or `InSubquery` predicate based on the values from the other side of the join.

Runtime Filtering uses [InjectRuntimeFilter](../logical-optimizations/InjectRuntimeFilter.md) logical optimization to inject either [Bloom Filter](../bloom-filter-join/index.md) or `InSubquery` predicate based on [spark.sql.optimizer.runtime.bloomFilter.enabled](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.enabled) configuration property.
