# AliasAwareOutputPartitioning Unary Physical Operators

`AliasAwareOutputPartitioning` is an extension of the [AliasAwareOutputExpression](AliasAwareOutputExpression.md) abstraction for [unary physical operators](#implementations) with [alias-aware output partitioning](#outputPartitioning).

## Implementations

* [BaseAggregateExec](BaseAggregateExec.md)
* [ProjectExec](ProjectExec.md)

## <span id="outputPartitioning"> Output Data Partitioning Requirements

```scala
outputPartitioning: Partitioning
```

`outputPartitioning`...FIXME

`outputPartitioning` is part of the [SparkPlan](SparkPlan.md#outputPartitioning) abstraction.
