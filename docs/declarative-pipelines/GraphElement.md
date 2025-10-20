# GraphElement

`GraphElement` is an [abstraction](#contract) of [dataflow graph elements](#implementations) that have an [identifier](#identifier) and an [origin](#origin).

## Contract

### Identifier { #identifier }

```scala
identifier: TableIdentifier
```

### QueryOrigin { #origin }

```scala
origin: QueryOrigin
```

Used when:

* `PipelinesHandler` is requested to [define a flow](PipelinesHandler.md#defineFlow) and an [output](PipelinesHandler.md#defineOutput)
* `SqlGraphRegistrationContext` is requested to [process a single SQL query](SqlGraphRegistrationContext.md#processSqlQuery)
* `FlowResolver` is requested to [attemptResolveFlow](FlowResolver.md#attemptResolveFlow)
* `DatasetManager` is requested to [materialize datasets](DatasetManager.md#materializeDatasets) (for error reporting)
* `FlowExecution` is requested for the [QueryOrigin](FlowExecution.md#getOrigin)
* [FlowProgressEventLogger](FlowProgressEventLogger.md) is requested to report an event

## Implementations

* [Flow](Flow.md)
* [Input](Input.md)
* [Sink](Sink.md)
* [View](View.md)
