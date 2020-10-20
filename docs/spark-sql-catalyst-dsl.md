# Catalyst DSL

**Catalyst DSL** is a collection of <<implicit-conversions, Scala implicit conversions>> for constructing Catalyst data structures, i.e. <<ExpressionConversions, expressions>> and <<plans, logical plans>>, more easily.

The goal of Catalyst DSL is to make working with Spark SQL's building blocks easier (e.g. for testing or Spark SQL internals exploration).

[[implicit-conversions]]
.Catalyst DSL's Implicit Conversions
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| <<ExpressionConversions, ExpressionConversions>>
a| Creates expressions

* Literals
* UnresolvedAttribute and UnresolvedReference
* ...

| <<ImplicitOperators, ImplicitOperators>>
| Adds operators to expressions for complex expressions

| <<plans, plans>>
a| Creates logical plans

* <<hint, hint>>
* <<join, join>>
* <<table, table>>
* <<DslLogicalPlan, DslLogicalPlan>>
|===

Catalyst DSL is part of `org.apache.spark.sql.catalyst.dsl` package object.

[source, scala]
----
import org.apache.spark.sql.catalyst.dsl.expressions._
scala> :type $"hello"
org.apache.spark.sql.catalyst.analysis.UnresolvedAttribute
----

[IMPORTANT]
====
Some implicit conversions from the Catalyst DSL interfere with the implicits conversions from `SQLImplicits` that are imported automatically in `spark-shell` (through `spark.implicits._`).

```
scala> 'hello.decimal
<console>:30: error: type mismatch;
 found   : Symbol
 required: ?{def decimal: ?}
Note that implicit conversions are not applicable because they are ambiguous:
 both method symbolToColumn in class SQLImplicits of type (s: Symbol)org.apache.spark.sql.ColumnName
 and method DslSymbol in trait ExpressionConversions of type (sym: Symbol)org.apache.spark.sql.catalyst.dsl.expressions.DslSymbol
 are possible conversion functions from Symbol to ?{def decimal: ?}
       'hello.decimal
       ^
<console>:30: error: value decimal is not a member of Symbol
       'hello.decimal
              ^
```

Use `sbt console` with Spark libraries defined (in `build.sbt`) instead.

---

You can also disable an implicit conversion using a trick described in https://stackoverflow.com/q/15592324/1305344[How can an implicit be unimported from the Scala repl?]

[source, scala]
----
// HACK: Disable symbolToColumn implicit conversion
// It is imported automatically in spark-shell (and makes demos impossible)
// implicit def symbolToColumn(s: Symbol): org.apache.spark.sql.ColumnName
trait ThatWasABadIdea
implicit def symbolToColumn(ack: ThatWasABadIdea) = ack

// HACK: Disable $ string interpolator
// It is imported automatically in spark-shell (and makes demos impossible)
implicit class StringToColumn(val sc: StringContext) {}
----
====

[[example]]
[source, scala]
----
import org.apache.spark.sql.catalyst.dsl.expressions._
import org.apache.spark.sql.catalyst.dsl.plans._

// ExpressionConversions

import org.apache.spark.sql.catalyst.expressions.Literal
scala> val trueLit: Literal = true
trueLit: org.apache.spark.sql.catalyst.expressions.Literal = true

import org.apache.spark.sql.catalyst.analysis.UnresolvedAttribute
scala> val name: UnresolvedAttribute = 'name
name: org.apache.spark.sql.catalyst.analysis.UnresolvedAttribute = 'name

// NOTE: This conversion may not work, e.g. in spark-shell
// There is another implicit conversion StringToColumn in SQLImplicits
// It is automatically imported in spark-shell
// See :imports
val id: UnresolvedAttribute = $"id"

