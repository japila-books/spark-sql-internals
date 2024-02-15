---
title: WriteDelta
---

# WriteDelta Logical Operator

`WriteDelta` is a [RowLevelWrite](RowLevelWrite.md) logical operator.

## Creating Instance

`WriteDelta` takes the following to be created:

* <span id="table"> Table ([NamedRelation](NamedRelation.md))
* <span id="condition"> Condition ([Expression](../expressions/Expression.md))
* <span id="query"> Query ([LogicalPlan](LogicalPlan.md))
* <span id="originalTable"> Original Table ([NamedRelation](NamedRelation.md))
* <span id="projections"> `WriteDeltaProjections`
* <span id="write"> `DeltaWrite`

`WriteDelta` is created when:

* [RewriteDeleteFromTable](../logical-analysis-rules/RewriteDeleteFromTable.md) logical analysis rule is executed (and requested to [buildWriteDeltaPlan](../logical-analysis-rules/RewriteDeleteFromTable.md#buildWriteDeltaPlan) for [SupportsDelta](../connector/SupportsDelta.md) row-level operations)
* `RewriteMergeIntoTable` logical analysis rule is executed (and `buildWriteDeltaPlan` for [SupportsDelta](../connector/SupportsDelta.md) row-level operations)
* `RewriteUpdateTable` logical analysis rule is executed (and `buildWriteDeltaPlan` for [SupportsDelta](../connector/SupportsDelta.md) row-level operations)

## Query Planning

`WriteDelta` is planned to [WriteDeltaExec](../physical-operators/WriteDeltaExec.md) physical operator by [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy.
