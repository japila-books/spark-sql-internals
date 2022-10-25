# BasePredicate Expressions

`BasePredicate` is an [abstraction](#contract) of [predicate expressions](#implementations) that can be [evaluated](#eval) to a `Boolean` value.

`BasePredicate` is created using [Predicate.create](Predicate.md#create) utility.

## Contract

### <span id="eval"> Evaluating

```scala
eval(
  r: InternalRow): Boolean
```

### <span id="initialize"> Initializing

```scala
initialize(
  partitionIndex: Int): Unit
```

## Implementations

* `InterpretedPredicate`