import org.apache.spark.sql.catalyst.expressions.Expression
scala> val expr: Expression = sum('id)
expr: org.apache.spark.sql.catalyst.expressions.Expression = sum('id)

// implicit class DslSymbol
scala> 'hello.s
res2: String = hello

scala> 'hello.attr
res4: org.apache.spark.sql.catalyst.analysis.UnresolvedAttribute = 'hello

// implicit class DslString
scala> "helo".expr
res0: org.apache.spark.sql.catalyst.expressions.Expression = helo

scala> "helo".attr
res1: org.apache.spark.sql.catalyst.analysis.UnresolvedAttribute = 'helo

// logical plans

scala> val t1 = table("t1")
t1: org.apache.spark.sql.catalyst.plans.logical.LogicalPlan =
'UnresolvedRelation `t1`

scala> val p = t1.select('*).serialize[String].where('id % 2 == 0)
p: org.apache.spark.sql.catalyst.plans.logical.LogicalPlan =
'Filter false
+- 'SerializeFromObject [staticinvoke(class org.apache.spark.unsafe.types.UTF8String, StringType, fromString, input[0, java.lang.String, true], true) AS value#1]
   +- 'Project ['*]
      +- 'UnresolvedRelation `t1`

// FIXME Does not work because SimpleAnalyzer's catalog is empty
// the p plan references a t1 table
import org.apache.spark.sql.catalyst.analysis.SimpleAnalyzer
scala> p.analyze
----

=== [[ImplicitOperators]] `ImplicitOperators` Implicit Conversions

[[in]]
Operators for expressions/Expression.md[expressions], i.e. `in`.

=== [[ExpressionConversions]] `ExpressionConversions` Implicit Conversions

`ExpressionConversions` implicit conversions add <<ImplicitOperators, ImplicitOperators>> operators to expressions/Expression.md[Catalyst expressions].

==== Type Conversions to Literal Expressions

`ExpressionConversions` adds conversions of Scala native types (e.g. `Boolean`, `Long`, `String`, `Date`, `Timestamp`) and Spark SQL types (i.e. `Decimal`) to spark-sql-Expression-Literal.md[Literal] expressions.

[source, scala]
----
// DEMO FIXME
----

==== Converting Symbols to UnresolvedAttribute and AttributeReference Expressions

`ExpressionConversions` adds conversions of Scala's `Symbol` to spark-sql-Expression-UnresolvedAttribute.md[UnresolvedAttribute] and `AttributeReference` expressions.

[source, scala]
----
// DEMO FIXME
----

==== Converting $-Prefixed String Literals to UnresolvedAttribute Expressions

`ExpressionConversions` adds conversions of `$"col name"` to an spark-sql-Expression-UnresolvedAttribute.md[UnresolvedAttribute] expression.

[source, scala]
----
// DEMO FIXME
----

==== [[star]] Adding Aggregate And Non-Aggregate Functions to Expressions

[source, scala]
----
star(names: String*): Expression
----

`ExpressionConversions` adds the aggregate and non-aggregate functions to expressions/Expression.md[Catalyst expressions] (e.g. `sum`, `count`, `upper`, `star`, `callFunction`, `windowSpec`, `windowExpr`)

[source, scala]
----
import org.apache.spark.sql.catalyst.dsl.expressions._
val s = star()

import org.apache.spark.sql.catalyst.analysis.UnresolvedStar
assert(s.isInstanceOf[UnresolvedStar])

val s = star("a", "b")
scala> println(s)
WrappedArray(a, b).*
----

==== [[function]][[distinctFunction]] Creating UnresolvedFunction Expressions -- `function` and `distinctFunction` Methods

`ExpressionConversions` allows creating spark-sql-Expression-UnresolvedFunction.md[UnresolvedFunction] expressions with `function` and `distinctFunction` operators.

[source, scala]
----
function(exprs: Expression*): UnresolvedFunction
distinctFunction(exprs: Expression*): UnresolvedFunction
----

[source, scala]
----
import org.apache.spark.sql.catalyst.dsl.expressions._

// Works with Scala Symbols only
val f = 'f.function()
scala> :type f
org.apache.spark.sql.catalyst.analysis.UnresolvedFunction

scala> f.isDistinct
res0: Boolean = false

val g = 'g.distinctFunction()
scala> g.isDistinct
res1: Boolean = true
----

==== [[DslAttribute]][[notNull]][[canBeNull]] Creating AttributeReference Expressions With nullability On or Off -- `notNull` and `canBeNull` Methods

`ExpressionConversions` adds `canBeNull` and `notNull` operators to create a `AttributeReference` with `nullability` turned on or off, respectively.

[source, scala]
----
notNull: AttributeReference
canBeNull: AttributeReference
----

[source, scala]
----
// DEMO FIXME
----

==== [[at]] Creating BoundReference -- `at` Method

[source, scala]
----
at(ordinal: Int): BoundReference
----

`ExpressionConversions` adds `at` method to `AttributeReferences` to create spark-sql-Expression-BoundReference.md[BoundReference] expressions.

[source, scala]
----
import org.apache.spark.sql.catalyst.dsl.expressions._
val boundRef = 'hello.string.at(4)
scala> println(boundRef)
input[4, string, true]
----

=== [[plans]] `plans` Implicit Conversions for Logical Plans

==== [[hint]] Creating UnresolvedHint Logical Operator -- `hint` Method

`plans` adds `hint` method to create a spark-sql-LogicalPlan-UnresolvedHint.md[UnresolvedHint] logical operator.

[source, scala]
----
hint(name: String, parameters: Any*): LogicalPlan
----

==== [[join]] Creating Join Logical Operator -- `join` Method

`join` creates a spark-sql-LogicalPlan-Join.md[Join] logical operator.

[source, scala]
----
join(
  otherPlan: LogicalPlan,
  joinType: JoinType = Inner,
  condition: Option[Expression] = None): LogicalPlan
----

==== [[table]] Creating UnresolvedRelation Logical Operator -- `table` Method

`table` creates a spark-sql-LogicalPlan-UnresolvedRelation.md[UnresolvedRelation] logical operator.

[source, scala]
----
table(ref: String): LogicalPlan
table(db: String, ref: String): LogicalPlan
----

[source, scala]
----
import org.apache.spark.sql.catalyst.dsl.plans._

val t1 = table("t1")
scala> println(t1.treeString)
'UnresolvedRelation `t1`
----

==== [[DslLogicalPlan]] `DslLogicalPlan` Implicit Class

[source, scala]
----
implicit class DslLogicalPlan(
  logicalPlan: LogicalPlan)
----

`DslLogicalPlan` implicit class is part of <<plans, plans>> implicit conversions with extension methods (of spark-sql-LogicalPlan.md[logical operators]) to build entire logical plans.

.DslLogicalPlan's Extension Methods
[cols="30m,70",options="header",width="100%"]
|===
| Name
| Description

| analyze
a| [[analyze]]

[source, scala]
----
analyze: LogicalPlan
----

Resolves attribute references (using spark-sql-Optimizer-EliminateSubqueryAliases.md[EliminateSubqueryAliases] logical optimization and `SimpleAnalyzer` logical analyzer)

| as
a| [[as]]

[source, scala]
----
as(
  alias: String): LogicalPlan
----

| coalesce
a| [[coalesce]]

[source, scala]
----
coalesce(
  num: Integer): LogicalPlan
----

| cogroup
a| [[cogroup]]

[source, scala]
----
cogroup[Key: Encoder, Left: Encoder, Right: Encoder, Result: Encoder](
  otherPlan: LogicalPlan,
  func: (Key, Iterator[Left], Iterator[Right]) => TraversableOnce[Result],
  leftGroup: Seq[Attribute],
  rightGroup: Seq[Attribute],
  leftAttr: Seq[Attribute],
  rightAttr: Seq[Attribute]): LogicalPlan
----

| deserialize
a| [[deserialize]]

[source, scala]
----
deserialize[T : Encoder]: LogicalPlan
----

| distribute
a| [[distribute]]

[source, scala]
----
distribute(
  exprs: Expression*)(
  n: Int): LogicalPlan
----

| except
a| [[except]]

[source, scala]
----
except(
  otherPlan: LogicalPlan,
  isAll: Boolean): LogicalPlan
----

| filter
a| [[filter]]

[source, scala]
----
filter[T : Encoder](
  func: T => Boolean): LogicalPlan
----

| generate
a| [[generate]]

[source, scala]
----
generate(
  generator: Generator,
  unrequiredChildIndex: Seq[Int] = Nil,
  outer: Boolean = false,
  alias: Option[String] = None,
  outputNames: Seq[String] = Nil): LogicalPlan
----

| groupBy
a| [[groupBy]]

[source, scala]
----
groupBy(
  groupingExprs: Expression*)(
  aggregateExprs: Expression*): LogicalPlan
----

| hint
a| [[hint]]

[source, scala]
----
hint(
  name: String,
  parameters: Any*): LogicalPlan
----

| insertInto
a| [[insertInto]]

[source, scala]
----
insertInto(
  tableName: String,
  overwrite: Boolean = false): LogicalPlan
----

| intersect
a| [[intersect]]

[source, scala]
----
intersect(
  otherPlan: LogicalPlan,
  isAll: Boolean): LogicalPlan
----

| join
a| [[join]]

[source, scala]
----
join(
  otherPlan: LogicalPlan,
  joinType: JoinType = Inner,
  condition: Option[Expression] = None): LogicalPlan
----

| limit
a| [[limit]]

[source, scala]
----
limit(
  limitExpr: Expression): LogicalPlan
----

| orderBy
a| [[orderBy]]

[source, scala]
----
orderBy(
  sortExprs: SortOrder*): LogicalPlan
----

| repartition
a| [[repartition]]

[source, scala]
----
repartition(
  num: Integer): LogicalPlan
----

| select
a| [[select]]

[source, scala]
----
select(
  exprs: Expression*): LogicalPlan
----

| serialize
a| [[serialize]]

[source, scala]
----
serialize[T : Encoder]: LogicalPlan
----

| sortBy
a| [[sortBy]]

[source, scala]
----
sortBy(
  sortExprs: SortOrder*): LogicalPlan
----

| subquery
a| [[subquery]]

[source, scala]
----
subquery(
  alias: Symbol): LogicalPlan
----

| union
a| [[union]]

[source, scala]
----
union(
  otherPlan: LogicalPlan): LogicalPlan
----

| where
a| [[where]]

[source, scala]
----
where(
  condition: Expression): LogicalPlan
----

| window
a| [[window]]

[source, scala]
----
window(
  windowExpressions: Seq[NamedExpression],
  partitionSpec: Seq[Expression],
  orderSpec: Seq[SortOrder]): LogicalPlan
----

|===

[source, scala]
----
// Import plans object
// That loads implicit class DslLogicalPlan
// And so every LogicalPlan is the "target" of the DslLogicalPlan methods
import org.apache.spark.sql.catalyst.dsl.plans._

val t1 = table(ref = "t1")

// HACK: Disable symbolToColumn implicit conversion
// It is imported automatically in spark-shell (and makes demos impossible)
// implicit def symbolToColumn(s: Symbol): org.apache.spark.sql.ColumnName
trait ThatWasABadIdea
implicit def symbolToColumn(ack: ThatWasABadIdea) = ack

import org.apache.spark.sql.catalyst.dsl.expressions._
val id = 'id.long
val logicalPlan = t1.select(id)
scala> println(logicalPlan.numberedTreeString)
00 'Project [id#1L]
01 +- 'UnresolvedRelation `t1`

val t2 = table("t2")
import org.apache.spark.sql.catalyst.plans.LeftSemi
val logicalPlan = t1.join(t2, joinType = LeftSemi, condition = Some(id))
scala> println(logicalPlan.numberedTreeString)
00 'Join LeftSemi, id#1: bigint
01 :- 'UnresolvedRelation `t1`
02 +- 'UnresolvedRelation `t2`
----
