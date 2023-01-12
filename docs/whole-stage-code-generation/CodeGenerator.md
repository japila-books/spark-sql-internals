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

## <span id="cache"> cache

```scala
cache: Cache[CodeAndComment, (GeneratedClass, ByteCodeStats)]
```

`CodeGenerator` creates a cache of generated classes when loaded (as an Scala object).

When requested to look up a non-existent `CodeAndComment`, `cache` [doCompile](#doCompile), updates `CodegenMetrics` and prints out the following INFO message to the logs:

```text
Code generated in [timeMs] ms
```

`cache` allows for up to [spark.sql.codegen.cache.maxEntries](../StaticSQLConf.md#spark.sql.codegen.cache.maxEntries) pairs.

`cache` is used when:

* `CodeGenerator` is requested to [compile a Java source code](#compile).

## <span id="compile"> Compiling Java Code

```scala
compile(
  code: CodeAndComment): (GeneratedClass, ByteCodeStats)
```

`compile` looks the given `CodeAndComment` up in the [cache](#cache).

---

`compile` is used when:

* `GenerateMutableProjection` is requested to [create a MutableProjection](GenerateMutableProjection.md#create)
* `GenerateOrdering` is requested to [create a BaseOrdering](GenerateOrdering.md#create)
* `GeneratePredicate` is requested to [create a BasePredicate](GeneratePredicate.md#create)
* `GenerateSafeProjection` is requested to [create a Projection](GenerateSafeProjection.md#create)
* `GenerateUnsafeProjection` is requested to [create an UnsafeProjection](GenerateUnsafeProjection.md#create)
* `GenerateUnsafeRowJoiner` is requested to `create` an `UnsafeRowJoiner`
* `WholeStageCodegenExec` is requested to [doExecute](../physical-operators/WholeStageCodegenExec.md#doExecute)
* `GenerateColumnAccessor` is requested to [create a ColumnarIterator](GenerateColumnAccessor.md#create)
* `debug` utility is used to `codegenStringSeq`

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

## <span id="doCompile"><span id="GeneratedClass"> doCompile

```scala
doCompile(
  code: CodeAndComment): (GeneratedClass, ByteCodeStats)
```

`doCompile` creates a `ClassBodyEvaluator` (Janino).

`doCompile` requests the `ClassBodyEvaluator` to use `org.apache.spark.sql.catalyst.expressions.GeneratedClass` as the name of the generated class and sets some default imports (to be included in the generated class).

`doCompile` requests the `ClassBodyEvaluator` to use `GeneratedClass` as a superclass of the generated class (for passing extra `references` objects into the generated class).

```scala
abstract class GeneratedClass {
  def generate(references: Array[Any]): Any
}
```

`doCompile` prints out the following DEBUG message to the logs (with the given `code`):

```text
[formatted code]
```

`doCompile` requests the `ClassBodyEvaluator` to _cook_ (read, scan, parse and compile Java tokens) the source code and gets the bytecode statistics:

* max method bytecode size
* max constant pool size
* number of inner classes

`doCompile` updates `CodeGenerator` code-gen metrics.

In the end, `doCompile` returns the `GeneratedClass` instance and bytecode statistics.

---

`doCompile` is used when:

* `CodeGenerator` is requested to look up a code (in the [cache](#cache))

## Logging

`CodeGenerator` is an abstract class and logging is configured using the logger of the [implementations](#implementations).
