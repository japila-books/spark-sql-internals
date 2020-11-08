# DataSourceV2ScanExec Leaf Physical Operator

!!! warning
    As of this [commit](https://github.com/apache/spark/commit/e97ab1d9807134bb557ae73920af61e8534b2b08) DataSourceV2ScanExec is no longer available in Spark 3.0.0 and the page will soon be removed (once [DataSourceV2ScanExecBase](DataSourceV2ScanExecBase.md) takes over).

`DataSourceV2ScanExec` is a [leaf physical operator](SparkPlan.md#LeafExecNode) that represents a [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md) logical operator at execution time.

`DataSourceV2ScanExec` supports [ColumnarBatchScan](ColumnarBatchScan.md) with [vectorized batch decoding](#supportsBatch) (when [created](#creating-instance) for a [DataSourceReader](#reader) that supports it, i.e. the `DataSourceReader` is a [SupportsScanColumnarBatch](../spark-sql-SupportsScanColumnarBatch.md) with the [enableBatchRead](../spark-sql-SupportsScanColumnarBatch.md#enableBatchRead) flag enabled).

`DataSourceV2ScanExec` is also a [DataSourceV2StringFormat](../spark-sql-DataSourceV2StringFormat.md), i.e....FIXME

[[inputRDDs]]
`DataSourceV2ScanExec` gives the single <<inputRDD, input RDD>> as the [only input RDD of internal rows](CodegenSupport.md#inputRDDs) (when `WholeStageCodegenExec` physical operator is WholeStageCodegenExec.md#doExecute[executed]).

## Creating Instance

`DataSourceV2ScanExec` takes the following to be created:

* [[output]] Output schema (as a collection of `AttributeReferences`)
* [[reader]] spark-sql-DataSourceReader.md[DataSourceReader]

`DataSourceV2ScanExec` is <<creating-instance, created>> exclusively when [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (i.e. applied to a logical plan) and finds a <<DataSourceV2Relation.md#, DataSourceV2Relation>> logical operator.

=== [[doExecute]] Executing Physical Operator (Generating RDD[InternalRow]) -- `doExecute` Method

[source, scala]
----
doExecute(): RDD[InternalRow]
----

`doExecute`...FIXME

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

=== [[inputRDD]] Creating Input RDD of Internal Rows -- `inputRDD` Internal Property

[source, scala]
----
inputRDD: RDD[InternalRow]
----

NOTE: `inputRDD` is a Scala lazy value which is computed once when accessed and cached afterwards.

`inputRDD` branches off per the type of the <<reader, DataSourceReader>>:

. For a `ContinuousReader` in Spark Structured Streaming, `inputRDD` is a `ContinuousDataSourceRDD` that...FIXME

. For a <<spark-sql-SupportsScanColumnarBatch.md#, SupportsScanColumnarBatch>> with the <<spark-sql-SupportsScanColumnarBatch.md#enableBatchRead, enableBatchRead>> flag enabled, `inputRDD` is a <<spark-sql-DataSourceRDD.md#, DataSourceRDD>> with the <<batchPartitions, batchPartitions>>

. For all other types of the <<reader, DataSourceReader>>, `inputRDD` is a <<spark-sql-DataSourceRDD.md#, DataSourceRDD>> with the <<partitions, partitions>>.

NOTE: `inputRDD` is used when `DataSourceV2ScanExec` physical operator is requested for the <<inputRDDs, input RDDs>> and to <<doExecute, execute>>.

=== [[internal-properties]] Internal Properties

[cols="30m,70",options="header",width="100%"]
|===
| Name
| Description

| batchPartitions
a| [[batchPartitions]] Input partitions of [ColumnarBatches](../ColumnarBatch.md) (`Seq[InputPartition[ColumnarBatch]]`)

| partitions
a| [[partitions]] Input partitions of [InternalRow](../InternalRow.md)s (`Seq[InputPartition[InternalRow]]`)

|===
