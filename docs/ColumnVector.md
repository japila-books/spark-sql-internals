# ColumnVector

`ColumnVector` is an [abstraction](#contract) of [in-memory columnar data](#implementations) (_vectors_) with elements of a given [DataType](#type).

`ColumnVector` is expected to be reused during the entire data loading process, to avoid allocating memory again and again.

`ColumnVector` is meant to maximize CPU efficiency but not to minimize storage footprint. Implementations should prefer computing efficiency over storage efficiency when design the format. Since it is expected to reuse the ColumnVector instance while loading data, the storage footprint is negligible.

## Implementations

* `ArrowColumnVector`
* `ConstantColumnVector`
* `OrcColumnVector`
* [WritableColumnVector](WritableColumnVector.md)

## Creating Instance

`ColumnVector` takes the following to be created:

* <span id="type"> [DataType](types/DataType.md)

!!! note "Abstract Class"
    `ColumnVector` is an abstract class and cannot be created directly. It is created indirectly for the [concrete ColumnVectors](#implementations).
