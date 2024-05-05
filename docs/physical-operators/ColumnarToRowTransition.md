---
title: ColumnarToRowTransition
---

# ColumnarToRowTransition Unary Physical Operators

`ColumnarToRowTransition` is a marker extension of the [UnaryExecNode](UnaryExecNode.md) abstraction for [unary physical operators](#implementations) that can transition from columns to rows (when [executed](SparkPlan.md#doExecute)).

!!! quote "Found in the source code"
    This allows plugins to replace the current [ColumnarToRowExec](ColumnarToRowExec.md) with an optimized version.

`ColumnarToRowTransition` type is explicitly checked while [ApplyColumnarRulesAndInsertTransitions](../physical-optimizations/ApplyColumnarRulesAndInsertTransitions.md) physical optimization is executed (to skip [insertTransitions](#insertTransitions)).

`ColumnarToRowTransition` is used for `InMemoryRelation` to [convertToColumnarIfPossible](../logical-operators/InMemoryRelation.md#convertToColumnarIfPossible) (when `CachedBatchSerializer` supports columnar input).

## Implementations

* [ColumnarToRowExec](ColumnarToRowExec.md)

## Whole-Stage Code Generation

`ColumnarToRowTransition` and [ApplyColumnarRulesAndInsertTransitions](../physical-optimizations/ApplyColumnarRulesAndInsertTransitions.md) physical optimization look similar to how [Whole-Stage Code Generation](../whole-stage-code-generation/index.md) works (with [WholeStageCodegen](WholeStageCodegenExec.md) and [InputAdapter](InputAdapter.md) physical operators).
