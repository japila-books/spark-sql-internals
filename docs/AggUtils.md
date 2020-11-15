# AggUtils Utility

`AggUtils` is an utility for [Aggregation](execution-planning-strategies/Aggregation.md) execution planning strategy.

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

## <span id="planAggregateWithoutDistinct"> planAggregateWithoutDistinct

```scala
planAggregateWithoutDistinct(
  groupingExpressions: Seq[NamedExpression],
  aggregateExpressions: Seq[AggregateExpression],
  resultExpressions: Seq[NamedExpression],
  child: SparkPlan): Seq[SparkPlan]
```

`planAggregateWithoutDistinct` is a two-step physical operator generator.

`planAggregateWithoutDistinct` first <<AggUtils-createAggregate, creates an aggregate physical operator>> with `aggregateExpressions` in `Partial` mode (for partial aggregations).

NOTE: `requiredChildDistributionExpressions` for the aggregate physical operator for partial aggregation "stage" is empty.

In the end, `planAggregateWithoutDistinct` <<AggUtils-createAggregate, creates another aggregate physical operator>> (of the same type as before), but `aggregateExpressions` are now in `Final` mode (for final aggregations). The aggregate physical operator becomes the parent of the first aggregate operator.

NOTE: `requiredChildDistributionExpressions` for the parent aggregate physical operator for final aggregation "stage" are the spark-sql-Expression-Attribute.md[attributes] of `groupingExpressions`.

## <span id="createAggregate"> Selecting Physical Operator for Aggregation

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

`createAggregate` creates a [physical operator](physical-operators/SparkPlan.md) given the input `aggregateExpressions` [aggregate expressions](expressions/AggregateExpression.md):

* [HashAggregateExec](physical-operators/HashAggregateExec.md)
* [ObjectHashAggregateExec](physical-operators/ObjectHashAggregateExec.md)
* [SortAggregateExec](physical-operators/SortAggregateExec.md)

`createAggregate` is used when `AggUtils` is used to [planAggregateWithoutDistinct](#planAggregateWithoutDistinct), [planAggregateWithOneDistinct](#planAggregateWithOneDistinct), and `planStreamingAggregation`.
