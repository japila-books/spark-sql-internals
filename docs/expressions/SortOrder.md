# SortOrder Unevaluable Unary Expression

`SortOrder` is a <<spark-sql-Expression-UnaryExpression.md#, unary expression>> that represents the following operators in a logical plan:

* `AstBuilder` is requested to <<sql/AstBuilder.md#visitSortItem, parse ORDER BY or SORT BY sort specifications>>

* <<spark-sql-column-operators.md#asc, Column.asc>>, <<spark-sql-column-operators.md#asc_nulls_first, Column.asc_nulls_first>>, <<spark-sql-column-operators.md#asc_nulls_last, Column.asc_nulls_last>>, <<spark-sql-column-operators.md#desc, Column.desc>>, <<spark-sql-column-operators.md#desc_nulls_first, Column.desc_nulls_first>>, and <<spark-sql-column-operators.md#desc_nulls_last, Column.desc_nulls_last>> operators are used

`SortOrder` is used to specify the <<SparkPlan.md#, output data ordering requirements>> of a physical operator.

`SortOrder` is an [unevaluable expression](Unevaluable.md).

[[foldable]]
`SortOrder` is never <<Expression.md#foldable, foldable>> (as an unevaluable expression with no evaluation).

[[catalyst-dsl]]
TIP: Use <<asc, asc>>, <<asc_nullsLast, asc_nullsLast>>, <<desc, desc>> or <<desc_nullsFirst, desc_nullsFirst>> operators from the [Catalyst DSL](../catalyst-dsl/index.md) to create a `SortOrder` expression, e.g. for testing or Spark SQL internals exploration.

NOTE: <<spark-sql-dataset-operators.md#repartitionByRange, Dataset.repartitionByRange>>, <<spark-sql-dataset-operators.md#sortWithinPartitions, Dataset.sortWithinPartitions>>, <<spark-sql-dataset-operators.md#sort, Dataset.sort>> and <<WindowSpec.md#orderBy, WindowSpec.orderBy>> default to <<Ascending, Ascending>> sort direction.

=== [[apply]] Creating SortOrder Instance -- `apply` Factory Method

[source, scala]
----
apply(
  child: Expression,
  direction: SortDirection,
  sameOrderExpressions: Set[Expression] = Set.empty): SortOrder
----

`apply` is a convenience method to create a <<SortOrder, SortOrder>> with the `defaultNullOrdering` of the <<SortDirection, SortDirection>>.

NOTE: `apply` is used exclusively in spark-sql-functions-datetime.md#window[window] function.

=== [[asc]][[asc_nullsLast]][[desc]][[desc_nullsFirst]] Catalyst DSL -- `asc`, `asc_nullsLast`, `desc` and `desc_nullsFirst` Operators

[source, scala]
----
asc: SortOrder
asc_nullsLast: SortOrder
desc: SortOrder
desc_nullsFirst: SortOrder
----

`asc`, `asc_nullsLast`, `desc` and `desc_nullsFirst` <<creating-instance, create>> a `SortOrder` expression with the `Ascending` or `Descending` sort direction, respectively.

[source, scala]
----
import org.apache.spark.sql.catalyst.dsl.expressions._
val sortNullsLast = 'id.asc_nullsLast
scala> println(sortNullsLast.sql)
`id` ASC NULLS LAST
----

=== [[creating-instance]] Creating SortOrder Instance

`SortOrder` takes the following when created:

* [[child]] Child <<Expression.md#, expression>>
* [[direction]] <<SortDirection, SortDirection>>
* [[nullOrdering]] `NullOrdering`
* [[sameOrderExpressions]] "Same Order" <<Expression.md#, expressions>>

=== [[SortDirection]] SortDirection Contract

`SortDirection` is the <<SortDirection-contract, base>> of <<SortDirection-extensions, sort directions>>.

[[SortDirection-contract]]
.SortDirection Contract
[cols="1m,2",options="header",width="100%"]
|===
| Method
| Description

| defaultNullOrdering
a| [[defaultNullOrdering]]

[source, scala]
----
defaultNullOrdering: NullOrdering
----

Used when...FIXME

| sql
a| [[sql]]

[source, scala]
----
sql: String
----

Used when...FIXME
|===

==== [[SortDirection-extensions]][[Ascending]][[Descending]] Ascending and Descending Sort Directions

There are two <<SortDirection, sorting directions>> available, i.e. `Ascending` and `Descending`.
