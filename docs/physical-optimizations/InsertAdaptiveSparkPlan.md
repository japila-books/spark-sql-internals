# InsertAdaptiveSparkPlan Physical Optimization

`InsertAdaptiveSparkPlan` is a [physical query plan optimization rule](catalyst/Rule.md) (`Rule[SparkPlan]`) that re-optimizes the physical query plan in the middle of query execution, based on accurate runtime statistics.

!!! important
    `InsertAdaptiveSparkPlan` is disabled by default based on [spark.sql.adaptive.enabled](spark-sql-properties.md#spark.sql.adaptive.enabled) configuration property.

## Creating Instance

`InsertAdaptiveSparkPlan` takes the following to be created:

* <span id="adaptiveExecutionContext"> [AdaptiveExecutionContext](physical-optimizations/AdaptiveExecutionContext.md)

`InsertAdaptiveSparkPlan` is created when `QueryExecution` is requested for [physical preparations rules](QueryExecution.md#preparations).

## <span id="apply"> apply

```scala
apply(
  plan: SparkPlan): SparkPlan
```

`apply` simply calls [applyInternal](#applyInternal) with the given [SparkPlan](physical-operators/SparkPlan.md) and `isSubquery` flag disabled (`false`).

`apply` is part of the [Rule](catalyst/Rule.md#apply) abstraction.

## <span id="applyInternal"> applyInternal

```scala
applyInternal(
  plan: SparkPlan,
  isSubquery: Boolean): SparkPlan
```

`applyInternal`...FIXME

`applyInternal` is used when `InsertAdaptiveSparkPlan` physical optimization is [executed](#apply) (with the `isSubquery` flag disabled) and requested to [compileSubquery](#compileSubquery) (with the `isSubquery` flag enabled).

## <span id="buildSubqueryMap"> buildSubqueryMap

```scala
buildSubqueryMap(
  plan: SparkPlan): Map[Long, SubqueryExec]
```

`buildSubqueryMap`...FIXME

`buildSubqueryMap` is used when `InsertAdaptiveSparkPlan` physical optimization is [executed](#applyInternal).

## <span id="compileSubquery"> compileSubquery

```scala
compileSubquery(
  plan: LogicalPlan): SparkPlan
```

`compileSubquery`...FIXME

`compileSubquery` is used when `InsertAdaptiveSparkPlan` physical optimization is requested to [buildSubqueryMap](#buildSubqueryMap).
