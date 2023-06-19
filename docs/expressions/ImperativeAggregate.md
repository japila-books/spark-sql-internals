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
* `AggregatingAccumulator` is requested to [createBuffer](../AggregatingAccumulator.md#createBuffer)
* `AggregationIterator` is requested to [initializeBuffer](../aggregations/AggregationIterator.md#initializeBuffer)
* `ObjectAggregationIterator` is requested to [initAggregationBuffer](../aggregations/ObjectAggregationIterator.md#initAggregationBuffer)
* `TungstenAggregationIterator` is requested to [createNewAggregationBuffer](../aggregations/TungstenAggregationIterator.md#createNewAggregationBuffer)
* `AggregateProcessor` is requested to [initialize](../window-functions/AggregateProcessor.md#initialize)

### <span id="merge"> merge

```scala
merge(
  mutableAggBuffer: InternalRow,
  inputAggBuffer: InternalRow): Unit
```

Used when:

* `AggregatingAccumulator` is requested to [merge](../AggregatingAccumulator.md#merge)
* `AggregationIterator` is requested to [generateProcessRow](../aggregations/AggregationIterator.md#generateProcessRow)

### <span id="update"> update

```scala
update(
  mutableAggBuffer: InternalRow,
  inputRow: InternalRow): Unit
```

Used when:

* `AggregatingAccumulator` is requested to [add a value](../AggregatingAccumulator.md#add)
* `AggregationIterator` is requested to [generateProcessRow](../aggregations/AggregationIterator.md#generateProcessRow)
* `AggregateProcessor` is requested to [update](../window-functions/AggregateProcessor.md#update)

## Implementations

* `HyperLogLogPlusPlus`
* `PivotFirst`
* [ScalaUDAF](ScalaUDAF.md)
* [TypedImperativeAggregate](TypedImperativeAggregate.md)

## <span id="CodegenFallback"> CodegenFallback

`ImperativeAggregate` is a [CodegenFallback](CodegenFallback.md).
