# BloomFilter

`BloomFilter` is an [abstraction](#contract) of [bloom filters](#implementations) for the following:

* [DataFrameStatFunctions.bloomFilter](../DataFrameStatFunctions.md#bloomFilter) operator
* [BloomFilterAggregate](../expressions/BloomFilterAggregate.md) expression (as an [aggregation buffer](../expressions/BloomFilterAggregate.md#createAggregationBuffer))
* [BloomFilterMightContain](../expressions/BloomFilterMightContain.md#bloomFilter) expression

## Contract (Subset)

### bitSize { #bitSize }

```java
long bitSize()
```

See:

* [BloomFilterImpl](BloomFilterImpl.md#bitSize)

Used when:

* `BloomFilterAggregate` is requested to [serialize a BloomFilter](../expressions/BloomFilterAggregate.md#serialize)

### mightContain { #mightContain }

```java
boolean mightContain(
  Object item)
```

See:

* [BloomFilterImpl](BloomFilterImpl.md#mightContain)

!!! note "Not Used"
    `mightContain` does not seem to be used (as [mightContainLong](#mightContainLong) seems to be used directly instead).

### mightContainLong { #mightContainLong }

```java
boolean mightContainLong(
  long item)
```

See:

* [BloomFilterImpl](BloomFilterImpl.md#mightContainLong)

Used when:

* `BloomFilterImpl` is requested to [mightContain](BloomFilterImpl.md#mightContain)
* `BloomFilterMightContain` is requested to [evaluate](../expressions/BloomFilterMightContain.md#eval) and [doGenCode](../expressions/BloomFilterMightContain.md#doGenCode)

### mightContainString { #mightContainString }

```java
boolean mightContainString(
  String item)
```

See:

* [BloomFilterImpl](BloomFilterImpl.md#mightContainString)

Used when:

* `BloomFilterImpl` is requested to [mightContain](BloomFilterImpl.md#mightContain)

## Implementations

* [BloomFilterImpl](BloomFilterImpl.md)

## Creating BloomFilter { #create }

```java
BloomFilter create(
  long expectedNumItems)
BloomFilter create(
  long expectedNumItems,
  double fpp)
BloomFilter create(
  long expectedNumItems,
  long numBits)
```

`create` creates a [BloomFilterImpl](BloomFilterImpl.md) for the given `expectedNumItems`.

Unless the **False Positive Probability** (`fpp`) is given, `create` uses [DEFAULT_FPP](#DEFAULT_FPP) value to [determine the optimal number of bits](#optimalNumOfBits).

---

`create` is used when:

* `BloomFilterAggregate` is requested to [create an aggregation buffer](../expressions/BloomFilterAggregate.md#createAggregationBuffer)
* `DataFrameStatFunctions` is requested to [build a BloomFilter](../DataFrameStatFunctions.md#buildBloomFilter)
