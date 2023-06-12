# AliasAwareOutputExpression Physical Operators

`AliasAwareOutputExpression` is an [abstraction](#contract) of [physical operators](#implementations) with the [output named expressions](#outputExpressions).

## Contract

### Output Named Expressions { #outputExpressions }

```scala
outputExpressions: Seq[NamedExpression]
```

Output [NamedExpression](../expressions/NamedExpression.md)s

See:

* [BaseAggregateExec](BaseAggregateExec.md#outputExpressions)
* [ProjectExec](ProjectExec.md#outputExpressions)

Used when:

* `AliasAwareOutputExpression` is requested for the [aliasMap](#aliasMap), [projectExpression](#projectExpression)
* `AliasAwareQueryOutputOrdering` is requested for the [output ordering](AliasAwareQueryOutputOrdering.md#outputOrdering)
* `PartitioningPreservingUnaryExecNode` is requested for the [output partitioning](PartitioningPreservingUnaryExecNode.md#outputPartitioning)

## Implementations

* [AliasAwareQueryOutputOrdering](AliasAwareQueryOutputOrdering.md)
* [PartitioningPreservingUnaryExecNode](PartitioningPreservingUnaryExecNode.md)

## spark.sql.optimizer.expressionProjectionCandidateLimit { #aliasCandidateLimit }

`aliasCandidateLimit` is the value of [spark.sql.optimizer.expressionProjectionCandidateLimit](../configuration-properties.md#spark.sql.optimizer.expressionProjectionCandidateLimit) configuration property.

`aliasCandidateLimit` is used when:

* `AliasAwareOutputExpression` is requested for the [aliasMap](#aliasMap)
* `AliasAwareQueryOutputOrdering` is requested for the [output ordering](AliasAwareQueryOutputOrdering.md#outputOrdering)
* `PartitioningPreservingUnaryExecNode` is requested for the [output partitioning](PartitioningPreservingUnaryExecNode.md#outputPartitioning)

## aliasMap { #aliasMap }

```scala
aliasMap: AttributeMap[Attribute]
```

`aliasMap` is a collection of `AttributeReference` expressions (of the `Alias` expressions with the `AttributeReference` expressions in the [output named expressions](#outputExpressions)) and the `Alias`es converted to `Attribute`s.

??? note "Lazy Value"
    `aliasMap` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`aliasMap` is used when:

* `AliasAwareOutputExpression` is requested to [hasAlias](#hasAlias) and [normalizeExpression](#normalizeExpression)

## hasAlias { #hasAlias }

```scala
hasAlias: Boolean
```

`hasAlias` is `true` when the [aliasMap](#aliasMap) is not empty.

---

`hasAlias` is used when:

* `PartitioningPreservingUnaryExecNode` is requested for the [outputPartitioning](PartitioningPreservingUnaryExecNode.md#outputPartitioning)
* `AliasAwareQueryOutputOrdering` is requested for the [outputOrdering](AliasAwareQueryOutputOrdering.md#outputOrdering)

## normalizeExpression { #normalizeExpression }

```scala
normalizeExpression(
  exp: Expression): Expression
```

`normalizeExpression`...FIXME

---

`normalizeExpression` is used when:

* `PartitioningPreservingUnaryExecNode` is requested for the [outputPartitioning](PartitioningPreservingUnaryExecNode.md#outputPartitioning)
* `AliasAwareQueryOutputOrdering` is requested for the [outputOrdering](AliasAwareQueryOutputOrdering.md#outputOrdering)
