---
title: FlowAnalysis
---

# FlowAnalysis Utility

??? note "Singleton Object"
    `FlowAnalysis` is a Scala **object** which is a class that has exactly one instance. It is created lazily when it is referenced, like a `lazy val`.

    Learn more in [Tour of Scala](https://docs.scala-lang.org/tour/singleton-objects.html).

## createFlowFunctionFromLogicalPlan { #createFlowFunctionFromLogicalPlan }

```scala
createFlowFunctionFromLogicalPlan(
  plan: LogicalPlan): FlowFunction
```

`createFlowFunctionFromLogicalPlan` takes a [LogicalPlan](../logical-operators/LogicalPlan.md) and creates a [FlowFunction](FlowFunction.md).

When [executed](FlowFunction.md#call), this `FlowFunction` creates a [FlowAnalysisContext](FlowAnalysisContext.md).

`FlowFunction` uses this `FlowAnalysisContext` to [setConf](#setConf) the given SQL configs (to the [FlowFunction](FlowFunction.md#call)).

`FlowFunction` [analyze](#analyze) this `LogicalPlan` (with the `FlowAnalysisContext`). This gives the result data (as a `DataFrame`).

In the end, `FlowFunction` creates a [FlowFunctionResult](FlowFunctionResult.md) with the result data (as a [DataFrame](FlowFunctionResult.md#dataFrame)) and the others (from the [FlowAnalysisContext](FlowAnalysisContext.md)).

---

`createFlowFunctionFromLogicalPlan` is used when:

* `PipelinesHandler` is requested to [define a flow](PipelinesHandler.md#defineFlow)
* `SqlGraphRegistrationContext` is requested to [handle the following logical commands](SqlGraphRegistrationContext.md#processSqlQuery):
    * [CreateFlowCommand](SqlGraphRegistrationContext.md#CreateFlowCommand)
    * [CreateMaterializedViewAsSelect](SqlGraphRegistrationContext.md#CreateMaterializedViewAsSelect)
    * [CreateView](SqlGraphRegistrationContext.md#CreateView)
    * [CreateStreamingTableAsSelect](SqlGraphRegistrationContext.md#CreateStreamingTableAsSelect)
    * [CreateViewCommand](SqlGraphRegistrationContext.md#CreateViewCommand)
