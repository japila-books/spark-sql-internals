---
title: CodeGeneratorWithInterpretedFallback
---

# CodeGeneratorWithInterpretedFallback Generators

`CodeGeneratorWithInterpretedFallback` is an [abstraction](#contract) of [codegen object generators](#implementations) that can [create `OUT` objects](#createObject) for [codegen](#createCodeGeneratedObject) and [interpreted](#createInterpretedObject) evaluation paths.

`CodeGeneratorWithInterpretedFallback` is a Scala type constructor (_generic class_) with `IN` and `OUT` type aliases.

```scala
CodeGeneratorWithInterpretedFallback[IN, OUT]
```

CodeGeneratorWithInterpretedFallback | IN | OUT
-------------------------------------|----|----
 [RowOrdering](RowOrdering.md) | [SortOrder](SortOrder.md)s (`Seq[SortOrder]`) | `BaseOrdering`
 [Predicate](Predicate.md) | [Expression](Expression.md) | `BasePredicate`
 [MutableProjection](MutableProjection.md) | [Expression](Expression.md)s (`Seq[Expression]`) | [MutableProjection](MutableProjection.md)
 [UnsafeProjection](UnsafeProjection.md) | [Expression](Expression.md)s (`Seq[Expression]`) | [UnsafeProjection](UnsafeProjection.md)
 `SafeProjection` | [Expression](Expression.md)s (`Seq[Expression]`) | [Projection](Projection.md)

## Contract

### createCodeGeneratedObject { #createCodeGeneratedObject }

```scala
createCodeGeneratedObject(
  in: IN): OUT
```

See:

* [MutableProjection](MutableProjection.md#createCodeGeneratedObject)
* [UnsafeProjection](UnsafeProjection.md#createCodeGeneratedObject)
* [RowOrdering](RowOrdering.md#createCodeGeneratedObject)

Used when:

* `CodeGeneratorWithInterpretedFallback` is requested to [create an `OUT` object](#createObject)

### createInterpretedObject { #createInterpretedObject }

```scala
createInterpretedObject(
  in: IN): OUT
```

See:

* [MutableProjection](MutableProjection.md#createInterpretedObject)
* [UnsafeProjection](UnsafeProjection.md#createInterpretedObject)
* [RowOrdering](RowOrdering.md#createInterpretedObject)

Used when:

* `CodeGeneratorWithInterpretedFallback` is requested to [create an `OUT` object](#createObject) (after [createCodeGeneratedObject](#createCodeGeneratedObject) failed with a non-fatal exception)

## Implementations

* [MutableProjection](MutableProjection.md)
* [Predicate](Predicate.md)
* [RowOrdering](RowOrdering.md)
* `SafeProjection`
* [UnsafeProjection](UnsafeProjection.md)

## Creating OUT Object { #createObject }

```scala
createObject(
  in: IN): OUT
```

`createObject` [createCodeGeneratedObject](#createCodeGeneratedObject).

In case of a non-fatal exception, `createObject` prints out the following WARN message to the logs and [createInterpretedObject](#createInterpretedObject).

```text
Expr codegen error and falling back to interpreter mode
```

---

`createObject` is used when:

* `MutableProjection` utility is used to [create a MutableProjection](MutableProjection.md#create)
* `Predicate` utility is used to [create a BasePredicate](Predicate.md#create)
* `RowOrdering` utility is used to [create a BaseOrdering](RowOrdering.md#create)
* `SafeProjection` utility is used to create a `Projection`
* `UnsafeProjection` utility is used to [create an UnsafeProjection](UnsafeProjection.md#create)
