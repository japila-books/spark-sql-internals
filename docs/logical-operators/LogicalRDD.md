---
title: LogicalRDD
---

# LogicalRDD Leaf Logical Operator

`LogicalRDD` is a [leaf logical operator](LeafNode.md) with <<newInstance, MultiInstanceRelation>> support for a logical representation of a scan over <<rdd, RDD of internal binary rows>>.

`LogicalRDD` is <<creating-instance, created>> when:

* `Dataset` is requested to [checkpoint](../dataset/untyped-transformations.md#checkpoint)

* `SparkSession` is requested to [create a DataFrame from an RDD of internal binary rows](../SparkSession.md#internalCreateDataFrame)

!!! note
    `LogicalRDD` is resolved to `RDDScanExec` physical operator when [BasicOperators](../execution-planning-strategies/BasicOperators.md#LogicalRDD) execution planning strategy is executed.

=== [[newInstance]] `newInstance` Method

[source, scala]
----
newInstance(): LogicalRDD.this.type
----

`newInstance` is part of [MultiInstanceRelation](MultiInstanceRelation.md#newInstance) abstraction.

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
