# FileRelation

`FileRelation` is an [abstraction](#contract) of [relations](#implementations) that are backed by files.

## Contract

### <span id="inputFiles"> inputFiles

```scala
inputFiles: Array[String]
```

The files that this relation will read when scanning

Used when:

* `Dataset` is requested for the [inputFiles](Dataset.md#inputFiles)

## Implementations

* [HadoopFsRelation](files/HadoopFsRelation.md)
