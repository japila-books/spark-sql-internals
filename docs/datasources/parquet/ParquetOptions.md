# ParquetOptions

`ParquetOptions` is a `FileSourceOptions`.

## Creating Instance

`ParquetOptions` takes the following to be created:

* <span id="parameters"> Parameters
* <span id="sqlConf"> [SQLConf](../../SQLConf.md)

`ParquetOptions` is created when:

* `HiveOptions` is requested to `getHiveWriteCompression`
* `ParquetFileFormat` is requested to [prepareWrite](ParquetFileFormat.md#prepareWrite) and [buildReaderWithPartitionValues](ParquetFileFormat.md#buildReaderWithPartitionValues)
* `ParquetUtils` is requested to [inferSchema](ParquetUtils.md#inferSchema)
* `ParquetScan` is requested to [createReaderFactory](ParquetScan.md#createReaderFactory)
* `ParquetWrite` is requested to [prepareWrite](ParquetWrite.md#prepareWrite)

## Options

### <span id="mergeSchema"> mergeSchema

Controls merging schemas from all Parquet part-files

Default: [spark.sql.parquet.mergeSchema](../../configuration-properties.md#spark.sql.parquet.mergeSchema)

Used when:

* `ParquetUtils` is requested to [infer schema](ParquetUtils.md#inferSchema)
