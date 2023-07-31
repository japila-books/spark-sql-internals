# MergeIntoTable Logical Command

`MergeIntoTable` is a [BinaryCommand](Command.md#BinaryCommand) that represents [MERGE INTO](../sql/AstBuilder.md#visitMergeIntoTable) DML statement.

`MergeIntoTable` is a [SupportsSubquery](SupportsSubquery.md) (for the [source](#sourceTable)).

## Creating Instance

`MergeIntoTable` takes the following to be created:

* <span id="targetTable"> Target Table ([LogicalPlan](LogicalPlan.md))
* <span id="sourceTable"> Source Table or Subquery ([LogicalPlan](LogicalPlan.md))
* <span id="mergeCondition"> Merge Condition ([Expression](../expressions/Expression.md))
* <span id="matchedActions"> Matched `MergeAction`s
* <span id="notMatchedActions"> Not-Matched `MergeAction`s
* <span id="notMatchedBySourceActions"> Not-Matched-by-Source `MergeAction`s

`MergeIntoTable` is created when:

* `AstBuilder` is requested to [parse MERGE INTO SQL statement](../sql/AstBuilder.md#visitMergeIntoTable)

## Execution Planning

`MergeIntoTable` command is not supported in Spark SQL and [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy throws an `UnsupportedOperationException` when finds any:

```text
MERGE INTO TABLE is not supported temporarily.
```

!!! note
    `MergeIntoTable` is to allow custom connectors to support `MERGE` SQL statement (and so does [Delta Lake]({{ book.delta }}/commands/merge/)).
