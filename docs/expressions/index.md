# Catalyst Expressions

The [Catalyst Tree Manipulation Framework](../catalyst/index.md) defines [Expression](Expression.md) abstraction for expression nodes in (the trees of) [logical](../logical-operators/index.md) and [physical](../physical-operators/index.md) query plans.

Spark SQL uses `Expression` abstraction to represent standard and user-defined functions as well as subqueries in logical query plans. Every time you use one of them in a query it creates a new `Expression`.

## Execution Modes

When the query is executed, `Expression`s are evaluated (i.e. requested to produce a value for an input [InternalRow](../InternalRow.md)). There are two execution modes:

1. [Code-Generated](Expression.md#genCode)
1. [Interpreted](Expression.md#eval)

## Be Careful With User-Defined Functions

There are many reasons why you should not write your own user-defined functions. First and foremost, [they are a blackbox to Catalyst optimizer](../spark-sql-udfs-blackbox.md).

Speaking of memory usage, UDFs are written in a programming language like Scala, Java or Python that require an internal representation of data ([InternalRow](../InternalRow.md)) to be fully deserialized and available as an object to the UDFs (that most of the time and for a reason know nothing about [InternalRow](../InternalRow.md) and such). If it happens that two or more UDFs share computation (unless the UDFs are [deterministic](Expression.md#deterministic)) they cannot share anything. Spark SQL cannot do much to optimize such queries.

---

There comes a thought that I'm still shaping in my head and haven't fully "dissected" yet.

Given that expressions (incl. UDFs) can be executed in [code-generated execution mode](Expression.md#genCode) that begs the question about possible performance improvements when an UDF uses `Expression`s (as the "programming language"). I'm not really sure what the benefits could be yet, but gives some hope.

## <span id="MonotonicallyIncreasingID"> MonotonicallyIncreasingID Expression

[MonotonicallyIncreasingID](MonotonicallyIncreasingID.md) expression is an example of "basic" expressions.
