# UDFRegistration

`UDFRegistration` is a facade to a session-scoped [FunctionRegistry](#functionRegistry) to register user-defined functions (UDFs) and user-defined aggregate functions (UDAFs).

## Creating Instance

`UDFRegistration` takes the following to be created:

* <span id="functionRegistry"> [FunctionRegistry](../FunctionRegistry.md)

`UDFRegistration` is created when:

* `BaseSessionStateBuilder` is requested for the [UDFRegistration](../BaseSessionStateBuilder.md#udfRegistration)

## Accessing UDFRegistration

`UDFRegistration` is available as [SparkSession.udf](../SparkSession.md#udf).

```scala
import org.apache.spark.sql.UDFRegistration
assert(spark.udf.isInstanceOf[UDFRegistration])
```

## <span id="SessionState"> SessionState

`UDFRegistration` is used to [create a SessionState](../SessionState.md#UDFRegistration).

## <span id="register"> Registering UserDefinedFunction

```scala
register(
  name: String,
  udf: UserDefinedFunction): UserDefinedFunction
```

`register` [associates the given name](../expressions/UserDefinedFunction.md#withName) with the given [UserDefinedFunction](../expressions/UserDefinedFunction.md).

`register` requests the [FunctionRegistry](#functionRegistry) to [createOrReplaceTempFunction](../FunctionRegistryBase.md#createOrReplaceTempFunction) under the given name and with `scala_udf` source name and a function builder based on the type of the `UserDefinedFunction`:

* For [UserDefinedAggregator](../expressions/UserDefinedAggregator.md)s, the function builder requests the `UserDefinedAggregator` for a [ScalaAggregator](../expressions/UserDefinedAggregator.md#scalaAggregator)
* For all other types, the function builder requests the `UserDefinedFunction` for a [Column](../expressions/UserDefinedFunction.md#apply) and takes the [Expression](../Column.md#expr)

## Registering User-Defined Python Function { #registerPython }

```scala
registerPython(
  name: String,
  udf: UserDefinedPythonFunction): Unit
```

`registerPython` prints out the following DEBUG message to the logs:

```text
Registering new PythonUDF:
name: [name]
command: [command]
envVars: [envVars]
pythonIncludes: [pythonIncludes]
pythonExec: [pythonExec]
dataType: [dataType]
pythonEvalType: [pythonEvalType]
udfDeterministic: [udfDeterministic]
```

In the end, requests the [FunctionRegistry](#functionRegistry) to [createOrReplaceTempFunction](../FunctionRegistryBase.md#createOrReplaceTempFunction) (under the given name, the [builder](UserDefinedPythonFunction.md#builder) factory and `python_udf` source name).

---

`registerPython` is used when:

* `UDFRegistration` ([PySpark]({{ book.pyspark }}/sql/UDFRegistration)) is requested to `register`

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.UDFRegistration` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
logger.UDFRegistration.name = org.apache.spark.sql.UDFRegistration
logger.UDFRegistration.level = all
```

Refer to [Logging](../spark-logging.md).
