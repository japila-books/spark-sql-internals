# DataType

`DataType` is an [extension](#contract) of the [AbstractDataType](AbstractDataType.md) abstraction for [data types](#implementations) in Spark SQL.

## Contract

### <span id="asNullable"> asNullable

```scala
asNullable: DataType
```

### <span id="defaultSize"> Default Size

```scala
defaultSize: Int
```

Default size of a value of this data type

Used when:

* [ResolveGroupingAnalytics](../logical-analysis-rules/ResolveGroupingAnalytics.md) logical resolution is executed
* `CommandUtils` is used to [statExprs](../CommandUtils.md#statExprs)
* `JoinEstimation` is used to [estimateInnerOuterJoin](../logical-operators/JoinEstimation.md#estimateInnerOuterJoin)
* _others_

## Implementations

* [ArrayType](ArrayType.md)
* [AtomicType](AtomicType.md)
* CalendarIntervalType
* HiveVoidType
* MapType
* NullType
* ObjectType
* [StructType](../StructType.md)
* UserDefinedType
