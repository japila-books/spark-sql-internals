---
title: CreateFlowCommand
---

# CreateFlowCommand Binary Logical Operator

`CreateFlowCommand` is a `BinaryCommand` logical operator that represents [CREATE FLOW ... AS INSERT INTO ... BY NAME](../sql/SparkSqlAstBuilder.md#visitCreatePipelineInsertIntoFlow) SQL statements in [Spark Declarative Pipelines](../declarative-pipelines/index.md).

`CreateFlowCommand` is handled by [SqlGraphRegistrationContext](../declarative-pipelines/SqlGraphRegistrationContext.md#CreateFlowCommand).

`Pipelines` execution planning strategy is used to prevent direct execution of Spark Declarative Pipelines' SQL stataments.

## Creating Instance

`CreateFlowCommand` takes the following to be created:

* <span id="name"> Name (`UnresolvedIdentifier` leaf logical operator)
* <span id="flowOperation"> Flow operation ([InsertIntoStatement](InsertIntoStatement.md) unary logical operator)
* <span id="comment"> Comment (optional)

`CreateFlowCommand` is created when:

* `SparkSqlAstBuilder` is requested to [parse CREATE FLOW AS INSERT INTO BY NAME SQL statement](../sql/SparkSqlAstBuilder.md#visitCreatePipelineInsertIntoFlow)
