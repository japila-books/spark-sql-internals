# PythonRunner

`PythonRunner` is a concrete [BasePythonRunner](BasePythonRunner.md).

## Creating Instance

`PythonRunner` takes the following to be created:

* <span id="funcs"> `Seq[ChainedPythonFunctions]`

`PythonRunner` is created (indirectly using [apply](#apply) factory method) when:

* `PythonRDD` is requested to [compute a partition](PythonRDD.md#compute)
* `PythonForeachWriter` is requested for a [PythonRunner](PythonForeachWriter.md#pythonRunner)

## <span id="apply"> Creating PythonRunner

```scala
apply(
  func: PythonFunction): PythonRunner
```

`apply` simply creates a [PythonRunner](PythonRunner.md) for the [PythonFunction](PythonFunction.md).

`apply` is used when:

* `PythonRDD` is requested to [compute a partition](PythonRDD.md#compute)
* `PythonForeachWriter` is requested for a [PythonRunner](PythonForeachWriter.md#pythonRunner)
