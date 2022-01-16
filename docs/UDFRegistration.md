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
