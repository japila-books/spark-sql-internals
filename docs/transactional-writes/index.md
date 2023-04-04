# Transactional Writes

Spark SQL uses [spark.sql.sources.commitProtocolClass](../configuration-properties.md#spark.sql.sources.commitProtocolClass) configuration property for the class that is responsible for transactional writes in [file-based connectors](../files/index.md).

## Logging

Enable the following loggers:

* [org.apache.spark.sql.execution.datasources.SQLHadoopMapReduceCommitProtocol](SQLHadoopMapReduceCommitProtocol.md#logging)
* [org.apache.spark.sql.execution.datasources.FileFormatWriter](../connectors/FileFormatWriter.md#logging)

## Learn More

1. [Transactional Writes to Cloud Storage on Databricks](https://www.databricks.com/blog/2017/05/31/transactional-writes-cloud-storage.html)
