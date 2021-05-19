# Projection Functions

`Projection` is an [abstraction](#contract) of [InternalRow converter functions](#implementations) to produce an [InternalRow](../InternalRow.md) for a given `InternalRow`.

```scala
Projection: InternalRow => InternalRow
```

## Contract

### <span id="initialize"> Initialization

```scala
initialize(
  partitionIndex: Int): Unit
```

## Implementations

* `IdentityProjection`
* [InterpretedProjection](InterpretedProjection.md)
* `InterpretedSafeProjection`
* [MutableProjection](MutableProjection.md)
* [UnsafeProjection](UnsafeProjection.md)
