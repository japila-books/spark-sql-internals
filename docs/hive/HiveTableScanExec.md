== [[HiveTableScanExec]] HiveTableScanExec Leaf Physical Operator

:hive-version: 2.3.6
:hadoop-version: 2.10.0
:url-hive-javadoc: https://hive.apache.org/javadocs/r{hive-version}/api
:url-hadoop-javadoc: https://hadoop.apache.org/docs/r{hadoop-version}/api

`HiveTableScanExec` is a ../SparkPlan.md#LeafExecNode[leaf physical operator] that represents a HiveTableRelation.md[HiveTableRelation] logical operator at execution time.

`HiveTableScanExec` is <<creating-instance, created>> exclusively when HiveTableScans.md[HiveTableScans] execution planning strategy plans a `HiveTableRelation` logical operator (i.e. is executed on a logical query plan with a `HiveTableRelation` logical operator).

[[nodeName]]
`HiveTableScanExec` uses the HiveTableRelation.md#tableMeta[fully-qualified name of the Hive table] (of the <<relation, HiveTableRelation>>) for the [node name](../catalyst/TreeNode.md#nodeName):

```text
Scan hive [table]
```

=== [[creating-instance]] Creating HiveTableScanExec Instance

`HiveTableScanExec` takes the following when created:

* [[requestedAttributes]] Requested ../spark-sql-Expression-Attribute.md[attributes]
* [[relation]] HiveTableRelation.md[HiveTableRelation]
* [[partitionPruningPred]] <<partition-pruning-predicates, Partition pruning predicates>>
* [[sparkSession]] ../SparkSession.md[SparkSession]

`HiveTableScanExec` initializes the <<internal-registries, internal registries and counters>>.

=== [[partition-pruning-predicates]] Partition Pruning Predicates

`HiveTableScanExec` physical operator supports *partition pruning* for <<relation, Hive tables>> that are HiveTableRelation.md#isPartitioned[partitioned].

`HiveTableScanExec` requires that either the <<partitionPruningPred, partitionPruningPred>> has no expressions or the <<relation, HiveTableRelation>> is partitioned. Otherwise, `HiveTableScanExec` throws an `IllegalArgumentException`.

HiveTableScans.md[HiveTableScans] execution planning strategy creates a `HiveTableScanExec` physical operator for every HiveTableRelation.md[HiveTableRelation] operator in a query plan. When created, `HiveTableScanExec` is given the <<partitionPruningPred, partition pruning predicates>> that are predicate expressions with no references and among the HiveTableRelation.md#partitionCols[partition columns] of the `HiveTableRelation`.

=== [[metrics]] Performance Metrics -- `metrics` Method

.HiveTableScanExec's Performance Metrics
[cols="1m,2,2",options="header",width="100%"]
|===
| Key
| Name (in web UI)
| Description

| numOutputRows
| number of output rows
| [[numOutputRows]]
|===

=== [[doExecute]] Executing Physical Operator (Generating RDD[InternalRow]) -- `doExecute` Method

[source, scala]
----
doExecute(): RDD[InternalRow]
----

NOTE: `doExecute` is part of ../SparkPlan.md#doExecute[SparkPlan] contract to generate the runtime representation of a structured query as a distributed computation over ../spark-sql-InternalRow.md[internal binary rows] on Apache Spark (i.e. `RDD[InternalRow]`).

`doExecute`...FIXME

=== [[internal-properties]] Internal Properties

[cols="30m,70",options="header",width="100%"]
|===
| Name
| Description

| boundPruningPred
a| [[boundPruningPred]] Catalyst ../expressions/Expression.md[expression] for the <<partitionPruningPred, partitionPruningPred>> bound to (the HiveTableRelation.md#partitionCols[partitionCols] of) the <<relation, HiveTableRelation>>

| hiveQlTable
a| [[hiveQlTable]] Hive {url-hive-javadoc}/org/apache/hadoop/hive/ql/metadata/Table.html[Table] metadata (HiveClientImpl.md#toHiveTable[converted] from the HiveTableRelation.md#tableMeta[CatalogTable] of the <<relation, HiveTableRelation>>)

Used when `HiveTableScanExec` is requested for the <<tableDesc, tableDesc>>, <<rawPartitions, rawPartitions>> and is <<doExecute, executed>>

| hadoopReader
a| [[hadoopReader]] HadoopTableReader.md[HadoopTableReader]

| rawPartitions
a| [[rawPartitions]] HiveClientImpl.md#toHivePartition[Hive partitions] (`Seq[Partition]`)

Used when `HiveTableScanExec` physical operator is <<doExecute, executed>> with a partitioned table

| tableDesc
a| [[tableDesc]] Hive {url-hive-javadoc}/org/apache/hive/hcatalog/templeton/TableDesc.html[TableDesc]

|===
