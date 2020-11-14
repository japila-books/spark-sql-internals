# BufferedRowIterator

`BufferedRowIterator` is an [abstraction](#contract) of iterators that are code-generated at execution time in [Whole-Stage Java Code Generation](index.md) (using [WholeStageCodegenExec](../physical-operators/WholeStageCodegenExec.md#doCodeGen) unary physical operator).

## Contract

### <span id="init"> Initializing

```java
void init(
  int index,
  Iterator<InternalRow>[] iters)
```

Used when `WholeStageCodegenExec` unary physical operator is [executed](../physical-operators/WholeStageCodegenExec.md#doExecute)

### <span id="processNext"> Processing Next Row

```java
void processNext()
```

Used when `BufferedRowIterator` is requested to [hasNext](#hasNext)

## <span id="hasNext"> hasNext

```java
boolean hasNext()
```

`hasNext` [processNext](#processNext) when there are no rows in the [currentRows](#currentRows) buffer.

`hasNext` is `true` when the [currentRows](#currentRows) buffer has got any element. Otherwise, `hasNext` is `false`.

`hasNext` is used when `WholeStageCodegenExec` unary physical operator is [executed](../physical-operators/WholeStageCodegenExec.md#doExecute) (to generate an `RDD[InternalRow]` to `mapPartitionsWithIndex` over rows from up to two input RDDs).

## <span id="currentRows"> currentRows Buffer

```java
LinkedList<InternalRow> currentRows
```

`currentRows` is an internal buffer of [InternalRow](../InternalRow.md):

* A new row is added when [appending a row](#append)
* A row is removed when requested to [next](#next)

`currentRows` is used for [hasNext](#hasNext) and [shouldStop](#shouldStop).

## <span id="append"> Appending Row

```java
void append(
  InternalRow row)
```

`append` simply adds the given [InternalRow](../InternalRow.md) to the end of the [currentRows](#currentRows) buffer (thus the name _append_).

`append` is used...FIXME
