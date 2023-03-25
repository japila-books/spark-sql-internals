# NoopTable

`NoopTable` is a [Table](../connector/Table.md) that supports [write](../connector/SupportsWrite.md) in [noop](index.md) data source.

## <span id="name"> Name

```scala
name(): String
```

`name` is **noop-table**.

`name` is part of the [SupportsWrite](../connector/SupportsWrite.md#name) abstraction.

## <span id="capabilities"> Capabilities

```scala
capabilities(): ju.Set[TableCapability]
```

`NoopTable` supports the following capabilities:

* [BATCH_WRITE](../connector/TableCapability.md#BATCH_WRITE)
* [STREAMING_WRITE](../connector/TableCapability.md#STREAMING_WRITE)
* [TRUNCATE](../connector/TableCapability.md#TRUNCATE)
* [ACCEPT_ANY_SCHEMA](../connector/TableCapability.md#ACCEPT_ANY_SCHEMA)

`capabilities` is part of the [Table](../connector/Table.md#capabilities) abstraction.

## <span id="newWriteBuilder"> Creating WriteBuilder

```scala
newWriteBuilder(
  info: LogicalWriteInfo): WriteBuilder
```

`newWriteBuilder` creates a [NoopWriteBuilder](NoopWriteBuilder.md).

`newWriteBuilder` is part of the [SupportsWrite](../connector/SupportsWrite.md#newWriteBuilder) abstraction.
