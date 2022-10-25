# Predicate Expressions

`Predicate` is an extension of the [Expression](Expression.md) abstraction for [predicate expressions](#implementations) that evaluate to a value of [BooleanType](#dataType) type.

## Implementations

* [BinaryComparison](BinaryComparison.md)
* [Exists](Exists.md)
* [In](In.md)
* [InSet](InSet.md)
* _others_

## <span id="dataType"> DataType

```scala
dataType: DataType
```

`dataType` is part of the [Expression](Expression.md#dataType) abstraction.

---

`dataType` is always [BooleanType](../types/DataType.md#BooleanType).

## <span id="create"> Creating BasePredicate for Bound Expression

```scala
create(
  e: Expression): BasePredicate
create(
  e: Expression,
  inputSchema: Seq[Attribute]): BasePredicate
```

`create` [creates a BasePredicate](#createObject) for the given [Expression](Expression.md) that is [bound](#bindReference) to the input schema ([Attribute](Attribute.md)s).
