# RowOrdering

## <span id="isOrderable"> isOrderable

```scala
isOrderable(
  dataType: DataType): Boolean
isOrderable(
  exprs: Seq[Expression]): Boolean
```

`isOrderable` holds `true` when the [DataType](../types/DataType.md) is one of the following:

* [NullType](../types/DataType.md#NullType)
* [AtomicType](../types/AtomicType.md)
* [StructType](../types/StructType.md) with all [fields](../types/StructType.md#fields) orderable (recursive)
* [ArrayType](../types/ArrayType.md) with orderable type of the elements
* [UserDefinedType](../types/UserDefinedType.md)

`isOrderable` is used when:

* [JoinSelection](../execution-planning-strategies/JoinSelection.md) execution planning strategy is executed (and [SortMergeJoinExec](../execution-planning-strategies/JoinSelection.md#createSortMergeJoin) is considered)
* FIXME
