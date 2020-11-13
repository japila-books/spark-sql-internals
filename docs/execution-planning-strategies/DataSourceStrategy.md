# DataSourceStrategy Execution Planning Strategy

`DataSourceStrategy` is an [execution planning strategy](SparkStrategy.md) (of [SparkPlanner](../SparkPlanner.md)) that [plans LogicalRelation logical operators as RowDataSourceScanExec physical operators](#apply) (possibly under `FilterExec` and `ProjectExec` logical operators).

[[apply]]
[[selection-requirements]]
.DataSourceStrategy's Selection Requirements (in execution order)
[cols="1,2",options="header",width="100%"]
|===
| Logical Operator
| Description

| [LogicalRelation](../logical-operators/LogicalRelation.md) with a [CatalystScan](../CatalystScan.md) relation
| [[CatalystScan]] Uses <<pruneFilterProjectRaw, pruneFilterProjectRaw>> (with the <<toCatalystRDD, RDD conversion to RDD[InternalRow]>> as part of `scanBuilder`).

`CatalystScan` does not seem to be used in Spark SQL.

| [LogicalRelation](../logical-operators/LogicalRelation.md) with [PrunedFilteredScan](../PrunedFilteredScan.md) relation
| [[PrunedFilteredScan]] Uses <<pruneFilterProject, pruneFilterProject>> (with the <<toCatalystRDD, RDD conversion to RDD[InternalRow]>> as part of `scanBuilder`).

Matches [JDBCRelation](../datasources/jdbc/JDBCRelation.md) exclusively

| [LogicalRelation](../logical-operators/LogicalRelation.md) with a [PrunedScan](../PrunedScan.md) relation
| [[PrunedScan]] Uses <<pruneFilterProject, pruneFilterProject>> (with the <<toCatalystRDD, RDD conversion to RDD[InternalRow]>> as part of `scanBuilder`).

`PrunedScan` does not seem to be used in Spark SQL.

| [LogicalRelation](../logical-operators/LogicalRelation.md) with a [TableScan](../TableScan.md) relation
a| [[TableScan]] Creates a [RowDataSourceScanExec](../physical-operators/RowDataSourceScanExec.md) directly (requesting the `TableScan` to [buildScan](../TableScan.md#buildScan) followed by [RDD conversion to RDD[InternalRow]](#toCatalystRDD))

Matches [KafkaRelation](../datasources/kafka/KafkaRelation.md) exclusively
|===

[source, scala]
----
import org.apache.spark.sql.execution.datasources.DataSourceStrategy
val strategy = DataSourceStrategy(spark.sessionState.conf)

import org.apache.spark.sql.catalyst.plans.logical.LogicalPlan
val plan: LogicalPlan = ???

val sparkPlan = strategy(plan).head
----

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

`pruneFilterProject` is used when `DataSourceStrategy` execution planning strategy is <<apply, executed>> (for [LogicalRelation](../logical-operators/LogicalRelation.md) logical operators with a [PrunedFilteredScan](../PrunedFilteredScan.md) or a [PrunedScan](../PrunedScan.md)).

## <span id="selectFilters"> Selecting Catalyst Expressions Convertible to Data Source Filter Predicates

```scala
selectFilters(
  relation: BaseRelation,
  predicates: Seq[Expression]): (Seq[Expression], Seq[Filter], Set[Filter])
```

`selectFilters` builds a map of [Catalyst predicate expressions](../expressions/Expression.md) (from the input `predicates`) that can be [translated](#translateFilter) to a [data source filter predicate](../Filter.md).

`selectFilters` then requests the input [BaseRelation](../BaseRelation.md) for [unhandled filters](../BaseRelation.md#unhandledFilters) (out of the convertible ones that `selectFilters` built the map with).

In the end, `selectFilters` returns a 3-element tuple with the following:

1. Inconvertible and unhandled Catalyst predicate expressions

1. All converted data source filters

1. Pushed-down data source filters (that the input `BaseRelation` can handle)

`selectFilters` is used when `DataSourceStrategy` execution planning strategy is [executed](#apply) (and [creates a RowDataSourceScanExec physical operator](#pruneFilterProjectRaw)).

=== [[translateFilter]] Translating Catalyst Expression Into Data Source Filter Predicate -- `translateFilter` Method

[source, scala]
----
translateFilter(predicate: Expression): Option[Filter]
----

`translateFilter` translates a expressions/Expression.md[Catalyst expression] into a corresponding [Filter predicate](../Filter.md) if possible. If not, `translateFilter` returns `None`.

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

`translateFilter` is used when:

* [FileSourceScanExec](../physical-operators/FileSourceScanExec.md) is created (and initializes [pushedDownFilters](../physical-operators/FileSourceScanExec.md#pushedDownFilters))
* `DataSourceStrategy` is requested to [selectFilters](#selectFilters)
* [PushDownOperatorsToDataSource](../logical-optimizations/PushDownOperatorsToDataSource.md) logical optimization is executed (for [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md) leaf operators with a [SupportsPushDownFilters](../connector/SupportsPushDownFilters.md) data source reader)

## <span id="toCatalystRDD"> RDD Conversion (Converting RDD of Rows to Catalyst RDD of InternalRows)

```scala
toCatalystRDD(
  relation: LogicalRelation,
  output: Seq[Attribute],
  rdd: RDD[Row]): RDD[InternalRow]
toCatalystRDD(
  relation: LogicalRelation,
  rdd: RDD[Row]) // <1>
```

`toCatalystRDD` branches off per the [needConversion](../BaseRelation.md#needConversion) flag of the [BaseRelation](../logical-operators/LogicalRelation.md#relation) of the input [LogicalRelation](../logical-operators/LogicalRelation.md):

* when `true`, `toCatalystRDD` [converts the objects inside Rows to Catalyst types](../spark-sql-RDDConversions.md#rowToRowRdd).

* otherwise, `toCatalystRDD` casts the input `RDD[Row]` to an `RDD[InternalRow]` (using Java's `asInstanceOf` operator)

`toCatalystRDD` is used when `DataSourceStrategy` execution planning strategy is [executed](#apply) (for all kinds of [BaseRelations](#selection-requirements)).

## <span id="pruneFilterProjectRaw"> Creating RowDataSourceScanExec Physical Operator for LogicalRelation

```scala
pruneFilterProjectRaw(
  relation: LogicalRelation,
  projects: Seq[NamedExpression],
  filterPredicates: Seq[Expression],
  scanBuilder: (Seq[Attribute], Seq[Expression], Seq[Filter]) => RDD[InternalRow]): SparkPlan
```

`pruneFilterProjectRaw` creates a [RowDataSourceScanExec](../physical-operators/RowDataSourceScanExec.md) leaf physical operator with the [LogicalRelation](../logical-operators/LogicalRelation.md) leaf logical operator (possibly as a child of a [FilterExec](../physical-operators/FilterExec.md) and a [ProjectExec](../physical-operators/ProjectExec.md) unary physical operators).

In other words, `pruneFilterProjectRaw` simply converts a <<LogicalRelation.md#, LogicalRelation>> leaf logical operator into a <<RowDataSourceScanExec.md#, RowDataSourceScanExec>> leaf physical operator (possibly under a <<FilterExec.md#, FilterExec>> and a <<ProjectExec.md#, ProjectExec>> unary physical operators).

!!! note
    `pruneFilterProjectRaw` is almost like [SparkPlanner.pruneFilterProject](../SparkPlanner.md#pruneFilterProject).

Internally, `pruneFilterProjectRaw` splits the input `filterPredicates` expressions to <<selectFilters, select the Catalyst expressions that can be converted to data source filter predicates>> (and handled by the <<LogicalRelation.md#relation, BaseRelation>> of the `LogicalRelation`).

`pruneFilterProjectRaw` combines all expressions that are neither convertible to data source filters nor can be handled by the relation using `And` binary expression (that creates a so-called `filterCondition` that will eventually be used to create a <<FilterExec.md#, FilterExec>> physical operator if non-empty).

`pruneFilterProjectRaw` creates a <<RowDataSourceScanExec.md#creating-instance, RowDataSourceScanExec>> leaf physical operator.

If it is possible to use a column pruning only to get the right projection and if the columns of this projection are enough to evaluate all filter conditions, `pruneFilterProjectRaw` creates a <<FilterExec.md#creating-instance, FilterExec>> unary physical operator (with the unhandled predicate expressions and the `RowDataSourceScanExec` leaf physical operator as the child).

NOTE: In this case no extra <<ProjectExec.md#, ProjectExec>> unary physical operator is created.

Otherwise, `pruneFilterProjectRaw` creates a <<FilterExec.md#creating-instance, FilterExec>> unary physical operator (with the unhandled predicate expressions and the `RowDataSourceScanExec` leaf physical operator as the child) that in turn becomes the <<ProjectExec.md#child, child>> of a new <<ProjectExec.md#creating-instance, ProjectExec>> unary physical operator.

`pruneFilterProjectRaw` is used when `DataSourceStrategy` execution planning strategy is [executed](#apply).
