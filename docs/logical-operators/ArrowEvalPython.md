---
title: ArrowEvalPython
---

# ArrowEvalPython Logical Operator

`ArrowEvalPython` is a [BaseEvalPython](BaseEvalPython.md) logical operator to execute `PythonUDF`s with [`SQL_SCALAR_PANDAS_UDF` and `SQL_SCALAR_PANDAS_ITER_UDF` eval types](#evalType).

`ArrowEvalPython` is planned to `ArrowEvalPythonExec` physical operator (by `PythonEvals` execution planning strategy).

## Creating Instance

`ArrowEvalPython` takes the following to be created:

* <span id="udfs"> `PythonUDF`s
* <span id="resultAttrs"> Result [Attribute](../expressions/Attribute.md)s
* <span id="child"> Child [LogicalPlan](LogicalPlan.md)
* [PythonUDF Eval Type](#evalType)

`ArrowEvalPython` is created when:

* [ExtractPythonUDFs](../logical-optimizations/ExtractPythonUDFs.md) logical optimization is executed (with [`SQL_SCALAR_PANDAS_UDF` and `SQL_SCALAR_PANDAS_ITER_UDF` PythonUDFs](#evalType))

### PythonUDF Eval Type { #evalType }

`ArrowEvalPython` is given a `PythonUDF` eval type when [created](#creating-instance) that can be one of the two int values.

PythonEvalType | Int Value
---------------|----------
 `SQL_SCALAR_PANDAS_UDF` | 200
 `SQL_SCALAR_PANDAS_ITER_UDF` | 204

## Logical Optimizations

`ArrowEvalPython` is optimized using the following logical optimizations:

* `PushPredicateThroughNonJoin` (`canPushThrough`)
* [LimitPushDown](../logical-optimizations/LimitPushDown.md)
