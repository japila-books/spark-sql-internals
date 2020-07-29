# DataSourceStrategy Execution Planning Strategy

`DataSourceStrategy` is an spark-sql-SparkStrategy.md[execution planning strategy] (of spark-sql-SparkPlanner.md[SparkPlanner]) that <<apply, plans LogicalRelation logical operators as RowDataSourceScanExec physical operators>> (possibly under `FilterExec` and `ProjectExec` operators).

[[apply]]
[[selection-requirements]]
.DataSourceStrategy's Selection Requirements (in execution order)
[cols="1,2",options="header",width="100%"]
|===
| Logical Operator
| Description

| spark-sql-LogicalPlan-LogicalRelation.md[LogicalRelation] with a spark-sql-CatalystScan.md[CatalystScan] relation
| [[CatalystScan]] Uses <<pruneFilterProjectRaw, pruneFilterProjectRaw>> (with the <<toCatalystRDD, RDD conversion to RDD[InternalRow]>> as part of `scanBuilder`).

`CatalystScan` does not seem to be used in Spark SQL.

| spark-sql-LogicalPlan-LogicalRelation.md[LogicalRelation] with spark-sql-PrunedFilteredScan.md[PrunedFilteredScan] relation
| [[PrunedFilteredScan]] Uses <<pruneFilterProject, pruneFilterProject>> (with the <<toCatalystRDD, RDD conversion to RDD[InternalRow]>> as part of `scanBuilder`).

Matches spark-sql-JDBCRelation.md[JDBCRelation] exclusively

| spark-sql-LogicalPlan-LogicalRelation.md[LogicalRelation] with a spark-sql-PrunedScan.md[PrunedScan] relation
| [[PrunedScan]] Uses <<pruneFilterProject, pruneFilterProject>> (with the <<toCatalystRDD, RDD conversion to RDD[InternalRow]>> as part of `scanBuilder`).

`PrunedScan` does not seem to be used in Spark SQL.

| spark-sql-LogicalPlan-LogicalRelation.md[LogicalRelation] with a spark-sql-TableScan.md[TableScan] relation
a| [[TableScan]] Creates a spark-sql-SparkPlan-RowDataSourceScanExec.md#creating-instance[RowDataSourceScanExec] directly (requesting the `TableScan` to spark-sql-TableScan.md#buildScan[buildScan] followed by <<toCatalystRDD, RDD conversion to RDD[InternalRow]>>)

Matches <<spark-sql-KafkaRelation.md#, KafkaRelation>> exclusively
|===

[source, scala]
----
import org.apache.spark.sql.execution.datasources.DataSourceStrategy
val strategy = DataSourceStrategy(spark.sessionState.conf)

import org.apache.spark.sql.catalyst.plans.logical.LogicalPlan
val plan: LogicalPlan = ???

val sparkPlan = strategy(plan).head
----

NOTE: `DataSourceStrategy` uses spark-sql-PhysicalOperation.md[PhysicalOperation] Scala extractor object to destructure a logical query plan.

=== [[pruneFilterProject]] `pruneFilterProject` Internal Method

[source, scala]
----
pruneFilterProject(
  relation: LogicalRelation,
  projects: Seq[NamedExpression],
  filterPredicates: Seq[Expression],
  scanBuilder: (Seq[Attribute], Array[Filter]) => RDD[InternalRow])
----

`pruneFilterProject` simply calls <<pruneFilterProjectRaw, pruneFilterProjectRaw>> with `scanBuilder` ignoring the `Seq[Expression]` input parameter.

NOTE: `pruneFilterProject` is used when `DataSourceStrategy` execution planning strategy is <<apply, executed>> (for spark-sql-LogicalPlan-LogicalRelation.md[LogicalRelation] logical operators with a spark-sql-PrunedFilteredScan.md[PrunedFilteredScan] or a spark-sql-PrunedScan.md[PrunedScan]).

=== [[selectFilters]] Selecting Catalyst Expressions Convertible to Data Source Filter Predicates (and Handled by BaseRelation) -- `selectFilters` Method

[source, scala]
----
selectFilters(
  relation: BaseRelation,
  predicates: Seq[Expression]): (Seq[Expression], Seq[Filter], Set[Filter])
----

