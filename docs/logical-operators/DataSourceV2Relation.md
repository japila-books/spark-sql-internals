# DataSourceV2Relation Leaf Logical Operator

`DataSourceV2Relation` is a <<spark-sql-LogicalPlan-LeafNode.md#, leaf logical operator>> that represents a data scan (_data reading_) or data writing in the <<spark-sql-data-source-api-v2.md#, Data Source API V2>>.

`DataSourceV2Relation` is <<creating-instance, created>> (indirectly via <<create, create>> helper method) exclusively when `DataFrameReader` is requested to ["load" data (as a DataFrame)](../DataFrameReader.md#load) (from a data source with <<spark-sql-ReadSupport.md#, ReadSupport>>).

[[creating-instance]]
`DataSourceV2Relation` takes the following to be created:

* [[source]] <<spark-sql-DataSourceV2.md#, DataSourceV2>>
* [[output]] Output <<spark-sql-Expression-AttributeReference.md#, attributes>> (`Seq[AttributeReference]`)
* [[options]] Options (`Map[String, String]`)
* [[tableIdent]] Optional `TableIdentifier` (default: undefined, i.e. `None`)
* [[userSpecifiedSchema]] User-defined <<spark-sql-StructType.md#, schema>> (default: undefined, i.e. `None`)

When used to represent a data scan (_data reading_), `DataSourceV2Relation` is planned (_translated_) to a <<spark-sql-SparkPlan-ProjectExec.md#, ProjectExec>> with a <<spark-sql-SparkPlan-DataSourceV2ScanExec.md#, DataSourceV2ScanExec>> physical operator (possibly under the <<spark-sql-SparkPlan-FilterExec.md#, FilterExec>> operator) when [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is requested to [plan a logical plan](../execution-planning-strategies/DataSourceV2Strategy.md#apply-DataSourceV2Relation).

When used to represent a data write (with <<spark-sql-LogicalPlan-AppendData.md#, AppendData>> logical operator), `DataSourceV2Relation` is planned (_translated_) to a <<spark-sql-SparkPlan-WriteToDataSourceV2Exec.md#, WriteToDataSourceV2Exec>> physical operator (with the <<newWriter, DataSourceWriter>>) when [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is requested to [plan a logical plan](../execution-planning-strategies/DataSourceV2Strategy.md#apply-AppendData).

`DataSourceV2Relation` object defines a `SourceHelpers` implicit class that extends <<spark-sql-DataSourceV2.md#, DataSourceV2>> instances with the additional <<extension-methods, extension methods>>.

=== [[create]] Creating DataSourceV2Relation Instance -- `create` Factory Method

[source, scala]
----
create(
  source: DataSourceV2,
  options: Map[String, String],
  tableIdent: Option[TableIdentifier] = None,
  userSpecifiedSchema: Option[StructType] = None): DataSourceV2Relation
----

`create` requests the given <<spark-sql-DataSourceV2.md#, DataSourceV2>> to create a <<spark-sql-DataSourceReader.md#, DataSourceReader>> (with the given options and user-specified schema).

`create` finds the table in the given options unless the optional `tableIdent` is defined.

In the end, `create` <<creating-instance, creates a DataSourceV2Relation>>.

NOTE: `create` is used exclusively when `DataFrameReader` is requested to ["load" data (as a DataFrame)](../DataFrameReader.md#load) (from a data source with [ReadSupport](../spark-sql-ReadSupport.md)).

=== [[computeStats]] Computing Statistics -- `computeStats` Method

[source, scala]
----
computeStats(): Statistics
----

NOTE: `computeStats` is part of the <<spark-sql-LogicalPlan-LeafNode.md#computeStats, LeafNode Contract>> to compute a <<spark-sql-Statistics.md#, Statistics>>.

`computeStats`...FIXME

=== [[newReader]] Creating DataSourceReader -- `newReader` Method

[source, scala]
----
newReader(): DataSourceReader
----

`newReader` simply requests (_delegates to_) the <<source, DataSourceV2>> to <<createReader, create a DataSourceReader>>.

!!! note
    `DataSourceV2Relation` object defines the <<SourceHelpers, SourceHelpers>> implicit class to "extend" the marker <<spark-sql-DataSourceV2.md#, DataSourceV2>> type with the method to <<createReader, create a DataSourceReader>>.

`newReader` is used when:

* `DataSourceV2Relation` is requested to <<computeStats, computeStats>>

* `DataSourceV2Strategy` execution planning strategy is requested to [plan a DataSourceV2Relation logical operator](../execution-planning-strategies/DataSourceV2Strategy.md#apply-DataSourceV2Relation)

=== [[newWriter]] Creating DataSourceWriter -- `newWriter` Method

[source, scala]
----
newWriter(): DataSourceWriter
----

`newWriter` simply requests (_delegates to_) the <<source, DataSourceV2>> to <<createWriter, create a DataSourceWriter>>.

!!! note
    `DataSourceV2Relation` object defines the <<SourceHelpers, SourceHelpers>> implicit class to "extend" the marker <<spark-sql-DataSourceV2.md#, DataSourceV2>> type with the method to <<createWriter, create a DataSourceWriter>>.

`newWriter` is used when [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed.

=== [[SourceHelpers]] SourceHelpers Implicit Class

`DataSourceV2Relation` object defines a `SourceHelpers` implicit class that extends <<spark-sql-DataSourceV2.md#, DataSourceV2>> instances with the additional <<extension-methods, extension methods>>.

[[extension-methods]]
.SourceHelpers' Extension Methods
[cols="1m,3",options="header",width="100%"]
|===
| Method
| Description

| asReadSupport
a| [[asReadSupport]]

[source, scala]
----
asReadSupport: ReadSupport
----

Used exclusively for <<createReader, createReader>> implicit method

| asWriteSupport
a| [[asWriteSupport]]

[source, scala]
----
asWriteSupport: WriteSupport
----

Used when...FIXME

| name
a| [[name]]

[source, scala]
----
name: String
----

Used when...FIXME

| createReader
a| [[createReader]]

[source, scala]
----
createReader(
  options: Map[String, String],
  userSpecifiedSchema: Option[StructType]): DataSourceReader
----

Used when:

* `DataSourceV2Relation` logical operator is requested to <<newReader, create a DataSourceReader>>

* `DataSourceV2Relation` factory object is requested to <<create, create a DataSourceV2Relation>> (when `DataFrameReader` is requested to ["load" data (as a DataFrame)](../DataFrameReader.md#load) from a data source with [ReadSupport](../spark-sql-ReadSupport.md))

| createWriter
a| [[createWriter]]

[source, scala]
----
createWriter(
  options: Map[String, String],
  schema: StructType): DataSourceWriter
----

Creates a <<spark-sql-DataSourceWriter.md#, DataSourceWriter>>

Used when...FIXME

|===

TIP: Read up on https://docs.scala-lang.org/overviews/core/implicit-classes.html[implicit classes] in the https://docs.scala-lang.org/[official documentation of the Scala programming language].
