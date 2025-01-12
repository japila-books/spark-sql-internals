---
title: CallMethodViaReflection
---

# CallMethodViaReflection Expression

`CallMethodViaReflection` is a [non-deterministic expression](Nondeterministic.md) that represents a static method call (in Scala or Java) using `reflect` and `java_method` standard functions.

`CallMethodViaReflection` supports [fallback mode for expression code generation](Expression.md#CodegenFallback).

## Creating Instance

`CallMethodViaReflection` takes the following to be created:

* <span id="children"> Children [Expression](Expression.md)s

`CallMethodViaReflection` is created when:

* `reflect` standard function is used

## evalInternal { #evalInternal }

??? note "Nondeterministic"

    ```scala
    evalInternal(
      input: InternalRow): Any
    ```

    `evalInternal` is part of the [Nondeterministic](Nondeterministic.md#evalInternal) abstraction.

`evalInternal`...FIXME

## initializeInternal { #initializeInternal }

??? note "Nondeterministic"

    ```scala
    initializeInternal(
      partitionIndex: Int): Unit
    ```

    `initializeInternal` is part of the [Nondeterministic](Nondeterministic.md#initializeInternal) abstraction.

`initializeInternal`...FIXME

## Demo

```scala
import org.apache.spark.sql.catalyst.expressions.CallMethodViaReflection
import org.apache.spark.sql.catalyst.expressions.Literal
val expr = CallMethodViaReflection(
  Literal("java.time.LocalDateTime") ::
  Literal("now") :: Nil)
```

```text
scala> println(expr.numberedTreeString)
00 reflect(java.time.LocalDateTime, now, true)
01 :- java.time.LocalDateTime
02 +- now
```

```scala
val q = """SELECT reflect("java.time.LocalDateTime", "now") AS now"""
val plan = spark.sql(q).queryExecution.logical
```

```text
// CallMethodViaReflection shows itself under "reflect" name
scala> println(plan.numberedTreeString)
00 'Project ['reflect(java.time.LocalDateTime, now) AS now#0]
01 +- OneRowRelation
```
