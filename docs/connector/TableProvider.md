# TableProvider

`TableProvider` is an [abstraction](#contract) of [table providers](#implementations) (for `DataSourceV2Utils` utility when requested for a [Table](../connectors/DataSourceV2Utils.md#getTableFromProvider)).

`TableProvider` is part of [Connector API](index.md) and serves as an indication to use newer code execution paths (e.g., [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule).

## Contract

### Table { #getTable }

```java
Table getTable(
  StructType schema,
  Transform[] partitioning,
  Map<String, String> properties)
```

Creates a [Table](Table.md) for the given `schema`, partitioning (as [Transform](Transform.md)s) and properties.

Used when:

* `DataFrameWriter` is requested to [save data](../DataFrameWriter.md#save)
* `DataSourceV2Utils` utility is used to [getTableFromProvider](../connectors/DataSourceV2Utils.md#getTableFromProvider)

### Inferring Partitioning { #inferPartitioning }

```java
Transform[] inferPartitioning(
  CaseInsensitiveStringMap options)
```

Default: No partitions (as [Transform](Transform.md)s)

Used when:

* `DataSourceV2Utils` utility is used to [getTableFromProvider](../connectors/DataSourceV2Utils.md#getTableFromProvider)

### Inferring Schema { #inferSchema }

```java
StructType inferSchema(
  CaseInsensitiveStringMap options)
```

Used when:

* `DataSourceV2Utils` utility is used to [getTableFromProvider](../connectors/DataSourceV2Utils.md#getTableFromProvider)

### supportsExternalMetadata { #supportsExternalMetadata }

```java
boolean supportsExternalMetadata()
```

Default: `false`

Used when:

* `DataSourceV2Utils` utility is used to [getTableFromProvider](../connectors/DataSourceV2Utils.md#getTableFromProvider)

## Implementations

* [FileDataSourceV2](../files/FileDataSourceV2.md)
* [SessionConfigSupport](SessionConfigSupport.md)
* [SimpleTableProvider](SimpleTableProvider.md)
* [SupportsCatalogOptions](catalog/SupportsCatalogOptions.md)
