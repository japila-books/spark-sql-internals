# RewriteDeleteFromTable Analysis Rule

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

---

`apply` rewrites the [table](../logical-operators/DeleteFromTable.md#table) in [DeleteFromTable](../logical-operators/DeleteFromTable.md) logical operators (in the given [LogicalPlan](../logical-operators/LogicalPlan.md)):

* For [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md)s with [TruncatableTable](../connector/TruncatableTable.md) and `TrueLiteral` [condition](../logical-operators/DeleteFromTable.md#condition), skips rewriting (leaves them untouched).

* For [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md)s with [SupportsRowLevelOperations](../connector/SupportsRowLevelOperations.md)...FIXME

* For [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md)s with [SupportsDelete](../connector/SupportsDelete.md)...FIXME

### <span id="buildReplaceDataPlan"> buildReplaceDataPlan

```scala
buildReplaceDataPlan(
  relation: DataSourceV2Relation,
  operationTable: RowLevelOperationTable,
  cond: Expression): ReplaceData
```

`buildReplaceDataPlan`...FIXME
