# BloomFilterImpl

`BloomFilterImpl` is a [BloomFilter](BloomFilter.md).

## Creating Instance

`BloomFilterImpl` takes the following to be created:

* <span id="numHashFunctions"> numHashFunctions
* <span id="numBits"><span id="bits"> Number of bits (to create a `BitArray` or `BitArray` directly)

`BloomFilterImpl` is created when:

* `BloomFilter` is requested to [create a BloomFilter](BloomFilter.md#create)

## <span id="mightContainLong"> mightContainLong

```java
boolean mightContainLong(
  long item)
```

`mightContainLong` is part of the [BloomFilter](BloomFilter.md#mightContainLong) abstraction.

---

`mightContainLong`...FIXME
