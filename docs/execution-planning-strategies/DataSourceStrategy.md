# DataSourceStrategy Execution Planning Strategy

`DataSourceStrategy` is an [execution planning strategy](SparkStrategy.md) (of [SparkPlanner](../SparkPlanner.md)) that [plans LogicalRelation logical operators as RowDataSourceScanExec physical operators](#apply) (possibly under [FilterExec](../physical-operators/FilterExec.md) and [ProjectExec](../physical-operators/ProjectExec.md) logical operators).

## <span id="apply"><span id="selection-requirements"> Executing Rule

```scala
apply(
  plan: LogicalPlan): Seq[SparkPlan]
```

`apply` plans the given [LogicalPlan](../logical-operators/LogicalPlan.md) into a corresponding [SparkPlan](../physical-operators/SparkPlan.md).

Logical Operator | Description
-----------------|---------
 [LogicalRelation](../logical-operators/LogicalRelation.md) with a `CatalystScan` relation | <ul><li>[pruneFilterProjectRaw](#pruneFilterProjectRaw) (with the [RDD conversion to RDD[InternalRow]](#toCatalystRDD) as part of `scanBuilder`)</li><li>`CatalystScan` does not seem to be used in Spark SQL</li></ul>
 [LogicalRelation](../logical-operators/LogicalRelation.md) with [PrunedFilteredScan](../PrunedFilteredScan.md) relation | <ul><li>[pruneFilterProject](#pruneFilterProject) (with the [RDD conversion to RDD[InternalRow]](#toCatalystRDD) as part of `scanBuilder`)</li><li>Matches [JDBCRelation](../datasources/jdbc/JDBCRelation.md) exclusively</li></ul>
 [LogicalRelation](../logical-operators/LogicalRelation.md) with a [PrunedScan](../PrunedScan.md) relation | <ul><li>[pruneFilterProject](#pruneFilterProject) (with the [RDD conversion to RDD[InternalRow]](#toCatalystRDD) as part of `scanBuilder`)</li><li>`PrunedScan` does not seem to be used in Spark SQL</li></ul>
 [LogicalRelation](../logical-operators/LogicalRelation.md) with a [TableScan](../TableScan.md) relation | <ul><li>Creates a [RowDataSourceScanExec](../physical-operators/RowDataSourceScanExec.md) directly (requesting the `TableScan` to [buildScan](../TableScan.md#buildScan) followed by [RDD conversion to RDD[InternalRow]](#toCatalystRDD))</li><li>Matches [KafkaRelation](../datasources/kafka/KafkaRelation.md) exclusively</li></ul>

## <span id="pruneFilterProject"> pruneFilterProject

```scala
pruneFilterProject(
  relation: LogicalRelation,
  projects: Seq[NamedExpression],
  filterPredicates: Seq[Expression],
  scanBuilder: (Seq[Attribute], Array[Filter]) => RDD[InternalRow]): SparkPlan
```

`pruneFilterProject` [pruneFilterProjectRaw](#pruneFilterProjectRaw) (with `scanBuilder` ignoring the `Seq[Expression]` input argument).

`pruneFilterProject` is used when:

* `DataSourceStrategy` execution planning strategy is [executed](#apply) (with [LogicalRelation](../logical-operators/LogicalRelation.md)s over a [PrunedFilteredScan](../PrunedFilteredScan.md) or a [PrunedScan](../PrunedScan.md))

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

## <span id="translateFilter"> Translating Catalyst Expression into Data Source Filter Predicate

```scala
translateFilter(
  predicate: Expression,
  supportNestedPredicatePushdown: Boolean): Option[Filter]
```

`translateFilter` [translateFilterWithMapping](#translateFilterWithMapping) (with the input parameters and an undefined (`None`) `translatedFilterToExpr`).

`translateFilter` is used when:

* `FileSourceScanExec` physical operator is requested for the [pushedDownFilters](../physical-operators/FileSourceScanExec.md#pushedDownFilters)
* `DataSourceStrategy` execution planning strategy is requested to [selectFilters](#selectFilters)
* `FileSourceStrategy` execution planning strategy is [executed](FileSourceStrategy.md#apply)
* `DataSourceV2Strategy` execution planning strategy is [executed](DataSourceV2Strategy.md#apply)
* `V2Writes` is requested to `apply`

## <span id="translateFilterWithMapping"> translateFilterWithMapping

```scala
translateFilterWithMapping(
  predicate: Expression,
  translatedFilterToExpr: Option[mutable.HashMap[sources.Filter, Expression]],
  nestedPredicatePushdownEnabled: Boolean): Option[Filter]
```

`translateFilterWithMapping` translates the input [Catalyst Expression](../expressions/Expression.md) to a [Data Source Filter predicate](../Filter.md).

---

`translateFilterWithMapping` branches off based on the given predicate expression:

* For `And`s, `translateFilterWithMapping` [translateFilterWithMapping](#translateFilterWithMapping) with the left and right expressions and creates a `And` filter

* For `Or`s, `translateFilterWithMapping` [translateFilterWithMapping](#translateFilterWithMapping) with the left and right expressions and creates a `Or` filter

* For `Not`s, `translateFilterWithMapping` [translateFilterWithMapping](#translateFilterWithMapping) with the child expression and creates a `Not` filter

* For all the other cases, `translateFilterWithMapping` [translateLeafNodeFilter](#translateLeafNodeFilter) and, if successful, adds the filter and the predicate expression to `translatedFilterToExpr` collection

`translateFilterWithMapping` is used when:

* `DataSourceStrategy` is requested to [translateFilter](#translateFilter)
* `PushDownUtils` is requested to `pushFilters`

### <span id="translateLeafNodeFilter"> translateLeafNodeFilter

```scala
translateLeafNodeFilter(
  predicate: Expression,
  pushableColumn: PushableColumnBase): Option[Filter]
```

`translateLeafNodeFilter` translates a given [Catalyst Expression](../expressions/Expression.md) into a corresponding [Filter predicate](../Filter.md) if possible. If not, `translateFilter` returns `None`.

Catalyst Expression | Filter Predicate
--------------------|-----------------
 [EqualTo](../expressions/EqualTo.md) (with a "pushable" column and a `Literal`) | `EqualTo`
 [EqualNullSafe](../expressions/EqualNullSafe.md) (with a "pushable" column and a `Literal`) | `EqualNullSafe`
 `GreaterThan` (with a "pushable" column and a `Literal`) | `GreaterThan` or `LessThan`
 `LessThan` (with a "pushable" column and a `Literal`) | `LessThan` or `GreaterThan`
 `GreaterThanOrEqual` (with a "pushable" column and a `Literal`) | `GreaterThanOrEqual` or `LessThanOrEqual`
 `LessThanOrEqual` (with a "pushable" column and a `Literal`) | `LessThanOrEqual` or `GreaterThanOrEqual`
 [InSet](../expressions/InSet.md) (with a "pushable" column and values) | `In`
 [InSet](../expressions/In.md) (with a "pushable" column and expressions) | `In`
 `IsNull` (with a "pushable" column) | `IsNull`
 `IsNotNull` (with a "pushable" column) | `IsNotNull`
 `StartsWith` (with a "pushable" column and a string `Literal`) | `StringStartsWith`
 `EndsWith` (with a "pushable" column and a string `Literal`) | `StringEndsWith`
 `Contains` (with a "pushable" column and a string `Literal`) | `StringContains`
 `Literal` (with `true`) | `AlwaysTrue`
 `Literal` (with `false`) | `AlwaysFalse`

!!! note
    The Catalyst expressions and their corresponding data source filter predicates have the same names _in most cases_ but belong to different Scala packages (`org.apache.spark.sql.catalyst.expressions` and `org.apache.spark.sql.sources`, respectively).

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

`pruneFilterProjectRaw` converts the given [LogicalRelation](../logical-operators/LogicalRelation.md) leaf logical operator into a [RowDataSourceScanExec](../physical-operators/RowDataSourceScanExec.md) leaf physical operator with the [LogicalRelation](../logical-operators/LogicalRelation.md) leaf logical operator (possibly as a child of a [FilterExec](../physical-operators/FilterExec.md) and a [ProjectExec](../physical-operators/ProjectExec.md) unary physical operators).

!!! note
    `pruneFilterProjectRaw` is almost like [SparkPlanner.pruneFilterProject](../SparkPlanner.md#pruneFilterProject).

Internally, `pruneFilterProjectRaw` splits the input `filterPredicates` expressions to [select the Catalyst expressions that can be converted to data source filter predicates](#selectFilters) (and handled by the underlying [BaseRelation](../logical-operators/LogicalRelation.md#relation) of the `LogicalRelation`).

`pruneFilterProjectRaw` combines all expressions that are neither convertible to data source filters nor can be handled by the relation using `And` binary expression (that creates a so-called `filterCondition` that will eventually be used to create a [FilterExec](../physical-operators/FilterExec.md) physical operator if non-empty).

`pruneFilterProjectRaw` creates a [RowDataSourceScanExec](../physical-operators/RowDataSourceScanExec.md) leaf physical operator.

## Demo

```text
import org.apache.spark.sql.execution.datasources.DataSourceStrategy
val strategy = DataSourceStrategy(spark.sessionState.conf)

import org.apache.spark.sql.catalyst.plans.logical.LogicalPlan
val plan: LogicalPlan = ???

val sparkPlan = strategy(plan).head
```
