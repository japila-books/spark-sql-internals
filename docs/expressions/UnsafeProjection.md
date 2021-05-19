# UnsafeProjection

`UnsafeProjection` is an [extension](#contract) of the [Projection](Projection.md) abstraction for [expressions](#implementations) that [encode InternalRows to UnsafeRows](#apply).

```text
UnsafeProjection: InternalRow =[apply]=> UnsafeRow
```

## Contract

### <span id="apply"> Encoding InternalRow as UnsafeRow

```scala
apply(
  row: InternalRow): UnsafeRow
```

Encodes the given [InternalRow](../InternalRow.md) to an [UnsafeRow](../UnsafeRow.md)

## Implementations

* `InterpretedUnsafeProjection`

## <span id="create"> create

```scala
create(
  fields: Array[DataType]): UnsafeProjection
create(
  expr: Expression): UnsafeProjection
create(
  exprs: Seq[Expression]): UnsafeProjection
create(
  exprs: Seq[Expression],
  inputSchema: Seq[Attribute]): UnsafeProjection
create(
  schema: StructType): UnsafeProjection
```

`create` [creates an UnsafeProjection](CodeGeneratorWithInterpretedFallback.md#createObject) for the given [BoundReference](BoundReference.md)s.
