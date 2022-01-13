# UnsafeProjection

`UnsafeProjection` is an [extension](#contract) of the [Projection](Projection.md) abstraction for [expressions](#implementations) that [encode InternalRows to UnsafeRows](#apply).

```text
UnsafeProjection: InternalRow =[apply]=> UnsafeRow
```

## Contract

### <span id="apply"> Encoding InternalRow as UnsafeRow

```scala
apply(
  row: InternalRow): UnsafeRow
```

Encodes the given [InternalRow](../InternalRow.md) to an [UnsafeRow](../UnsafeRow.md)

## Implementations

* `InterpretedUnsafeProjection`

## <span id="CodeGeneratorWithInterpretedFallback"> CodeGeneratorWithInterpretedFallback

`UnsafeProjection` factory object is a [CodeGeneratorWithInterpretedFallback](CodeGeneratorWithInterpretedFallback.md) of `UnsafeProjection`s (based on [Expression](Expression.md)s).

```scala
CodeGeneratorWithInterpretedFallback[Seq[Expression], UnsafeProjection]
```

### <span id="createCodeGeneratedObject"> createCodeGeneratedObject

```scala
createCodeGeneratedObject(
  in: Seq[Expression]): UnsafeProjection
```

`createCodeGeneratedObject` is part of the [CodeGeneratorWithInterpretedFallback](CodeGeneratorWithInterpretedFallback.md#createCodeGeneratedObject) abstraction.

`createCodeGeneratedObject`...FIXME

### <span id="createInterpretedObject"> createInterpretedObject

```scala
createInterpretedObject(
  in: Seq[Expression]): UnsafeProjection
```

`createInterpretedObject` is part of the [CodeGeneratorWithInterpretedFallback](CodeGeneratorWithInterpretedFallback.md#createInterpretedObject) abstraction.

`createInterpretedObject`...FIXME

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
