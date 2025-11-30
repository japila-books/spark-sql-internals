# Input

`Input` is an [extension](#contract) of the [GraphElement](GraphElement.md) abstraction for [inputs](#implementations) that can [load data](#load).

## Contract

### Load Data { #load }

```scala
load(
  readOptions: InputReadOptions): DataFrame
```

Loads a `DataFrame` with the given [InputReadOptions](InputReadOptions.md)

See:

* [ResolvedFlow](ResolvedFlow.md#load)
* [Table](Table.md#load)
* [VirtualTableInput](VirtualTableInput.md#load)

Used when:

* `FlowAnalysis` is requested to [readGraphInput](FlowAnalysis.md#readGraphInput)

## Implementations

* [ResolvedFlow](ResolvedFlow.md)
* [TableInput](TableInput.md)
