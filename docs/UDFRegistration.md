# UDFRegistration

`UDFRegistration` is a facade to a session-scoped [FunctionRegistry](#functionRegistry) to register user-defined functions (UDFs) and user-defined aggregate functions (UDAFs).

## Creating Instance

`UDFRegistration` takes the following to be created:

* <span id="functionRegistry"> [FunctionRegistry](FunctionRegistry.md)

`UDFRegistration` is created when:

* `BaseSessionStateBuilder` is requested for the [UDFRegistration](BaseSessionStateBuilder.md#udfRegistration)

## Accessing UDFRegistration

`UDFRegistration` is available using [SparkSession.udf](SparkSession.md#udf).

```scala
import org.apache.spark.sql.SparkSession
assert(spark.isInstanceOf[SparkSession])
```

```scala
import org.apache.spark.sql.UDFRegistration
assert(spark.udf.isInstanceOf[UDFRegistration])
```

## <span id="SessionState"> SessionState

`UDFRegistration` is used to [create a SessionState](SessionState.md#UDFRegistration).

## <span id="register"> Registering UserDefinedFunction

```scala
register(
  name: String,
  udf: UserDefinedFunction): UserDefinedFunction
```

`register` [associates the given name](expressions/UserDefinedFunction.md#withName) with the given [UserDefinedFunction](expressions/UserDefinedFunction.md).

`register` requests the [FunctionRegistry](#functionRegistry) to [createOrReplaceTempFunction](FunctionRegistryBase.md#createOrReplaceTempFunction) under the given name and with `scala_udf` source name and a function builder based on the type of the `UserDefinedFunction`:

* For [UserDefinedAggregator](expressions/UserDefinedAggregator.md)s, the function builder requests the `UserDefinedAggregator` for a [ScalaAggregator](expressions/UserDefinedAggregator.md#scalaAggregator)
* For all other types, the function builder requests the `UserDefinedFunction` for a [Column](expressions/UserDefinedFunction.md#apply) and takes the [Expression](Column.md#expr)
