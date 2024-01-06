# Transactional Writes in File-Based Connectors

[File-based connectors](../files/index.md) use [spark.sql.sources.commitProtocolClass](../configuration-properties.md#spark.sql.sources.commitProtocolClass) configuration property for the class that is responsible for transactional writes.

## Logging

Enable the following loggers:

* [FileFormatWriter](../files/FileFormatWriter.md#logging)
* [ParquetUtils](../parquet/ParquetUtils.md#logging)
* [SQLHadoopMapReduceCommitProtocol](SQLHadoopMapReduceCommitProtocol.md#logging)

## Learn More

1. [Transactional Writes to Cloud Storage on Databricks](https://www.databricks.com/blog/2017/05/31/transactional-writes-cloud-storage.html)
