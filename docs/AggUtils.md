# AggUtils Utility

`AggUtils` is an utility for [Aggregation](execution-planning-strategies/Aggregation.md) execution planning strategy.

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
    `requiredChildDistributionExpressions` for the parent aggregate physical operator for final aggregation "stage" are the [Attribute](expressions/Attribute.md)s of the `groupingExpressions`.

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

`createAggregate` creates a [physical operator](physical-operators/SparkPlan.md) for the given [AggregateExpression](expressions/AggregateExpression.md)s in the following order:

1. Selects [HashAggregateExec](physical-operators/HashAggregateExec.md) for `AggregateExpression`s with [AggregateFunction](expressions/AggregateFunction.md)s with [aggBufferAttributes supported](physical-operators/HashAggregateExec.md#supportsAggregate)

1. Selects [ObjectHashAggregateExec](physical-operators/ObjectHashAggregateExec.md) when the following all hold:
    * [spark.sql.execution.useObjectHashAggregateExec](configuration-properties.md#spark.sql.execution.useObjectHashAggregateExec) configuration property is enabled
    * [Aggregate expression supported](physical-operators/ObjectHashAggregateExec.md#supportsAggregate)

1. [SortAggregateExec](physical-operators/SortAggregateExec.md)

`createAggregate` is used when:

* `AggUtils` is used to [planAggregateWithoutDistinct](#planAggregateWithoutDistinct), [planAggregateWithOneDistinct](#planAggregateWithOneDistinct), and `planStreamingAggregation`
