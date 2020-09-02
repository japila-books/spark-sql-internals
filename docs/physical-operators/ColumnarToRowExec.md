# ColumnarToRowExec Physical Operator

`ColumnarToRowExec` is a [unary physical operator](UnaryExecNode.md) with [CodegenSupport](CodegenSupport.md).

## Creating Instance

`ColumnarToRowExec` takes the following to be created:

* <span id="child"> Child [physical operator](SparkPlan.md)

`ColumnarToRowExec` is created when [ApplyColumnarRulesAndInsertTransitions](../physical-optimizations/ApplyColumnarRulesAndInsertTransitions.md) physical optimization is executed.
