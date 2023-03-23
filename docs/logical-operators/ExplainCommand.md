# ExplainCommand Logical Command

`ExplainCommand` is a [logical command](RunnableCommand.md) to [display logical and physical query plans](#run) (with optional details about codegen and cost statistics) that represents [EXPLAIN](../sql/SparkSqlAstBuilder.md#visitExplain) SQL statement at execution.

## Creating Instance

`ExplainCommand` takes the following to be created:

* <span id="logicalPlan"> [LogicalPlan](LogicalPlan.md)
* <span id="mode"> `ExplainMode`

`ExplainCommand` is created when:

* `SparkSqlAstBuilder` is requested to [parse EXPLAIN statement](../sql/SparkSqlAstBuilder.md#visitExplain)

## <span id="output"> Output Attributes

`ExplainCommand` uses the following [output attributes](Command.md#output):

* `plan` (type: `StringType`)

## <span id="run"> Executing Logical Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` requests the given [SparkSession](../SparkSession.md) for [SessionState](../SparkSession.md#sessionState) that is requested to [execute](../SessionState.md#executePlan) the given [LogicalPlan](#logicalPlan).

The result `QueryExecution` is requested to [explainString](../QueryExecution.md#explainString) with the given [ExplainMode](#mode) that becomes the output.

In case of a `TreeNodeException`, `run` gives the following output:

```text
Error occurred during query planning:
[cause]
```

`run` is part of the [RunnableCommand](RunnableCommand.md#run) abstraction.
