---
title: Repartition
---

# Repartition Logical Operator

`Repartition` is a concrete [RepartitionOperation](RepartitionOperation.md).

## Creating Instance

`Repartition` takes the following to be created:

* <span id="numPartitions"> Number of partitions
* <span id="shuffle"> [shuffle](RepartitionOperation.md#shuffle) flag
* <span id="child"> Child [LogicalPlan](LogicalPlan.md)

`Repartition` is created for the following:

* [Dataset.coalesce](../Dataset.md#coalesce) and [Dataset.repartition](../Dataset.md#repartition) operators (with [shuffle](#shuffle) disabled and enabled, respectively)
* `COALESCE` and `REPARTITION` hints (via [ResolveCoalesceHints](../logical-analysis-rules/ResolveCoalesceHints.md) logical analysis rule, with [shuffle](#shuffle) disabled and enabled, respectively)

## Query Planning

`Repartition` is planned to the following physical operators based on [shuffle](#shuffle) flag:

* [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md) with `shuffle` enabled
* [CoalesceExec](../physical-operators/CoalesceExec.md) with `shuffle` disabled

## Catalyst DSL

[Catalyst DSL](../catalyst-dsl/index.md) defines the following operators to create a `Repartition` logical operator:

* [coalesce](../catalyst-dsl/index.md#coalesce) (with [shuffle](#shuffle) disabled)
* [repartition](../catalyst-dsl/index.md#repartition) (with [shuffle](#shuffle) enabled)

## <span id="partitioning"> Partitioning

```scala
partitioning: Partitioning
```

`partitioning` uses the [numPartitions](#numPartitions) to determine the [Partitioning](../physical-operators/Partitioning.md):

* [SinglePartition](../physical-operators/Partitioning.md#SinglePartition) for `1`
* [RoundRobinPartitioning](../physical-operators/Partitioning.md#RoundRobinPartitioning) otherwise

---

`partitioning` requires that the [shuffle](#shuffle) flag is enabled or throws an exception:

```text
Partitioning can only be used in shuffle.
```

---

`partitioning` is part of the [RepartitionOperation](RepartitionOperation.md#partitioning) abstraction.
