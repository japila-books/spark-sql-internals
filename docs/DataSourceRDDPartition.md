# DataSourceRDDPartition

`DataSourceRDDPartition` is a `Partition` ([Apache Spark]({{ book.spark_core }}/rdd/Partition)) of [DataSourceRDD](DataSourceRDD.md).

## Creating Instance

`DataSourceRDDPartition` takes the following to be created:

* <span id="index"> Partition Index
* <span id="inputPartitions"> [InputPartition](connector/InputPartition.md)s

`DataSourceRDDPartition` is created when:

* `DataSourceRDD` is requested for the [partitions](DataSourceRDD.md#getPartitions)
