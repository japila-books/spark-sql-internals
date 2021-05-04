# Predicate Expressions

`Predicate` is an extension of the [Expression](Expression.md) abstraction for [expressions](#implementations) that return a [boolean](#dataType) value (_predicates_).

## Implementations

* And
* AtLeastNNonNulls
* [BinaryComparison](BinaryComparison.md)
* DynamicPruning
* [Exists](Exists.md)
* [In](In.md)
* [InSet](InSet.md)
* [InSubquery](InSubquery.md)
* IsNaN
* IsNotNull
* IsNull
* Not
* Or
* StringPredicate

## <span id="dataType"> DataType

```scala
dataType: DataType
```

`dataType` is part of the [Expression](Expression.md#dataType) abstraction.

`dataType` is always [BooleanType](../DataType.md#BooleanType).
