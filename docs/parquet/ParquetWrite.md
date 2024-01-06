# ParquetWrite

`ParquetWrite` is a [FileWrite](../files/FileWrite.md) of [ParquetTable](ParquetTable.md#newWriteBuilder) in [Parquet Connector](index.md).

## Creating Instance

`ParquetWrite` takes the following to be created:

* <span id="paths"> Paths
* <span id="formatName"> Format Name
* <span id="supportsDataType"> `supportsDataType` function (`DataType => Boolean`)
* <span id="info"> `LogicalWriteInfo`

`ParquetWrite` is created when:

* `ParquetTable` is requested for a [WriteBuilder](ParquetTable.md#newWriteBuilder)

## Preparing Write Job { #prepareWrite }

??? note "FileWrite"

    ```scala
    prepareWrite(
      sqlConf: SQLConf,
      job: Job,
      options: Map[String, String],
      dataSchema: StructType): OutputWriterFactory
    ```

    `prepareWrite` is part of the [FileWrite](../files/FileWrite.md#prepareWrite) abstraction.

`prepareWrite` creates a [ParquetOptions](ParquetOptions.md) (for the given `options` and `SQLConf`).

In the end, `prepareWrite` [prepareWrite](ParquetUtils.md#prepareWrite).
