# Attribute Named Leaf Expressions

`Attribute` is an [extension](#contract) of the [LeafExpression](Expression.md#LeafExpression) and [NamedExpression](NamedExpression.md) abstractions for [named leaf expressions](#implementations).

[Attribute](../catalyst/QueryPlan.md#output)s are used by `QueryPlan` to build the [schema](../types/StructType.md) of the structured query (it represents).

## Contract

### <span id="newInstance"> newInstance

```scala
newInstance(): Attribute
```

!!! note
    `newInstance` is part of the [NamedExpression](NamedExpression.md#newInstance) abstraction but changes the return type to `Attribute` (from the base `NamedExpression`).

### <span id="withDataType"> withDataType

```scala
withDataType(
  newType: DataType): Attribute
```

### <span id="withExprId"> withExprId

```scala
withExprId(
  newExprId: ExprId): Attribute
```

### <span id="withMetadata"> withMetadata

```scala
withMetadata(
  newMetadata: Metadata): Attribute
```

### <span id="withName"> withName

```scala
withName(
  newName: String): Attribute
```

### <span id="withNullability"> withNullability

```scala
withNullability(
  newNullability: Boolean): Attribute
```

### <span id="withQualifier"> withQualifier

```scala
withQualifier(
  newQualifier: Seq[String]): Attribute
```

## Implementations

* `AttributeReference`
* [PrettyAttribute](PrettyAttribute.md)
* [UnresolvedAttribute](UnresolvedAttribute.md)
