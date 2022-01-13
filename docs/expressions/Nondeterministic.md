# Nondeterministic Expressions

`Nondeterministic` is an [extension](#contract) of the [Expression](Expression.md) abstraction for [non-deterministic and non-foldable expressions](#implementations).

Nondeterministic expression should be [initialized](#initialize) (with the partition ID) before [evaluation](#eval).

## Contract

### <span id="evalInternal"> evalInternal

```scala
evalInternal(
  input: InternalRow): Any
```

Used when:

* `Nondeterministic` is requested to [eval](#eval)

### <span id="initializeInternal"> initializeInternal

```scala
initializeInternal(
  partitionIndex: Int): Unit
```

Used when:

* `Nondeterministic` is requested to [initialize](#initialize)

## Implementations

* [CallMethodViaReflection](CallMethodViaReflection.md)
* `CurrentBatchTimestamp`
* `InputFileBlockLength`
* `InputFileBlockStart`
* `InputFileName`
* `SparkPartitionID`
* `Stateful`

## Review Me

NOTE: `Nondeterministic` expressions are the target of `PullOutNondeterministic` logical plan rule.

=== [[initialize]] Initializing Expression -- `initialize` Method

[source, scala]
----
initialize(partitionIndex: Int): Unit
----

Internally, `initialize` <<initializeInternal, initializes>> itself (with the input partition index) and turns the internal <<initialized, initialized>> flag on.

`initialize` is used when [InterpretedProjection](InterpretedProjection.md#initialize) and `InterpretedMutableProjection` are requested to `initialize` themselves.

=== [[eval]] Evaluating Expression -- `eval` Method

[source, scala]
----
eval(input: InternalRow): Any
----

`eval` is part of the [Expression](Expression.md#eval) abstraction.

`eval` is just a wrapper of <<evalInternal, evalInternal>> that makes sure that <<initialize, initialize>> has already been executed (and so the expression is initialized).

Internally, `eval` makes sure that the expression was <<initialized, initialized>> and calls <<evalInternal, evalInternal>>.

`eval` reports a `IllegalArgumentException` exception when the internal <<initialized, initialized>> flag is off, i.e. <<initialize, initialize>> has not yet been executed.

```text
requirement failed: Nondeterministic expression [name] should be initialized before eval.
```
