# AggUtils Utility

`AggUtils` is a Scala object that defines the methods used exclusively when [Aggregation](execution-planning-strategies/Aggregation.md) execution planning strategy is executed.

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

## <span id="createAggregate"> createAggregate

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

`createAggregate` creates a [physical operator](physical-operators/SparkPlan.md) given the input `aggregateExpressions` [aggregate expressions](expressions/AggregateExpression.md).

[[aggregate-physical-operator-selection-criteria]]
.createAggregate's Aggregate Physical Operator Selection Criteria (in execution order)
[cols="1,2",options="header",width="100%"]
|===
| Aggregate Physical Operator
| Selection Criteria

| HashAggregateExec.md[HashAggregateExec]
a| `HashAggregateExec` HashAggregateExec.md#supportsAggregate[supports] all `aggBufferAttributes` of the input `aggregateExpressions` [aggregate expressions](expressions/AggregateExpression.md).

| ObjectHashAggregateExec.md[ObjectHashAggregateExec]
a|

* [spark.sql.execution.useObjectHashAggregateExec](configuration-properties.md#spark.sql.execution.useObjectHashAggregateExec) internal flag enabled (it is by default)

* `ObjectHashAggregateExec` [supports](physical-operators/ObjectHashAggregateExec.md#supportsAggregate) the input `aggregateExpressions` [aggregate expressions](expressions/AggregateExpression.md).

| SortAggregateExec.md[SortAggregateExec]
| When all the above requirements could not be met.
|===
