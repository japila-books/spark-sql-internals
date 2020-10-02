# PythonRDD

`PythonRDD` is an `RDD` (`RDD[Array[Byte]]`) that uses [PythonRunner](PythonRunner.md) (to [compute a partition](#compute)).

## Creating Instance

`PythonRDD` takes the following to be created:

* <span id="parent"> Parent `RDD`
* <span id="func"> [PythonFunction](PythonFunction.md)
* <span id="preservePartitoning"> `preservePartitoning` flag
* <span id="isFromBarrier"> `isFromBarrier` flag (default: `false`)

`PythonRDD` is created when...FIXME
