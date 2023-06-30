# BloomFilterImpl

`BloomFilterImpl` is a [BloomFilter](BloomFilter.md).

## Creating Instance

`BloomFilterImpl` takes the following to be created:

* <span id="numHashFunctions"> numHashFunctions
* <span id="numBits"><span id="bits"> Number of bits (to create a `BitArray` or `BitArray` directly)

`BloomFilterImpl` is created when:

* `BloomFilter` is requested to [create a BloomFilter](BloomFilter.md#create)

## mightContainLong { #mightContainLong }

??? note "BloomFilter"

    ```java
    boolean mightContainLong(
      long item)
    ```

    `mightContainLong` is part of the [BloomFilter](BloomFilter.md#mightContainLong) abstraction.

`mightContainLong` uses `Murmur3_x86_32` to generate two hashes of the given `item` with two different seeds: `0` and the hash result of the first hashing.

`mightContainLong` requests the [BitArray](#bits) for the number of bits (`bitSize`).

In the end, `mightContainLong` checks out if the bit for the hashes (combined) is set (non-zero) in the [BitArray](#bits) up to [numHashFunctions](#numHashFunctions) times.
With all the bits checked and set, `mightContainLong` is positive. Otherwise, `mightContainLong` is negative.
