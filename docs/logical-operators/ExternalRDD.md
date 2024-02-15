---
title: ExternalRDD
---

# ExternalRDD Leaf Logical Operator

`ExternalRDD` is a LeafNode.md[leaf logical operator] that is a logical representation of (the data from) an RDD in a logical query plan.

`ExternalRDD` is <<creating-instance, created>> when:

* `SparkSession` is requested to create a SparkSession.md#createDataFrame[DataFrame from RDD of product types] (e.g. Scala case classes, tuples) or SparkSession.md#createDataset[Dataset from RDD of a given type]

* `ExternalRDD` is requested to <<newInstance, create a new instance>>

[source, scala]
----
val pairsRDD = sc.parallelize((0, "zero") :: (1, "one") :: (2, "two") :: Nil)

// A tuple of Int and String is a product type
scala> :type pairsRDD
org.apache.spark.rdd.RDD[(Int, String)]

val pairsDF = spark.createDataFrame(pairsRDD)

// ExternalRDD represents the pairsRDD in the query plan
val logicalPlan = pairsDF.queryExecution.logical
scala> println(logicalPlan.numberedTreeString)
00 SerializeFromObject [assertnotnull(assertnotnull(input[0, scala.Tuple2, true]))._1 AS _1#10, staticinvoke(class org.apache.spark.unsafe.types.UTF8String, StringType, fromString, assertnotnull(assertnotnull(input[0, scala.Tuple2, true]))._2, true, false) AS _2#11]
01 +- ExternalRDD [obj#9]
----

`ExternalRDD` is a <<newInstance, MultiInstanceRelation>> and a `ObjectProducer`.

`ExternalRDD` is resolved to ExternalRDDScanExec.md[ExternalRDDScanExec] when [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed.

=== [[newInstance]] `newInstance` Method

[source, scala]
----
newInstance(): LogicalRDD.this.type
----

`newInstance` is part of [MultiInstanceRelation](MultiInstanceRelation.md#newInstance) abstraction.

`newInstance`...FIXME

=== [[creating-instance]] Creating ExternalRDD Instance

`ExternalRDD` takes the following when created:

* [[outputObjAttr]] Output schema spark-sql-Expression-Attribute.md[attribute]
* [[rdd]] `RDD` of `T`
* [[session]] SparkSession.md[SparkSession]

=== [[apply]] Creating ExternalRDD -- `apply` Factory Method

[source, scala]
----
apply[T: Encoder](rdd: RDD[T], session: SparkSession): LogicalPlan
----

`apply`...FIXME

NOTE: `apply` is used when `SparkSession` is requested to create a SparkSession.md#createDataFrame[DataFrame from RDD of product types] (e.g. Scala case classes, tuples) or SparkSession.md#createDataset[Dataset from RDD of a given type].
