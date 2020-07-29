# V2CreateTablePlan Logical Operators

`V2CreateTablePlan` is an [extension](#contract) of the [LogicalPlan](LogicalPlan.md) abstraction for [logical operators](#implementations) that create or replace V2 table definitions.

## Contract

### <span id="partitioning"> partitioning

```scala
partitioning: Seq[Transform]
```

Used when...FIXME

### <span id="tableName"> tableName

```scala
tableName: Identifier
```

Used when [PreprocessTableCreation](../logical-analysis-rules/PreprocessTableCreation.md) post-hoc logical resolution rule is executed

### <span id="tableSchema"> tableSchema

```scala
tableSchema: StructType
```

Used when...FIXME

### <span id="withPartitioning"> withPartitioning

```scala
withPartitioning(
  rewritten: Seq[Transform]): V2CreateTablePlan
```

Used when...FIXME

## Implementations

* CreateTableAsSelect
* [CreateV2Table](CreateV2Table.md)
* ReplaceTable
* ReplaceTableAsSelect
