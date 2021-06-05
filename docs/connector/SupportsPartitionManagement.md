# SupportsPartitionManagement

`SupportsPartitionManagement` is an [extension](#contract) of the [Table](Table.md) abstraction for [partitioned tables](#implementations).

## Contract

### <span id="createPartition"> createPartition

```java
void createPartition(
  InternalRow ident,
  Map<String, String> properties)
```

Used when:

* `AlterTableAddPartitionExec` physical command is executed

### <span id="dropPartition"> dropPartition

```java
boolean dropPartition(
  InternalRow ident)
```

Used when:

* `AlterTableDropPartitionExec` physical command is executed

### <span id="listPartitionIdentifiers"> listPartitionIdentifiers

```java
InternalRow[] listPartitionIdentifiers(
  String[] names,
  InternalRow ident)
```

Used when:

* `ShowPartitionsExec` physical command is executed

### <span id="loadPartitionMetadata"> loadPartitionMetadata

```java
Map<String, String> loadPartitionMetadata(
  InternalRow ident)
```

### <span id="partitionExists"> partitionExists

```java
boolean partitionExists(
  InternalRow ident)
```

Used when:

* `AlterTableAddPartitionExec` and `AlterTableDropPartitionExec` physical commands are executed

### <span id="partitionSchema"> partitionSchema

```java
StructType partitionSchema()
```

Used when:

* `AlterTableAddPartitionExec`, `AlterTableDropPartitionExec` and `ShowPartitionsExec` physical commands are executed
* `SupportsPartitionManagement` is requested to [partitionExists](#partitionExists)
* `CheckAnalysis` is requested to [checkShowPartitions](../CheckAnalysis.md#checkShowPartitions)
* `ResolvePartitionSpec` logical analysis rule is executed

### <span id="replacePartitionMetadata"> replacePartitionMetadata

```java
void replacePartitionMetadata(
  InternalRow ident,
  Map<String, String> properties)
```

## Implementations

* [SupportsAtomicPartitionManagement](SupportsAtomicPartitionManagement.md)
