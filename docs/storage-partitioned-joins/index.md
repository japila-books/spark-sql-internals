# Storage-Partitioned Joins

**Storage-Partitioned Join** (_SPJ_) is a new type of [join](../joins.md) in Spark SQL that uses the existing storage layout for a partitioned join to avoid expensive shuffles (similarly to [Bucketing](../bucketing/index.md)).

!!! note
    Storage-Partitioned Joins feature was added in Apache Spark 3.3.0 ([\[SPARK-37375\] Umbrella: Storage Partitioned Join (SPJ)]({{ spark.jira }}/SPARK-37375)).

Storage-Partitioned Join is based on [KeyGroupedPartitioning](../connector/KeyGroupedPartitioning.md) to determine partitions.

Out of the available built-in [DataSourceV2ScanExecBase](../physical-operators/DataSourceV2ScanExecBase.md) physical operators, only [BatchScanExec](../physical-operators/BatchScanExec.md) supports storage-partitioned joins.

Storage-Partitioned Join is meant for [Spark SQL connectors](../connector/index.md) (yet there are none built-in at the moment).

Storage-Partitioned Join was proposed in this [SPIP](https://docs.google.com/document/d/1foTkDSM91VxKgkEcBMsuAvEjNybjja-uHk-r3vtXWFE).

!!! note
    It [appears](../physical-optimizations/EnsureRequirements.md#checkKeyGroupCompatible) that [SortMergeJoinExec](../physical-operators/SortMergeJoinExec.md) and [ShuffledHashJoinExec](../physical-operators/ShuffledHashJoinExec.md) physical operator are the only candidates for Storage-Partitioned Joins.

## Configuration Properties

* [spark.sql.sources.v2.bucketing.enabled](../configuration-properties.md#spark.sql.sources.v2.bucketing.enabled)
* [spark.sql.sources.v2.bucketing.pushPartValues.enabled](../configuration-properties.md#spark.sql.sources.v2.bucketing.pushPartValues.enabled)
* [spark.sql.sources.v2.bucketing.partiallyClusteredDistribution.enabled](../configuration-properties.md#spark.sql.sources.v2.bucketing.partiallyClusteredDistribution.enabled)

## Apache Iceberg

Storage-Partitioned Join is supported in [Apache Iceberg 1.2.0](https://iceberg.apache.org/releases/#121-release):

> Added support for storage partition joins to improve read and write performance ([#6371](https://github.com/apache/iceberg/pull/6371))

## Delta Lake

Storage-Partitioned Join is not supported in Delta Lake yet (as per [this feature request](https://github.com/delta-io/delta/issues/1698)).

## Learn More

1. [What's new in Apache Spark 3.3 - joins](https://www.waitingforcode.com/apache-spark-sql/what-new-apache-spark-3.3-joins/read) by Bartosz Konieczny
1. (video) [Storage-Partitioned Join for Apache Spark](https://youtu.be/ioLeHZDMSuU)
1. (video) [Eliminating Shuffles in Delete Update, and Merge](https://youtu.be/AIZjy6_K0ws)
