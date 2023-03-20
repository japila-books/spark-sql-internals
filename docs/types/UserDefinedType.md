---
tags:
  - DeveloperApi
---

# UserDefinedType

`UserDefinedType[UserType]` is an [extension](#contract) of the [DataType](DataType.md) abstraction for [user-defined data types](#implementations).

## Contract

### <span id="deserialize"> deserialize

```scala
deserialize(
  datum: Any): UserType
```

Used when:

* `UDTConverter` is requested to `toScala`
* `Cast` expression is requested to `castToString`
* `BaseScriptTransformationExec` is requested to `outputFieldWriters`

### <span id="serialize"> serialize

```scala
serialize(
  obj: UserType): Any
```

Used when:

* `Row` is requested to [toJson](../Row.md#toJson)
* `UDTConverter` is requested to `toCatalystImpl`

### <span id="sqlType"> sqlType

```scala
sqlType: DataType
```

The underlying storage [DataType](DataType.md)

### <span id="userClass"> userClass

```scala
userClass: Class[UserType]
```

## Implementations

* `PythonUserDefinedType`
* `MatrixUDT` (Spark MLlib)
* `VectorUDT` (Spark MLlib)
