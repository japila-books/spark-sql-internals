---
title: RowToColumnarExec
---

# RowToColumnarExec Physical Operator

`RowToColumnarExec` is a `RowToColumnarTransition` for [Columnar Execution](../columnar-execution/index.md).

`RowToColumnarExec` is the opposite of [ColumnarToRowExec](ColumnarToRowExec.md) physical operator.

## Creating Instance

`RowToColumnarExec` takes the following to be created:

* <span id="child"> Child [SparkPlan](SparkPlan.md)

`RowToColumnarExec` is created when:

* [ApplyColumnarRulesAndInsertTransitions](../physical-optimizations/ApplyColumnarRulesAndInsertTransitions.md) physical optimization is executed
