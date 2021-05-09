# DataSourceV2ScanRelation Leaf Logical Operator

`DataSourceV2ScanRelation` is a [leaf logical operator](LeafNode.md) and a [NamedRelation](NamedRelation.md).

## Creating Instance

`DataSourceV2ScanRelation` takes the following to be created:

* <span id="relation"> [DataSourceV2Relation](DataSourceV2Relation.md)
* <span id="scan"> [Scan](../connector/Scan.md)
* <span id="output"> Output Schema ([AttributeReference](../expressions/AttributeReference.md)s)

`DataSourceV2ScanRelation` is created when:

* [V2ScanRelationPushDown](../logical-optimizations/V2ScanRelationPushDown.md) logical optimization is executed (for a [DataSourceV2Relation](DataSourceV2Relation.md))

## <span id="name"> Name

```scala
name: String
```

`name` is part of the [NamedRelation](NamedRelation.md#name) abstraction.

`name` requests the [DataSourceV2Relation](#relation) for the [Table](DataSourceV2Relation.md#table) that is in turn requested for the [name](../connector/Table.md#name).

## <span id="simpleString"> Simple Node Description

```scala
simpleString(
  maxFields: Int): String
```

`simpleString` is part of the [TreeNode](../catalyst/TreeNode.md#simpleString) abstraction.

`simpleString` is the following (with the [output schema](#output) and the [name](#name)):

```text
RelationV2[output] [name]
```

## <span id="computeStats"> Statistics

```scala
computeStats(): Statistics
```

`computeStats` is part of the [LeafNode](LeafNode.md#computeStats) abstraction.

`computeStats`...FIXME

## Execution Planning

`DataSourceV2ScanRelation` is planned by [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy to the following physical operators:

* [RowDataSourceScanExec](../physical-operators/RowDataSourceScanExec.md)
* [BatchScanExec](../physical-operators/BatchScanExec.md)
