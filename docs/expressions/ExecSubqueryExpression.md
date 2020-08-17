# ExecSubqueryExpression Expressions

`SubqueryExpression` is an [extension](#contract) of the [PlanExpression](PlanExpression.md) abstraction for [subquery expressions](#implementations) with [BaseSubqueryExec](../physical-operators/BaseSubqueryExec.md) physical operators (for a subquery).

## Contract

### updateResult

<span id="updateResult">
```scala
updateResult(): Unit
```

Updates the expression with a [collected result](../physical-operators/SparkPlan.md#executeCollect) from an executed plan

`updateResult` is used when `SparkPlan` is requested to [waitForSubqueries](../physical-operators/SparkPlan.md#waitForSubqueries).

### withNewPlan

 <span id="withNewPlan">
```scala
withNewPlan(
  plan: BaseSubqueryExec): ExecSubqueryExpression
```

!!! note
    `withNewPlan` is part of the [PlanExpression](PlanExpression.md) abstraction and is defined as follows:
    
    ```scala
    withNewPlan(plan: T): PlanExpression[T]
    ```

    The purpose of this override method is to change the input and output generic types to the concrete [BaseSubqueryExec](../physical-operators/BaseSubqueryExec.md) and `ExecSubqueryExpression`, respectively.

## Implementations

* [InSubqueryExec](InSubqueryExec.md)
* [ScalarSubquery](ScalarSubquery.md)
