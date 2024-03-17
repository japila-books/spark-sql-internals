---
title: ExpandExec
---

# ExpandExec Physical Operator

`ExpandExec` is a [unary physical operator](UnaryExecNode.md) with support for [Whole-Stage Java Code Generation](CodegenSupport.md).

## Creating Instance

`ExpandExec` takes the following to be created:

* <span id="projections"> Projection [Expression](../expressions/Expression.md)s (`Seq[Seq[Expression]]`)
* <span id="output"> Output [Attribute](../expressions/Attribute.md)s
* <span id="child"> Child [physical operator](SparkPlan.md)

`ExpandExec` is created when:

* [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed (to plan a [Expand](../logical-operators/Expand.md) logical operator)

## Performance Metrics { #metrics }

### number of output rows { #numOutputRows }

## Generating Java Source Code for Consume Path { #doConsume }

??? note "CodegenSupport"

    ```scala
    doConsume(
      ctx: CodegenContext,
      input: Seq[ExprCode],
      row: ExprCode): String
    ```

    `doConsume` is part of the [CodegenSupport](CodegenSupport.md#doConsume) abstraction.

`doConsume`...FIXME

## Generating Java Source Code for Produce Path { #doProduce }

??? note "CodegenSupport"

    ```scala
    doProduce(
      ctx: CodegenContext): String
    ```

    `doProduce` is part of the [CodegenSupport](CodegenSupport.md#doProduce) abstraction.

`doProduce` requests the [child](#child) operator (that is supposed to be a [CodegenSupport](CodegenSupport.md) physical operator) to [generate a Java source code for produce code path](CodegenSupport.md#produce).

## Executing Operator { #doExecute }

??? note "SparkPlan"

    ```scala
    doExecute(): RDD[InternalRow]
    ```

    `doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute` requests the [child](#child) operator to [execute](SparkPlan.md#execute) (that creates a `RDD[InternalRow]`).

`doExecute` uses `RDD.mapPartitions` operator to apply a function to each partition of the `RDD[InternalRow]`.

`doExecute`...FIXME

## needCopyResult { #needCopyResult }

??? note "CodegenSupport"

    ```scala
    needCopyResult: Boolean
    ```

    `needCopyResult` is part of the [CodegenSupport](CodegenSupport.md#needCopyResult) abstraction.

`needCopyResult` is always enabled (`true`).

## canPassThrough { #canPassThrough }

`ExpandExec` [canPassThrough](../physical-optimizations/RemoveRedundantProjects.md#canPassThrough) in [RemoveRedundantProjects](../physical-optimizations/RemoveRedundantProjects.md) physical optimization.

## Demo

!!! note "FIXME"

    1. Create an plan with `ExpandExec`
    1. Access the operator
    1. Request it to produce the consume path code
