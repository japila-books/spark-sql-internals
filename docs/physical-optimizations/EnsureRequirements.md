# EnsureRequirements Physical Optimization

[[apply]]
`EnsureRequirements` is a *physical query optimization* (aka _physical query preparation rule_ or simply _preparation rule_) that `QueryExecution` spark-sql-QueryExecution.md#preparations[uses] to optimize the physical plan of a structured query by transforming the following physical operators (up the plan tree):

. Removes two adjacent spark-sql-SparkPlan-ShuffleExchangeExec.md[ShuffleExchangeExec] physical operators if the child partitioning scheme guarantees the parent's partitioning

. For other non-``ShuffleExchangeExec`` physical operators, <<ensureDistributionAndOrdering, ensures partition distribution and ordering>> (possibly adding new physical operators, e.g. spark-sql-SparkPlan-BroadcastExchangeExec.md[BroadcastExchangeExec] and spark-sql-SparkPlan-ShuffleExchangeExec.md[ShuffleExchangeExec] for distribution or spark-sql-SparkPlan-SortExec.md[SortExec] for sorting)

Technically, `EnsureRequirements` is just a catalyst/Rule.md[Catalyst rule] for transforming SparkPlan.md[physical query plans], i.e. `Rule[SparkPlan]`.

`EnsureRequirements` is part of spark-sql-QueryExecution.md#preparations[preparations] batch of physical query plan rules and is executed when `QueryExecution` is requested for the spark-sql-QueryExecution.md#executedPlan[optimized physical query plan] (i.e. in *executedPlan* phase of a query execution).

[[conf]]
`EnsureRequirements` takes a [SQLConf](SQLConf.md) when created.

[source, scala]
----
val q = ??? // FIXME
val sparkPlan = q.queryExecution.sparkPlan

import org.apache.spark.sql.execution.exchange.EnsureRequirements
val plan = EnsureRequirements(spark.sessionState.conf).apply(sparkPlan)
----

=== [[createPartitioning]] `createPartitioning` Internal Method

CAUTION: FIXME

=== [[defaultNumPreShufflePartitions]] `defaultNumPreShufflePartitions` Internal Method

CAUTION: FIXME

=== [[ensureDistributionAndOrdering]] Enforcing Partition Requirements (Distribution and Ordering) of Physical Operator -- `ensureDistributionAndOrdering` Internal Method

[source, scala]
----
ensureDistributionAndOrdering(operator: SparkPlan): SparkPlan
----

Internally, `ensureDistributionAndOrdering` takes the following from the input physical `operator`:

* SparkPlan.md#requiredChildDistribution[required partition requirements] for the children

* SparkPlan.md#requiredChildOrdering[required sort ordering] per the required partition requirements per child

* child physical plans

NOTE: The number of requirements for partitions and their sort ordering has to match the number and the order of the child physical plans.

`ensureDistributionAndOrdering` matches the operator's required partition requirements of children (`requiredChildDistributions`) to the children's SparkPlan.md#outputPartitioning[output partitioning] and (in that order):

. If the child satisfies the requested distribution, the child is left unchanged

. For spark-sql-Distribution-BroadcastDistribution.md[BroadcastDistribution], the child becomes the child of spark-sql-SparkPlan-BroadcastExchangeExec.md[BroadcastExchangeExec] unary operator for spark-sql-SparkPlan-BroadcastHashJoinExec.md[broadcast hash joins]

