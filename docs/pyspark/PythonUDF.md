# PythonUDF

`PythonUDF` is an [Catalyst expression](../expressions/Expression.md).

## Creating Instance

`PythonUDF` takes the following to be created:

* <span id="name"> Name
* <span id="func"> `PythonFunction`
* <span id="dataType"> [DataType](../DataType.md)
* <span id="children"> Children Catalyst [Expression](../expressions/Expression.md)s
* <span id="evalType"> Python Eval Type
* <span id="udfDeterministic"> `udfDeterministic` flag
* <span id="resultId"> Result ID (`ExprId`)

`PythonUDF` is created when:

* `UserDefinedPythonFunction` is requested to [builder](UserDefinedPythonFunction.md#builder)

## Unevaluable

`PythonUDF` is an [Unevaluable](../expressions/Unevaluable.md) expression.

## NonSQLExpression

`PythonUDF` is a [NonSQLExpression](../expressions/NonSQLExpression.md) expression.

## UserDefinedExpression

`PythonUDF` is a [UserDefinedExpression](../expressions/UserDefinedExpression.md) expression.
