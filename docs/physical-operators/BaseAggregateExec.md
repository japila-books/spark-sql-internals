# BaseAggregateExec &mdash; Aggregate Unary Physical Operators

`BaseAggregateExec` is an [extension](#contract) of the [UnaryExecNode](UnaryExecNode.md) abstraction for [aggregate unary physical operators](#implementations).

## Contract

### <span id="aggregateAttributes"> Aggregate Attributes

```scala
aggregateAttributes: Seq[Attribute]
```

Aggregate [Attribute](../expressions/Attribute.md)s

### <span id="aggregateExpressions"> Aggregate Functions

```scala
aggregateExpressions: Seq[AggregateExpression]
```

[AggregateExpression](../expressions/AggregateExpression.md)s

### <span id="groupingExpressions"> Grouping Keys

```scala
groupingExpressions: Seq[NamedExpression]
```

Grouping [NamedExpression](../expressions/NamedExpression.md)s

### <span id="requiredChildDistributionExpressions"> Required Child Distribution Expressions

```scala
requiredChildDistributionExpressions: Option[Seq[Expression]]
```

Used when:

* `BaseAggregateExec` is requested for the [requiredChildDistribution](#requiredChildDistribution)
* [DisableUnnecessaryBucketedScan](../physical-optimizations/DisableUnnecessaryBucketedScan.md) physical optimization is executed

### <span id="resultExpressions"> Results

```scala
resultExpressions: Seq[NamedExpression]
```

Result [NamedExpression](../expressions/NamedExpression.md)s

## Implementations

* [HashAggregateExec](HashAggregateExec.md)
* [ObjectHashAggregateExec](ObjectHashAggregateExec.md)
* [SortAggregateExec](SortAggregateExec.md)

## AliasAwareOutputPartitioning

`BaseAggregateExec` is an [AliasAwareOutputPartitioning](AliasAwareOutputPartitioning.md).

## <span id="verboseStringWithOperatorId"> Detailed Description (with Operator Id)

```scala
verboseStringWithOperatorId(): String
```

`verboseStringWithOperatorId` is part of the [QueryPlan](../catalyst/QueryPlan.md#verboseStringWithOperatorId) abstraction.

`verboseStringWithOperatorId` returns the following text (with the [formattedNodeName](../catalyst/QueryPlan.md#formattedNodeName) and the others):

```text
[formattedNodeName]
Input: [child.output]
Keys: [groupingExpressions]
Functions: [aggregateExpressions]
Aggregate Attributes: [aggregateAttributes]
Results: [resultExpressions]
```

## <span id="requiredChildDistribution"> Required Child Output Distribution

```scala
requiredChildDistribution: List[Distribution]
```

`requiredChildDistribution` is part of the [SparkPlan](SparkPlan.md#requiredChildDistribution) abstraction.

`requiredChildDistribution`...FIXME
