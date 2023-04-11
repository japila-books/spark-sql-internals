---
tags:
  - DeveloperApi
---

# TypedColumn

`TypedColumn` is a [Column](Column.md) with the [ExpressionEncoder](#encoder) for the types of the input and the output.

`TypedColumn` is [created](#creating-instance) using [as](Column.md#as) operator on a `Column`.

```text
scala> val id = $"id".as[Int]
id: org.apache.spark.sql.TypedColumn[Any,Int] = id

scala> id.expr
res1: org.apache.spark.sql.catalyst.expressions.Expression = 'id
```

=== [[name]] `name` Operator

```scala
name(
  alias: String): TypedColumn[T, U]
```

`name` is part of the [Column](Column.md#name) abstraction.

`name`...FIXME

=== [[withInputType]] Creating TypedColumn -- `withInputType` Internal Method

[source, scala]
----
withInputType(
  inputEncoder: ExpressionEncoder[_],
  inputAttributes: Seq[Attribute]): TypedColumn[T, U]
----

`withInputType`...FIXME

`withInputType` is used when the following typed operators are used:

* [Dataset.select](spark-sql-dataset-operators.md#select)

* [KeyValueGroupedDataset.agg](KeyValueGroupedDataset.md#agg)

* [RelationalGroupedDataset.agg](RelationalGroupedDataset.md#agg)

## Creating Instance

`TypedColumn` takes the following when created:

* [[expr]] Catalyst expressions/Expression.md[expression]
* [[encoder]] [ExpressionEncoder](ExpressionEncoder.md) of the column results

`TypedColumn` initializes the <<internal-registries, internal registries and counters>>.
