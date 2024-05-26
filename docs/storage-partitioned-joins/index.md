# Storage-Partitioned Joins

**Storage-Partitioned Joins** (_SPJ_) are a new type of [join](../joins.md) in Spark SQL that use the existing storage layout for a partitioned join to avoid expensive shuffles (similarly to [Bucketing](../bucketing/index.md)).

!!! note
    Storage-Partitioned Joins feature was added in Apache Spark 3.3.0 ([\[SPARK-37375\] Umbrella: Storage Partitioned Join (SPJ)]({{ spark.jira }}/SPARK-37375)).

Storage-Partitioned Join is meant mainly, if not exclusively, for [Spark SQL connectors](../connector/index.md) (_v2 data sources_).

Storage-Partitioned Join was proposed in this [SPIP](https://docs.google.com/document/d/1foTkDSM91VxKgkEcBMsuAvEjNybjja-uHk-r3vtXWFE).

Storage-Partitioned Join uses [KeyGroupedPartitioning](../connector/KeyGroupedPartitioning.md) to determine partitions.
