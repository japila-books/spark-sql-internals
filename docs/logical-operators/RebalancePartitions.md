# RebalancePartitions Unary Logical Operator

`RebalancePartitions` is a [unary logical operator](LogicalPlan.md#UnaryNode) that represents a `REBALANCE` hint in a logical query plan.

## Creating Instance

`RebalancePartitions` takes the following to be created:

* <span id="partitionExpressions"> Partition [Expression](../expressions/Expression.md)s
* <span id="child"> Child [logical operator](LogicalPlan.md)

`RebalancePartitions` is created when:

* `ResolveCoalesceHints` logical resolution rule is [executed](../logical-analysis-rules/ResolveCoalesceHints.md#apply) (to resolve a `REBALANCE` hint with [Adaptive Query Execution](../adaptive-query-execution/index.md) enabled)

## <span id="partitioning"> Partitioning

```scala
partitioning: Partitioning
```

`partitioning` is one of the following:

With no [partition expressions](#partitionExpressions), `partitioning` is `RoundRobinPartitioning` (with the [numShufflePartitions](../SQLConf.md#numShufflePartitions)).
Otherwise, `partitioning` is a [HashPartitioning](../expressions/HashPartitioning.md) (with the [partition expressions](#partitionExpressions) and the [numShufflePartitions](../SQLConf.md#numShufflePartitions)).

`partitioning` is used when:

* `BasicOperators` execution planning strategy is [executed](../execution-planning-strategies/BasicOperators.md#apply) (for a `RebalancePartitions` logical operator)

## Query Planning

`RebalancePartitions` logical operators are planned by [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy (to [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md) physical operators).
