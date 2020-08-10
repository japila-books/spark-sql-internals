# SparkStrategy &mdash; Base for Execution Planning Strategies

`SparkStrategy` is an extension of the [GenericStrategy](../catalyst/GenericStrategy.md) abstraction for [execution planning strategies](#implementations) that can convert (_plan_) a [logical query plan](../logical-operators/LogicalPlan.md) to zero or more [physical query plans](../physical-operators/SparkPlan.md) for execution.

## SparkSessionExtensions

[SparkSessionExtensions](../SparkSessionExtensions.md) is used to [inject a planner strategy](../SparkSessionExtensions.md#injectPlannerStrategy) to a [SparkSession](../SparkSession.md).

## ExperimentalMethods

[ExperimentalMethods](../ExperimentalMethods.md) is used to register [extraStrategies](../ExperimentalMethods.md#extraStrategies) globally.

## SparkPlanner and extraPlanningStrategies

[SparkPlanner](../SparkPlanner.md) defines an extension point for [extraPlanningStrategies](../SparkPlanner.md#extraPlanningStrategies).

## <span id="Strategy"> Strategy Type Alias

`SparkStrategy` is used for `Strategy` type alias (_type synonym_) in Spark's code base that is defined in [org.apache.spark.sql](https://github.com/apache/spark/blob/v3.0.0/sql/core/src/main/scala/org/apache/spark/sql/package.scala#L44) package object.

```scala
type Strategy = SparkStrategy
```

## <span id="PlanLater"> PlanLater Leaf Physical Operator

`SparkStrategy` defines `PlanLater` physical operator that is used as a marker operator to be planned later.

`PlanLater` cannot be executed and, when requested to execute (using `doExecute`), simply throws an `UnsupportedOperationException`.

## planLater

```scala
planLater(
  plan: LogicalPlan): SparkPlan
```

`planLater` creates a [PlanLater](#PlanLater) leaf physical operator for the given [LogicalPlan](../logical-operators/LogicalPlan.md).
