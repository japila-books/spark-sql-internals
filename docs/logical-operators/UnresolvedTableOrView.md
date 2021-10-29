# UnresolvedTableOrView Leaf Logical Operator

`UnresolvedTableOrView` is a [leaf logical operator](LeafNode.md).

## Creating Instance

`UnresolvedTableOrView` takes the following to be created:

* <span id="multipartIdentifier"> Multi-Part Identifier
* <span id="commandName"> Command Name
* <span id="allowTempView"> `allowTempView` flag (default: `true`)

`UnresolvedTableOrView` is created when:

* `AstBuilder` is requested to [visitDropTable](../sql/AstBuilder.md#visitDropTable), [visitDescribeRelation](../sql/AstBuilder.md#visitDescribeRelation), [visitAnalyze](../sql/AstBuilder.md#visitAnalyze), [visitShowCreateTable](../sql/AstBuilder.md#visitShowCreateTable), [visitRefreshTable](../sql/AstBuilder.md#visitRefreshTable), [visitShowColumns](../sql/AstBuilder.md#visitShowColumns), [visitShowTblProperties](../sql/AstBuilder.md#visitShowTblProperties)

## <span id="resolved"> resolved

```scala
resolved: Boolean
```

`resolved` is part of the [LogicalPlan](LogicalPlan.md#resolved) abstraction.

`resolved` is `false`.

## Logical Analysis

`UnresolvedTableOrView` is resolved to the following logical operators:

* `ResolvedView` (by [ResolveTempViews](../logical-analysis-rules/ResolveTempViews.md) and [ResolveRelations](../logical-analysis-rules/ResolveRelations.md) logical resolution rules)
* [ResolvedTable](ResolvedTable.md) (by [ResolveTables](../logical-analysis-rules/ResolveTables.md) and [ResolveRelations](../logical-analysis-rules/ResolveRelations.md) logical resolution rules)
