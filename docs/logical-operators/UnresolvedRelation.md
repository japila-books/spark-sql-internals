---
title: UnresolvedRelation
---

# UnresolvedRelation Logical Operator

`UnresolvedRelation` is a [leaf logical operator](LeafNode.md) with a [name](#name) (as a [NamedRelation](NamedRelation.md)) that represents a named relation that has yet to be looked up in a catalog at analysis.

`UnresolvedRelation` is never [resolved](#resolved) and has to be replaced using [ResolveRelations](../logical-analysis-rules/ResolveRelations.md) logical resolution rule.

## Creating Instance

`UnresolvedRelation` takes the following to be created:

* <span id="multipartIdentifier"> Multi-part identifier
* <span id="options"> Options
* <span id="isStreaming"> `isStreaming` flag (default: `false`)

`UnresolvedRelation` is created (possibly indirectly using [apply](#apply) factory) when:

* `AstBuilder` is requested to parse [TABLE statement](../sql/AstBuilder.md#visitTable) and [table name](../sql/AstBuilder.md#visitTableName), and [create an UnresolvedRelation](../sql/AstBuilder.md#createUnresolvedRelation)
* [DataFrameReader.table](../DataFrameReader.md#table) operator is used
* [DataFrameWriterV2](../DataFrameWriterV2.md) operators are used:
    * [DataFrameWriterV2.append](../DataFrameWriterV2.md#append)
    * [DataFrameWriterV2.overwrite](../DataFrameWriterV2.md#overwrite)
    * [DataFrameWriterV2.overwritePartitions](../DataFrameWriterV2.md#overwritePartitions)
* `DataStreamReader.table` ([Spark Structured Streaming]({{ book.structured_streaming }}/DataStreamReader#table)) operator is used
* `SparkConnectPlanner` is requested to [transformReadRel](../connect/SparkConnectPlanner.md#transformReadRel)
* [table](../catalyst-dsl/index.md#table) ([Catalyst DSL](../catalyst-dsl/index.md)) operator is used

## Creating UnresolvedRelation { #apply }

```scala
apply(
  tableIdentifier: TableIdentifier): UnresolvedRelation
apply(
  tableIdentifier: TableIdentifier,
  extraOptions: CaseInsensitiveStringMap,
  isStreaming: Boolean): UnresolvedRelation
```

`apply` creates an [UnresolvedRelation](#creating-instance).

---

`apply` is used when:

* [DataFrameWriter.insertInto](../DataFrameWriter.md#insertInto) operator is used
* [SparkSession.table](../SparkSession.md#table) operator is used

## Name { #name }

??? note "Signature"

    ```scala
    name: String
    ```

    `name` is part of the [NamedRelation](NamedRelation.md#name) abstraction.

`name` is [quoted multi-part dot-separated table name](#tableName).

### Quoted Multi-Part Dot-Separated Table Name { #tableName }

```scala
tableName: String
```

`tableName` is a quoted multi-part `.`-separated [multipartIdentifier](#multipartIdentifier).

## resolved

??? note "Signature"

    ```scala
    resolved: Boolean
    ```

    `resolved` is part of the [LogicalPlan](LogicalPlan.md#resolved) abstraction.

`resolved` is disabled (`false`).

## nodePatterns { #nodePatterns }

??? note "Signature"

    ```scala
    nodePatterns: Seq[TreePattern]
    ```

    `nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.

`nodePatterns` is a single-element collection with [UNRESOLVED_RELATION](../catalyst/TreePattern.md#UNRESOLVED_RELATION).
