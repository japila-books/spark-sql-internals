# ImperativeAggregate Expressions

`ImperativeAggregate` is an [extension](#contract) of the [AggregateFunction](AggregateFunction.md) abstraction for [aggregate functions](#implementations) that are expressed using imperative [initialize](#initialize), [merge](#merge) and [update](#update) methods (that operate on `Row`-based aggregation buffers).

## Contract (Subset)

### <span id="initialize"> initialize

```scala
initialize(
  mutableAggBuffer: InternalRow): Unit
```

Used when:

* `EliminateAggregateFilter` logical optimization is executed
* `AggregatingAccumulator` is requested to `createBuffer`
* `AggregationIterator` is requested to [initializeBuffer](../AggregationIterator.md#initializeBuffer)
* `ObjectAggregationIterator` is requested to [initAggregationBuffer](../ObjectAggregationIterator.md#initAggregationBuffer)
* `TungstenAggregationIterator` is requested to [createNewAggregationBuffer](../TungstenAggregationIterator.md#createNewAggregationBuffer)
* `AggregateProcessor` is requested to [initialize](../physical-operators/AggregateProcessor.md#initialize)

### <span id="merge"> merge

```scala
merge(
  mutableAggBuffer: InternalRow,
  inputAggBuffer: InternalRow): Unit
```

Used when:

* `AggregatingAccumulator` is requested to `merge`
* `AggregationIterator` is requested to [generateProcessRow](../AggregationIterator.md#generateProcessRow)

### <span id="update"> update

```scala
update(
  mutableAggBuffer: InternalRow,
  inputRow: InternalRow): Unit
```

Used when:

* `AggregatingAccumulator` is requested to `add` an `InternalRow`
* `AggregationIterator` is requested to [generateProcessRow](../AggregationIterator.md#generateProcessRow)
* `AggregateProcessor` is requested to [update](../physical-operators/AggregateProcessor.md#update)

## Implementations

* `HyperLogLogPlusPlus`
* `PivotFirst`
* `ScalaUDAF`
* `TypedImperativeAggregate`

## <span id="CodegenFallback"> CodegenFallback

`ImperativeAggregate` is a [CodegenFallback](CodegenFallback.md).
