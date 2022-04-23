# Parquet Data Source

[Apache Parquet](http://parquet.apache.org/) is a columnar storage format for the Apache Hadoop ecosystem with support for efficient storage and encoding of data.

Spark SQL supports `parquet`-encoded data using [ParquetDataSourceV2](ParquetDataSourceV2.md). There is also an older [ParquetFileFormat](ParquetFileFormat.md) that is used as a [fallbackFileFormat](ParquetDataSourceV2.md#fallbackFileFormat), for backward-compatibility and [Hive](../../hive/HiveMetastoreCatalog.md#convert) (to name a few use cases).

Parquet is the default data source format based on the [spark.sql.sources.default](../../configuration-properties.md#spark.sql.sources.default) configuration property.

Parquet data source uses `spark.sql.parquet` prefix for [parquet-specific configuration properties](../../configuration-properties.md).
