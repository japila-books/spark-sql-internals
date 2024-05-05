---
title: DataFrameStatFunctions
---

# DataFrameStatFunctions

`DataFrameStatFunctions` API gives the statistic functions to be used in a structured query.

`DataFrameStatFunctions` is available using [stat](dataset-untyped-transformations.md#stat) untyped transformation.

```scala
val q: DataFrame = ...
q.stat
```

## bloomFilter { #bloomFilter }

```scala
bloomFilter(
  colName: String,
  expectedNumItems: Long,
  fpp: Double): BloomFilter
bloomFilter(
  col: Column,
  expectedNumItems: Long,
  fpp: Double): BloomFilter
bloomFilter(
  colName: String,
  expectedNumItems: Long,
  numBits: Long): BloomFilter
bloomFilter(
  col: Column,
  expectedNumItems: Long,
  numBits: Long): BloomFilter
```

`bloomFilter` [builds a BloomFilter](#buildBloomFilter).

### Building BloomFilter { #buildBloomFilter }

```scala
buildBloomFilter(
  col: Column, expectedNumItems: Long,
  numBits: Long,
  fpp: Double): BloomFilter
```

`buildBloomFilter`...FIXME
