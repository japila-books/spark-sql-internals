---
title: V2CreateTablePlan
---

# V2CreateTablePlan Logical Operators

`V2CreateTablePlan` is an [extension](#contract) of the [LogicalPlan](LogicalPlan.md) abstraction for [logical operators](#implementations) that create or replace V2 table definitions.

## Contract

### <span id="partitioning"> Partitioning Transforms

```scala
partitioning: Seq[Transform]
```

Partitioning [Transform](../connector/Transform.md)s

### <span id="tableName"> tableName

```scala
tableName: Identifier
```

Used when [PreprocessTableCreation](../logical-analysis-rules/PreprocessTableCreation.md) post-hoc logical resolution rule is executed

### <span id="tableSchema"> Table Schema

```scala
tableSchema: StructType
```

### <span id="withPartitioning"> withPartitioning

```scala
withPartitioning(
  rewritten: Seq[Transform]): V2CreateTablePlan
```

## Implementations

* [CreateTableAsSelect](CreateTableAsSelect.md)
* `ReplaceTable`
* `ReplaceTableAsSelect`
