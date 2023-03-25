# SessionConfigSupport

`SessionConfigSupport` is an [extension](#contract) of the [TableProvider](TableProvider.md) abstraction for [table providers](#implementations) that use [custom key prefix for spark.datasource configuration options](#keyPrefix).

`SessionConfigSupport` connectors can be configured by additional (session-scoped) configuration options that are specified in [SparkSession](../SparkSession.md) to extend user-defined options.

## Contract

### <span id="keyPrefix"> Configuration Key Prefix

```java
String keyPrefix()
```

The prefix of the configuration keys of this connector that is added to `spark.datasource` prefix

```text
spark.datasource.[keyPrefix]
```

Must not be `null`

Used when:

* `DataSourceV2Utils` is requested to [extract session configuration options](../connectors/DataSourceV2Utils.md#extractSessionConfigs)

## Implementations

!!! note
    No built-in implementations available.
