# AliasAwareOutputExpression Unary Physical Operators

`AliasAwareOutputExpression` is an [extension](#contract) of the [UnaryExecNode](UnaryExecNode.md) abstraction for [unary physical operators](#implementations) with the [output named expressions](#outputExpressions).

## Contract

### <span id="outputExpressions"> Output Named Expressions

```scala
outputExpressions: Seq[NamedExpression]
```

Output [NamedExpression](../expressions/NamedExpression.md)s

Used when:

* `AliasAwareOutputExpression` is requested for the [aliasMap](#aliasMap)

## Implementations

* [AliasAwareOutputOrdering](AliasAwareOutputOrdering.md)
* [AliasAwareOutputPartitioning](AliasAwareOutputPartitioning.md)

## <span id="aliasMap"> aliasMap

```scala
aliasMap: AttributeMap[Attribute]
```

`aliasMap` is a collection of `AttributeReference` expressions (of the `Alias` expressions with the `AttributeReference` expressions in the [output named expressions](#outputExpressions)) and the `Alias`es converted to `Attribute`s.

??? note "Lazy Value"
    `aliasMap` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`aliasMap` is used when:

* `AliasAwareOutputExpression` is requested to [hasAlias](#hasAlias) and [normalizeExpression](#normalizeExpression)

## <span id="hasAlias"> hasAlias

```scala
hasAlias: Boolean
```

`hasAlias` is `true` when the [aliasMap](#aliasMap) is not empty.

`hasAlias` is used when:

* `AliasAwareOutputPartitioning` is requested for the [outputPartitioning](AliasAwareOutputPartitioning.md#outputPartitioning)
* `AliasAwareOutputOrdering` is requested for the [outputOrdering](AliasAwareOutputOrdering.md#outputOrdering)

## <span id="normalizeExpression"> normalizeExpression

```scala
normalizeExpression(
  exp: Expression): Expression
```

`normalizeExpression`...FIXME

`normalizeExpression` is used when:

* `AliasAwareOutputPartitioning` is requested for the [outputPartitioning](AliasAwareOutputPartitioning.md#outputPartitioning)
* `AliasAwareOutputOrdering` is requested for the [outputOrdering](AliasAwareOutputOrdering.md#outputOrdering)
