# BloomFilterMightContain Expression

`BloomFilterMightContain` is a `BinaryExpression`.

## Creating Instance

`BloomFilterMightContain` takes the following to be created:

* <span id="bloomFilterExpression"> Bloom Filter [Expression](Expression.md)
* <span id="valueExpression"> Value [Expression](Expression.md)

`BloomFilterMightContain` is created when:

* `InjectRuntimeFilter` logical optimization is requested to [injectBloomFilter](../logical-optimizations/InjectRuntimeFilter.md#injectBloomFilter)
