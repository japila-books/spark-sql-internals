# TruncatableTable

`TruncatableTable` is an [extension](#contract) of the [Table](Table.md) abstraction for [tables](#implementations) that can be [truncated](#truncateTable) (i.e., with all rows removed from the table).

## Contract

### truncateTable { #truncateTable }

```java
boolean truncateTable()
```

See:

* [SupportsDeleteV2](SupportsDeleteV2.md#truncateTable)

Used when:

* [TruncateTableExec](../physical-operators/TruncateTableExec.md) physical operator is executed

## Implementations

* [SupportsDeleteV2](SupportsDeleteV2.md)
