# SortOrder

`SortOrder` is an [Expression](Expression.md) that represents the following operators in a structured query:

* `AstBuilder` is requested to [parse ORDER BY or SORT BY sort specifications](../sql/AstBuilder.md#visitSortItem)

* [Column.asc](../spark-sql-column-operators.md#asc), [Column.asc_nulls_first](../spark-sql-column-operators.md#asc_nulls_first), [Column.asc_nulls_last](../spark-sql-column-operators.md#asc_nulls_last), [Column.desc](../spark-sql-column-operators.md#desc), [Column.desc_nulls_first](../spark-sql-column-operators.md#desc_nulls_first), and [Column.desc_nulls_last](../spark-sql-column-operators.md#desc_nulls_last) high-level operators

## Creating Instance

`SortOrder` takes the following to be created:

* <span id="child"> Child [Expression](Expression.md)
* <span id="direction"> [SortDirection](#SortDirection)
* <span id="nullOrdering"> [NullOrdering](#NullOrdering)
* <span id="sameOrderExpressions"> "Same Order" [Expression](Expression.md)s

## <span id="SortDirection"> SortDirection

SortDirection | Default Null Ordering | SQL
--------------|-----------------------|---------
 `Ascending`  | NullsFirst            | ASC
 `Descending` | NullsLast             | DESC

## <span id="NullOrdering"> NullOrdering

NullOrdering  | SQL
--------------|---------
 `NullsFirst` | NULLS FIRST
 `NullsLast`  | NULLS LAST

## <span id="apply"> Creating SortOrder

```scala
apply(
  child: Expression,
  direction: SortDirection,
  sameOrderExpressions: Seq[Expression] = Seq.empty): SortOrder
```

`apply` creates a [SortOrder](#creating-instance) (with the `defaultNullOrdering` of the given [SortDirection](#SortDirection)).

## Catalyst DSL

[Catalyst DSL](../catalyst-dsl/index.md) defines the following operators to create `SortOrder`s:

* [asc](../catalyst-dsl/index.md#asc) (with `null`s first)
* [asc_nullsLast](../catalyst-dsl/index.md#asc_nullsLast)
* [desc](../catalyst-dsl/index.md#desc) (with `null`s last)
* [desc_nullsFirst](../catalyst-dsl/index.md#desc_nullsFirst)

```text
import org.apache.spark.sql.catalyst.dsl.expressions._
val sortNullsLast = 'id.asc_nullsLast
scala> println(sortNullsLast.sql)
`id` ASC NULLS LAST
```

## <span id="Unevaluable"> Unevaluable

`SortOrder` is an [Unevaluable](Unevaluable.md) expression.

## Physical Operators

`SortOrder` is used to specify the [output data ordering requirements](../physical-operators/SparkPlan.md#outputOrdering) and the [required child ordering](../physical-operators/SparkPlan.md#requiredChildOrdering) of [physical operator](../physical-operators/SparkPlan.md)s.
