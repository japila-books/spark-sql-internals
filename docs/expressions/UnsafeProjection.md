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

`createCodeGeneratedObject` [generates an UnsafeProjection](../whole-stage-code-generation/GenerateUnsafeProjection.md#generate) for the given [Expression](Expression.md)s (possibly with [Subexpression Elimination](../subexpression-elimination/index.md) based on [spark.sql.subexpressionElimination.enabled](../configuration-properties.md#spark.sql.subexpressionElimination.enabled) configuration property).

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
  exprs: Seq[Expression]): UnsafeProjection // (1)!
create(
  exprs: Seq[Expression],
  inputSchema: Seq[Attribute]): UnsafeProjection
create(
  schema: StructType): UnsafeProjection
```

1. The main `create` that the other variants depend on

`create` [creates an UnsafeProjection](CodeGeneratorWithInterpretedFallback.md#createObject) for the given [Expression](Expression.md)s.

---

`create` is used when:

* `ExpressionEncoder` is requested to [create a serializer](../ExpressionEncoder.md#apply)
* `V2Aggregator` is requested for an `inputProjection`
* [SerializeFromObjectExec](../physical-operators/SerializeFromObjectExec.md) physical operator is executed
* `SortExec` physical operator is requested to [create an UnsafeExternalRowSorter](../physical-operators/SortExec.md#createSorter)
* `HashAggregateExec` physical operator is requested to [create a hash map](../physical-operators/HashAggregateExec.md#createHashMap) and [getEmptyAggregationBuffer](../physical-operators/HashAggregateExec.md#getEmptyAggregationBuffer)
* `AggregationIterator` is [created](../aggregations/AggregationIterator.md#groupingProjection) and requested to [generateResultProjection](../aggregations/AggregationIterator.md#generateResultProjection)
* `TungstenAggregationIterator` is requested to [create an aggregation buffer](../aggregations/TungstenAggregationIterator.md#createNewAggregationBuffer)
* `ScalaAggregator` is requested for the [inputProjection](ScalaAggregator.md#inputProjection)
* _others_
