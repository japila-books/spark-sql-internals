# DataSourceRDDPartition

`DataSourceRDDPartition` is a Spark Core `Partition` of spark-sql-DataSourceRDD.md[DataSourceRDD] and Spark Structured Streaming's `ContinuousDataSourceRDD` RDDs.

`DataSourceRDDPartition` is <<creating-instance, created>> when:

* spark-sql-DataSourceRDD.md#getPartitions[DataSourceRDD] and Spark Structured Streaming's `ContinuousDataSourceRDD` are requested for partitions

* spark-sql-DataSourceRDD.md#compute[DataSourceRDD] and Spark Structured Streaming's `ContinuousDataSourceRDD` are requested to compute a partition

* spark-sql-DataSourceRDD.md#getPreferredLocations[DataSourceRDD] and Spark Structured Streaming's `ContinuousDataSourceRDD` are requested for preferred locations

[[creating-instance]]
`DataSourceRDDPartition` takes the following when created:

* [[index]] Partition index
* [[inputPartition]] [InputPartition](connector/InputPartition.md)
