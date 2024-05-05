---
title: AliasAwareQueryOutputOrdering
---

# AliasAwareQueryOutputOrdering Unary Physical Operators

`AliasAwareQueryOutputOrdering` is an [extension](#contract) of the [AliasAwareOutputExpression](AliasAwareOutputExpression.md) abstraction for [unary physical operators](#implementations) with [alias-aware ordering expressions](#orderingExpressions).

```scala
AliasAwareQueryOutputOrdering[T <: QueryPlan[T]]
```

## Contract

### Ordering Expressions { #orderingExpressions }

```scala
orderingExpressions: Seq[SortOrder]
```

[Sort ordering](../expressions/SortOrder.md)s of this unary physical operator

See:

* [ProjectExec](ProjectExec.md#orderingExpressions)
* [SortAggregateExec](SortAggregateExec.md#orderingExpressions)

Used when:

* `AliasAwareQueryOutputOrdering` is requested for the [output ordering](#outputOrdering)

## Implementations

* [OrderPreservingUnaryExecNode](OrderPreservingUnaryExecNode.md)
* `OrderPreservingUnaryNode`

## Output Data Ordering Requirements { #outputOrdering }

??? note "QueryPlan"

    ```scala
    outputOrdering: Seq[SortOrder]
    ```

    `outputOrdering` is part of the [QueryPlan](../catalyst/QueryPlan.md#outputOrdering) abstraction.

`outputOrdering`...FIXME
