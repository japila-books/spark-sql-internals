# TypedColumn

`TypedColumn` is a spark-sql-Column.md[Column] with the <<encoder, ExpressionEncoder>> for the types of the input and the output.

`TypedColumn` is <<creating-instance, created>> using spark-sql-Column.md#as[as] operator on a `Column`.

[source, scala]
----
scala> val id = $"id".as[Int]
id: org.apache.spark.sql.TypedColumn[Any,Int] = id

scala> id.expr
res1: org.apache.spark.sql.catalyst.expressions.Expression = 'id
----

=== [[name]] `name` Operator

[source, scala]
----
name(alias: String): TypedColumn[T, U]
----

NOTE: `name` is part of spark-sql-Column.md#name[Column Contract] to...FIXME.

`name`...FIXME

NOTE: `name` is used when...FIXME

=== [[withInputType]] Creating TypedColumn -- `withInputType` Internal Method

[source, scala]
----
withInputType(
  inputEncoder: ExpressionEncoder[_],
  inputAttributes: Seq[Attribute]): TypedColumn[T, U]
----

`withInputType`...FIXME

[NOTE]
====
`withInputType` is used when the following typed operators are used:

* spark-sql-dataset-operators.md#select[Dataset.select]

* spark-sql-KeyValueGroupedDataset.md#agg[KeyValueGroupedDataset.agg]

* spark-sql-RelationalGroupedDataset.md#agg[RelationalGroupedDataset.agg]
====

=== [[creating-instance]] Creating TypedColumn Instance

`TypedColumn` takes the following when created:

* [[expr]] Catalyst expressions/Expression.md[expression]
* [[encoder]] [ExpressionEncoder](ExpressionEncoder.md) of the column results

`TypedColumn` initializes the <<internal-registries, internal registries and counters>>.
