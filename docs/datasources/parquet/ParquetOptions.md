# ParquetOptions

## <span id="mergeSchema"> mergeSchema

Controls merging schemas from all Parquet part-files

Default: [spark.sql.parquet.mergeSchema](../../configuration-properties.md#spark.sql.parquet.mergeSchema)

Used when:

* `ParquetUtils` is requested to [infer schema](ParquetUtils.md#inferSchema)
