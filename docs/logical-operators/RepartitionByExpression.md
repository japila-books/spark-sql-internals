# RepartitionByExpression Logical Operator

`RepartitionByExpression` is a concrete [RepartitionOperation](RepartitionOperation.md).

`RepartitionByExpression` is also called **distribute** operator.

## Creating Instance

`RepartitionByExpression` takes the following to be created:

* <span id="partitionExpressions"> [Partition Expressions](../expressions/Expression.md)
* <span id="child"> Child [LogicalPlan](LogicalPlan.md)
* <span id="optNumPartitions"> Number of partitions

`RepartitionByExpression` is created when:

* [Dataset.repartition](../Dataset.md#repartition) and [Dataset.repartitionByRange](../Dataset.md#repartitionByRange) operators
* `COALESCE`, `REPARTITION` and `REPARTITION_BY_RANGE` hints (via [ResolveCoalesceHints](../logical-analysis-rules/ResolveCoalesceHints.md) logical analysis rule)
* `DISTRIBUTE BY` and `CLUSTER BY` SQL clauses (via [SparkSqlAstBuilder](../sql/SparkSqlAstBuilder.md#withRepartitionByExpression))

## Query Planning

`RepartitionByExpression` is planned to [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md) physical operator.

### <span id="catalyst-dsl"> Catalyst DSL

[Catalyst DSL](../catalyst-dsl/index.md) defines [distribute](../catalyst-dsl/index.md#distribute) operator to create `RepartitionByExpression` logical operators.

### <span id="partitioning"> Partitioning

`RepartitionByExpression` determines a [Partitioning](../physical-operators/Partitioning.md) when [created](#creating-instance).

### <span id="maxRows"> Maximum Number of Rows

```scala
maxRows: Option[Long]
```

`maxRows` simply requests the [child](LogicalPlan.md#UnaryNode) logical operator for the [maximum number of rows](LogicalPlan.md#maxRows).

`maxRows` is part of the [LogicalPlan](LogicalPlan.md#maxRows) abstraction.

### <span id="shuffle"> shuffle

```scala
shuffle: Boolean
```

`shuffle` is always `true`.

`shuffle` is part of the [RepartitionOperation](RepartitionOperation.md#shuffle) abstraction.
