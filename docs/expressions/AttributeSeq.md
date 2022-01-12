# AttributeSeq

`AttributeSeq` is an implicit class ([Scala]({{ scala.spec }}/07-implicits.html#views)) of [Seq[Attribute]](#attrs) type.

`AttributeSeq` is a `Serializable` ([Java]({{ java.api }}/java/lang/Serializable.html)).

## Creating Instance

`AttributeSeq` takes the following to be created:

* <span id="attrs"> [Attribute](Attribute.md)s

## <span id="resolve"> Resolving Attribute Names (to NamedExpressions)

```scala
resolve(
  nameParts: Seq[String],
  resolver: Resolver): Option[NamedExpression]
```

`resolve` resolves the given `nameParts` to a [NamedExpression](NamedExpression.md).

`resolve` branches off based on whether the number of the [qualifier parts](NamedExpression.md#qualifier) of all the [Attributes](#attrs) is 3 or less or not (more than 3).

`resolve` can return:

* `Alias` with `ExtractValue`s for nested fields
* [NamedExpression](NamedExpression.md) if there were no nested fields to resolve
* `None` (_undefined_ value) for no candidate

`resolve` throws an `AnalysisException` for more candidates:

```text
Reference '[name]' is ambiguous, could be: [referenceNames].
```

`resolve` is used when:

* `LateralJoin` is requested to `resolveChildren`
* `LogicalPlan` is requested to [resolveChildren](../logical-operators/LogicalPlan.md#resolveChildren) and [resolve](../logical-operators/LogicalPlan.md#resolve)
