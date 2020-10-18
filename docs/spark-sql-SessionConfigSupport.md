# SessionConfigSupport &mdash; Data Sources with Session-Scoped Configuration Options

`SessionConfigSupport` is the <<contract, contract>> of <<implementations, DataSourceV2 data sources>> in [DataSource V2](new-and-noteworthy/datasource-v2.md) that use <<keyPrefix, custom key prefix for configuration options>> (i.e. options with *spark.datasource* prefix for the keys in [SQLConf](SQLConf.md)).

With `SessionConfigSupport`, a data source can be configured by additional (session-scoped) configuration options that are specified in <<SparkSession.md#, SparkSession>> that extend user-defined options.

[[contract]]
[[keyPrefix]]
[source, java]
----
String keyPrefix()
----

`keyPrefix` is used exclusively when `DataSourceV2Utils` object is requested to <<spark-sql-DataSourceV2Utils.md#extractSessionConfigs, extract session configuration options>> (i.e. options with *spark.datasource* prefix for the keys) for <<spark-sql-DataSourceV2.md#, DataSourceV2>> data sources with <<spark-sql-SessionConfigSupport.md#, SessionConfigSupport>>.

`keyPrefix` must not be `null` or an `IllegalArgumentException` is thrown:

```
The data source config key prefix can't be null.
```
