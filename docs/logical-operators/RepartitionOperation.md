# RepartitionOperation Unary Logical Operators

`RepartitionOperation` is an [extension](#contract) of the [UnaryNode](LogicalPlan.md#UnaryNode) abstraction for [repartition operations](#implementations).

## Contract

### <span id="shuffle"> shuffle

```scala
shuffle: Boolean
```

### <span id="numPartitions"> numPartitions

```scala
numPartitions: Int
```

## Implementations

* [Repartition](#Repartition)
* [RepartitionByExpression](#RepartitionByExpression)

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

## <span id="Repartition"> Repartition Logical Operator

`Repartition` is a concrete [RepartitionOperation](RepartitionOperation.md) that takes the following to be created:

* <span id="Repartition-numPartitions"> Number of Partitions (must be positive)
* <span id="Repartition-shuffle"> [shuffle](#shuffle) flag
* <span id="Repartition-child"> [Child Logical Plan](LogicalPlan.md)

`Repartition` is created for the following:

* [Dataset.coalesce](../Dataset.md#coalesce) and [Dataset.repartition](../Dataset.md#repartition) operators (with [shuffle](#shuffle) disabled and enabled, respectively)
* `COALESCE` and `REPARTITION` hints (via [ResolveCoalesceHints](../logical-analysis-rules/ResolveCoalesceHints.md) logical analysis rule, with [shuffle](#shuffle) disabled and enabled, respectively)

`Repartition` is planned to [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md) or [CoalesceExec](../physical-operators/CoalesceExec.md) physical operators (based on [shuffle](#shuffle) flag).

### <span id="Repartition-catalyst-dsl"> Catalyst DSL

[Catalyst DSL](../catalyst-dsl/index.md) defines the following operators to create `Repartition` logical operators:

* [coalesce](../catalyst-dsl/index.md#coalesce) (with [shuffle](#shuffle) disabled)
* [repartition](../catalyst-dsl/index.md#repartition) (with [shuffle](#shuffle) enabled)

## <span id="RepartitionByExpression"> RepartitionByExpression Logical Operator

`RepartitionByExpression` is a concrete [RepartitionOperation](RepartitionOperation.md) that takes the following to be created:

* <span id="RepartitionByExpression-partitionExpressions"> [Partition Expressions](../expressions/Expression.md)
* <span id="RepartitionByExpression-child"> [Child Logical Plan](LogicalPlan.md)
* <span id="RepartitionByExpression-numPartitions"> Number of Partitions (must be positive)

`RepartitionByExpression` is also called **distribute** operator.

`RepartitionByExpression` is created for the following:

* [Dataset.repartition](../Dataset.md#repartition) and [Dataset.repartitionByRange](../Dataset.md#repartitionByRange) operators
* `COALESCE`, `REPARTITION` and `REPARTITION_BY_RANGE` hints (via [ResolveCoalesceHints](../logical-analysis-rules/ResolveCoalesceHints.md) logical analysis rule)
* `DISTRIBUTE BY` and `CLUSTER BY` SQL clauses (via [SparkSqlAstBuilder](../sql/SparkSqlAstBuilder.md#withRepartitionByExpression))

`RepartitionByExpression` is planned to [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md) physical operator.

### <span id="RepartitionByExpression-catalyst-dsl"> Catalyst DSL

[Catalyst DSL](../catalyst-dsl/index.md) defines [distribute](../catalyst-dsl/index.md#distribute) operator to create `RepartitionByExpression` logical operators.

### <span id="RepartitionByExpression-partitioning"> Partitioning

`RepartitionByExpression` determines a [Partitioning](../physical-operators/Partitioning.md) when created.

### <span id="RepartitionByExpression-maxRows"> Maximum Number of Rows

```scala
maxRows: Option[Long]
```

`maxRows` simply requests the [child](LogicalPlan.md#UnaryNode) logical operator for the [maximum number of rows](LogicalPlan.md#maxRows).

`maxRows` is part of the [LogicalPlan](LogicalPlan.md#maxRows) abstraction.

### <span id="RepartitionByExpression-shuffle"> shuffle

```scala
shuffle: Boolean
```

`shuffle` is always `true`.

`shuffle` is part of the [RepartitionOperation](RepartitionOperation.md#shuffle) abstraction.

## Demo

```text
val nums = spark.range(5)

scala> nums.rdd.getNumPartitions
res1: Int = 16
```

### Repartition Operator

```text
val numsRepartitioned = nums.repartition(numPartitions = 4)

assert(numsRepartitioned.rdd.getNumPartitions == 4, "Number of partitions should be 4")

scala> numsRepartitioned.explain(extended = true)
== Parsed Logical Plan ==
Repartition 4, true
+- Range (0, 5, step=1, splits=Some(16))

== Analyzed Logical Plan ==
id: bigint
Repartition 4, true
+- Range (0, 5, step=1, splits=Some(16))

== Optimized Logical Plan ==
Repartition 4, true
+- Range (0, 5, step=1, splits=Some(16))

== Physical Plan ==
Exchange RoundRobinPartitioning(4), false, [id=#31]
+- *(1) Range (0, 5, step=1, splits=16)
```

### Repartition Operator (Twice)

```text
val numsRepartitionedTwice = numsRepartitioned.repartition(numPartitions = 8)
assert(numsRepartitionedTwice.rdd.getNumPartitions == 8, "Number of partitions should be 4")

scala> numsRepartitionedTwice.explain(extended = true)
== Parsed Logical Plan ==
Repartition 8, true
+- Repartition 4, true
   +- Range (0, 5, step=1, splits=Some(16))

== Analyzed Logical Plan ==
id: bigint
Repartition 8, true
+- Repartition 4, true
   +- Range (0, 5, step=1, splits=Some(16))

== Optimized Logical Plan ==
Repartition 8, true
+- Range (0, 5, step=1, splits=Some(16))

== Physical Plan ==
Exchange RoundRobinPartitioning(8), false, [id=#77]
+- *(1) Range (0, 5, step=1, splits=16)
```

### Coalesce Operator

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

### RepartitionByExpression (Partition Expressions Only)

```text
val q = nums.repartition(partitionExprs = 'id % 2)
scala> q.explain(extended = true)
== Parsed Logical Plan ==
'RepartitionByExpression [('id % 2)], 200
+- Range (0, 5, step=1, splits=Some(16))

== Analyzed Logical Plan ==
id: bigint
RepartitionByExpression [(id#2L % cast(2 as bigint))], 200
+- Range (0, 5, step=1, splits=Some(16))

== Optimized Logical Plan ==
RepartitionByExpression [(id#2L % 2)], 200
+- Range (0, 5, step=1, splits=Some(16))

== Physical Plan ==
Exchange hashpartitioning((id#2L % 2), 200), false, [id=#86]
+- *(1) Range (0, 5, step=1, splits=16)
```

### RepartitionByExpression (Number of Partitions and Partition Expressions )

```text
val q = nums.repartition(numPartitions = 2, partitionExprs = 'id % 2)
scala> q.explain(extended = true)
== Parsed Logical Plan ==
'RepartitionByExpression [('id % 2)], 2
+- Range (0, 5, step=1, splits=Some(16))

== Analyzed Logical Plan ==
id: bigint
RepartitionByExpression [(id#2L % cast(2 as bigint))], 2
+- Range (0, 5, step=1, splits=Some(16))

== Optimized Logical Plan ==
RepartitionByExpression [(id#2L % 2)], 2
+- Range (0, 5, step=1, splits=Some(16))

== Physical Plan ==
Exchange hashpartitioning((id#2L % 2), 2), false, [id=#95]
+- *(1) Range (0, 5, step=1, splits=16)
```
