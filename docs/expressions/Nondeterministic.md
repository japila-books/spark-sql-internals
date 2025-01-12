---
title: Nondeterministic
---

# Nondeterministic Expressions

`Nondeterministic` is an [extension](#contract) of the [Expression](Expression.md) abstraction for [non-deterministic, non-foldable expressions](#implementations).

`Nondeterministic` expressions should be [initialized](#initialize) (with the partition ID) before [evaluation](#eval).

## Contract

### Internal Interpreted Expression Evaluation { #evalInternal }

```scala
evalInternal(
  input: InternalRow): Any
```

See:

* [CallMethodViaReflection](CallMethodViaReflection.md#evalInternal)
* [MonotonicallyIncreasingID](MonotonicallyIncreasingID.md#evalInternal)

Used when:

* `Nondeterministic` expression is requested to [evaluate](#eval)

### Internal Initialize { #initializeInternal }

```scala
initializeInternal(
  partitionIndex: Int): Unit
```

See:

* [CallMethodViaReflection](CallMethodViaReflection.md#initializeInternal)
* [MonotonicallyIncreasingID](MonotonicallyIncreasingID.md#initializeInternal)

Used when:

* `Nondeterministic` is requested to [initialize](#initialize)

## Implementations

* [CallMethodViaReflection](CallMethodViaReflection.md)
* [MonotonicallyIncreasingID](MonotonicallyIncreasingID.md)
* _others_

## Deterministic { #deterministic }

??? note "Expression"

    ```scala
    deterministic: Boolean
    ```

    `deterministic` is part of the [Expression](Expression.md#deterministic) abstraction.

??? note "Final Method"
    `deterministic` is a Scala **final method** and may not be overridden in [subclasses](#implementations).

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#final).

`deterministic` is always `false`.

## Foldable { #foldable }

??? note "Expression"

    ```scala
    foldable: Boolean
    ```

    `foldable` is part of the [Expression](Expression.md#foldable) abstraction.

??? note "Final Method"
    `foldable` is a Scala **final method** and may not be overridden in [subclasses](#implementations).

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#final).

`foldable` is always `false`.

## Initialize { #initialize }

```scala
initialize(
  partitionIndex: Int): Unit
```

`initialize` [initializeInternal](#initializeInternal) and sets the [initialized](#initialized) internal flag to `true`.

---

`initialize` is used when:

* `ExpressionsEvaluator` is requested to `initializeExprs`
* `GenerateExec` physical operator is requested to [doExecute](../physical-operators/GenerateExec.md#doExecute)
