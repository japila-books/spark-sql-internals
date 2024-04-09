# CollectSet Expression

`CollectSet` is a [Collect](Collect.md) expression (with a [mutable.HashSet\[Any\]\]](#createAggregationBuffer) aggregation buffer).

!!! note "CollectSet and Scala's `HashSet`"
    It's fair to say that `CollectSet` is merely a Spark SQL-enabled Scala [mutable.HashSet\[Any\]\]]({{ scala.api }}/scala/collection/mutable/HashSet.html).

## Creating Instance

`CollectSet` takes the following to be created:

* <span id="child"> Child [Expression](Expression.md)
* <span id="mutableAggBufferOffset"> `mutableAggBufferOffset` (default: `0`)
* <span id="inputAggBufferOffset"> `inputAggBufferOffset` (default: `0`)

`CollectSet` is created when:

* Catalyst DSL's [collectSet](../catalyst-dsl/index.md#collectSet) is used
* [collect_set](../standard-functions//aggregate.md#collect_set) standard function is used
* [collect_set](../FunctionRegistry.md#collect_set) SQL function is used

## <span id="prettyName"> Pretty Name

```scala
prettyName: String
```

`prettyName` is part of the [Expression](Expression.md#prettyName) abstraction.

---

`prettyName` is `collect_set`.

## <span id="createAggregationBuffer"> Creating Aggregation Buffer

```scala
createAggregationBuffer(): mutable.HashSet[Any]
```

`createAggregationBuffer` is part of the [TypedImperativeAggregate](TypedImperativeAggregate.md#createAggregationBuffer) abstraction.

---

`createAggregationBuffer` creates an empty `mutable.HashSet` ([Scala]({{ scala.api }}/scala/collection/mutable/HashSet.html)).

## <span id="eval"> Interpreted Execution

```scala
eval(
  buffer: mutable.HashSet[Any]): Any
```

`eval` is part of the [TypedImperativeAggregate](TypedImperativeAggregate.md#eval) abstraction.

---

`eval` creates a `GenericArrayData` with an array based on the [DataType](Expression.md#dataType) of the [child](#child) expression:

* For `BinaryType`, `eval`...FIXME
* Otherwise, `eval`...FIXME

## <span id="EliminateDistinct"> EliminateDistinct Logical Optimization

`CollectSet` is `isDuplicateAgnostic` per `EliminateDistinct` logical optimization.
