# AggregateInPandasExec Physical Operator

`AggregateInPandasExec` is a [unary physical operator](../physical-operators/UnaryExecNode.md) that...FIXME

## Creating Instance

`AggregateInPandasExec` takes the following to be created:

* <span id="groupingExpressions"> Grouping [Expressions](../expressions/Expression.md) (`Seq[NamedExpression]`)
* <span id="udfExpressions"> [PythonUDF](PythonUDF.md)s
* <span id="resultExpressions"> Result [Named Expressions](../expressions/NamedExpression.md) (`Seq[NamedExpression]`)
* <span id="child"> Child [Physical Operator](../physical-operators/SparkPlan.md)

`AggregateInPandasExec` is created when [Aggregation](../execution-planning-strategies/Aggregation.md) execution planning strategy is executed (for [Aggregate](../logical-operators/Aggregate.md) logical operators with [PythonUDF](PythonUDF.md) aggregate expressions only).

## <span id="doExecute"> Executing Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` uses [ArrowPythonRunner](ArrowPythonRunner.md) (one per partition) to execute [PythonUDFs](#udfExpressions).

`doExecute` is part of the [SparkPlan](../physical-operators/SparkPlan.md#doExecute) abstraction.
