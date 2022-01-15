# Expressions

The [Catalyst Tree Manipulation Framework](../catalyst/index.md) defines [Expression](Expression.md) abstraction for expression nodes in (the trees of) [logical](../logical-operators/) and [physical](../physical-operators/) query plans.

Spark SQL uses `Expression` abstraction to represent standard and user-defined functions as well as subqueries in logical query plans. Every time you use one of them in a query it creates a new `Expression`.

In the end, when the query is executed, `Expression`s are evaluated (i.e. requested to produce a value for an input [InternalRow](../InternalRow.md)). There are two execution modes:

1. [Code-Generated](Expression.md#genCode)
1. [Interpreted](Expression.md#eval)

Specialized `Expression`s:

1. [Unevaluable](Unevaluable.md)s
1. [AggregateFunction](AggregateFunction.md)s
1. [Attribute](Attribute.md)s
1. _others_ (FIXME)

## <span id="MonotonicallyIncreasingID"> MonotonicallyIncreasingID Expression

[MonotonicallyIncreasingID](MonotonicallyIncreasingID.md) expression is an example of "basic" expressions.
