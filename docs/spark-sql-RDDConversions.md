# RDDConversions Helper Object

`RDDConversions` is a Scala object that is used to <<productToRowRdd, productToRowRdd>> and <<rowToRowRdd, rowToRowRdd>> methods.

=== [[productToRowRdd]] `productToRowRdd` Method

[source, scala]
----
productToRowRdd[A <: Product](data: RDD[A], outputTypes: Seq[DataType]): RDD[InternalRow]
----

`productToRowRdd`...FIXME

NOTE: `productToRowRdd` is used when...FIXME

=== [[rowToRowRdd]] Converting Scala Objects In Rows to Values Of Catalyst Types -- `rowToRowRdd` Method

[source, scala]
----
rowToRowRdd(data: RDD[Row], outputTypes: Seq[DataType]): RDD[InternalRow]
----

`rowToRowRdd` maps over partitions of the input `RDD[Row]` (using `RDD.mapPartitions` operator) that creates a `MapPartitionsRDD` with a "map" function.

TIP: Use `RDD.toDebugString` to see the additional `MapPartitionsRDD` in an RDD lineage.

The "map" function takes a Scala `Iterator` of spark-sql-Row.md[Row] objects and does the following:

1. Creates a `GenericInternalRow` (of the size that is the number of columns per the input `Seq[DataType]`)

1. [Creates a converter function](CatalystTypeConverters.md#createToCatalystConverter) for every `DataType` in `Seq[DataType]`

1. For every [Row](spark-sql-Row.md) object in the partition (iterator), applies the converter function per position and adds the result value to the `GenericInternalRow`

1. In the end, returns a `GenericInternalRow` for every row

`rowToRowRdd` is used when [DataSourceStrategy](execution-planning-strategies/DataSourceStrategy.md) execution planning strategy is executed (and requested to [toCatalystRDD](execution-planning-strategies/DataSourceStrategy.md#toCatalystRDD)).
