---
title: Intersect
---

# Intersect Logical Operator

`Intersect` is a `SetOperation` binary logical operator that represents the following high-level operators in a logical plan:

* [INTERSECT](../sql/AstBuilder.md#visitSetOperation) SQL statement
* [Dataset.intersect](../Dataset.md#intersect) and [Dataset.intersectAll](../Dataset.md#intersectAll) operators

`Intersect` is replaced at [logical optimization](../logical-optimizations/index.md) phase (based on [isAll](#isAll) flag):

Logical Operators | Logical Optimization | isAll
-|-|-
Left Semi [Join](Join.md) | `ReplaceIntersectWithSemiJoin` | disabled
[Generate](Generate.md) over [Aggregate](Aggregate.md) over [Union](Union.md) | `RewriteIntersectAll` | enabled

??? note "Spark Structured Streaming Unsupported"
    `Intersect` is not supported on streaming DataFrames/Datasets (that is enforced by `UnsupportedOperationChecker` at [QueryExecution](../QueryExecution.md#assertSupported)).

## Creating Instance

`Intersect` takes the following to be created:

* <span id="left"> Left [LogicalPlan](LogicalPlan.md)
* <span id="right"> Right [LogicalPlan](LogicalPlan.md)
* <span id="isAll"> `isAll` flag

`Intersect` is created when:

* `AstBuilder` is requested to [parse INTERSECT statement](../sql/AstBuilder.md#visitSetOperation)
* [Dataset.intersect](../Dataset.md#intersect) operator is used ([isAll](#isAll) is `false`)
* [Dataset.intersectAll](../Dataset.md#intersectAll) operator is used ([isAll](#isAll) is `true`)

## Catalyst DSL

[Catalyst DSL](../catalyst-dsl/index.md) comes with [intersect](../catalyst-dsl/DslLogicalPlan.md#intersect) operator to create an `Intersect` operator.

```scala
intersect(
  otherPlan: LogicalPlan,
  isAll: Boolean): LogicalPlan
```
