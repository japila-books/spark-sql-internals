# Input

`Input` is an [extension](#contract) of the [GraphElement](GraphElement.md) abstraction for [inputs](#implementations) that can [load data](#load).

## Contract

### Load Data { #load }

```scala
load(
  readOptions: InputReadOptions): DataFrame
```

See:

* [Table](Table.md#load)

Used when:

* `FlowAnalysis` is requested to [readGraphInput](FlowAnalysis.md#readGraphInput)

## Implementations

* [ResolvedFlow](ResolvedFlow.md)
* [TableInput](TableInput.md)
