# BloomFilterMightContain Expression

`BloomFilterMightContain` is a [BinaryExpression](Expression.md#BinaryExpression).

## Creating Instance

`BloomFilterMightContain` takes the following to be created:

* <span id="bloomFilterExpression"> Bloom Filter [Expression](Expression.md)
* <span id="valueExpression"> Value [Expression](Expression.md)

`BloomFilterMightContain` is created when:

* [InjectRuntimeFilter](../logical-optimizations/InjectRuntimeFilter.md) logical optimization is executed (and [injects a BloomFilter](../logical-optimizations/InjectRuntimeFilter.md#injectBloomFilter))