. Any other pair of child and distribution leads to spark-sql-SparkPlan-ShuffleExchangeExec.md[ShuffleExchangeExec] unary physical operator (with proper <<createPartitioning, partitioning>> for distribution and with spark-sql-properties.md#spark.sql.shuffle.partitions[spark.sql.shuffle.partitions] number of partitions, i.e. `200` by default)

NOTE: spark-sql-SparkPlan-ShuffleExchangeExec.md[ShuffleExchangeExec] can appear in the physical plan when the children's output partitioning cannot satisfy the physical operator's required child distribution.

If the input `operator` has multiple children and specifies child output distributions, then the children's SparkPlan.md#outputPartitioning[output partitionings] have to be compatible.

If the children's output partitionings are not all compatible, then...FIXME

`ensureDistributionAndOrdering` <<withExchangeCoordinator, adds ExchangeCoordinator>> (only when spark-sql-adaptive-query-execution.md[adaptive query execution] is enabled which is not by default).

NOTE: At this point in `ensureDistributionAndOrdering` the required child distributions are already handled.

`ensureDistributionAndOrdering` matches the operator's required sort ordering of children (`requiredChildOrderings`) to the children's SparkPlan.md#outputPartitioning[output partitioning] and if the orderings do not match, spark-sql-SparkPlan-SortExec.md#creating-instance[SortExec] unary physical operator is created as a new child.

In the end, `ensureDistributionAndOrdering` [sets the new children](catalyst/TreeNode.md#withNewChildren) for the input `operator`.

NOTE: `ensureDistributionAndOrdering` is used exclusively when `EnsureRequirements` is <<apply, executed>> (i.e. applied to a physical plan).

=== [[withExchangeCoordinator]] Adding ExchangeCoordinator (Adaptive Query Execution) -- `withExchangeCoordinator` Internal Method

[source, scala]
----
withExchangeCoordinator(
  children: Seq[SparkPlan],
  requiredChildDistributions: Seq[Distribution]): Seq[SparkPlan]
----

`withExchangeCoordinator` adds spark-sql-ExchangeCoordinator.md[ExchangeCoordinator] to spark-sql-SparkPlan-ShuffleExchangeExec.md[ShuffleExchangeExec] operators if adaptive query execution is enabled (per spark-sql-properties.md#spark.sql.adaptive.enabled[spark.sql.adaptive.enabled] property) and partitioning scheme of the `ShuffleExchangeExec` operators support `ExchangeCoordinator`.

NOTE: spark-sql-properties.md#spark.sql.adaptive.enabled[spark.sql.adaptive.enabled] property is disabled by default.

[[supportsCoordinator]]
Internally, `withExchangeCoordinator` checks if the input `children` operators support `ExchangeCoordinator` which is that either holds:

* If there is at least one spark-sql-SparkPlan-ShuffleExchangeExec.md[ShuffleExchangeExec] operator, all children are either `ShuffleExchangeExec` with spark-sql-SparkPlan-Partitioning.md#HashPartitioning[HashPartitioning] or their SparkPlan.md#outputPartitioning[output partitioning] is spark-sql-SparkPlan-Partitioning.md#HashPartitioning[HashPartitioning] (even inside spark-sql-SparkPlan-Partitioning.md#PartitioningCollection[PartitioningCollection])

* There are at least two `children` operators and the input `requiredChildDistributions` are all spark-sql-Distribution-ClusteredDistribution.md[ClusteredDistribution]

With spark-sql-adaptive-query-execution.md[adaptive query execution] (i.e. when spark-sql-adaptive-query-execution.md#spark.sql.adaptive.enabled[spark.sql.adaptive.enabled] configuration property is `true`) and the <<supportsCoordinator, operator supports ExchangeCoordinator>>, `withExchangeCoordinator` creates a `ExchangeCoordinator` and:

* For every `ShuffleExchangeExec`, spark-sql-SparkPlan-ShuffleExchangeExec.md#coordinator[registers the `ExchangeCoordinator`]

* <<createPartitioning, Creates HashPartitioning partitioning scheme>> with the [default number of partitions to use when shuffling data for joins or aggregations](SQLConf.md#numShufflePartitions) (as spark-sql-properties.md#spark.sql.shuffle.partitions[spark.sql.shuffle.partitions] which is `200` by default) and adds `ShuffleExchangeExec` to the final result (for the current physical operator)

Otherwise (when adaptive query execution is disabled or `children` do not support `ExchangeCoordinator`), `withExchangeCoordinator` returns the input `children` unchanged.

NOTE: `withExchangeCoordinator` is used exclusively for <<ensureDistributionAndOrdering, enforcing partition requirements of a physical operator>>.

=== [[reorderJoinPredicates]] `reorderJoinPredicates` Internal Method

[source, scala]
----
reorderJoinPredicates(plan: SparkPlan): SparkPlan
----

`reorderJoinPredicates`...FIXME

NOTE: `reorderJoinPredicates` is used when...FIXME
