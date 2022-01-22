# SerializerBuildHelper

## <span id="createSerializerForObject"> Creating Serializer (Expression) for Object

```scala
createSerializerForObject(
  inputObject: Expression,
  fields: Seq[(String, Expression)]): Expression
```

`createSerializerForObject` creates a [CreateNamedStruct](expressions/CreateNamedStruct.md) expression with [argumentsForFieldSerializer](#argumentsForFieldSerializer) for the given `fields`.

Only when the given [Expression](expressions/Expression.md) is [nullable](expressions/Expression.md#nullable), `createSerializerForObject` wraps the `CreateNamedStruct` expression with an `If` expression with `IsNull` child expression, a `null` [Literal](expressions/Literal.md) and the `CreateNamedStruct` expressions (for the positive and negative branches of the `If` expression, respectively).

`createSerializerForObject` is used when:

* `JavaTypeInference` utility is used to `serializerFor`
* `ScalaReflection` utility is used to [create a serializer](ScalaReflection.md#serializerFor) (for Scala `Product`s or `DefinedByConstructorParams`s)

### <span id="argumentsForFieldSerializer"> argumentsForFieldSerializer

```scala
argumentsForFieldSerializer(
  fieldName: String,
  serializerForFieldValue: Expression): Seq[Expression]
```

`argumentsForFieldSerializer` creates a two-element collection of the following:

1. [Literal](expressions/Literal.md) for the given `fieldName`
1. `serializerForFieldValue` [Expression](expressions/Expression.md)
