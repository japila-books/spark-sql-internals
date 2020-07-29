# SubExprUtils Helper Object

`SubExprUtils` is a Scala object that is used for...FIXME

`SubExprUtils` uses spark-sql-PredicateHelper.md[PredicateHelper] for...FIXME

`SubExprUtils` is used to <<hasNullAwarePredicateWithinNot, check whether a condition expression has any null-aware predicate subqueries inside Not expressions>>.

=== [[hasNullAwarePredicateWithinNot]] Checking If Condition Expression Has Any Null-Aware Predicate Subqueries Inside Not -- `hasNullAwarePredicateWithinNot` Method

[source, scala]
----
hasNullAwarePredicateWithinNot(condition: Expression): Boolean
----

`hasNullAwarePredicateWithinNot` spark-sql-PredicateHelper.md#splitConjunctivePredicates[splits conjunctive predicates] (i.e. expressions separated by `And` expression).

`hasNullAwarePredicateWithinNot` is positive (i.e. `true`) and is considered to have a *null-aware predicate subquery inside a Not expression* when conjuctive predicate expressions include a `Not` expression with an spark-sql-Expression-In.md[In] predicate expression with a spark-sql-Expression-ListQuery.md[ListQuery] subquery expression.

[source, scala]
----
import org.apache.spark.sql.catalyst.plans.logical._
import org.apache.spark.sql.catalyst.dsl.plans._
val plan = LocalRelation('key.int, 'value.string).analyze

import org.apache.spark.sql.catalyst.expressions._
val in = In(value = Literal.create(1), Seq(ListQuery(plan)))
val condition = Not(child = Or(left = Literal.create(false), right = in))

import org.apache.spark.sql.catalyst.expressions.SubExprUtils
val positive = SubExprUtils.hasNullAwarePredicateWithinNot(condition)
assert(positive)
----

`hasNullAwarePredicateWithinNot` is negative (i.e. `false`) for all the other expressions and in particular the following expressions:

. spark-sql-Expression-Exists.md[Exists] predicate subquery expressions

. `Not` expressions with a spark-sql-Expression-Exists.md[Exists] predicate subquery expression as the child expression

. spark-sql-Expression-In.md[In] expressions with a spark-sql-Expression-ListQuery.md[ListQuery] subquery expression as the spark-sql-Expression-In.md#list[list] expression

. `Not` expressions with a spark-sql-Expression-In.md[In] expression (with a spark-sql-Expression-ListQuery.md[ListQuery] subquery expression as the spark-sql-Expression-In.md#list[list] expression)

[source, scala]
----
import org.apache.spark.sql.catalyst.plans.logical._
import org.apache.spark.sql.catalyst.dsl.plans._
val plan = LocalRelation('key.int, 'value.string).analyze

import org.apache.spark.sql.catalyst.expressions._
import org.apache.spark.sql.catalyst.expressions.SubExprUtils

// Exists
val condition = Exists(plan)
val negative = SubExprUtils.hasNullAwarePredicateWithinNot(condition)
assert(!negative)

// Not Exists
val condition = Not(child = Exists(plan))
val negative = SubExprUtils.hasNullAwarePredicateWithinNot(condition)
assert(!negative)

// In with ListQuery
val condition = In(value = Literal.create(1), Seq(ListQuery(plan)))
val negative = SubExprUtils.hasNullAwarePredicateWithinNot(condition)
assert(!negative)

// Not In with ListQuery
val in = In(value = Literal.create(1), Seq(ListQuery(plan)))
val condition = Not(child = in)
val negative = SubExprUtils.hasNullAwarePredicateWithinNot(condition)
assert(!negative)
----

NOTE: `hasNullAwarePredicateWithinNot` is used exclusively when `CheckAnalysis` analysis validation is requested to spark-sql-Analyzer-CheckAnalysis.md#checkAnalysis[validate analysis of a logical plan] (with `Filter` logical operators).
