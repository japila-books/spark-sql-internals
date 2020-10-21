# LogicalRDD

`LogicalRDD` is a [leaf logical operator](LeafNode.md) with <<newInstance, MultiInstanceRelation>> support for a logical representation of a scan over <<rdd, RDD of internal binary rows>>.

`LogicalRDD` is <<creating-instance, created>> when:

* `Dataset` is requested to [checkpoint](../Dataset-untyped-transformations.md#checkpoint)

* `SparkSession` is requested to [create a DataFrame from an RDD of internal binary rows](../SparkSession.md#internalCreateDataFrame)

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

`computeStats`...FIXME

`computeStats` is part of the [LeafNode](LeafNode.md#computeStats) abstraction.

## Creating Instance

`LogicalRDD` takes the following to be created:

* [[output]] Output schema [attributes](../expressions/Attribute.md)
* [[rdd]] `RDD` of [InternalRow](../InternalRow.md)s
* [[outputPartitioning]] Output [Partitioning](../physical-operators/Partitioning.md)
* [[outputOrdering]] Output ordering (`SortOrder`)
* [[isStreaming]] `isStreaming` flag
* [[session]] [SparkSession](../SparkSession.md)
