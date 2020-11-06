# TableProvider

`TableProvider` is an [abstraction](#contract) of [table providers](#implementations) (for `DataSourceV2Utils` utility when requested for a [Table](../DataSourceV2Utils.md#getTableFromProvider)).

## Contract

### <span id="getTable"> Creating Table

```java
Table getTable(
  StructType schema,
  Transform[] partitioning,
  Map<String, String> properties)
```

Creates a [Table](Table.md) for the given `schema`, partitioning (as [Transform](Transform.md)s) and properties.

Used when:

* `DataFrameWriter` is requested to [save data](../DataFrameWriter.md#save)
* `DataSourceV2Utils` utility is used to [getTableFromProvider](../DataSourceV2Utils.md#getTableFromProvider)

### <span id="inferPartitioning"> Inferring Partitioning

```java
Transform[] inferPartitioning(
  CaseInsensitiveStringMap options)
```

Default: No partitions (as [Transform](Transform.md)s)

Used when:

* `DataSourceV2Utils` utility is used to [getTableFromProvider](../DataSourceV2Utils.md#getTableFromProvider)

### <span id="inferSchema"> Inferring Schema

```java
StructType inferSchema(
  CaseInsensitiveStringMap options)
```

Used when:

* `DataSourceV2Utils` utility is used to [getTableFromProvider](../DataSourceV2Utils.md#getTableFromProvider)

### <span id="supportsExternalMetadata"> supportsExternalMetadata

```java
boolean supportsExternalMetadata()
```

Default: `false`

Used when:

* `DataSourceV2Utils` utility is used to [getTableFromProvider](../DataSourceV2Utils.md#getTableFromProvider)

## Implementations

* [FileDataSourceV2](../FileDataSourceV2.md)
* [SessionConfigSupport](SessionConfigSupport.md)
* [SimpleTableProvider](SimpleTableProvider.md)
* [SupportsCatalogOptions](catalog/SupportsCatalogOptions.md)
