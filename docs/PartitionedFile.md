# PartitionedFile

`PartitionedFile` is a part (_block_) of a file that is in a sense similar to a Parquet block or a HDFS split.

`PartitionedFile` represents a chunk of a file that will be read, along with <<partitionValues, partition column values>> appended to each row, in a partition.

NOTE: *Partition column values* are values of the columns that are column partitions and therefore part of the directory structure not the partitioned files themselves (that together are the partitioned dataset).

`PartitionedFile` is <<creating-instance, created>> exclusively when `FileSourceScanExec` is requested to create the input RDD for FileSourceScanExec.md#createBucketedReadRDD[bucketed] or FileSourceScanExec.md#createNonBucketedReadRDD[non-bucketed] reads.

[[creating-instance]]
`PartitionedFile` takes the following to be created:

* [[partitionValues]] Partition column values to be appended to each row (as an [internal row](InternalRow.md))
* [[filePath]] Path of the file to read
* [[start]] Beginning offset (in bytes)
* [[length]] Number of bytes to read (aka `length`)
* [[locations]] Locality information that is a list of nodes (by their host names) that have the data (`Array[String]`). Default: empty

[source, scala]
----
import org.apache.spark.sql.execution.datasources.PartitionedFile
import org.apache.spark.sql.catalyst.InternalRow

val partFile = PartitionedFile(InternalRow.empty, "fakePath0", 0, 10, Array("host0", "host1"))
----

[[toString]]
`PartitionedFile` uses the following *text representation* (`toString`):

```
path: [filePath], range: [start]-[end], partition values: [partitionValues]
```

[source, scala]
----
scala> :type partFile
org.apache.spark.sql.execution.datasources.PartitionedFile

scala> println(partFile)
path: fakePath0, range: 0-10, partition values: [empty row]
----
