---
tags:
  - DeveloperApi
---

# ColumnarBatch

`ColumnarBatch` allows to work with multiple [ColumnVectors](#columns) as a row-wise table for [Columnar Scan](../vectorized-decoding/index.md) and [Vectorized Query Execution](index.md).

## Creating Instance

`ColumnarBatch` takes the following to be created:

* <span id="columns"> [ColumnVector](../vectorized-decoding/ColumnVector.md)s
* [Number of Rows](#numRows)

`ColumnarBatch` immediately creates an internal [ColumnarBatchRow](#row).

`ColumnarBatch` is created when:

* `RowToColumnarExec` physical operator is requested to [doExecuteColumnar](../physical-operators/RowToColumnarExec.md#doExecuteColumnar)
* [InMemoryTableScanExec](../physical-operators/InMemoryTableScanExec.md) leaf physical operator is requested for a [RDD[ColumnarBatch]](../physical-operators/InMemoryTableScanExec.md#columnarInputRDD)
* `OrcColumnarBatchReader` is requested to `initBatch`
* `VectorizedParquetRecordReader` is requested to [init a batch](../parquet/VectorizedParquetRecordReader.md#initBatch)
* _others_ (PySpark and SparkR)

### <span id="row"> ColumnarBatchRow

`ColumnarBatch` creates a `ColumnarBatchRow` when [created](#creating-instance).

### <span id="numRows"> Number of Rows

```java
int numRows
```

`ColumnarBatch` is given the number of rows (`numRows`) when [created](#creating-instance).

`numRows` can also be (re)set using [setNumRows](#setNumRows) (and is often used to reset a `ColumnarBatch` to `0` before the end value is set).

`numRows` is available using [numRows](#numRows-accessor) accessor.

Used when:

* [rowIterator](#rowIterator)
* [getRow](#getRow)

#### <span id="numRows-accessor"> numRows

```java
int numRows()
```

`numRows` returns the [number of rows](#numRows).

---

`numRows` is used when:

* `FileScanRDD` is requested to [compute a partition](../rdds/FileScanRDD.md#compute)
* `ColumnarToRowExec` physical operator is requested to [execute](../physical-operators/ColumnarToRowExec.md#doExecute)
* `InMemoryTableScanExec` physical operator is requested for the [columnarInputRDD](../physical-operators/InMemoryTableScanExec.md#columnarInputRDD)
* `MetricsBatchIterator` is requested for `next` (ColumnarBatch)
* [DataSourceV2ScanExecBase](../physical-operators/DataSourceV2ScanExecBase.md#doExecuteColumnar) and [FileSourceScanExec](../physical-operators/FileSourceScanExec.md#doExecuteColumnar) physical operators are requested to `doExecuteColumnar`
* _others_ (PySpark)

#### <span id="setNumRows"> setNumRows

```java
void setNumRows(
  int numRows)
```

`setNumRows` sets the [setNumRows](#setNumRows) registry to the given `numRows`.

---

`setNumRows` is used when:

* `OrcColumnarBatchReader` is requested to `nextBatch`
* `VectorizedParquetRecordReader` is requested to [nextBatch](../parquet/VectorizedParquetRecordReader.md#nextBatch)
* `RowToColumnarExec` physical operator is requested to [doExecuteColumnar](../physical-operators/RowToColumnarExec.md#doExecuteColumnar)
* `InMemoryTableScanExec` physical operator is requested for the [columnarInputRDD](../physical-operators/InMemoryTableScanExec.md#columnarInputRDD) (and uses `DefaultCachedBatchSerializer` to `convertCachedBatchToColumnarBatch`)
* _others_ (PySpark and SparkR)

## <span id="rowIterator"> rowIterator

```java
Iterator<InternalRow> rowIterator()
```

`rowIterator`...FIXME

---

`rowIterator` is used when:

* `SparkResult` is requested for `iterator`
* [ColumnarToRowExec](../physical-operators/ColumnarToRowExec.md) physical operator is [executed](../physical-operators/ColumnarToRowExec.md#doExecute)
* _others_ (SparkR and PySpark)

## Demo

```text
import org.apache.spark.sql.types._
val schema = new StructType()
  .add("intCol", IntegerType)
  .add("doubleCol", DoubleType)
  .add("intCol2", IntegerType)
  .add("string", BinaryType)

val capacity = 4 * 1024 // 4k
import org.apache.spark.memory.MemoryMode
import org.apache.spark.sql.execution.vectorized.OnHeapColumnVector
val columns = schema.fields.map { field =>
  new OnHeapColumnVector(capacity, field.dataType)
}

import org.apache.spark.sql.vectorized.ColumnarBatch
val batch = new ColumnarBatch(columns.toArray)

// Add a row [1, 1.1, NULL]
columns(0).putInt(0, 1)
columns(1).putDouble(0, 1.1)
columns(2).putNull(0)
columns(3).putByteArray(0, "Hello".getBytes(java.nio.charset.StandardCharsets.UTF_8))
batch.setNumRows(1)

assert(batch.getRow(0).numFields == 4)
```
