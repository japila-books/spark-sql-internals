---
title: BloomFilterMightContain
---

# BloomFilterMightContain Predicate Expression

`BloomFilterMightContain` is a [Predicate](Predicate.md) that uses [BloomFilter](#bloomFilter) when executed ([evaluate](#eval) and [doGenCode](#doGenCode)) to [mightContainLong](../bloom-filter-join/BloomFilter.md#mightContainLong).

`BloomFilterMightContain` is a [BinaryExpression](Expression.md#BinaryExpression).

??? note "`null` Result"
    `BloomFilterMightContain` returns `null` when executed and there is neither [BloomFilter](#bloomFilter) nor [value](#valueExpression) (for an [InternalRow](../InternalRow.md)) defined.

## Creating Instance

`BloomFilterMightContain` takes the following to be created:

* [Bloom Filter Expression](#bloomFilterExpression)
* [Value Expression](#valueExpression)

`BloomFilterMightContain` is created when:

* [InjectRuntimeFilter](../logical-optimizations/InjectRuntimeFilter.md) logical optimization is executed (and [injects a BloomFilter](../logical-optimizations/InjectRuntimeFilter.md#injectBloomFilter))

### Bloom Filter Expression { #bloomFilterExpression }

`BloomFilterMightContain` is given a Bloom Filter [Expression](Expression.md) when [created](#creating-instance).

The Bloom Filter expression is always a [ScalarSubquery](ScalarSubquery.md) expression over an [Aggregate](../logical-operators/Aggregate.md) logical operator.

The `Aggregate` logical operator is created as follows:

* No grouping (all rows are in the same group)
* [BloomFilterAggregate](BloomFilterAggregate.md) as the aggregate function (with `XxHash64` child expression)

### Value Expression { #valueExpression }

`BloomFilterMightContain` is given a Value [Expression](Expression.md) when [created](#creating-instance).

The Value expression is always an `XxHash64` expression (of type `Long`).

!!! note "`null` Value"
    If the value evaluates to `null`, `BloomFilterMightContain` evaluates to `null` (in [eval](#eval) and [doGenCode](#doGenCode)).

## BloomFilter { #bloomFilter }

```scala
bloomFilter: BloomFilter
```

??? note "Lazy Value"
    `bloomFilter` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`bloomFilter` requests the [Bloom Filter Expression](#bloomFilterExpression) to [evaluate](Expression.md#eval) (that gives an `Array[Byte]`).

In the end, `bloomFilter` [deserializes](#deserialize) the bytes (to re-create a [BloomFilter](../bloom-filter-join/BloomFilter.md)).

!!! note
    If the `Array[Byte]` is `null` (undefined), `bloomFilter` is `null`.

---

`bloomFilter` is used when:

* `BloomFilterMightContain` is requested to [evaluate](#eval) and [doGenCode](#doGenCode)

## Pretty Name { #prettyName }

??? note "Expression"

    ```scala
    prettyName: String
    ```

    `prettyName` is part of the [Expression](Expression.md#prettyName) abstraction.

`prettyName` is the following text:

```text
might_contain
```
