# ParquetTable

`ParquetTable` is a [FileTable](../../connector/FileTable.md).

## Creating Instance

`ParquetTable` takes the following to be created:

* <span id="name"> Name
* <span id="sparkSession"> [SparkSession](../../SparkSession.md)
* <span id="options"> Case-Insensitive Options
* <span id="paths"> Paths
* <span id="userSpecifiedSchema"> User-specified [schema](../../types/StructType.md)
* <span id="fallbackFileFormat"> Fallback [FileFormat](../FileFormat.md)

`ParquetTable` is created when:

* `ParquetDataSourceV2` is requested to [getTable](ParquetDataSourceV2.md#getTable)
