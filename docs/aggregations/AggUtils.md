---
title: AggUtils
---

# AggUtils Utility

`AggUtils` is an utility for [Aggregation](../execution-planning-strategies/Aggregation.md) execution planning strategy.

## <span id="planAggregateWithoutDistinct"> planAggregateWithoutDistinct

```scala
planAggregateWithoutDistinct(
  groupingExpressions: Seq[NamedExpression],
  aggregateExpressions: Seq[AggregateExpression],
  resultExpressions: Seq[NamedExpression],
  child: SparkPlan): Seq[SparkPlan]
```

`planAggregateWithoutDistinct` is a two-step physical operator generator.

`planAggregateWithoutDistinct` first [creates an aggregate physical operator](#createAggregate) with `aggregateExpressions` in `Partial` mode (for partial aggregations).

!!! NOTE
    `requiredChildDistributionExpressions` for the aggregate physical operator for partial aggregation "stage" is empty.

In the end, `planAggregateWithoutDistinct` [creates another aggregate physical operator](#createAggregate) (of the same type as before), but `aggregateExpressions` are now in `Final` mode (for final aggregations). The aggregate physical operator becomes the parent of the first aggregate operator.

!!! NOTE
    `requiredChildDistributionExpressions` for the parent aggregate physical operator for final aggregation "stage" are the [Attribute](../expressions/Attribute.md)s of the `groupingExpressions`.

## <span id="planAggregateWithOneDistinct"> planAggregateWithOneDistinct

```scala
planAggregateWithOneDistinct(
  groupingExpressions: Seq[NamedExpression],
  functionsWithDistinct: Seq[AggregateExpression],
  functionsWithoutDistinct: Seq[AggregateExpression],
  resultExpressions: Seq[NamedExpression],
  child: SparkPlan): Seq[SparkPlan]
```

`planAggregateWithOneDistinct`...FIXME

## <span id="createAggregate"> Creating Physical Operator for Aggregation

```scala
createAggregate(
  requiredChildDistributionExpressions: Option[Seq[Expression]] = None,
  groupingExpressions: Seq[NamedExpression] = Nil,
  aggregateExpressions: Seq[AggregateExpression] = Nil,
  aggregateAttributes: Seq[Attribute] = Nil,
  initialInputBufferOffset: Int = 0,
  resultExpressions: Seq[NamedExpression] = Nil,
  child: SparkPlan): SparkPlan
```

`createAggregate` creates one of the following [physical operator](../physical-operators/SparkPlan.md)s based on the given [AggregateExpression](../expressions/AggregateExpression.md)s (in the following order):

1. [HashAggregateExec](../physical-operators/HashAggregateExec.md) when all the [aggBufferAttributes](../expressions/AggregateFunction.md#aggBufferAttributes) (of the [AggregateFunction](../expressions/AggregateFunction.md)s of the given [AggregateExpression](../expressions/AggregateExpression.md)s) are [supported](../logical-operators/Aggregate.md#supportsHashAggregate)

1. [ObjectHashAggregateExec](../physical-operators/ObjectHashAggregateExec.md) when the following all hold:
    * [spark.sql.execution.useObjectHashAggregateExec](../configuration-properties.md#spark.sql.execution.useObjectHashAggregateExec) configuration property is enabled
    * [Aggregate expression supported](../physical-operators/ObjectHashAggregateExec.md#supportsAggregate)

1. [SortAggregateExec](../physical-operators/SortAggregateExec.md)

---

`createAggregate` is used when:

* `AggUtils` is used to [createStreamingAggregate](#createStreamingAggregate), [planAggregateWithoutDistinct](#planAggregateWithoutDistinct), [planAggregateWithOneDistinct](#planAggregateWithOneDistinct)

## <span id="planStreamingAggregation"> Planning Execution of Streaming Aggregation

```scala
planStreamingAggregation(
  groupingExpressions: Seq[NamedExpression],
  functionsWithoutDistinct: Seq[AggregateExpression],
  resultExpressions: Seq[NamedExpression],
  stateFormatVersion: Int,
  child: SparkPlan): Seq[SparkPlan]
```

`planStreamingAggregation`...FIXME

---

`planStreamingAggregation` is used when:

* `StatefulAggregationStrategy` ([Spark Structured Streaming]({{ book.structured_streaming }}/StatefulAggregationStrategy)) execution planning strategy is requested to plan a logical plan of a streaming aggregation (a streaming query with [Aggregate](../logical-operators/Aggregate.md) operator)

## <span id="createStreamingAggregate"> Creating Streaming Aggregate Physical Operator

```scala
createStreamingAggregate(
  requiredChildDistributionExpressions: Option[Seq[Expression]] = None,
  groupingExpressions: Seq[NamedExpression] = Nil,
  aggregateExpressions: Seq[AggregateExpression] = Nil,
  aggregateAttributes: Seq[Attribute] = Nil,
  initialInputBufferOffset: Int = 0,
  resultExpressions: Seq[NamedExpression] = Nil,
  child: SparkPlan): SparkPlan
```

`createStreamingAggregate` [creates an aggregate physical operator](#createAggregate) (with `isStreaming` flag enabled).

!!! note
    `createStreamingAggregate` is exactly [createAggregate](#createAggregate) with `isStreaming` flag enabled.

---

`createStreamingAggregate` is used when:

* `AggUtils` is requested to plan a [regular](#planStreamingAggregation) and [session-windowed](#planStreamingAggregationForSession) streaming aggregation
