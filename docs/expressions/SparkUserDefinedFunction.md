# SparkUserDefinedFunction

`SparkUserDefinedFunction` is a [UserDefinedFunction](UserDefinedFunction.md).

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
* [udf](../spark-sql-functions.md#udf) standard function is used
* `UDFRegistration` is requested to [register a named user-defined function](../UDFRegistration.md#register)

## <span id="createScalaUDF"> createScalaUDF

```scala
createScalaUDF(
  exprs: Seq[Expression]): ScalaUDF
```

`createScalaUDF` creates a [ScalaUDF](ScalaUDF.md) expression.

---

`createScalaUDF` is used when:

* `UDFRegistration` is requested to [register a named user-defined function](../UDFRegistration.md#register)
* `SparkUserDefinedFunction` is requested to [create a Column](#apply)
