title: Filter

# Data Source Filter Predicate (For Filter Pushdown)

`Filter` is the <<contract, contract>> for <<implementations, filter predicates>> that can be pushed down to a relation (aka _data source_).

`Filter` is used when:

* (Data Source API V1) `BaseRelation` is requested for spark-sql-BaseRelation.md#unhandledFilters[unhandled filter predicates] (and hence `BaseRelation` implementations, i.e. spark-sql-JDBCRelation.md#unhandledFilters[JDBCRelation])

* (Data Source API V1) `PrunedFilteredScan` is requested for spark-sql-PrunedFilteredScan.md#buildScan[build a scan] (and hence `PrunedFilteredScan` implementations, i.e. spark-sql-JDBCRelation.md#buildScan[JDBCRelation])

* `FileFormat` is requested to spark-sql-FileFormat.md#buildReader[buildReader] (and hence `FileFormat` implementations, i.e. spark-sql-OrcFileFormat.md#buildReader[OrcFileFormat], spark-sql-CSVFileFormat.md#buildReader[CSVFileFormat], spark-sql-JsonFileFormat.md#buildReader[JsonFileFormat], spark-sql-TextFileFormat.md#buildReader[TextFileFormat] and Spark MLlib's `LibSVMFileFormat`)

* `FileFormat` is requested to spark-sql-FileFormat.md#buildReaderWithPartitionValues[build a Data Reader with partition column values appended] (and hence `FileFormat` implementations, i.e. spark-sql-OrcFileFormat.md#buildReaderWithPartitionValues[OrcFileFormat], spark-sql-ParquetFileFormat.md#buildReaderWithPartitionValues[ParquetFileFormat])

* `RowDataSourceScanExec` is spark-sql-SparkPlan-RowDataSourceScanExec.md#creating-instance[created] (for a spark-sql-SparkPlan-DataSourceScanExec.md#simpleString[simple text representation (in a query plan tree)])

* `DataSourceStrategy` execution planning strategy is requested to [pruneFilterProject](execution-planning-strategies/DataSourceStrategy.md#pruneFilterProject) (when [executed](execution-planning-strategies/DataSourceStrategy.md#apply) for spark-sql-LogicalPlan-LogicalRelation.md[LogicalRelation] logical operators with a spark-sql-PrunedFilteredScan.md[PrunedFilteredScan] or a spark-sql-PrunedScan.md[PrunedScan])

* `DataSourceStrategy` execution planning strategy is requested to [selectFilters](execution-planning-strategies/DataSourceStrategy.md#selectFilters)

* `JDBCRDD` is spark-sql-JDBCRDD.md#filters[created] and requested to spark-sql-JDBCRDD.md#scanTable[scanTable]

* (DataSource V2) `SupportsPushDownFilters` is requested to spark-sql-SupportsPushDownFilters.md#pushFilters[pushFilters] and for spark-sql-SupportsPushDownFilters.md#pushedFilters[pushedFilters]

[[contract]]
[source, scala]
----
package org.apache.spark.sql.sources

abstract class Filter {
  // only required methods that have no implementation
  // the others follow
  def references: Array[String]
}
----

.Filter Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| `references`
a| [[references]] *Column references*, i.e. list of column names that are referenced by a filter

Used when:

* `Filter` is requested to <<findReferences, find the column references in a value>>

* <<And, And>>, <<Or, Or>> and <<Not, Not>> filters are requested for the <<references, column references>>
|===

[[implementations]]
.Filters
[cols="1,2",options="header",width="100%"]
|===
| Filter
| Description

| `And`
| [[And]]

| `EqualNullSafe`
| [[EqualNullSafe]]

| `EqualTo`
| [[EqualTo]]

| `GreaterThan`
| [[GreaterThan]]

| `GreaterThanOrEqual`
| [[GreaterThanOrEqual]]

| `In`
| [[In]]

| `IsNotNull`
| [[IsNotNull]]

| `IsNull`
| [[IsNull]]

| `LessThan`
| [[LessThan]]

| `LessThanOrEqual`
| [[LessThanOrEqual]]

| `Not`
| [[Not]]

| `Or`
| [[Or]]

| `StringContains`
| [[StringContains]]

| `StringEndsWith`
| [[StringEndsWith]]

| `StringStartsWith`
| [[StringStartsWith]]
|===

=== [[findReferences]] Finding Column References in Any Value -- `findReferences` Method

[source, scala]
----
findReferences(value: Any): Array[String]
----

`findReferences` takes the <<references, references>> from the `value` filter is it is one or returns an empty array.

NOTE: `findReferences` is used when <<EqualTo, EqualTo>>, <<EqualNullSafe, EqualNullSafe>>, <<GreaterThan, GreaterThan>>, <<GreaterThanOrEqual, GreaterThanOrEqual>>, <<LessThan, LessThan>>, <<LessThanOrEqual, LessThanOrEqual>> and <<In, In>> filters are requested for their <<references, column references>>.

## v2references

```
v2references: Array[Array[String]]
```

v2references...FIXME

v2references is used when...FIXME
