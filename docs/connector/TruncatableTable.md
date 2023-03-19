# TruncatableTable

`TruncatableTable` is an [extension](#contract) of the [Table](Table.md) abstraction for [tables](#implementations) that can [truncateTable](#truncateTable).

## Contract

### <span id="truncateTable"> truncateTable

```java
boolean truncateTable()
```

See:

* [SupportsDeleteV2](SupportsDeleteV2.md#truncateTable)

Used when:

* [TruncateTableExec](../physical-operators/TruncateTableExec.md) physical operator is executed

## Implementations

* [SupportsDeleteV2](SupportsDeleteV2.md)
