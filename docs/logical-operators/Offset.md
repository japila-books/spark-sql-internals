---
title: Offset
---

# Offset Logical Operator

`Offset` is an [OrderPreservingUnaryNode](OrderPreservingUnaryNode.md) that can skip the [specified number of rows](#offsetExpr) (_offset_) from the beginning of the output of the [child logical operator](#child).

??? note "Spark Structured Streaming"
    `Offset` is not supported on streaming DataFrames/Datasets.

## Creating Instance

`Offset` takes the following to be created:

* <span id="offsetExpr"> Offset [Expression](../expressions/Expression.md)
* <span id="child"> Child [Logical operator](LogicalPlan.md)

`Offset` is created when:

* `AstBuilder` is requested to [withQueryResultClauses](../sql/AstBuilder.md#withQueryResultClauses)
* [Dataset.offset](../Dataset.md#offset) operator is used

## Catalyst DSL

[Catalyst DSL](../catalyst-dsl/index.md) comes with [offset](../catalyst-dsl/DslLogicalPlan.md#offset) operator to create an `Offset`.

```scala
offset(
  offsetExpr: Expression): LogicalPlan
```

## Logical Optimizations

`Offset` is optimized using the following logical optimizations:

* `EliminateOffsets`
* [LimitPushDown](../logical-optimizations/LimitPushDown.md)
* [V2ScanRelationPushDown](../logical-optimizations/V2ScanRelationPushDown.md)

## Physical Planning

`Offset` is planned as either `GlobalLimitExec` or [CollectLimitExec](../physical-operators/CollectLimitExec.md) physical operators.

## maxRows { #maxRows }

??? note "LogicalPlan"

    ```scala
    maxRows: Option[Long]
    ```

    `maxRows` is part of the [LogicalPlan](LogicalPlan.md#maxRows) abstraction.

`maxRows`...FIXME
