---
title: OrderPreservingUnaryExecNode
---

# OrderPreservingUnaryExecNode Unary Physical Operators

`OrderPreservingUnaryExecNode` is a marker extension of the [UnaryExecNode](UnaryExecNode.md) and [AliasAwareQueryOutputOrdering](AliasAwareQueryOutputOrdering.md) abstractions for [unary physical operators](#implementations).

??? warning "FIXME Why is OrderPreservingUnaryExecNode needed?"
    Review the commit log to find out.

## Implementations

* [ProjectExec](ProjectExec.md)
* [SortAggregateExec](SortAggregateExec.md)
* `TakeOrderedAndProjectExec`
