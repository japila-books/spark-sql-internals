# ColumnarBatch

`ColumnarBatch` allows to work with multiple [ColumnVectors](#columns) as a row-wise table.

## Example

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

## Creating Instance

`ColumnarBatch` takes the following to be created:

* <span id="columns"> [ColumnVectors](spark-sql-ColumnVector.md)
* <span id="numRows"> Number of Rows

`ColumnarBatch` immediately creates the internal `MutableColumnarRow`.

`ColumnarBatch` is created when:

* `RowToColumnarExec` unary physical operator is requested to `doExecuteColumnar`
* [InMemoryTableScanExec](physical-operators/InMemoryTableScanExec.md) leaf physical operator is requested for a [RDD[ColumnarBatch]](physical-operators/InMemoryTableScanExec.md#columnarInputRDD)
* `MapInPandasExec` unary physical operator is requested to `doExecute`
* `OrcColumnarBatchReader` and `VectorizedParquetRecordReader` are requested to `initBatch`
* `PandasGroupUtils` utility is requested to `executePython`
* `ArrowConverters` utility is requested to `fromBatchIterator`

=== [[rowIterator]] Iterator Over InternalRows (in Batch) -- `rowIterator` Method

[source, java]
----
Iterator<InternalRow> rowIterator()
----

`rowIterator`...FIXME

[NOTE]
====
`rowIterator` is used when:

* `ArrowConverters` is requested to `fromBatchIterator`

* `AggregateInPandasExec`, `WindowInPandasExec`, and `FlatMapGroupsInPandasExec` physical operators are requested to execute (`doExecute`)

* `ArrowEvalPythonExec` physical operator is requested to `evaluate`
====

=== [[setNumRows]] Specifying Number of Rows (in Batch) -- `setNumRows` Method

[source, java]
----
void setNumRows(int numRows)
----

In essence, `setNumRows` resets the batch and makes it available for reuse.

Internally, `setNumRows` simply sets the <<numRows, numRows>> to the given `numRows`.

[NOTE]
====
`setNumRows` is used when:

* `OrcColumnarBatchReader` is requested to `nextBatch`

* `VectorizedParquetRecordReader` is requested to <<spark-sql-VectorizedParquetRecordReader.md#nextBatch, nextBatch>> (when `VectorizedParquetRecordReader` is requested to <<spark-sql-VectorizedParquetRecordReader.md#nextKeyValue, nextKeyValue>>)

* `ColumnVectorUtils` is requested to `toBatch` (for testing only)

* `ArrowConverters` is requested to `fromBatchIterator`

* `InMemoryTableScanExec` physical operator is requested to <<spark-sql-SparkPlan-InMemoryTableScanExec.md#createAndDecompressColumn, createAndDecompressColumn>>

* `ArrowPythonRunner` is requested for a `ReaderIterator` (`newReaderIterator`)
====
