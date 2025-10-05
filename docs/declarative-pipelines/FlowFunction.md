# FlowFunction

`FlowFunction` is an [abstraction](#contract) of [transformation functions](#implementations) that define [flow](Flow.md#func)s.

`FlowFunction` is created when `FlowAnalysis` is requested to [createFlowFunctionFromLogicalPlan](FlowAnalysis.md#createFlowFunctionFromLogicalPlan).

## Contract

### call

```scala
call(
  allInputs: Set[TableIdentifier],
  availableInputs: Seq[Input],
  configuration: Map[String, String],
  queryContext: QueryContext,
  queryOrigin: QueryOrigin): FlowFunctionResult
```

Transformation that yields a [FlowFunctionResult](FlowFunctionResult.md) (with the [data](FlowFunctionResult.md#dataFrame), if successful)

Used when:

* `FlowResolver` is requested to [attemptResolveFlow](FlowResolver.md#attemptResolveFlow)
