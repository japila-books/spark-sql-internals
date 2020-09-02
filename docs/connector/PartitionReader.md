# PartitionReader

`PartitionReader` is an [abstraction](#contract) of [partition readers](#implementations) (that [PartitionReaderFactory](PartitionReaderFactory.md) creates for reading partitions in [columnar](PartitionReaderFactory.md#createColumnarReader) or [row-based](PartitionReaderFactory.md#createReader) fashion).

## Generic Interface

`PartitionReader` is a generic interface with the following Java definition:

```java
public interface PartitionReader<T>
```

`PartitionReader` uses `T` as the name of the type parameter.

??? note "Generic Types"
    Find out more on generic types in [The Java Tutorials](https://docs.oracle.com/javase/tutorial/java/generics/types.html).

## Contract

### <span id="get"> Next Record

```java
T get()
```

Retrieves the current record

Used when:

* `DataSourceRDD` is requested to [compute a partition](../DataSourceRDD.md#compute)
* `FilePartitionReader` is requested to `get` the current record
* `PartitionReaderWithPartitionValues` is requested to `get` the current record

### <span id="next"> Proceeding to Next Record

```java
boolean next()
```

Proceeds to next record if available (`true`) or `false`

Used when:

* `DataSourceRDD` is requested to [compute a partition](../DataSourceRDD.md#compute)
* `FilePartitionReader` is requested to proceed to `next` record if available
* `PartitionReaderWithPartitionValues` is requested to proceed to `next` record if available

## Implementations

* EmptyPartitionReader
* FilePartitionReader
* PartitionedFileReader
* PartitionReaderFromIterator
* PartitionReaderWithPartitionValues
* PartitionRecordReader
* _others_
