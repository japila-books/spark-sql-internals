# DataSourceV2Relation Leaf Logical Operator

`DataSourceV2Relation` is a <<LeafNode.md#, leaf logical operator>> that represents a data scan (_data reading_) or data writing in the [DataSource V2](../new-and-noteworthy/datasource-v2.md).

`DataSourceV2Relation` is <<creating-instance, created>> (indirectly via <<create, create>> helper method) exclusively when `DataFrameReader` is requested to ["load" data (as a DataFrame)](../DataFrameReader.md#load).

[[creating-instance]]
`DataSourceV2Relation` takes the following to be created:

* [[source]] FIXME
* [[output]] Output <<spark-sql-Expression-AttributeReference.md#, attributes>> (`Seq[AttributeReference]`)
* [[options]] Options (`Map[String, String]`)
* [[tableIdent]] Optional `TableIdentifier` (default: undefined, i.e. `None`)
* [[userSpecifiedSchema]] User-defined [schema](../StructType.md) (default: undefined, i.e. `None`)

When used to represent a data scan (_data reading_), `DataSourceV2Relation` is planned (_translated_) to a <<ProjectExec.md#, ProjectExec>> with a <<DataSourceV2ScanExec.md#, DataSourceV2ScanExec>> physical operator (possibly under the <<FilterExec.md#, FilterExec>> operator) when [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is requested to [plan a logical plan](../execution-planning-strategies/DataSourceV2Strategy.md#apply-DataSourceV2Relation).

When used to represent a data write (with <<AppendData.md#, AppendData>> logical operator), `DataSourceV2Relation` is planned (_translated_) to a <<WriteToDataSourceV2Exec.md#, WriteToDataSourceV2Exec>> physical operator (with the <<newWriter, DataSourceWriter>>) when [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is requested to [plan a logical plan](../execution-planning-strategies/DataSourceV2Strategy.md#apply-AppendData).

=== [[create]] Creating DataSourceV2Relation Instance -- `create` Factory Method

[source, scala]
----
create(
  source: DataSourceV2,
  options: Map[String, String],
  tableIdent: Option[TableIdentifier] = None,
  userSpecifiedSchema: Option[StructType] = None): DataSourceV2Relation
----

`create` requests the given FIXME to create a FIXME (with the given options and user-specified schema).

`create` finds the table in the given options unless the optional `tableIdent` is defined.

In the end, `create` <<creating-instance, creates a DataSourceV2Relation>>.

NOTE: `create` is used exclusively when `DataFrameReader` is requested to ["load" data (as a DataFrame)](../DataFrameReader.md#load).

=== [[computeStats]] Computing Statistics -- `computeStats` Method

[source, scala]
----
computeStats(): Statistics
----

NOTE: `computeStats` is part of the <<LeafNode.md#computeStats, LeafNode Contract>> to compute a [Statistics](Statistics.md).

`computeStats`...FIXME

=== [[newWriter]] Creating DataSourceWriter -- `newWriter` Method

[source, scala]
----
newWriter(): DataSourceWriter
----

`newWriter` simply requests (_delegates to_) the <<source, DataSourceV2>> to <<createWriter, create a DataSourceWriter>>.

`newWriter` is used when [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed.
