# HigherOrderFunction

`HigherOrderFunction` is an [extension](#contract) of the [Expression](Expression.md) abstraction for [FIXME](#implementations) that [method](#method) and...FIXME.

## Contract

### <span id="arguments"> arguments

```scala
arguments: Seq[Expression]
```

Used when...FIXME

### <span id="argumentTypes"> argumentTypes

```scala
argumentTypes: Seq[AbstractDataType]
```

Used when...FIXME

### <span id="bind"> bind

```scala
bind(
    f: (Expression, Seq[(DataType, Boolean)]) => LambdaFunction): HigherOrderFunction
```

Used when...FIXME

### <span id="functions"> functions

```scala
functions: Seq[Expression]
```

Used when...FIXME

### <span id="functionTypes"> functionTypes

```scala
functionTypes: Seq[AbstractDataType]
```

Used when...FIXME

## Implementations

* `ArrayAggregate`
* `MapZipWith`
* [SimpleHigherOrderFunction](SimpleHigherOrderFunction.md)
* `ZipWith`
