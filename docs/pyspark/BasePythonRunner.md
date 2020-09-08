# BasePythonRunner

`BasePythonRunner` is an [abstraction](#contract) of [Python Runners](#implementations).

## Contract

### <span id="newReaderIterator"> newReaderIterator

```scala
newReaderIterator(
  stream: DataInputStream,
  writerThread: WriterThread,
  startTime: Long,
  env: SparkEnv,
  worker: Socket,
  releasedOrClosed: AtomicBoolean,
  context: TaskContext): Iterator[OUT]
```

Used when `BasePythonRunner` is requested to [compute](#compute)

### <span id="newWriterThread"> newWriterThread

```scala
newWriterThread(
  env: SparkEnv,
  worker: Socket,
  inputIterator: Iterator[IN],
  partitionIndex: Int,
  context: TaskContext): WriterThread
```

Used when `BasePythonRunner` is requested to [compute](#compute)

## Implementations

* ArrowPythonRunner
* CoGroupedArrowPythonRunner
* PythonRunner
* PythonUDFRunner

## Scala Definition

`BasePythonRunner` is a type constructor in Scala (_generic class_ in Java) with the following definition:

```scala
abstract class BasePythonRunner[IN, OUT](...) {
    // ...
}
```

`BasePythonRunner` uses `IN` and `OUT` as the name of the types for the input and output values.

## Creating Instance

`BasePythonRunner` takes the following to be created:

* <span id="funcs"> `ChainedPythonFunctions`
* <span id="evalType"> Eval Type
* <span id="argOffsets"> Argument Offsets

`BasePythonRunner` requires that the number of [ChainedPythonFunctions](#funcs) and [Argument Offsets](#argOffsets) are the same.

!!! note "Abstract Class"
    `BasePythonRunner` is an abstract class and cannot be created directly. It is created indirectly for the [concrete BasePythonRunners](#implementations).

## <span id="compute"> Computing Result

```scala
compute(
  inputIterator: Iterator[IN],
  partitionIndex: Int,
  context: TaskContext): Iterator[OUT]
```

`compute`...FIXME

`compute` is used when:

* `PythonRDD` is requested to `compute`
* `AggregateInPandasExec`, `ArrowEvalPythonExec`, `BatchEvalPythonExec`, `FlatMapCoGroupsInPandasExec`, `FlatMapGroupsInPandasExec` `MapInPandasExec`, `WindowInPandasExec` physical operators are executed
