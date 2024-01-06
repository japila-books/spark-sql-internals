# UnsafeExternalRowSorter

`UnsafeExternalRowSorter` is a facade of `UnsafeExternalSorter` ([Spark Core]({{ book.spark_core }}/memory/UnsafeExternalSorter)) to allow [sorting InternalRows](#sort).

## Creating Instance

`UnsafeExternalRowSorter` takes the following to be created:

* <span id="schema"> Output Schema
* <span id="recordComparatorSupplier"> `RecordComparator` Supplier
* <span id="prefixComparator"> `PrefixComparator`
* <span id="prefixComputer"> `UnsafeExternalRowSorter.PrefixComputer`
* <span id="pageSizeBytes"> Page Size (bytes)
* <span id="canUseRadixSort"> `canUseRadixSort` flag

`UnsafeExternalRowSorter` is created using [createWithRecordComparator](#createWithRecordComparator) and [create](#create) utilities.

## Spilling

`UnsafeExternalRowSorter` ([UnsafeExternalSorter](#sorter) actually) may be forced to spill in-memory data when the number of elements reaches `spark.shuffle.spill.numElementsForceSpillThreshold` ([Spark Core]({{ book.spark_core }}/configuration-properties#spark.shuffle.spill.numElementsForceSpillThreshold)).

## <span id="sorter"> UnsafeExternalSorter

`UnsafeExternalRowSorter` creates an `UnsafeExternalSorter` ([Spark Core]({{ book.spark_core }}/memory/UnsafeExternalSorter)) when [created](#creating-instance).

## <span id="create"> Creating UnsafeExternalRowSorter

```java
UnsafeExternalRowSorter create(
  StructType schema,
  Ordering<InternalRow> ordering,
  PrefixComparator prefixComparator,
  UnsafeExternalRowSorter.PrefixComputer prefixComputer,
  long pageSizeBytes,
  boolean canUseRadixSort)
```

`create` creates an [UnsafeExternalRowSorter](#creating-instance) (with a new `RowComparator` when requested).

---

`create` is used when:

* `SortExec` physical operator is requested to [create one](physical-operators/SortExec.md#createSorter)

## <span id="sort"> Sorting

```java
Iterator<InternalRow> sort()
Iterator<InternalRow> sort(
  Iterator<UnsafeRow> inputIterator) // (1)!
```

1. [Inserts all the input rows](#insertRow) and calls no-argument `sort`

`sort`...FIXME

---

`sort` is used when:

* `DynamicPartitionDataConcurrentWriter` is requested to [writeWithIterator](files/DynamicPartitionDataConcurrentWriter.md#writeWithIterator)
* `ShuffleExchangeExec` physical operator is requested to [prepareShuffleDependency](physical-operators/ShuffleExchangeExec.md#prepareShuffleDependency)
* `SortExec` physical operator is [executed](physical-operators/SortExec.md#doExecute)