`selectFilters` builds a map of expressions/Expression.md[Catalyst predicate expressions] (from the input `predicates`) that can be <<translateFilter, translated>> to a spark-sql-Filter.md[data source filter predicate].

`selectFilters` then requests the input `BaseRelation` for spark-sql-BaseRelation.md#unhandledFilters[unhandled filters] (out of the convertible ones that `selectFilters` built the map with).

In the end, `selectFilters` returns a 3-element tuple with the following:

. Inconvertible and unhandled Catalyst predicate expressions

. All converted data source filters

. Pushed-down data source filters (that the input `BaseRelation` can handle)

NOTE: `selectFilters` is used exclusively when `DataSourceStrategy` execution planning strategy is requested to <<pruneFilterProjectRaw, create a RowDataSourceScanExec physical operator (possibly under FilterExec and ProjectExec operators)>> (which is when `DataSourceStrategy` is <<apply, executed>> and <<pruneFilterProject, pruneFilterProject>>).

=== [[translateFilter]] Translating Catalyst Expression Into Data Source Filter Predicate -- `translateFilter` Method

[source, scala]
----
translateFilter(predicate: Expression): Option[Filter]
----

`translateFilter` translates a expressions/Expression.md[Catalyst expression] into a corresponding spark-sql-Filter.md[Filter predicate] if possible. If not, `translateFilter` returns `None`.

[[translateFilter-conversions]]
.translateFilter's Conversions
[cols="1,1",options="header",width="100%"]
|===
| Catalyst Expression
| Filter Predicate

| `EqualTo`
| `EqualTo`

| `EqualNullSafe`
| `EqualNullSafe`

| `GreaterThan`
| `GreaterThan`

| `LessThan`
| `LessThan`

| `GreaterThanOrEqual`
| `GreaterThanOrEqual`

| `LessThanOrEqual`
| `LessThanOrEqual`

| spark-sql-Expression-InSet.md[InSet]
| `In`

| spark-sql-Expression-In.md[In]
| `In`

| `IsNull`
| `IsNull`

| `IsNotNull`
| `IsNotNull`

| `And`
| `And`

| `Or`
| `Or`

| `Not`
| `Not`

| `StartsWith`
| `StringStartsWith`

| `EndsWith`
| `StringEndsWith`

| `Contains`
| `StringContains`
|===

NOTE: The Catalyst expressions and their corresponding data source filter predicates have the same names _in most cases_ but belong to different Scala packages, i.e. `org.apache.spark.sql.catalyst.expressions` and `org.apache.spark.sql.sources`, respectively.

[NOTE]
====
`translateFilter` is used when:

* `FileSourceScanExec` is spark-sql-SparkPlan-FileSourceScanExec.md#creating-instance[created] (and initializes spark-sql-SparkPlan-FileSourceScanExec.md#pushedDownFilters[pushedDownFilters])

* `DataSourceStrategy` is requested to <<selectFilters, selectFilters>>

* `PushDownOperatorsToDataSource` logical optimization is spark-sql-SparkOptimizer-PushDownOperatorsToDataSource.md#apply[executed] (for spark-sql-LogicalPlan-DataSourceV2Relation.md[DataSourceV2Relation] leaf operators with a spark-sql-SupportsPushDownFilters.md[SupportsPushDownFilters] data source reader)
====

=== [[toCatalystRDD]] RDD Conversion (Converting RDD of Rows to Catalyst RDD of InternalRows) -- `toCatalystRDD` Internal Method

[source, scala]
----
toCatalystRDD(
  relation: LogicalRelation,
  output: Seq[Attribute],
  rdd: RDD[Row]): RDD[InternalRow]
toCatalystRDD(relation: LogicalRelation, rdd: RDD[Row]) // <1>
----
<1> Calls the former `toCatalystRDD` with the spark-sql-LogicalPlan-LogicalRelation.md#output[output] of the `LogicalRelation`

`toCatalystRDD` branches off per the spark-sql-BaseRelation.md#needConversion[needConversion] flag of the spark-sql-LogicalPlan-LogicalRelation.md#relation[BaseRelation] of the input spark-sql-LogicalPlan-LogicalRelation.md[LogicalRelation].

When enabled (`true`), `toCatalystRDD` spark-sql-RDDConversions.md#rowToRowRdd[converts the objects inside Rows to Catalyst types].

