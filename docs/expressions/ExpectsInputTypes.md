# ExpectsInputTypes Expressions

`ExpectsInputTypes` is an [extension](#contract) of the [Expression](Expression.md) abstraction for [Catalyst Expressions](#implementations) that can define the [expected types from child expressions](#inputTypes).

## Contract

### <span id="inputTypes"> inputTypes

```scala
inputTypes: Seq[AbstractDataType]
```

Expected [AbstractDataType](../types/AbstractDataType.md)s of the [child expressions](../catalyst/TreeNode.md#children)

Used when:

* `ImplicitTypeCasts` utility (as `TypeCoercionRule`) is used to`transform`
* `ExpectsInputTypes` is requested to [checkInputDataTypes](#checkInputDataTypes)

## Implementations

* [HigherOrderFunction](HigherOrderFunction.md)
* [JsonToStructs](JsonToStructs.md)
* _others_

## <span id="checkInputDataTypes"> checkInputDataTypes

```scala
checkInputDataTypes(): TypeCheckResult
```

`checkInputDataTypes` is part of the [Expression](Expression.md#checkInputDataTypes) abstraction.

---

`checkInputDataTypes` checks that the expected [inputTypes](#inputTypes) are the [DataType](Expression.md#dataType)s of the evaluation of the [child expressions](../catalyst/TreeNode.md#children).
