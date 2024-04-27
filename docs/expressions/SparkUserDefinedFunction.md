# SparkUserDefinedFunction

`SparkUserDefinedFunction` is a [UserDefinedFunction](UserDefinedFunction.md) that uses [ScalaUDF](ScalaUDF.md) for execution.

`SparkUserDefinedFunction` is [created](#creating-instance) using [udf](../standard-functions/index.md#udaf) standard function (among the other _less interesting_ means).

## Creating Instance

`SparkUserDefinedFunction` takes the following to be created:

* <span id="f"> Scala Function
* <span id="dataType"> [DataType](../types/DataType.md)
* <span id="inputEncoders"> Input [ExpressionEncoder](../ExpressionEncoder.md)s
* <span id="outputEncoder"> Output [ExpressionEncoder](../ExpressionEncoder.md)
* <span id="name"> Name
* <span id="nullable"> `nullable` flag (default: `true`)
* <span id="deterministic"> `deterministic` flag (default: `true`)

`SparkUserDefinedFunction` is created when:

* `FPGrowthModel` (Spark MLlib) is requested to `genericTransform`
* [udf](../standard-functions/index.md#udf) standard function is used
* `UDFRegistration` is requested to [register a named user-defined function](../user-defined-functions/UDFRegistration.md#register)

## <span id="apply"> Creating Column (for Function Execution)

```scala
apply(
  exprs: Column*): Column
```

`apply` is part of the [UserDefinedFunction](UserDefinedFunction.md#apply) abstraction.

---

`apply` creates a [Column](../Column.md) with a [ScalaUDF](#createScalaUDF) (with the given `exprs`).

## <span id="createScalaUDF"> Creating ScalaUDF

```scala
createScalaUDF(
  exprs: Seq[Expression]): ScalaUDF
```

`createScalaUDF` creates a [ScalaUDF](ScalaUDF.md) expression.

---

`createScalaUDF` is used when:

* `UDFRegistration` is requested to [register a named user-defined function](../user-defined-functions/UDFRegistration.md#register)
* `SparkUserDefinedFunction` is requested to [create a Column (for function execution)](#apply)
