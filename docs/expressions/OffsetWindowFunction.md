# OffsetWindowFunction Expressions

`OffsetWindowFunction` is an [extension](#contract) of the [WindowFunction](WindowFunction.md) abstraction for [offset-based window functions](#implementations).

## Contract

### <span id="default"> Default Expression

```scala
default: Expression
```

Used when:

* `FrameLessOffsetWindowFunction` is requested to `nullable`, `toString`
* `OffsetWindowFunctionFrameBase` is requested for `fillDefaultValue`

### <span id="ignoreNulls"> ignoreNulls

```scala
ignoreNulls: Boolean
```

Used when:

* `WindowExecBase` unary physical operator is requested for [windowFrameExpressionFactoryPairs](../physical-operators/WindowExecBase.md#windowFrameExpressionFactoryPairs)

### <span id="input"> Input Expression

```scala
input: Expression
```

Input [Expression](Expression.md)

Used when:

* `FrameLessOffsetWindowFunction` is requested to `nullable`, `dataType`, `inputTypes`, `toString`
* `OffsetWindowFunctionFrameBase` is requested for `projection`, `project`

### <span id="offset"> Offset Expression

```scala
offset: Expression
```

Offset ([foldable](Expression.md#foldable)) [Expression](Expression.md)

Used when:

* `OffsetWindowFunction` is requested to `fakeFrame`
* `FrameLessOffsetWindowFunction` is requested to `checkInputDataTypes`, `toString`

## Implementations

* `FrameLessOffsetWindowFunction`
* `NthValue`
