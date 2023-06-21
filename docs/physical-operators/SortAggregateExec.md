---
title: SortAggregateExec
---

# SortAggregateExec Aggregate Unary Physical Operator

`SortAggregateExec` is an [AggregateCodegenSupport](AggregateCodegenSupport.md) physical operator for **Sort-Based Aggregation** that uses [SortBasedAggregationIterator](../aggregations/SortBasedAggregationIterator.md) (to iterate over [UnsafeRow](../UnsafeRow.md)s in partitions) when [executed](#doExecute).

![SortAggregateExec in web UI (Details for Query)](../images/SortAggregateExec-webui-details-for-query.png)

`SortAggregateExec` is an [OrderPreservingUnaryExecNode](OrderPreservingUnaryExecNode.md).

## Creating Instance

`SortAggregateExec` takes the following to be created:

* <span id="requiredChildDistributionExpressions"> Required Child Distribution
* <span id="isStreaming"> `isStreaming` flag
* <span id="numShufflePartitions"> Number of Shuffle Partitions
* <span id="groupingExpressions"> Grouping Keys ([NamedExpression](../expressions/NamedExpression.md)s)
* <span id="aggregateExpressions"> Aggregates ([AggregateExpression](../expressions/AggregateExpression.md)s)
* <span id="aggregateAttributes"> Aggregate [Attribute](../expressions/Attribute.md)s
* <span id="initialInputBufferOffset"> Initial Input Buffer Offset
* <span id="resultExpressions"> Result ([NamedExpression](../expressions/NamedExpression.md)s)
* <span id="child"> Child [Physical Operator](SparkPlan.md)

`SortAggregateExec` is created when:

* `AggUtils` utility is used to [create a physical operator for aggregation](../aggregations/AggUtils.md#createAggregate)

## Performance Metrics { #metrics }

### number of output rows { #numOutputRows }

## Whole-Stage Code Generation

As an [AggregateCodegenSupport](AggregateCodegenSupport.md) physical operator, `SortAggregateExec` supports [Whole-Stage Code Generation](../whole-stage-code-generation/index.md) only when [supportCodegen](#supportCodegen) flag is enabled.

## Executing Physical Operator { #doExecute }

??? note "SparkPlan"

    ```scala
    doExecute(): RDD[InternalRow]
    ```

    `doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute` requests the [child physical operator](#child) to [execute](SparkPlan.md#execute) (that triggers physical query planning and generates an `RDD[InternalRow]`).

`doExecute` transforms the `RDD[InternalRow]` with the [transformation `f` function](#doExecute-mapPartitionsWithIndex) for every partition (using [RDD.mapPartitionsWithIndex](#mapPartitionsWithIndex) transformation).

!!! note
    This is exactly as in [HashAggregateExec](HashAggregateExec.md#doExecute).

### Transformation Function { #doExecute-mapPartitionsWithIndex }

`doExecute` uses [RDD.mapPartitionsWithIndex](#mapPartitionsWithIndex) to process partition [InternalRow](../InternalRow.md)s (with a partition ID).

```scala
// (partition ID, partition rows)
f: (Int, Iterator[T]) => Iterator[U]
```

For every partition, `mapPartitionsWithIndex`...FIXME

!!! note
    This is exactly as in [HashAggregateExec](HashAggregateExec.md#doExecute) except that `SortAggregateExec` uses [SortBasedAggregationIterator](../aggregations/SortBasedAggregationIterator.md).

### supportCodegen { #supportCodegen }

??? note "AggregateCodegenSupport"

    ```scala
    supportCodegen: Boolean
    ```

    `supportCodegen` is part of the [AggregateCodegenSupport](AggregateCodegenSupport.md#supportCodegen) abstraction.

`supportCodegen` is enabled (`true`) when all the following hold:

* The parent [supportCodegen](AggregateCodegenSupport.md#supportCodegen) is enabled
* [spark.sql.codegen.aggregate.sortAggregate.enabled](../configuration-properties.md#spark.sql.codegen.aggregate.sortAggregate.enabled) is enabled
* No [grouping keys](#groupingExpressions)

## Required Child Ordering { #requiredChildOrdering }

??? note "SparkPlan"

    ```scala
    requiredChildOrdering: Seq[Seq[SortOrder]]
    ```

    `requiredChildOrdering` is part of the [SparkPlan](SparkPlan.md#requiredChildOrdering) abstraction.

`requiredChildOrdering` is [SortOrder](../expressions/SortOrder.md)s in `Ascending` direction for every [grouping key](#groupingExpressions).

## Ordering Expressions { #orderingExpressions }

??? note "AliasAwareQueryOutputOrdering"

    ```scala
    orderingExpressions: Seq[SortOrder]
    ```

    `orderingExpressions` is part of the [AliasAwareQueryOutputOrdering](AliasAwareQueryOutputOrdering.md#orderingExpressions) abstraction.

`orderingExpressions` is [SortOrder](../expressions/SortOrder.md)s in `Ascending` direction for every [grouping key](#groupingExpressions).

## Demo

Let's disable preference for [ObjectHashAggregateExec](ObjectHashAggregateExec.md) physical operator (using the [spark.sql.execution.useObjectHashAggregateExec](../configuration-properties.md#spark.sql.execution.useObjectHashAggregateExec) configuration property).

```scala
spark.conf.set("spark.sql.execution.useObjectHashAggregateExec", false)
assert(spark.sessionState.conf.useObjectHashAggregation == false)
```

```scala
val names = Seq(
  (0, "zero"),
  (1, "one"),
  (2, "two")).toDF("num", "name")
```

Let's use [immutable](../UnsafeRow.md#isMutable) data types for `aggregateBufferAttributes` (so [HashAggregateExec](HashAggregateExec.md) physical operator will not be selected).

```scala
val q = names
  .withColumn("initial", substring('name, 0, 1))
  .groupBy('initial)
  .agg(collect_set('initial))
```

=== "Scala"

    ```scala
    q.explain
    ```

```text
== Physical Plan ==
SortAggregate(key=[initial#160], functions=[collect_set(initial#160, 0, 0)])
+- *(2) Sort [initial#160 ASC NULLS FIRST], false, 0
   +- Exchange hashpartitioning(initial#160, 200), ENSURE_REQUIREMENTS, [id=#122]
      +- SortAggregate(key=[initial#160], functions=[partial_collect_set(initial#160, 0, 0)])
         +- *(1) Sort [initial#160 ASC NULLS FIRST], false, 0
            +- *(1) LocalTableScan [initial#160]
```

```scala
import q.queryExecution.optimizedPlan
import org.apache.spark.sql.catalyst.plans.logical.Aggregate
val aggLog = optimizedPlan.asInstanceOf[Aggregate]
import org.apache.spark.sql.catalyst.planning.PhysicalAggregation
import org.apache.spark.sql.catalyst.expressions.aggregate.AggregateExpression
val (_, aggregateExpressions: Seq[AggregateExpression], _, _) = PhysicalAggregation.unapply(aggLog).get
val aggregateBufferAttributes =
  aggregateExpressions.flatMap(_.aggregateFunction.aggBufferAttributes)
```

```scala
import org.apache.spark.sql.execution.aggregate.HashAggregateExec
assert(HashAggregateExec.supportsAggregate(aggregateBufferAttributes) == false)
```
