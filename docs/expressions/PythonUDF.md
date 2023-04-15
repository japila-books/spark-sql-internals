---
title: PythonUDF
---

# PythonUDF Expression

`PythonUDF` is an [Expression](Expression.md) that is [unevaluable](Unevaluable.md) and a `NonSQLExpression`.

`PythonUDF` is a [UserDefinedExpression](UserDefinedExpression.md) expression.

## Creating Instance

`PythonUDF` takes the following to be created:

* <span id="name"> Name
* <span id="func"> `PythonFunction`
* <span id="dataType"> [DataType](../types/DataType.md)
* <span id="children"> Children [Expression](Expression.md)s
* [Eval Type](#evalType)
* <span id="udfDeterministic"> `udfDeterministic` flag
* <span id="resultId"> Result `ExprId`

`PythonUDF` is created when:

* `SparkConnectPlanner` is requested to [transformPythonUDF](../connect/SparkConnectPlanner.md#transformPythonUDF)
* `UserDefinedPythonFunction` is requested to [builder](../user-defined-functions/UserDefinedPythonFunction.md#builder)

### evalType { #evalType }

`PythonUDF` is given an eval type when [created](#creating-instance).

## nodePatterns { #nodePatterns }

??? note "TreeNode"

    ```scala
    nodePatterns: Seq[TreePattern]
    ```

    `nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.

`nodePatterns` is [PYTHON_UDF](../catalyst/TreePattern.md#PYTHON_UDF).

## nullable { #nullable }

??? note "Expression"

    ```scala
    nullable: Boolean
    ```

    `nullable` is part of the [Expression](Expression.md#nullable) abstraction.

`nullable` is always `true`.
