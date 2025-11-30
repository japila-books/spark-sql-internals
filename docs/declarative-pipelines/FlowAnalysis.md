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

`createFlowFunctionFromLogicalPlan` takes a [LogicalPlan](../logical-operators/LogicalPlan.md) (that represents one of the supported logical commands) and creates a [FlowFunction](FlowFunction.md).

When [executed](FlowFunction.md#call), this `FlowFunction` creates a [FlowAnalysisContext](FlowAnalysisContext.md).

`FlowFunction` uses this `FlowAnalysisContext` to [set the SQL configs](FlowAnalysisContext.md#setConf) (given to the [FlowFunction](FlowFunction.md#call) being defined).

`FlowFunction` [analyze](#analyze) this `LogicalPlan` (with the `FlowAnalysisContext`). This gives the result data (as a `DataFrame`).

In the end, `FlowFunction` creates a [FlowFunctionResult](FlowFunctionResult.md) with the result data (as a [DataFrame](FlowFunctionResult.md#dataFrame)) and the others (from the [FlowAnalysisContext](FlowAnalysisContext.md)).

---

`createFlowFunctionFromLogicalPlan` is used when:

* `PipelinesHandler` is requested to [define a flow](PipelinesHandler.md#defineFlow)
* `SqlGraphRegistrationContext` is requested to [handle the following queries](SqlGraphRegistrationContext.md#processSqlQuery):
    * [CreateFlowCommand](SqlGraphRegistrationContext.md#CreateFlowCommand)
    * [CreateMaterializedViewAsSelect](SqlGraphRegistrationContext.md#CreateMaterializedViewAsSelect)
    * [CreateView](SqlGraphRegistrationContext.md#CreateView)
    * [CreateStreamingTableAsSelect](SqlGraphRegistrationContext.md#CreateStreamingTableAsSelect)
    * [CreateViewCommand](SqlGraphRegistrationContext.md#CreateViewCommand)

### Analyze Logical Command { #analyze }

```scala
analyze(
  context: FlowAnalysisContext,
  plan: LogicalPlan): DataFrame
```

!!! note "CTEs"
    `analyze` resolves pipeline-specific TVFs and CTEs.

    ```sql
    SELECT ... FROM STREAM(t1)
    SELECT ... FROM STREAM t1
    ```

    Developers can define CTEs within their CREATE statements:

    ```sql
    CREATE STREAMING TABLE a
    WITH b AS (
       SELECT * FROM STREAM upstream
    )
    SELECT * FROM b
    ```

`analyze`...FIXME

## Read Batch Input { #readBatchInput }

```scala
readBatchInput(
  context: FlowAnalysisContext,
  name: String,
  batchReadOptions: BatchReadOptions): DataFrame
```

`readBatchInput`...FIXME

---

`readBatchInput` is used when:

* `FlowAnalysis` is requested to [analyze](#analyze)

### Read External Batch Input { #readExternalBatchInput }

```scala
readExternalBatchInput(
  context: FlowAnalysisContext,
  inputIdentifier: ExternalDatasetIdentifier,
  name: String): DataFrame
```

`readExternalBatchInput`...FIXME

## Read Stream Input { #readStreamInput }

```scala
readStreamInput(
  context: FlowAnalysisContext,
  name: String,
  streamReader: DataStreamReader,
  streamingReadOptions: StreamingReadOptions): DataFrame
```

`readStreamInput` resolves the given `name` (in the given [FlowAnalysisContext](FlowAnalysisContext.md)).

For an `InternalDatasetIdentifier` (that is defined by the current pipeline), `readStreamInput` [readGraphInput](#readGraphInput).

For an `ExternalDatasetIdentifier` (that is external to the current pipeline), `readStreamInput` [readExternalStreamInput](#readExternalStreamInput).

---

`readStreamInput` is used when:

* `FlowAnalysis` is requested to [analyze](#analyze)

### Read External Stream Input { #readExternalStreamInput }

```scala
readExternalStreamInput(
  context: FlowAnalysisContext,
  inputIdentifier: ExternalDatasetIdentifier,
  streamReader: DataStreamReader,
  name: String): DataFrame
```

`readExternalStreamInput`...FIXME

## Read Graph Input { #readGraphInput }

```scala
readGraphInput(
  ctx: FlowAnalysisContext,
  inputIdentifier: InternalDatasetIdentifier,
  readOptions: InputReadOptions): DataFrame
```

!!! note "Load DataFrame"
    It is up to the [Input](Input.md) (for the given `InternalDatasetIdentifier`) to [load a DataFrame](Input.md#load) that may either be batch or streaming.

`readGraphInput` records the input dataset identifier in the given [FlowAnalysisContext](FlowAnalysisContext.md#requestedInputs).

??? note "SparkException"
    For a dataset not defined in the dataflow graph (the given `InternalDatasetIdentifier` not being available in the [FlowAnalysisContext](FlowAnalysisContext.md#allInputs)),
    `readGraphInput` reports a `SparkException`.

`readGraphInput` finds the [Input](Input.md) for the given `InternalDatasetIdentifier` (in the [FlowAnalysisContext](FlowAnalysisContext.md#availableInput)).

`readGraphInput` requests the `Input` to [load a DataFrame](Input.md#load) (with the given [InputReadOptions](InputReadOptions.md)).

`readGraphInput` records a `ResolvedInput` in the [FlowAnalysisContext](FlowAnalysisContext.md) (in [streamingInputs](FlowAnalysisContext.md#streamingInputs) or [batchInputs](FlowAnalysisContext.md#batchInputs) for `StreamingReadOptions` or `BatchReadOptions`, respectively).

In the end, `readGraphInput` creates a (streaming or batch) `Dataset`.

---

`readGraphInput` is used when:

* `FlowAnalysis` is requested to read [batch](#readBatchInput) and [stream](#readStreamInput) input
