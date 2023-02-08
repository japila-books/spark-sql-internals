# PartitionedFile

`PartitionedFile` is a part (_block_) of a file (similarly to a Parquet block or a HDFS split).

`PartitionedFile` represents a chunk of a file that will be read, along with [partition column values](#partitionValues) appended to each row, in a partition.

## Creating Instance

`PartitionedFile` takes the following to be created:

* [Partition Column Values](#partitionValues)
* <span id="filePath"> Path of the file to read
* <span id="start"> Beginning offset (in bytes)
* <span id="length"> Length of this file part (number of bytes to read)
* [Block Hosts](#locations)
* <span id="modificationTime"> Modification time
* <span id="fileSize"> File size

`PartitionedFile` is created when:

* `PartitionedFileUtil` is requested for [split files](PartitionedFileUtil.md#splitFiles) and [getPartitionedFile](PartitionedFileUtil.md#getPartitionedFile)

### <span id="partitionValues"> Partition Column Values

```scala
partitionValues: InternalRow
```

`PartitionedFile` is given an [InternalRow](../InternalRow.md) with the **partition column values** to be appended to each row.

The partition column values are the values of the partition columns and therefore part of the directory structure not the partitioned files themselves (that together are the partitioned dataset).

### <span id="locations"> Block Hosts

```scala
locations: Array[String]
```

`PartitionedFile` is given a collection of nodes (host names) with data blocks.

Default: (empty)

## <span id="toString"> String Representation

```scala
toString: String
```

`toString` is part of the `Object` ([Java]({{ java.api }}/java/lang/Object.html#toString())) abstraction.

---

`toString` is the following text:

```text
path: [filePath], range: [start]-[start+length], partition values: [partitionValues]
```

## Demo

```scala
import org.apache.spark.sql.execution.datasources.PartitionedFile
import org.apache.spark.sql.catalyst.InternalRow

val partFile = PartitionedFile(InternalRow.empty, "fakePath0", 0, 10, Array("host0", "host1"))

println(partFile)
```

```text
path: fakePath0, range: 0-10, partition values: [empty row]
```
