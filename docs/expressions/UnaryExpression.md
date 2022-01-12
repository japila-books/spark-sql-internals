# UnaryExpression

`UnaryExpression` is an [extension](#contract) of the [Expression](Expression.md) abstraction for [expressions](#implementations) with a single [child](#child).

## Contract

### <span id="child"> Child Expression

```scala
child: Expression
```

Child [Expression](Expression.md)

## Implementations

* `Alias`
* ArrayDistinct
* ArrayMax
* ArrayMin
* BitwiseCount
* CsvToStructs
* MapEntries
* MapKeys
* MapValues
* MultiAlias
* PrintToStderr
* SchemaOfCsv
* _others..._

## <span id="eval"> Interpreted Expression Evaluation

```scala
eval(
  input: InternalRow): Any
```

`eval`...FIXME

`eval` is part of the [Expression](Expression.md#eval) abstraction.

## <span id="defineCodeGen"> defineCodeGen

```scala
defineCodeGen(
  ctx: CodegenContext,
  ev: ExprCode,
  f: String => String): ExprCode
```

`defineCodeGen`...FIXME

## <span id="nullSafeCodeGen"> nullSafeCodeGen

```scala
nullSafeCodeGen(
  ctx: CodegenContext,
  ev: ExprCode,
  f: String => String): ExprCode
```

`nullSafeCodeGen`...FIXME

`nullSafeCodeGen` is used when...FIXME

## <span id="nullSafeEval"> nullSafeEval

```scala
nullSafeEval(
  input: Any): Any
```

`nullSafeEval` simply fails with the following error (and is expected to be overrided to save null-check code):

```text
UnaryExpressions must override either eval or nullSafeEval
```

`nullSafeEval` is used when `UnaryExpression` is requested to [evaluate (in interpreted mode)](#eval).
