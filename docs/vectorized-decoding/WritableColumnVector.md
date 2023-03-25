# WritableColumnVector

`WritableColumnVector` is an [extension](#contract) of the [ColumnVector](ColumnVector.md) abstraction for [writable in-memory columnar vectors](#implementations).

`WritableColumnVector` is used to [allocate ColumnVectors](../parquet/VectorizedParquetRecordReader.md#allocateColumns) for [VectorizedParquetRecordReader](../parquet/VectorizedParquetRecordReader.md).

## Contract (Subset)

### <span id="reserveInternal"> reserveInternal

```java
void reserveInternal(
  int capacity)
```

Used when:

* [OffHeapColumnVector](OffHeapColumnVector.md) and [OnHeapColumnVector](OnHeapColumnVector.md) are created
* `WritableColumnVector` is requested to [reserve](#reserve)

### <span id="reserveNewColumn"> reserveNewColumn

```java
WritableColumnVector reserveNewColumn(
  int capacity,
  DataType type)
```

Used when:

* `WritableColumnVector` is [created](#creating-instance) or requested to [reserveDictionaryIds](#reserveDictionaryIds)

## Implementations

* [OffHeapColumnVector](OffHeapColumnVector.md)
* [OnHeapColumnVector](OnHeapColumnVector.md)

## Creating Instance

`WritableColumnVector` takes the following to be created:

* <span id="capacity"> Capacity (number of rows to hold in a vector)
* <span id="type"> [Data type](../types/DataType.md) of the rows stored

!!! note "Abstract Class"
    `WritableColumnVector` is an abstract class and cannot be created directly. It is created indirectly for the [concrete WritableColumnVectors](#implementations).

## <span id="reserveAdditional"> reserveAdditional

```java
void reserveAdditional(
  int additionalCapacity)
```

`reserveAdditional`...FIXME

---

`reserveAdditional` is used when:

* `VectorizedRleValuesReader` is requested to `readValues`

## <span id="reserveDictionaryIds"> reserveDictionaryIds

```java
WritableColumnVector reserveDictionaryIds(
  int capacity)
```

`reserveDictionaryIds`...FIXME

---

`reserveDictionaryIds` is used when:

* `VectorizedColumnReader` is requested to [readBatch](../parquet/VectorizedColumnReader.md#readBatch)
* `DictionaryEncoding.Decoder` is requested to `decompress`

## <span id="reserve"> reserve

```java
void reserve(
  int requiredCapacity)
```

`reserve`...FIXME

---

`reserve` is used when:

* `ParquetColumnVector` is requested to `assembleCollection` and `assembleStruct`
* `WritableColumnVector` is requested to [reserveAdditional](#reserveAdditional), [reserveDictionaryIds](#reserveDictionaryIds) and all the `append`s

## <span id="reset"> reset

```java
void reset()
```

`reset` does nothing (_noop_) when either [isConstant](#isConstant) or [isAllNull](#isAllNull) is enabled.

`reset`...FIXME

---

`reset` is used when:

* `ParquetColumnVector` is requested to `reset`
* `VectorizedDeltaByteArrayReader` is requested to `skipBinary`
* [OffHeapColumnVector](OffHeapColumnVector.md) and [OnHeapColumnVector](OnHeapColumnVector.md) are created
* `WritableColumnVector` is requested to [reserveDictionaryIds](#reserveDictionaryIds)
* `RowToColumnarExec` physical operator is requested to [doExecuteColumnar](../physical-operators/RowToColumnarExec.md#doExecuteColumnar)
