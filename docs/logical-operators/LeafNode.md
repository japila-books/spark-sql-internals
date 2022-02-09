# LeafNodes

`LeafNode` is an extension of the [LogicalPlan](LogicalPlan.md) abstraction for [leaf logical operators](#implementations) (with no [child nodes](#children)).

## Implementations

* [CTERelationRef](CTERelationRef.md)
* [DataSourceV2Relation](DataSourceV2Relation.md)
* [DataSourceV2ScanRelation](DataSourceV2ScanRelation.md)
* [ExternalRDD](ExternalRDD.md)
* [HiveTableRelation](../hive/HiveTableRelation.md)
* [InMemoryRelation](InMemoryRelation.md)
* [LocalRelation](LocalRelation.md)
* [LogicalQueryStage](../logical-operators/LogicalQueryStage.md)
* [LogicalRDD](LogicalRDD.md)
* [LogicalRelation](LogicalRelation.md)
* _others_

## <span id="children"> Children

```scala
children: Seq[LogicalPlan]
```

`children` is an empty collection (to denote being a leaf in an operator tree).

`children` is part of the [TreeNode](../catalyst/TreeNode.md#children) abstraction.

## <span id="computeStats"> Statistics

```scala
computeStats(): Statistics
```

`computeStats` throws an `UnsupportedOperationException`.

`computeStats` is used when:

* `SizeInBytesOnlyStatsPlanVisitor` is requested for the [default size statistics](SizeInBytesOnlyStatsPlanVisitor.md#default)
