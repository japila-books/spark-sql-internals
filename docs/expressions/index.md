# Expressions

The [Catalyst Tree Manipulation Framework](../catalyst/index.md) introduces [Expression](Expression.md) abstraction for expression nodes in (the trees of) [logical](../logical-operators/) and [physical](../physical-operators/) query plans.

There are two types of expression evaluation:

1. [Code-Generated](Expression.md#genCode)
1. [Interpreted](Expression.md#eval)

Foundational abstractions:

1. [Unevaluable](Unevaluable.md)s
1. [AggregateFunction](AggregateFunction.md)s
1. [Attribute](Attribute.md)s
1. _others_ (FIXME)
