# FunctionRegistryBase

`FunctionRegistryBase[T]` is an [abstraction](#contract) of [function registries](#implementations) for [registering functions](#registerFunction) (that produce a result of type `T`).

## Contract (Subset)

### <span id="lookupFunction"> lookupFunction

```scala
lookupFunction(
  name: FunctionIdentifier): Option[ExpressionInfo]
```

Looks up the `ExpressionInfo` metadata of a user-defined function by the given `name`

See [SimpleFunctionRegistryBase](SimpleFunctionRegistryBase.md#lookupFunction)

Used when:

* `FunctionRegistryBase` is requested to [check if a function exists](#functionExists)
* `SessionCatalog` is requested to [lookupBuiltinOrTempFunction](SessionCatalog.md#lookupBuiltinOrTempFunction), [lookupBuiltinOrTempTableFunction](SessionCatalog.md#lookupBuiltinOrTempTableFunction), [lookupPersistentFunction](SessionCatalog.md#lookupPersistentFunction)

### <span id="registerFunction"> Registering Named User-Defined Function

```scala
registerFunction(
  name: FunctionIdentifier,
  info: ExpressionInfo,
  builder: Seq[Expression] => T): Unit
registerFunction(
  name: FunctionIdentifier,
  builder: Seq[Expression] => T,
  source: String): Unit // (1)!
```

1. A final method that relays to the abstract `registerFunction`

Registers a user-defined function (written in Python, Scala or Java) under the given `name`

See:

* [SimpleFunctionRegistryBase](SimpleFunctionRegistryBase.md#registerFunction)

Used when:

* `FunctionRegistryBase` is requested to [createOrReplaceTempFunction](#createOrReplaceTempFunction)
* `SessionCatalog` is requested to [registerFunction](SessionCatalog.md#registerFunction), [reset](SessionCatalog.md#reset)
* `SparkSessionExtensions` is requested to [registerFunctions](SparkSessionExtensions.md#registerFunctions), [registerTableFunctions](SparkSessionExtensions.md#registerTableFunctions)

## Implementations

* `EmptyFunctionRegistryBase`
* [FunctionRegistry](FunctionRegistry.md)
* [SimpleFunctionRegistryBase](SimpleFunctionRegistryBase.md)
* [TableFunctionRegistry](TableFunctionRegistry.md)

## <span id="createOrReplaceTempFunction"> createOrReplaceTempFunction

```scala
createOrReplaceTempFunction(
  name: String,
  builder: Seq[Expression] => T,
  source: String): Unit
```

`createOrReplaceTempFunction` [registers a named function](#registerFunction) (with a `FunctionIdentifier` for the given name).

!!! note "source Argument"

    source | Call Site
    -------|-----------
    `java_udf` | [UDFRegistration.register](UDFRegistration.md#register)
    `python_udf` | [UDFRegistration.registerPython](UDFRegistration.md#registerPython)
    `scala_udf` | [UDFRegistration.register](UDFRegistration.md#register)

    `source` is used to create an `ExpressionInfo` for [registering a named function](#registerFunction).

---

`createOrReplaceTempFunction` is used when:

* `UDFRegistration` is requested to register a user-defined function written in [Python](UDFRegistration.md#registerPython) or [Scala](UDFRegistration.md#register)
