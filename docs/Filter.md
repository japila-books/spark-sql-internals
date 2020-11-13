# Data Source Filter Predicate

`Filter` is the <<contract, contract>> for <<implementations, filter predicates>> that can be pushed down to a relation (aka _data source_).

`Filter` is used when:

* (Data Source API V1) `BaseRelation` is requested for [unhandled filter predicates](BaseRelation.md#unhandledFilters) (and hence `BaseRelation` implementations, i.e. [JDBCRelation](datasources/jdbc/JDBCRelation.md#unhandledFilters))

* (Data Source API V1) `PrunedFilteredScan` is requested for [build a scan](PrunedFilteredScan.md#buildScan) (and hence `PrunedFilteredScan` implementations, i.e. [JDBCRelation](datasources/jdbc/JDBCRelation.md#buildScan))

* `FileFormat` is requested to [buildReader](FileFormat.md#buildReader) (and hence `FileFormat` implementations, i.e. [OrcFileFormat](OrcFileFormat.md#buildReader), [CSVFileFormat](spark-sql-CSVFileFormat.md#buildReader), [JsonFileFormat](spark-sql-JsonFileFormat.md#buildReader), [TextFileFormat](TextFileFormat.md#buildReader) and Spark MLlib's `LibSVMFileFormat`)

* `FileFormat` is requested to [build a Data Reader with partition column values appended](FileFormat.md#buildReaderWithPartitionValues) (and hence `FileFormat` implementations, i.e. [OrcFileFormat](OrcFileFormat.md#buildReaderWithPartitionValues), [ParquetFileFormat](datasources/parquet/ParquetFileFormat.md#buildReaderWithPartitionValues))

* `RowDataSourceScanExec` is RowDataSourceScanExec.md#creating-instance[created] (for a DataSourceScanExec.md#simpleString[simple text representation (in a query plan tree)])

* `DataSourceStrategy` execution planning strategy is requested to [pruneFilterProject](execution-planning-strategies/DataSourceStrategy.md#pruneFilterProject) (when [executed](execution-planning-strategies/DataSourceStrategy.md#apply) for LogicalRelation.md[LogicalRelation] logical operators with a [PrunedFilteredScan](PrunedFilteredScan.md) or a [PrunedScan](PrunedScan.md))

* `DataSourceStrategy` execution planning strategy is requested to [selectFilters](execution-planning-strategies/DataSourceStrategy.md#selectFilters)

* `JDBCRDD` is [created](datasources/jdbc/JDBCRDD.md#filters) and requested to [scanTable](datasources/jdbc/JDBCRDD.md#scanTable)

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
