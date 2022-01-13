# NamedExpression

`NamedExpression` is an [extension](#contract) of the [Expression](Expression.md) abstraction for [named expressions](#implementations) (with an [ExprId](#exprId) and an optional [qualifier](#qualifier)).

## Contract

### <span id="exprId"> ExprId

```scala
exprId: ExprId
```

### <span id="name"> Name

```scala
name: String
```

### <span id="newInstance"> Creating NamedExpression

```scala
newInstance(): NamedExpression
```

### <span id="qualifier"> Qualifier (Parts)

```scala
qualifier: Seq[String]
```

Optional qualifier parts (with the names of catalog, database, table, fields, incl. nested fields)

### <span id="toAttribute"> toAttribute

```scala
toAttribute: Attribute
```

## Implementations

* [Attribute](Attribute.md)
* _others_

## <span id="foldable"> foldable

```scala
foldable: Boolean
```

`foldable` is always `false` (in order to not remove the alias).

`foldable` is part of the [Expression](Expression.md#foldable) abstraction.
