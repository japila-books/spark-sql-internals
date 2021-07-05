# SparkPlanner &mdash; Spark Query Planner

`SparkPlanner` is a concrete [Catalyst Query Planner](catalyst/QueryPlanner.md) that converts a [logical plan](logical-operators/LogicalPlan.md) to one or more [physical plans](physical-operators/SparkPlan.md) using [execution planning strategies](#strategies) with support for extension points:

* [extra strategies](#extraStrategies) (by means of [ExperimentalMethods](#experimentalMethods))
* [extraPlanningStrategies](#extraPlanningStrategies)

`SparkPlanner` is expected to plan (_create_) at least one [physical plan](physical-operators/SparkPlan.md) for a given [logical plan](logical-operators/LogicalPlan.md).

`SparkPlanner` extends [SparkStrategies](execution-planning-strategies/SparkStrategies.md) abstract class.

## <span id="strategies"> Execution Planning Strategies

1. [extraStrategies](ExperimentalMethods.md#extraStrategies) of the [ExperimentalMethods](#experimentalMethods)
1. [extraPlanningStrategies](#extraPlanningStrategies)
1. [LogicalQueryStageStrategy](execution-planning-strategies/LogicalQueryStageStrategy.md)
1. PythonEvals
1. [DataSourceV2Strategy](execution-planning-strategies/DataSourceV2Strategy.md)
1. [FileSourceStrategy](execution-planning-strategies/FileSourceStrategy.md)
1. [DataSourceStrategy](execution-planning-strategies/DataSourceStrategy.md)
1. [SpecialLimits](execution-planning-strategies/SpecialLimits.md)
1. [Aggregation](execution-planning-strategies/Aggregation.md)
1. Window
1. [JoinSelection](execution-planning-strategies/JoinSelection.md)
1. [InMemoryScans](execution-planning-strategies/InMemoryScans.md)
1. [BasicOperators](execution-planning-strategies/BasicOperators.md)

## Creating Instance

`SparkPlanner` takes the following to be created:

* <span id="session"> [SparkSession](SparkSession.md)
* <span id="conf"> [SQLConf](SQLConf.md)
* <span id="experimentalMethods"> [ExperimentalMethods](ExperimentalMethods.md)

`SparkPlanner` is created when the following are requested for one:

* [BaseSessionStateBuilder](BaseSessionStateBuilder.md#planner)
* [HiveSessionStateBuilder](hive/HiveSessionStateBuilder.md#planner)
* Structured Streaming's `IncrementalExecution`

## Accessing SparkPlanner

`SparkPlanner` is available as [planner](SessionState.md#planner) of a `SessionState`.

```text
val spark: SparkSession = ...
scala> :type spark.sessionState.planner
org.apache.spark.sql.execution.SparkPlanner
```

## <span id="extraPlanningStrategies"> Extra Planning Strategies

```scala
extraPlanningStrategies: Seq[Strategy] = Nil
```

`extraPlanningStrategies` is an extension point to register extra [planning strategies](execution-planning-strategies/SparkStrategy.md).

`extraPlanningStrategies` is used when `SparkPlanner` is requested for [planning strategies](#strategies).

`extraPlanningStrategies` is overriden in the `SessionState` builders ([BaseSessionStateBuilder](BaseSessionStateBuilder.md#planner) and [HiveSessionStateBuilder](hive/HiveSessionStateBuilder.md#planner)).

## <span id="collectPlaceholders"> Collecting PlanLater Physical Operators

```scala
collectPlaceholders(
  plan: SparkPlan): Seq[(SparkPlan, LogicalPlan)]
```

`collectPlaceholders` collects all [PlanLater](execution-planning-strategies/SparkStrategy.md#PlanLater) physical operators in the given [physical plan](physical-operators/SparkPlan.md).

`collectPlaceholders` is part of [QueryPlanner](catalyst/QueryPlanner.md#collectPlaceholders) abstraction.

## <span id="pruneFilterProject"> Filter and Project Pruning

```scala
pruneFilterProject(
  projectList: Seq[NamedExpression],
  filterPredicates: Seq[Expression],
  prunePushedDownFilters: Seq[Expression] => Seq[Expression],
  scanBuilder: Seq[Attribute] => SparkPlan): SparkPlan
```

!!! note
    `pruneFilterProject` is almost like [DataSourceStrategy.pruneFilterProjectRaw](execution-planning-strategies/DataSourceStrategy.md#pruneFilterProjectRaw).

`pruneFilterProject` branches off per whether it is possible to use a column pruning only (to get the right projection) and the input `projectList` columns of this projection are enough to evaluate all input `filterPredicates` filter conditions.

If so, `pruneFilterProject` does the following:

1. Applies the input `scanBuilder` function to the input `projectList` columns that creates a new [physical operator](physical-operators/SparkPlan.md)

1. If there are Catalyst predicate expressions in the input `prunePushedDownFilters` that cannot be pushed down, `pruneFilterProject` creates a [FilterExec](physical-operators/FilterExec.md) unary physical operator (with the unhandled predicate expressions)

1. Otherwise, `pruneFilterProject` simply returns the physical operator

In this case no extra [ProjectExec](physical-operators/ProjectExec.md) unary physical operator is created.

If not (i.e. it is neither possible to use a column pruning only nor evaluate filter conditions), `pruneFilterProject` does the following:

1. Applies the input `scanBuilder` function to the projection and filtering columns that creates a new [physical operator](physical-operators/SparkPlan.md)

1. Creates a [FilterExec](physical-operators/FilterExec.md) unary physical operator (with the unhandled predicate expressions if available)

1. Creates a [ProjectExec](physical-operators/ProjectExec.md) unary physical operator with the optional `FilterExec` operator (with the scan physical operator) or simply the scan physical operator alone

`pruneFilterProject` is used when [HiveTableScans](hive/HiveTableScans.md) and [InMemoryScans](execution-planning-strategies/InMemoryScans.md) execution planning strategies are executed.
