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

## <span id="output"> Output Attributes

```scala
output: Seq[Attribute]
```

`output` simply requests the [child](LogicalPlan.md#UnaryNode) logical operator for the [output attributes](../catalyst/QueryPlan.md#output).

`output` is part of the [QueryPlan](../catalyst/QueryPlan.md#output) abstraction.

## Repartition Logical Operator

`Repartition` is a concrete [RepartitionOperation](RepartitionOperation.md) that takes the following to be created:

* <span id="Repartition-numPartitions"> Number of Partitions (must be positive)
* <span id="Repartition-shuffle"> [shuffle](#shuffle) flag
* <span id="Repartition-child"> [Child Logical Plan](LogicalPlan.md)

`Repartition` is created for the following:

* [Dataset.coalesce](../spark-sql-Dataset.md#coalesce) and [Dataset.repartition](../spark-sql-Dataset.md#repartition) operators (with [shuffle](#shuffle) disabled and enabled, respectively)
* `COALESCE` and `REPARTITION` hints (via [ResolveCoalesceHints](../logical-analysis-rules/ResolveCoalesceHints.md) logical analysis rule, with [shuffle](#shuffle) disabled and enabled, respectively)

`Repartition` is planned to [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md) or [CoalesceExec](../physical-operators/CoalesceExec.md) physical operators (based on [shuffle](#shuffle) flag).

### <span id="Repartition-catalyst-dsl> Catalyst DSL

[Catalyst DSL](../spark-sql-catalyst-dsl.md) defines the following operators to create `Repartition` logical operators:

* [coalesce](../spark-sql-catalyst-dsl.md#coalesce) (with [shuffle](#shuffle) disabled)
* [repartition](../spark-sql-catalyst-dsl.md#repartition) (with [shuffle](#shuffle) enabled)

## RepartitionByExpression Logical Operator

`RepartitionByExpression` is a concrete [RepartitionOperation](RepartitionOperation.md) that takes the following to be created:

* <span id="RepartitionByExpression-partitionExpressions"> [Partition Expressions](../expressions/Expression.md)
* <span id="RepartitionByExpression-child"> [Child Logical Plan](LogicalPlan.md)
* <span id="RepartitionByExpression-numPartitions"> Number of Partitions (must be positive)

`RepartitionByExpression` is created for the following:

* [Dataset.repartition](../spark-sql-Dataset.md#repartition) and [Dataset.repartitionByRange](../spark-sql-Dataset.md#repartitionByRange) operators
* `COALESCE`, `REPARTITION` and `REPARTITION_BY_RANGE` hints (via [ResolveCoalesceHints](../logical-analysis-rules/ResolveCoalesceHints.md) logical analysis rule)
* `DISTRIBUTE BY` and `CLUSTER BY` SQL clauses (via [SparkSqlAstBuilder](../sql/SparkSqlAstBuilder.md#withRepartitionByExpression))

`RepartitionByExpression` is planned to [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md) physical operator.

### <span id="RepartitionByExpression-catalyst-dsl> Catalyst DSL

[Catalyst DSL](../spark-sql-catalyst-dsl.md) defines [distribute](../spark-sql-catalyst-dsl.md#distribute) operator to create `RepartitionByExpression` logical operators.

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
