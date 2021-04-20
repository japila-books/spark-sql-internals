# OverwriteByExpression Logical Command

`OverwriteByExpression` is a [V2WriteCommand](V2WriteCommand.md).

## Creating Instance

`OverwriteByExpression` takes the following to be created:

* <span id="table"> [NamedRelation](NamedRelation.md)
* <span id="deleteExpr"> Delete [Expression](../expressions/Expression.md)
* <span id="query"> [Logical Query Plan](LogicalPlan.md)
* <span id="writeOptions"> Write Options
* <span id="isByName"> `isByName` flag

`OverwriteByExpression` is created (using [byName](#byName) and [byPosition](#byPosition) utilities) when...FIXME

## <span id="resolved"> resolved

```scala
resolved: Boolean
```

`resolved` is `true` when [outputResolved](V2WriteCommand.md#outputResolved) and [delete expression](#deleteExpr) are.

`resolved` is part of the [LogicalPlan](LogicalPlan.md#resolved) abstraction.

## <span id="byName"> Creating OverwriteByExpression by Name

```scala
byName(
  table: NamedRelation,
  df: LogicalPlan,
  deleteExpr: Expression,
  writeOptions: Map[String, String] = Map.empty): OverwriteByExpression
```

`byName` creates a [OverwriteByExpression](#creating-instance) with [isByName](#isByName) enabled (`true`).

`byName` is used when:

* `DataFrameWriter` is requested to [save](../DataFrameWriter.md#save)
* `DataFrameWriterV2` is requested to [overwrite](../DataFrameWriterV2.md#overwrite)

## <span id="byPosition"> Creating OverwriteByExpression by Position

```scala
byPosition(
  table: NamedRelation,
  query: LogicalPlan,
  deleteExpr: Expression,
  writeOptions: Map[String, String] = Map.empty): OverwriteByExpression
```

`byPosition` creates a [OverwriteByExpression](#creating-instance) with [isByName](#isByName) disabled (`false`).

`byPosition` is used:

* [ResolveInsertInto](../logical-analysis-rules/ResolveInsertInto.md) logical resolution rule is executed
* `DataFrameWriter` is requested to [insertInto](../DataFrameWriter.md#insertInto)
