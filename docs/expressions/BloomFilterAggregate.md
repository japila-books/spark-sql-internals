# BloomFilterAggregate Expression

`BloomFilterAggregate` is a [TypedImperativeAggregate](TypedImperativeAggregate.md) expression (of `BloomFilter`s).

## Creating Instance

`BloomFilterAggregate` takes the following to be created:

* <span id="child"> Child [Expression](Expression.md)
* [Estimated Number of Items](#estimatedNumItemsExpression)
* <span id="numBitsExpression"> Number of Bits ([Expression](Expression.md))
* <span id="mutableAggBufferOffset"> Mutable Agg Buffer Offset (default: `0`)
* <span id="inputAggBufferOffset"> Input Agg Buffer Offset (default: `0`)

`BloomFilterAggregate` is created when:

* `InjectRuntimeFilter` logical optimization is requested to [injectBloomFilter](../logical-optimizations/InjectRuntimeFilter.md#injectBloomFilter)

### <span id="estimatedNumItemsExpression"> Estimated Number of Items

`BloomFilterAggregate` can be given an Estimated Number of Items ([Expression](Expression.md)) when [created](#creating-instance).

Unless given, `BloomFilterAggregate` uses [spark.sql.optimizer.runtime.bloomFilter.expectedNumItems](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.expectedNumItems) configuration property.

## <span id="createAggregationBuffer"> Creating Aggregation Buffer

```scala
createAggregationBuffer(): BloomFilter
```

`createAggregationBuffer` is part of the [TypedImperativeAggregate](TypedImperativeAggregate.md#createAggregationBuffer) abstraction.

---

`createAggregationBuffer` [creates a BloomFilter](../BloomFilter.md#create) (with the [estimatedNumItems](#estimatedNumItems) and [numBits](#numBits)).

## <span id="eval"> eval

```scala
eval(
  buffer: BloomFilter): Any
```

`eval` is part of the [TypedImperativeAggregate](TypedImperativeAggregate.md#eval) abstraction.

---

`eval`...FIXME
