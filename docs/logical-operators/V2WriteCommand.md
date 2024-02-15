---
title: V2WriteCommand
---

# V2WriteCommand Logical Commands

`V2WriteCommand` is an [extension](#contract) of the [UnaryCommand](Command.md) abstraction for [unary logical commands](#implementations) that write [data](#query) out to [tables](#table).

## Contract

### <span id="isByName"> isByName

```scala
isByName: Boolean
```

Always disabled (`false`):

* [ReplaceData](ReplaceData.md#isByName)
* [WriteDelta](WriteDelta.md#isByName)

Used when:

* `ResolveOutputRelation` logical resolution rule is executed (for `TableOutputResolver` to `resolveOutputColumns`)

### <span id="query"> Query

```scala
query: LogicalPlan
```

[LogicalPlan](LogicalPlan.md) of the data to be written out

### <span id="table"> Table

```scala
table: NamedRelation
```

[NamedRelation](NamedRelation.md) of the table to write data to

### <span id="withNewQuery"> withNewQuery

```scala
withNewQuery(
  newQuery: LogicalPlan): V2WriteCommand
```

Used when:

* `ResolveOutputRelation` logical analysis rule is executed

### <span id="withNewTable"> withNewTable

```scala
withNewTable(
  newTable: NamedRelation): V2WriteCommand
```

Used when:

* [ResolveRelations](../logical-analysis-rules/ResolveRelations.md) logical analysis rule is executed
* `ResolveOutputRelation` logical analysis rule is executed

## Implementations

* [AppendData](AppendData.md)
* [OverwriteByExpression](OverwriteByExpression.md)
* [OverwritePartitionsDynamic](OverwritePartitionsDynamic.md)
* [RowLevelWrite](RowLevelWrite.md)