NOTE: spark-sql-BaseRelation.md#needConversion[needConversion] flag is enabled (`true`) by default.

Otherwise, `toCatalystRDD` simply casts the input `RDD[Row]` to a `RDD[InternalRow]` (as a simple untyped Scala type conversion using Java's `asInstanceOf` operator).

NOTE: `toCatalystRDD` is used when `DataSourceStrategy` execution planning strategy is <<apply, executed>> (for all kinds of <<selection-requirements, BaseRelations>>).

=== [[pruneFilterProjectRaw]] Creating RowDataSourceScanExec Physical Operator for LogicalRelation (Possibly Under FilterExec and ProjectExec Operators) -- `pruneFilterProjectRaw` Internal Method

[source, scala]
----
pruneFilterProjectRaw(
  relation: LogicalRelation,
  projects: Seq[NamedExpression],
  filterPredicates: Seq[Expression],
  scanBuilder: (Seq[Attribute], Seq[Expression], Seq[Filter]) => RDD[InternalRow]): SparkPlan
----

`pruneFilterProjectRaw` creates a <<spark-sql-SparkPlan-RowDataSourceScanExec.md#creating-instance, RowDataSourceScanExec>> leaf physical operator given a <<spark-sql-LogicalPlan-LogicalRelation.md#, LogicalRelation>> leaf logical operator (possibly as a child of a <<spark-sql-SparkPlan-FilterExec.md#, FilterExec>> and a <<spark-sql-SparkPlan-ProjectExec.md#, ProjectExec>> unary physical operators).

In other words, `pruneFilterProjectRaw` simply converts a <<spark-sql-LogicalPlan-LogicalRelation.md#, LogicalRelation>> leaf logical operator into a <<spark-sql-SparkPlan-RowDataSourceScanExec.md#, RowDataSourceScanExec>> leaf physical operator (possibly under a <<spark-sql-SparkPlan-FilterExec.md#, FilterExec>> and a <<spark-sql-SparkPlan-ProjectExec.md#, ProjectExec>> unary physical operators).

NOTE: `pruneFilterProjectRaw` is almost like <<spark-sql-SparkPlanner.md#pruneFilterProject, SparkPlanner.pruneFilterProject>>.

Internally, `pruneFilterProjectRaw` splits the input `filterPredicates` expressions to <<selectFilters, select the Catalyst expressions that can be converted to data source filter predicates>> (and handled by the <<spark-sql-LogicalPlan-LogicalRelation.md#relation, BaseRelation>> of the `LogicalRelation`).

`pruneFilterProjectRaw` combines all expressions that are neither convertible to data source filters nor can be handled by the relation using `And` binary expression (that creates a so-called `filterCondition` that will eventually be used to create a <<spark-sql-SparkPlan-FilterExec.md#, FilterExec>> physical operator if non-empty).

`pruneFilterProjectRaw` creates a <<spark-sql-SparkPlan-RowDataSourceScanExec.md#creating-instance, RowDataSourceScanExec>> leaf physical operator.

If it is possible to use a column pruning only to get the right projection and if the columns of this projection are enough to evaluate all filter conditions, `pruneFilterProjectRaw` creates a <<spark-sql-SparkPlan-FilterExec.md#creating-instance, FilterExec>> unary physical operator (with the unhandled predicate expressions and the `RowDataSourceScanExec` leaf physical operator as the child).

NOTE: In this case no extra <<spark-sql-SparkPlan-ProjectExec.md#, ProjectExec>> unary physical operator is created.

Otherwise, `pruneFilterProjectRaw` creates a <<spark-sql-SparkPlan-FilterExec.md#creating-instance, FilterExec>> unary physical operator (with the unhandled predicate expressions and the `RowDataSourceScanExec` leaf physical operator as the child) that in turn becomes the <<spark-sql-SparkPlan-ProjectExec.md#child, child>> of a new <<spark-sql-SparkPlan-ProjectExec.md#creating-instance, ProjectExec>> unary physical operator.

NOTE: `pruneFilterProjectRaw` is used exclusively when `DataSourceStrategy` execution planning strategy is <<apply, executed>> (for a `LogicalRelation` with a `CatalystScan` relation) and <<pruneFilterProject, pruneFilterProject>> (when <<apply, executed>> for a `LogicalRelation` with a `PrunedFilteredScan` or a `PrunedScan` relation).
