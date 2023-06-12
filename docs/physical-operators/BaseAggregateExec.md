# BaseAggregateExec Unary Physical Operators

`BaseAggregateExec` is an [extension](#contract) of the [UnaryExecNode](UnaryExecNode.md) abstraction for [aggregate unary physical operators](#implementations).

## Contract

### <span id="aggregateAttributes"> Aggregate Attributes

```scala
aggregateAttributes: Seq[Attribute]
```

Aggregate [Attribute](../expressions/Attribute.md)s

Used when:

* `AggregateCodegenSupport` is requested to [doProduceWithoutKeys](AggregateCodegenSupport.md#doProduceWithoutKeys)
* `BaseAggregateExec` is requested to [verboseStringWithOperatorId](#verboseStringWithOperatorId), [producedAttributes](#producedAttributes), [toSortAggregate](#toSortAggregate)

### <span id="aggregateExpressions"> Aggregate Functions

```scala
aggregateExpressions: Seq[AggregateExpression]
```

[AggregateExpression](../expressions/AggregateExpression.md)s

### <span id="groupingExpressions"> Grouping Keys

```scala
groupingExpressions: Seq[NamedExpression]
```

[NamedExpression](../expressions/NamedExpression.md)s of the grouping keys

### <span id="initialInputBufferOffset"> initialInputBufferOffset

```scala
initialInputBufferOffset: Int
```

### <span id="isStreaming"> isStreaming

```scala
isStreaming: Boolean
```

Used when:

* `BaseAggregateExec` is requested to [requiredChildDistribution](#requiredChildDistribution), [toSortAggregate](#toSortAggregate)

### <span id="numShufflePartitions"> numShufflePartitions

```scala
numShufflePartitions: Option[Int]
```

Used when:

* `BaseAggregateExec` is requested to [requiredChildDistribution](#requiredChildDistribution), [toSortAggregate](#toSortAggregate)

### <span id="requiredChildDistributionExpressions"> Required Child Distribution Expressions

```scala
requiredChildDistributionExpressions: Option[Seq[Expression]]
```

[Expression](../expressions/Expression.md)s

Used when:

* `BaseAggregateExec` is requested for the [requiredChildDistribution](#requiredChildDistribution)
* [DisableUnnecessaryBucketedScan](../physical-optimizations/DisableUnnecessaryBucketedScan.md) physical optimization is executed

### <span id="resultExpressions"> Result Expressions

```scala
resultExpressions: Seq[NamedExpression]
```

[NamedExpression](../expressions/NamedExpression.md)s of the result

## Implementations

* [HashAggregateExec](HashAggregateExec.md)
* [ObjectHashAggregateExec](ObjectHashAggregateExec.md)
* [SortAggregateExec](SortAggregateExec.md)

## PartitioningPreservingUnaryExecNode

`BaseAggregateExec` is an [PartitioningPreservingUnaryExecNode](PartitioningPreservingUnaryExecNode.md).

## <span id="verboseStringWithOperatorId"> Detailed Description (with Operator Id)

```scala
verboseStringWithOperatorId(): String
```

`verboseStringWithOperatorId` is part of the [QueryPlan](../catalyst/QueryPlan.md#verboseStringWithOperatorId) abstraction.

---

`verboseStringWithOperatorId` returns the following text (with the [formattedNodeName](../catalyst/QueryPlan.md#formattedNodeName) and the others):

```text
[formattedNodeName]
Input [size]: [output]
Keys [size]: [groupingExpressions]
Functions [size]: [aggregateExpressions]
Aggregate Attributes [size]: [aggregateAttributes]
Results [size]: [resultExpressions]
```

Field | Description
------|------------
 [formattedNodeName](../catalyst/QueryPlan.md#formattedNodeName) | `(operatorId) nodeName [codegen id : $id]`
 Input | [Output schema](../catalyst/QueryPlan.md#output) of the single child operator
 Keys | [Grouping Keys](#groupingExpressions)
 Functions | [Aggregate Functions](#aggregateExpressions)
 Aggregate Attributes | [Aggregate Attributes](#aggregateAttributes)
 Results | [Result Expressions](#resultExpressions)

## <span id="requiredChildDistribution"> Required Child Output Distribution

```scala
requiredChildDistribution: List[Distribution]
```

`requiredChildDistribution` is part of the [SparkPlan](SparkPlan.md#requiredChildDistribution) abstraction.

---

`requiredChildDistribution`...FIXME

## <span id="producedAttributes"> Produced Attributes (Schema)

```scala
producedAttributes: AttributeSet
```

`producedAttributes` is part of the [QueryPlan](../catalyst/QueryPlan.md#producedAttributes) abstraction.

---

`producedAttributes` is the following:

* [Aggregate Attributes](#aggregateAttributes)
* [Result Expressions](#resultExpressions) that are not [Grouping Keys](#groupingExpressions)
* [Aggregate Buffer Attributes](#aggregateBufferAttributes)
* [inputAggBufferAttributes](#inputAggBufferAttributes) without the [output attributes](../catalyst/QueryPlan.md#output) of the single child operator

## <span id="aggregateBufferAttributes"> Aggregate Buffer Attributes (Schema)

```scala
aggregateBufferAttributes: Seq[AttributeReference]
```

`aggregateBufferAttributes` is the [aggBufferAttributes](../expressions/AggregateFunction.md#aggBufferAttributes) of the [AggregateFunction](../expressions/AggregateExpression.md#aggregateFunction)s of all the [Aggregate Functions](#aggregateExpressions).

---

`aggregateBufferAttributes` is used when:

* `AggregateCodegenSupport` is requested to [supportCodegen](AggregateCodegenSupport.md#supportCodegen), [doProduceWithoutKeys](AggregateCodegenSupport.md#doProduceWithoutKeys)
* `BaseAggregateExec` is requested for the [produced attributes](#producedAttributes)
