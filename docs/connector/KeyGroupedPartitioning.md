# KeyGroupedPartitioning

`KeyGroupedPartitioning` is a [Partitioning](Partitioning.md) where rows are split across partitions based on the [partition transform expressions](#keys).

`KeyGroupedPartitioning` is a key part of [Storage-Partitioned Joins](../storage-partitioned-joins/index.md).

!!! note
    Not used in any of the [built-in Spark SQL connectors](../connectors/index.md) yet.

## Creating Instance

`KeyGroupedPartitioning` takes the following to be created:

* <span id="keys"> Partition transform [expression](../expressions/Expression.md)s
* <span id="numPartitions"> Number of partitions
