# DataFrameStatFunctions

`DataFrameStatFunctions` API gives the statistic functions to be used in a structured query.

## <span id="bloomFilter"> bloomFilter

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

### <span id="buildBloomFilter"> Building BloomFilter

```scala
buildBloomFilter(
  col: Column, expectedNumItems: Long,
  numBits: Long,
  fpp: Double): BloomFilter
```

`buildBloomFilter`...FIXME

<!---
## Review Me

`DataFrameStatFunctions` is available using [stat](Dataset-untyped-transformations.md#stat) untyped transformation.

[source, scala]
----
val q: DataFrame = ...
q.stat
----
-->
