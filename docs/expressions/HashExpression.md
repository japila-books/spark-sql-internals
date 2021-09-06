# HashExpression

`HashExpression[E]` is an [extension](#contract) of the [Expression](Expression.md) abstraction for [hashing expressions](#implementations) that [calculate hash value](#computeHash) (for a group of expressions).

## Contract

### <span id="computeHash"> Computing Hash

```scala
computeHash(
  value: Any,
  dataType: DataType,
  seed: E): E
```

Used when:

* `HashExpression` is requested to [eval](#eval) and [doGenCode](#doGenCode)

### <span id="hasherClassName"> hasherClassName

```scala
hasherClassName: String
```

Used when:

* `HashExpression` is requested to [genHashInt](#genHashInt), [genHashLong](#genHashLong), [genHashBytes](#genHashBytes), [genHashCalendarInterval](#genHashCalendarInterval), [genHashString](#genHashString)

### <span id="seed"> Seed

```scala
seed: E
```

Used when:

* `HashExpression` is requested to [eval](#eval) and [doGenCode](#doGenCode)

## Implementations

* HiveHash
* [Murmur3Hash](Murmur3Hash.md)
* XxHash64

## <span id="eval"> eval

```scala
eval(
  input: InternalRow): Any
```

`eval`...FIXME

`eval` is part of the [Expression](Expression.md#eval) abstraction.

## <span id="doGenCode"> doGenCode

```scala
doGenCode(
  ctx: CodegenContext,
  ev: ExprCode): ExprCode
```

`doGenCode`...FIXME

`doGenCode` is part of the [Expression](Expression.md#doGenCode) abstraction.
