---
title: RepartitionOperation
---

# RepartitionOperation Unary Logical Operators

`RepartitionOperation` is an [extension](#contract) of the [UnaryNode](LogicalPlan.md#UnaryNode) abstraction for [repartition operations](#implementations).

## Contract

### <span id="shuffle"> shuffle

```scala
shuffle: Boolean
```

### <span id="numPartitions"> Number of Partitions

```scala
numPartitions: Int
```

### <span id="partitioning"> Partitioning

```scala
partitioning: Partitioning
```

[Partitioning](../physical-operators/Partitioning.md)

## Implementations

* [Repartition](Repartition.md)
* [RepartitionByExpression](RepartitionByExpression.md)

## Logical Optimizations

* [CollapseRepartition](../catalyst/Optimizer.md#CollapseRepartition) logical optimization collapses adjacent repartition operations

* Repartition operations allow [FoldablePropagation](../catalyst/Optimizer.md#FoldablePropagation) and [PushDownPredicate](../logical-optimizations/PushDownPredicate.md) logical optimizations to "push through"

* [PropagateEmptyRelation](../logical-optimizations/PropagateEmptyRelation.md) logical optimization may result in an empty [LocalRelation](LocalRelation.md) for repartition operations

## <span id="output"> Output Attributes

```scala
output: Seq[Attribute]
```

`output` simply requests the [child](LogicalPlan.md#UnaryNode) logical operator for the [output attributes](../catalyst/QueryPlan.md#output).

`output` is part of the [QueryPlan](../catalyst/QueryPlan.md#output) abstraction.

## Demo: Coalesce Operator

```text
val numsCoalesced = nums.coalesce(numPartitions = 4)
assert(numsCoalesced.rdd.getNumPartitions == 4, "Number of partitions should be 4")

scala> numsCoalesced.explain(extended = true)
== Parsed Logical Plan ==
Repartition 4, false
+- Range (0, 5, step=1, splits=Some(16))

== Analyzed Logical Plan ==
id: bigint
Repartition 4, false
+- Range (0, 5, step=1, splits=Some(16))

== Optimized Logical Plan ==
Repartition 4, false
+- Range (0, 5, step=1, splits=Some(16))

== Physical Plan ==
Coalesce 4
+- *(1) Range (0, 5, step=1, splits=16)
```
