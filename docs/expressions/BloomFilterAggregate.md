---
title: BloomFilterAggregate
---

# BloomFilterAggregate Expression

`BloomFilterAggregate` is a [TypedImperativeAggregate](TypedImperativeAggregate.md) expression that uses [BloomFilter](../BloomFilter.md) for an [aggregation buffer](#createAggregationBuffer).

## Creating Instance

`BloomFilterAggregate` takes the following to be created:

* <span id="child"> Child [Expression](Expression.md)
* [Estimated Number of Items](#estimatedNumItemsExpression)
* [Number of Bits](#numBitsExpression)
* <span id="mutableAggBufferOffset"> Mutable Agg Buffer Offset (default: `0`)
* <span id="inputAggBufferOffset"> Input Agg Buffer Offset (default: `0`)

`BloomFilterAggregate` is created when:

* `InjectRuntimeFilter` logical optimization is requested to [inject a BloomFilter](../logical-optimizations/InjectRuntimeFilter.md#injectBloomFilter)

### <span id="estimatedNumItemsExpression"> Estimated Number of Items Expression

`BloomFilterAggregate` can be given **Estimated Number of Items** (as an [Expression](Expression.md)) when [created](#creating-instance).

Unless given, `BloomFilterAggregate` uses [spark.sql.optimizer.runtime.bloomFilter.expectedNumItems](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.expectedNumItems) configuration property.

### <span id="numBitsExpression"> Number of Bits Expression

`BloomFilterAggregate` can be given **Number of Bits** (as an [Expression](Expression.md)) when [created](#creating-instance).

The number of bits expression [must be a constant literal](#checkInputDataTypes) (i.e., [foldable](Expression.md#foldable)) that [evaluates to a long value](#numBits).

The maximum value for the number of bits is [spark.sql.optimizer.runtime.bloomFilter.maxNumBits](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.maxNumBits) configuration property.

The number of bits expression is the [third](#third) expression (in this `TernaryLike` tree node).

## <span id="numBits"> Number of Bits

```scala
numBits: Long
```

??? note "Lazy Value"
    `numBits` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`BloomFilterAggregate` defines `numBits` value to be either the value of the [numBitsExpression](#numBitsExpression) (after [evaluating it to a number](Expression.md#eval)) or [spark.sql.optimizer.runtime.bloomFilter.maxNumBits](../configuration-properties.md#spark.sql.optimizer.runtime.bloomFilter.maxNumBits), whatever smaller.

The `numBits` value [must be a positive value](#checkInputDataTypes).

`numBits` is used to [create an aggregation buffer](#createAggregationBuffer).

## Creating Aggregation Buffer { #createAggregationBuffer }

??? note "TypedImperativeAggregate"

    ```scala
    createAggregationBuffer(): BloomFilter
    ```

    `createAggregationBuffer` is part of the [TypedImperativeAggregate](TypedImperativeAggregate.md#createAggregationBuffer) abstraction.

`createAggregationBuffer` [creates a BloomFilter](../BloomFilter.md#create) (with the [estimated number of items](#estimatedNumItems) and the [number of bits](#numBits)).

## Interpreted Execution { #eval }

??? note "TypedImperativeAggregate"

    ```scala
    eval(
      buffer: BloomFilter): Any
    ```

    `eval` is part of the [TypedImperativeAggregate](TypedImperativeAggregate.md#eval) abstraction.

`eval`...FIXME
