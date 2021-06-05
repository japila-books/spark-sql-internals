# SupportsAtomicPartitionManagement

`SupportsAtomicPartitionManagement` is an [extension](#contract) of the [SupportsPartitionManagement](SupportsPartitionManagement.md) abstraction for partitioned tables.

## Contract

### <span id="createPartitions"> createPartitions

```java
void createPartitions(
  InternalRow[] idents,
  Map<String, String>[] properties)
```

Used when:

* `AlterTableAddPartitionExec` physical operator is executed

### <span id="dropPartitions"> dropPartitions

```java
boolean dropPartitions(
  InternalRow[] idents)
```

Used when:

* `AlterTableDropPartitionExec` physical operator is executed
