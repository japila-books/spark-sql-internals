# CodeGenerator

`CodeGenerator` is an [abstraction](#contract) of [JVM bytecode generators](#implementations) for expression evaluation.

The Scala definition of this abstract class is as follows:

```scala
CodeGenerator[InType <: AnyRef, OutType <: AnyRef]
```

## Contract

### <span id="bind"> bind

```scala
bind(
  in: InType,
  inputSchema: Seq[Attribute]): InType
```

Used when:

* `CodeGenerator` is requested to [generate](#generate)

### <span id="canonicalize"> canonicalize

```scala
canonicalize(
  in: InType): InType
```

Used when:

* `CodeGenerator` is requested to [generate](#generate)

### <span id="create"> create

```scala
create(
  in: InType): OutType
```

Used when:

* `CodeGenerator` is requested to [generate](#generate)

## Implementations

* [GenerateColumnAccessor](GenerateColumnAccessor.md)
* [GenerateMutableProjection](GenerateMutableProjection.md)
* [GenerateOrdering](GenerateOrdering.md)
* [GeneratePredicate](GeneratePredicate.md)
* [GenerateSafeProjection](GenerateSafeProjection.md)
* [GenerateUnsafeProjection](GenerateUnsafeProjection.md)
* `GenerateUnsafeRowJoiner`

## <span id="generate"> generate

```scala
generate(
  expressions: InType): OutType
generate(
  expressions: InType,
  inputSchema: Seq[Attribute]): OutType // (1)!
```

1. [Binds](#bind) the input expressions to the given input schema

`generate` [creates a class](#create) for the input `expressions` (after [canonicalization](#canonicalize)).

`generate` is used when:

* `Serializer` (of [ExpressionEncoder](../ExpressionEncoder.md)) is requested to `apply`
* `RowOrdering` utility is used to [createCodeGeneratedObject](../expressions/RowOrdering.md#createCodeGeneratedObject)
* `SafeProjection` utility is used to `createCodeGeneratedObject`
* `LazilyGeneratedOrdering` is requested for `generatedOrdering`
* `ObjectOperator` utility is used to `deserializeRowToObject` and `serializeObjectToRow`
* `ComplexTypedAggregateExpression` is requested for `inputRowToObj` and `bufferRowToObject`
* `DefaultCachedBatchSerializer` is requested to `convertCachedBatchToInternalRow`

## <span id="newCodeGenContext"> Creating CodegenContext

```scala
newCodeGenContext(): CodegenContext
```

`newCodeGenContext` creates a new [CodegenContext](CodegenContext.md).

`newCodeGenContext` is used when:

* `GenerateMutableProjection` is requested to [create a MutableProjection](GenerateMutableProjection.md#create)
* `GenerateOrdering` is requested to [create a BaseOrdering](GenerateOrdering.md#create)
* `GeneratePredicate` utility is used to [create a BasePredicate](GeneratePredicate.md#create)
* `GenerateSafeProjection` is requested to [create a Projection](GenerateSafeProjection.md#create)
* `GenerateUnsafeProjection` utility is used to [create an UnsafeProjection](GenerateUnsafeProjection.md#create)
* `GenerateColumnAccessor` is requested to [create a ColumnarIterator](GenerateColumnAccessor.md#create)

## Logging

`CodeGenerator` is an abstract class and logging is configured using the logger of the [implementations](#implementations).
