---
title: OverwriteByExpressionExec
---

# OverwriteByExpressionExec Physical Command

`OverwriteByExpressionExec` is a [V2TableWriteExec](V2TableWriteExec.md) with [BatchWriteHelper](BatchWriteHelper.md).

## Creating Instance

`OverwriteByExpressionExec` takes the following to be created:

* <span id="table"> [SupportsWrite](../connector/SupportsWrite.md)
* <span id="deleteWhere"> Delete Filters (`Array[Filter]`)
* <span id="writeOptions"> Write Options
* <span id="query"> [Physical Query Plan](SparkPlan.md)

`OverwriteByExpressionExec` is created when [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed for [OverwriteByExpression](../logical-operators/OverwriteByExpression.md) with [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md) over writable tables (tables with [SupportsWrite](../connector/SupportsWrite.md) except with [V1_BATCH_WRITE](../connector/TableCapability.md#V1_BATCH_WRITE) capability).
