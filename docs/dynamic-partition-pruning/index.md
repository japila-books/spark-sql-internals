# Dynamic Partition Pruning

**Dynamic Partition Pruning** (**DPP**) is an optimization of JOIN batch queries of partitioned tables using partition columns in a join condition.
The idea is to push filter conditions down to the large fact table and reduce the number of rows to scan.

The best results are expected in JOIN queries between a large fact table and a much smaller dimension table (_star-schema queries_).

Dynamic Partition Pruning is applied to a query at logical optimization phase using [PartitionPruning](../logical-optimizations/PartitionPruning.md) and [CleanupDynamicPruningFilters](../logical-optimizations/CleanupDynamicPruningFilters.md) optimization rules.

Dynamic Partition Pruning optimization is controlled by [spark.sql.optimizer.dynamicPartitionPruning.enabled](../configuration-properties.md#spark.sql.optimizer.dynamicPartitionPruning.enabled) configuration property.

!!! note "Streaming Queries"
    Dynamic Partition Pruning is [not applied to streaming queries](../logical-optimizations/PartitionPruning.md#hasPartitionPruningFilter).

## References

### Articles

* [Dynamic Partition Pruning in Spark 3.0](https://dzone.com/articles/dynamic-partition-pruning-in-spark-30)

### Videos

* [Dynamic Partition Pruning in Apache Spark](https://databricks.com/session_eu19/dynamic-partition-pruning-in-apache-spark)
* [Apache Spark 3 | New Feature | Performance Optimization | Dynamic Partition Pruning](https://youtu.be/OyO13d3Nm14)
* [Dynamic Partition Pruning | Spark Performance Tuning](https://youtu.be/rwUgZP-EBZw) by Harjeet (aka Data Savvy)
