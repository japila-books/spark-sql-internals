# RowOrdering

## <span id="isOrderable"> isOrderable

```scala
isOrderable(
  dataType: DataType): Boolean
isOrderable(
  exprs: Seq[Expression]): Boolean
```

`isOrderable` holds `true` when the [DataType](../DataType.md) is one of the following:

* [NullType](../DataType.md#NullType)
* [AtomicType](../DataType.md#AtomicType)
* [StructType](../StructType.md) with all [fields](../StructType.md#fields) orderable (recursive)
* [ArrayType](../DataType.md#ArrayType.md) with orderable type of the elements
* `UserDefinedType`

`isOrderable` is used when:

* [JoinSelection](../execution-planning-strategies/JoinSelection.md) execution planning strategy is executed (and [SortMergeJoinExec](../execution-planning-strategies/JoinSelection.md#createSortMergeJoin) is considered)
* FIXME
