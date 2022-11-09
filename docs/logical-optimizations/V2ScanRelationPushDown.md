# V2ScanRelationPushDown Logical Optimization

`V2ScanRelationPushDown` is a logical optimization (`Rule[LogicalPlan]`).

`V2ScanRelationPushDown` is a [non-excludable optimization](../SparkOptimizer.md#nonExcludableRules) and is part of [earlyScanPushDownRules](../SparkOptimizer.md#earlyScanPushDownRules).

## <span id="apply"> Executing Rule

```scala
apply(plan: LogicalPlan): LogicalPlan
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

---

`apply` runs (_applies_) the following optimizations on the given [LogicalPlan](../logical-operators/LogicalPlan.md):

1. [Creating ScanBuilders](#createScanBuilder)
1. [pushDownSample](#pushDownSample)
1. [pushDownFilters](#pushDownFilters)
1. [pushDownAggregates](#pushDownAggregates)
1. [pushDownLimits](#pushDownLimits)
1. [pruneColumns](#pruneColumns)

## <span id="createScanBuilder"> Creating ScanBuilder (for DataSourceV2Relation)

```scala
createScanBuilder(
  plan: LogicalPlan): LogicalPlan
```

`createScanBuilder` transforms [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md)s in the given [LogicalPlan](../logical-operators/LogicalPlan.md).

For every `DataSourceV2Relation`, `createScanBuilder` creates a `ScanBuilderHolder` with the following:

* [output schema](../logical-operators/DataSourceV2Relation.md#output) of the `DataSourceV2Relation`
* The `DataSourceV2Relation`
* A [ScanBuilder](../connector/SupportsRead.md#newScanBuilder) (with the [options](../logical-operators/DataSourceV2Relation.md#options) of the `DataSourceV2Relation`) of the [SupportsRead](../connector/DataSourceV2Implicits.md#asReadable) of the [Table](../logical-operators/DataSourceV2Relation.md#table) of the `DataSourceV2Relation`

## <span id="pushDownSample"> pushDownSample

```scala
pushDownSample(
  plan: LogicalPlan): LogicalPlan
```

`pushDownSample` transforms `Sample` operators in the given [LogicalPlan](../logical-operators/LogicalPlan.md).

## <span id="pushDownFilters"> pushDownFilters

```scala
pushDownFilters(
  plan: LogicalPlan): LogicalPlan
```

`pushDownFilters` transforms `Filter` operators over `ScanBuilderHolder` in the given [LogicalPlan](../logical-operators/LogicalPlan.md).

`pushDownFilters` prints out the following INFO message to the logs:

```text
Pushing operators to [name]
Pushed Filters: [pushedFilters]
Post-Scan Filters: [postScanFilters]
```

## <span id="pushDownAggregates"> pushDownAggregates

```scala
pushDownAggregates(
  plan: LogicalPlan): LogicalPlan
```

`pushDownAggregates` transforms [Aggregate](../logical-operators/Aggregate.md) operators in the given [LogicalPlan](../logical-operators/LogicalPlan.md).

`pushDownAggregates` prints out the following INFO message to the logs:

```text
Pushing operators to [name]
Pushed Aggregate Functions: [aggregateExpressions]
Pushed Group by: [groupByExpressions]
Output: [output]
```

## <span id="pushDownLimits"> pushDownLimits

```scala
pushDownLimits(
  plan: LogicalPlan): LogicalPlan
```

`pushDownLimits` transforms [GlobalLimit](../logical-operators/GlobalLimit.md) operators in the given [LogicalPlan](../logical-operators/LogicalPlan.md).

## <span id="pruneColumns"> pruneColumns

```scala
pruneColumns(
  plan: LogicalPlan): LogicalPlan
```

`pruneColumns` transforms [Project](../logical-operators/Project.md) and `Filter` operators over `ScanBuilderHolder` in the given [LogicalPlan](../logical-operators/LogicalPlan.md) and creates [DataSourceV2ScanRelation](../logical-operators/DataSourceV2ScanRelation.md).

`pruneColumns` prints out the following INFO message to the logs:

```text
Output: [output]
```

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.datasources.v2.V2ScanRelationPushDown` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.datasources.v2.V2ScanRelationPushDown=ALL
```

Refer to [Logging](../spark-logging.md).
