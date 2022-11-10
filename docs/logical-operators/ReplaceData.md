# ReplaceData Logical Operator

`ReplaceData` is a [RowLevelWrite](RowLevelWrite.md) logical operator.

`ReplaceData` represents [DataSourceV2Relation](DataSourceV2Relation.md) with [SupportsRowLevelOperations](../connector/SupportsRowLevelOperations.md) in [DeleteFromTable](DeleteFromTable.md) operators.

## Creating Instance

`ReplaceData` takes the following to be created:

* <span id="table"> [NamedRelation](NamedRelation.md) of the target table
* <span id="condition"> Condition [Expression](../expressions/Expression.md)
* <span id="query"> Query [LogicalPlan](LogicalPlan.md)
* <span id="originalTable"> [NamedRelation](NamedRelation.md) of the original table
* <span id="write"> Optional [Write](../connector/Write.md) (default: undefined)

`ReplaceData` is created when:

* [RewriteDeleteFromTable](../logical-analysis-rules/RewriteDeleteFromTable.md) analysis rule is executed (to [buildReplaceDataPlan](../logical-analysis-rules/RewriteDeleteFromTable.md#buildReplaceDataPlan))
