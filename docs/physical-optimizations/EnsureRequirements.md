---
title: EnsureRequirements
---

# EnsureRequirements Physical Optimization

`EnsureRequirements` is a physical query optimization.

`EnsureRequirements` is a [Catalyst rule](../catalyst/Rule.md) for transforming [physical query plans](../physical-operators/SparkPlan.md) (`Rule[SparkPlan]`).

## Creating Instance

`EnsureRequirements` takes the following to be created:

* <span id="optimizeOutRepartition"> `optimizeOutRepartition` flag (default: `true`)
* [Required Distribution](#requiredDistribution)

`EnsureRequirements` is created when:

* `QueryExecution` is requested for the [preparations rules](../QueryExecution.md#preparations)
* [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md) physical operator is [created](../physical-operators/AdaptiveSparkPlanExec.md#queryStagePreparationRules)

### Required Distribution { #requiredDistribution }

```scala
requiredDistribution: Option[Distribution] = None
```

`EnsureRequirements` can be given a [Distribution](../physical-operators/Distribution.md) when [created](#creating-instance).

The `Distribution` is undefined (`None`):

* By default
* When `QueryExecution` is requested for the [preparations rules](../QueryExecution.md#preparations)

The `Distribution` can only be specified for [Adaptive Query Execution](../adaptive-query-execution/index.md) (for [QueryStage Physical Preparation Rules](../physical-operators/AdaptiveSparkPlanExec.md#queryStagePreparationRules)).

## Executing Rule { #apply }

??? note "Rule"

    ```scala
    apply(
      plan: SparkPlan): SparkPlan
    ```

    `apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply` transforms the following physical operators in the query plan (up the plan tree):

* [ShuffleExchangeExec](#ShuffleExchangeExec)
* Any [SparkPlan](#SparkPlan)s

With the [required distribution](#requiredDistribution) not specified, `apply` gives the new transformed plan.

Otherwise, with the [required distribution](#requiredDistribution) specified, `apply`...FIXME

### ShuffleExchangeExec { #ShuffleExchangeExec }

`apply` transforms [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md) with [HashPartitioning](../expressions/HashPartitioning.md) only beside the following requirements:

* [optimizeOutRepartition](#optimizeOutRepartition) is enabled (the default)
* [shuffleOrigin](../physical-operators/ShuffleExchangeExec.md#shuffleOrigin) is either `REPARTITION_BY_COL` or `REPARTITION_BY_NUM`

### SparkPlan { #SparkPlan }

`apply` transforms other [SparkPlan](../physical-operators/SparkPlan.md)s to [ensureDistributionAndOrdering](#ensureDistributionAndOrdering) of the [children](../physical-operators/SparkPlan.md#children) based on [requiredChildDistribution](../physical-operators/SparkPlan.md#requiredChildDistribution) and [requiredChildOrdering](../physical-operators/SparkPlan.md#requiredChildOrdering).

While transforming the query plan, `apply` may also [reorderJoinPredicates](#reorderJoinPredicates) of [ShuffledHashJoinExec](../physical-operators/ShuffledHashJoinExec.md) and [SortMergeJoinExec](../physical-operators/SortMergeJoinExec.md) physical operators, if found.

[ensureDistributionAndOrdering](#ensureDistributionAndOrdering) can introduce [BroadcastExchangeExec](../physical-operators/BroadcastExchangeExec.md)s or [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md)s physical operators in the query plan.

### ensureDistributionAndOrdering { #ensureDistributionAndOrdering }

```scala
ensureDistributionAndOrdering(
  parent: Option[SparkPlan],
  originalChildren: Seq[SparkPlan],
  requiredChildDistributions: Seq[Distribution],
  requiredChildOrderings: Seq[Seq[SortOrder]],
  shuffleOrigin: ShuffleOrigin): Seq[SparkPlan]
```

`ensureDistributionAndOrdering` is...FIXME

## OptimizeSkewedJoin { #OptimizeSkewedJoin }

`EnsureRequirements` is used to create a [OptimizeSkewedJoin](OptimizeSkewedJoin.md) physical optimization.

<!---
## Review Me

[[apply]]
`EnsureRequirements` is a *physical query optimization* that optimizes the physical plans by transforming the following physical operators:

. Removes two adjacent ShuffleExchangeExec.md[ShuffleExchangeExec] physical operators if the child partitioning scheme guarantees the parent's partitioning

. For other non-``ShuffleExchangeExec`` physical operators, <<ensureDistributionAndOrdering, ensures partition distribution and ordering>> (possibly adding new physical operators, e.g. BroadcastExchangeExec.md[BroadcastExchangeExec] and ShuffleExchangeExec.md[ShuffleExchangeExec] for distribution or SortExec.md[SortExec] for sorting)

[source, scala]
----
val q = ??? // FIXME
val sparkPlan = q.queryExecution.sparkPlan

import org.apache.spark.sql.execution.exchange.EnsureRequirements
val plan = EnsureRequirements(spark.sessionState.conf).apply(sparkPlan)
----

## <span id="ensureDistributionAndOrdering"> Enforcing Partition Requirements (Distribution and Ordering) of Physical Operator

```scala
ensureDistributionAndOrdering(
  operator: SparkPlan): SparkPlan
```

`ensureDistributionAndOrdering` takes the following from the input physical `operator`:

* SparkPlan.md#requiredChildDistribution[required partition requirements] for the children

* SparkPlan.md#requiredChildOrdering[required sort ordering] per the required partition requirements per child

* child physical plans

NOTE: The number of requirements for partitions and their sort ordering has to match the number and the order of the child physical plans.

`ensureDistributionAndOrdering` matches the operator's required partition requirements of children (`requiredChildDistributions`) to the children's SparkPlan.md#outputPartitioning[output partitioning] and (in that order):

. If the child satisfies the requested distribution, the child is left unchanged

. For [BroadcastDistribution](../physical-operators/BroadcastDistribution.md), the child becomes the child of BroadcastExchangeExec.md[BroadcastExchangeExec] unary operator for BroadcastHashJoinExec.md[broadcast hash joins]

. Any other pair of child and distribution leads to ShuffleExchangeExec.md[ShuffleExchangeExec] unary physical operator (with proper <<createPartitioning, partitioning>> for distribution and with [spark.sql.shuffle.partitions](../configuration-properties.md#spark.sql.shuffle.partitions) number of partitions)

NOTE: ShuffleExchangeExec.md[ShuffleExchangeExec] can appear in the physical plan when the children's output partitioning cannot satisfy the physical operator's required child distribution.

If the input `operator` has multiple children and specifies child output distributions, then the children's SparkPlan.md#outputPartitioning[output partitionings] have to be compatible.

If the children's output partitionings are not all compatible, then...FIXME

`ensureDistributionAndOrdering` <<withExchangeCoordinator, adds ExchangeCoordinator>> (only when [Adaptive Query Execution](../adaptive-query-execution/index.md) is enabled which is not by default).

NOTE: At this point in `ensureDistributionAndOrdering` the required child distributions are already handled.

`ensureDistributionAndOrdering` matches the operator's required sort ordering of children (`requiredChildOrderings`) to the children's SparkPlan.md#outputPartitioning[output partitioning] and if the orderings do not match, SortExec.md#creating-instance[SortExec] unary physical operator is created as a new child.

In the end, `ensureDistributionAndOrdering` [sets the new children](../catalyst/TreeNode.md#withNewChildren) for the input `operator`.

`ensureDistributionAndOrdering` is used when `EnsureRequirements` physical optimization is [executed](#apply).
-->
