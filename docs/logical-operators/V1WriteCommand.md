---
title: V1WriteCommand
---

# V1WriteCommand Logical Commands

`V1WriteCommand` is an [extension](#contract) of the [DataWritingCommand](DataWritingCommand.md) abstraction for [write commands](#implementations) that use the legacy write code paths.

## Contract (Subset)

### fileFormat { #fileFormat }

```scala
fileFormat: FileFormat
```

[FileFormat](../files/FileFormat.md) of the provider of this write command

See:

* [InsertIntoHadoopFsRelationCommand](InsertIntoHadoopFsRelationCommand.md#fileFormat)

Used when:

* `DataSource` is requested to [planForWritingFileFormat](../DataSource.md#planForWritingFileFormat)
* `V1Writes` logical optimization is executed

### requiredOrdering { #requiredOrdering }

```scala
requiredOrdering: Seq[SortOrder]
```

[SortOrder](../expressions/SortOrder.md) of this write command

See:

* [InsertIntoHadoopFsRelationCommand](InsertIntoHadoopFsRelationCommand.md#requiredOrdering)

Used when:

* `V1Writes` logical optimization is executed

## Implementations

* [InsertIntoHadoopFsRelationCommand](InsertIntoHadoopFsRelationCommand.md)
* [InsertIntoHiveTable](../hive/InsertIntoHiveTable.md)
