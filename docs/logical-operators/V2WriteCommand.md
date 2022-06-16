# V2WriteCommand Logical Commands

`V2WriteCommand` is an [extension](#contract) of the [Command](Command.md) abstraction for [logical commands](#implementations) that write [data](#query) to [tables](#table) in [DataSource V2](../new-and-noteworthy/datasource-v2.md).

## Contract

### <span id="isByName"> isByName Flag

```scala
isByName: Boolean
```

Used when:

* [ResolveOutputRelation](../logical-analysis-rules/ResolveOutputRelation.md) logical resolution rule is executed (for `TableOutputResolver` to `resolveOutputColumns`)

### <span id="query"> Query

```scala
query: LogicalPlan
```

[LogicalPlan](LogicalPlan.md) for the data to write out

### <span id="table"> Table

```scala
table: NamedRelation
```

[NamedRelation](NamedRelation.md) of the table

### <span id="withNewQuery"> withNewQuery

```scala
withNewQuery(
  newQuery: LogicalPlan): V2WriteCommand
```

### <span id="withNewQuery"> withNewQuery

```scala
withNewTable(
  newTable: NamedRelation): V2WriteCommand
```

## Implementations

* [AppendData](AppendData.md)
* [OverwriteByExpression](OverwriteByExpression.md)
* [OverwritePartitionsDynamic](OverwritePartitionsDynamic.md)
