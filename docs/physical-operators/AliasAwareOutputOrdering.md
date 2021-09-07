# AliasAwareOutputOrdering Unary Physical Operators

`AliasAwareOutputOrdering` is an [extension](#contract) of the [AliasAwareOutputExpression](AliasAwareOutputExpression.md) abstraction for [unary physical operators](#implementations) with [alias-aware ordering expressions](#orderingExpressions).

## Contract

### <span id="orderingExpressions"> Ordering Expressions

```scala
orderingExpressions: Seq[SortOrder]
```

[SortOrder](../expressions/SortOrder.md) expressions

Used when:

* `AliasAwareOutputOrdering` is requested for the [output ordering](#outputOrdering)

## Implementations

* [ProjectExec](ProjectExec.md)
* [SortAggregateExec](SortAggregateExec.md)

## <span id="outputOrdering"> Output Data Ordering Requirements

```scala
outputOrdering: Seq[SortOrder]
```

`outputOrdering`...FIXME

`outputOrdering` is part of the [SparkPlan](SparkPlan.md#outputOrdering) abstraction.
