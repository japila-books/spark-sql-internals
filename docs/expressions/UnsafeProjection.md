# UnsafeProjection

`UnsafeProjection` is an [extension](#contract) of the [Projection](Projection.md) abstraction for [projection functions](#implementations) from [InternalRows to (produce) UnsafeRows](#apply).

```text
UnsafeProjection: InternalRow => UnsafeRow
```

`UnsafeProjection` is created for [code generated](#createCodeGeneratedObject) and [interpreted](#createInterpretedObject) code evaluation paths (using [UnsafeProjection](#CodeGeneratorWithInterpretedFallback) factory object).

## Contract

### Encoding InternalRow as UnsafeRow { #apply }

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

### createCodeGeneratedObject { #createCodeGeneratedObject }

??? note "CodeGeneratorWithInterpretedFallback"

    ```scala
    createCodeGeneratedObject(
      in: Seq[Expression]): UnsafeProjection
    ```

    `createCodeGeneratedObject` is part of the [CodeGeneratorWithInterpretedFallback](CodeGeneratorWithInterpretedFallback.md#createCodeGeneratedObject) abstraction.

`createCodeGeneratedObject` [generates an UnsafeProjection](../whole-stage-code-generation/GenerateUnsafeProjection.md#generate) for the given [Expression](Expression.md)s (possibly with [Subexpression Elimination](../subexpression-elimination.md) based on [spark.sql.subexpressionElimination.enabled](../configuration-properties.md#spark.sql.subexpressionElimination.enabled) configuration property).

### createInterpretedObject { #createInterpretedObject }

??? note "CodeGeneratorWithInterpretedFallback"

    ```scala
    createInterpretedObject(
      in: Seq[Expression]): UnsafeProjection
    ```

    `createInterpretedObject` is part of the [CodeGeneratorWithInterpretedFallback](CodeGeneratorWithInterpretedFallback.md#createInterpretedObject) abstraction.

`createInterpretedObject` creates an `UnsafeProjection` for the given [Expression](Expression.md)s.

## Creating UnsafeProjection { #create }

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
