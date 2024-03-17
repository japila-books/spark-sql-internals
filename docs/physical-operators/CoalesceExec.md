---
title: CoalesceExec
---

# CoalesceExec Unary Physical Operator

`CoalesceExec` is a [unary physical operator](UnaryExecNode.md) that represents [Repartition](../logical-operators/Repartition.md) logical operator (with [shuffle](../logical-operators/Repartition.md#shuffle) disabled) at execution.

## Creating Instance

`CoalesceExec` takes the following to be created:

* <span id="numPartitions"> Number of partitions
* <span id="child"> Child [physical operator](SparkPlan.md)

`CoalesceExec` is created when:

* [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed (to plan a [Repartition](../logical-operators/Repartition.md) logical operator with [shuffle](../logical-operators/Repartition.md#shuffle) disabled)

## Executing Operator { #doExecute }

??? note "SparkPlan"

    ```scala
    doExecute(): RDD[InternalRow]
    ```

    `doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute`...FIXME

## Output Data Partitioning Requirements { #outputPartitioning }

??? note "SparkPlan"

    ```scala
    outputPartitioning: Partitioning
    ```

    `outputPartitioning` is part of the [SparkPlan](SparkPlan.md#outputPartitioning) abstraction.

`outputPartitioning` is one of the following:

* [SinglePartition](Partitioning.md#SinglePartition) for the [number of partitions](#numPartitions) being `1`
* [UnknownPartitioning](Partitioning.md#UnknownPartitioning) with the [number of partitions](#numPartitions)
