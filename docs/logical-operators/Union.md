---
title: Union
---

# Union Logical Operator

`Union` is a [logical operator](LogicalPlan.md) that represents the following high-level operators in a logical plan:

* [UNION](../sql/AstBuilder.md#visitSetOperation) SQL statement
* [Dataset.union](../dataset/index.md#union), [Dataset.unionAll](../dataset/index.md#unionAll) and [Dataset.unionByName](../dataset/index.md#unionByName) operators

`Union` is resolved using `ResolveUnion` logical analysis rule.

`Union` is resolved into `UnionExec` physical operator by [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy.

## Creating Instance

`Union` takes the following to be created:

* <span id="children"> Child [LogicalPlan](LogicalPlan.md)s
* <span id="byName"> `byName` flag (default: `false`)
* <span id="allowMissingCol"> `allowMissingCol` flag (default: `false`)

!!! note
    [allowMissingCol](#allowMissingCol) can be `true` only with [byName](#byName) being `true`.

`Union` is created (possibly using [apply](#apply) utility) when:

* `AstBuilder` is requested to [visitFromStatement](../sql/AstBuilder.md#visitFromStatement) and [visitMultiInsertQuery](../sql/AstBuilder.md#visitMultiInsertQuery)
* `Dataset` is requested to [flattenUnion](../dataset/index.md#flattenUnion) (for [Dataset.union](../dataset/index.md#union) and [Dataset.unionByName](../dataset/index.md#unionByName) operators)
* [Dataset.unionByName](../dataset/index.md#unionByName) operator is used

## Creating Union { #apply }

```scala
apply(
  left: LogicalPlan,
  right: LogicalPlan): Union
```

`apply` creates a [Union](Union.md) logical operator (with the `left` and `right` plans as the [children](#children) operators).

---

`apply` is used when:

* `ResolveUnion` logical resolution rule is executed
* `RewriteUpdateTable` is requested to `buildReplaceDataWithUnionPlan`
* [RewriteExceptAll](../logical-optimizations/RewriteExceptAll.md) logical optimization is executed
* `RewriteIntersectAll` logical optimization is executed
* `AstBuilder` is requested to [parse UNION SQL statement](../sql/AstBuilder.md#visitSetOperation)
* [Dataset.union](../dataset/index.md#union) operator is used

## Maximum Number of Records { #maxRows }

??? note "LogicalPlan"

    ```scala
    maxRows: Option[Long]
    ```

    `maxRows` is part of the [LogicalPlan](LogicalPlan.md#maxRows) abstraction.

`maxRows` is the total of the [maxRows](LogicalPlan.md#maxRows) of all the [children](#children).

## Node Patterns { #nodePatterns }

??? note "TreeNode"

    ```scala
    nodePatterns: Seq[TreePattern]
    ```

    `nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.

`nodePatterns` is [UNION](../catalyst/TreePattern.md#UNION).

## Metadata Output Attributes { #metadataOutput }

??? note "LogicalPlan"

    ```scala
    metadataOutput: Seq[Attribute]
    ```

    `metadataOutput` is part of the [LogicalPlan](LogicalPlan.md#metadataOutput) abstraction.

`metadataOutput` is empty.

## Catalyst DSL

[Catalyst DSL](../catalyst-dsl/index.md) comes with [union](../catalyst-dsl/DslLogicalPlan.md#union) operator to create an `Union` operator.

```scala
union(
  otherPlan: LogicalPlan): LogicalPlan
```

## Logical Optimizations

* `EliminateUnions`
* [CombineUnions](../logical-optimizations/CombineUnions.md)
