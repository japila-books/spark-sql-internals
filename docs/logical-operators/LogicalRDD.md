title: LogicalRDD

# LogicalRDD -- Logical Scan Over RDD

`LogicalRDD` is a spark-sql-LogicalPlan-LeafNode.md[leaf logical operator] with <<newInstance, MultiInstanceRelation>> support for a logical representation of a scan over <<rdd, RDD of internal binary rows>>.

`LogicalRDD` is <<creating-instance, created>> when:

* `Dataset` is requested to <<spark-sql-Dataset-untyped-transformations.md#checkpoint, checkpoint>>

* `SparkSession` is requested to SparkSession.md#internalCreateDataFrame[create a DataFrame from an RDD of internal binary rows]

!!! note
    `LogicalRDD` is resolved to [RDDScanExec](../physical-operators/RDDScanExec.md) when [BasicOperators](../execution-planning-strategies/BasicOperators.md#LogicalRDD) execution planning strategy is executed.

=== [[newInstance]] `newInstance` Method

[source, scala]
----
newInstance(): LogicalRDD.this.type
----

NOTE: `newInstance` is part of spark-sql-MultiInstanceRelation.md#newInstance[MultiInstanceRelation Contract] to...FIXME.

`newInstance`...FIXME

=== [[computeStats]] Computing Statistics -- `computeStats` Method

[source, scala]
----
computeStats(): Statistics
----

NOTE: `computeStats` is part of spark-sql-LogicalPlan-LeafNode.md#computeStats[LeafNode Contract] to compute statistics for spark-sql-cost-based-optimization.md[cost-based optimizer].

`computeStats`...FIXME

=== [[creating-instance]] Creating LogicalRDD Instance

`LogicalRDD` takes the following when created:

* [[output]] Output schema spark-sql-Expression-Attribute.md[attributes]
* [[rdd]] `RDD` of spark-sql-InternalRow.md[internal binary rows]
* [[outputPartitioning]] Output [Partitioning](../Partitioning.md)
* [[outputOrdering]] Output ordering (`SortOrder`)
* [[isStreaming]] `isStreaming` flag
* [[session]] SparkSession.md[SparkSession]
