---
title: ScalaUDAF
---

# ScalaUDAF Expression

`ScalaUDAF` is an [ImperativeAggregate](ImperativeAggregate.md) expression.

`ScalaUDAF` is a [UserDefinedExpression](UserDefinedExpression.md).

`ScalaUDAF` is a `NonSQLExpression`.

!!! warning "Deprecation"
    `ScalaUDAF` uses [UserDefinedAggregateFunction](UserDefinedAggregateFunction.md) class that is marked as deprecated as of Spark SQL 3.0.0 with the following comment:

    ```text
    Aggregator[IN, BUF, OUT] should now be registered as a UDF via the functions.udaf(agg) method.
    ```

## Creating Instance

`ScalaUDAF` takes the following to be created:

* <span id="children"> Children ([Expression](Expression.md)s)
* <span id="udaf"> [UserDefinedAggregateFunction](UserDefinedAggregateFunction.md)
* <span id="mutableAggBufferOffset"> `mutableAggBufferOffset` (default: `0`)
* <span id="inputAggBufferOffset"> `inputAggBufferOffset` (default: `0`)
* <span id="udafName"> Name (optional)

`ScalaUDAF` is created when:

* `UDFRegistration` is requested to [register a UserDefinedAggregateFunction](../user-defined-functions/UDFRegistration.md#register)
* `UserDefinedAggregateFunction` is requested to [create a Column for a UDAF](UserDefinedAggregateFunction.md#apply) and [distinct](UserDefinedAggregateFunction.md#distinct)
* `SparkUDFExpressionBuilder` is requested to `makeExpression`
