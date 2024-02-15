---
title: WriteDeltaExec
---

# WriteDeltaExec Physical Operator

`WriteDeltaExec` is a [V2ExistingTableWriteExec](V2ExistingTableWriteExec.md) physical operator that represents a [WriteDelta](../logical-operators/WriteDelta.md) logical operator at execution time.

## Creating Instance

`WriteDeltaExec` takes the following to be created:

* <span id="query"> Query Physical Plan ([SparkPlan](SparkPlan.md))
* <span id="refreshCache"> `refreshCache` function (`() => Unit`)
* <span id="projections"> `WriteDeltaProjections`
* <span id="write"> `DeltaWrite`

`WriteDeltaExec` is created when:

* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (to plan a [WriteDelta](../logical-operators/WriteDelta.md) logical operator)
