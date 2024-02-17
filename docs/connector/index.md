# Connector API

**Connector API** is a new API in Spark 3 for Spark SQL developers to create [connectors](../connectors/index.md) (_data sources_ or _providers_).

!!! note
    Connector API is meant to replace the older (deprecated) DataSource v1 and v2.

    Although "Data Source V2" name has already been used, Connector API is considered the "real" Data Source V2.

[ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule uses [TableProvider](TableProvider.md) to recognize Data Source V2 providers.

[spark.sql.sources.useV1SourceList](../configuration-properties.md#spark.sql.sources.useV1SourceList) configuration property is used for connectors for which Data Source V2 code path is disabled (that should fall back to Data Source V1 execution paths).
