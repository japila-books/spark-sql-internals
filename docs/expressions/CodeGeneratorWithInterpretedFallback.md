# CodeGeneratorWithInterpretedFallback Generators

`CodeGeneratorWithInterpretedFallback` is an [abstraction](#contract) of [codegen object generators](#implementations) that can create objects for [codegen](#createCodeGeneratedObject) and [interpreted](#createInterpretedObject) evaluation paths.

## Type Constructor

`CodeGeneratorWithInterpretedFallback` is a Scala type constructor (_generic class_) with `IN` and `OUT` type aliases.

```scala
CodeGeneratorWithInterpretedFallback[IN, OUT]
```

## Contract

### <span id="createCodeGeneratedObject"> createCodeGeneratedObject

```scala
createCodeGeneratedObject(
  in: IN): OUT
```

### <span id="createInterpretedObject"> createInterpretedObject

```scala
createInterpretedObject(
  in: IN): OUT
```

## Implementations

* [MutableProjection](MutableProjection.md)
* [Predicate](Predicate.md)
* [RowOrdering](RowOrdering.md)
* [SafeProjection](SafeProjection.md)
* [UnsafeProjection](UnsafeProjection.md)

## <span id="createObject"> Creating Object

```scala
createObject(
  in: IN): OUT
```

`createObject` [createCodeGeneratedObject](#createCodeGeneratedObject).

In case of a non-fatal exception, `createObject` prints out the following WARN message to the logs and [createInterpretedObject](#createInterpretedObject).

```text
Expr codegen error and falling back to interpreter mode
```

`createObject` is used when:

* `MutableProjection` utility is used to [create a MutableProjection](MutableProjection.md#create)
* `Predicate` utility is used to [create a BasePredicate](Predicate.md#create)
* `RowOrdering` utility is used to [create a BaseOrdering](RowOrdering.md#create)
* `SafeProjection` utility is used to [create a Projection](SafeProjection.md#create)
* `UnsafeProjection` utility is used to [create a UnsafeProjection](UnsafeProjection.md#create)
