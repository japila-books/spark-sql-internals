# ResolveReferences Logical Resolution Rule

`ResolveReferences` is a logical resolution rule that the [logical query plan analyzer](../Analyzer.md#ResolveReferences) uses to <<apply, resolve FIXME>> in a logical query plan, i.e.

1. Resolves...FIXME

Technically, `ResolveReferences` is just a catalyst/Rule.md[Catalyst rule] for transforming spark-sql-LogicalPlan.md[logical plans], i.e. `Rule[LogicalPlan]`.

`ResolveReferences` is part of [Resolution](../Analyzer.md#Resolution) fixed-point batch of rules.

[[example]]
[source, scala]
----
// FIXME: Use Catalyst DSL to create a logical plan
import org.apache.spark.sql.catalyst.dsl.plans._
val t1 = table("t1")

import org.apache.spark.sql.catalyst.dsl.expressions._
val logicalPlan = t1
  .select("a".attr, star())
  .groupBy(groupingExprs = "b".attr)(aggregateExprs = star())
scala> println(logicalPlan.numberedTreeString)
00 'Aggregate ['b], [*]
01 +- 'Project ['a, *]
02    +- 'UnresolvedRelation `t1`
// END FIXME

// Make the example repeatable
val table = "t1"
import org.apache.spark.sql.catalyst.TableIdentifier
spark.sessionState.catalog.dropTable(TableIdentifier(table), ignoreIfNotExists = true, purge = true)

Seq((0, "zero"), (1, "one")).toDF("id", "name").createOrReplaceTempView(table)
val query = spark.table("t1").select("id", "*").groupBy("id", "name").agg(col("*"))
val logicalPlan = query.queryExecution.logical
scala> println(logicalPlan.numberedTreeString)
00 'Aggregate [id#28, name#29], [id#28, name#29, *]
01 +- Project [id#28, id#28, name#29]
02    +- SubqueryAlias t1
03       +- Project [_1#25 AS id#28, _2#26 AS name#29]
04          +- LocalRelation [_1#25, _2#26]

import spark.sessionState.analyzer.ResolveReferences
val planWithRefsResolved = ResolveReferences(logicalPlan)
scala> println(planWithRefsResolved.numberedTreeString)
00 Aggregate [id#28, name#29], [id#28, name#29, id#28, id#28, name#29]
01 +- Project [id#28, id#28, name#29]
02    +- SubqueryAlias t1
03       +- Project [_1#25 AS id#28, _2#26 AS name#29]
04          +- LocalRelation [_1#25, _2#26]
----

=== [[resolve]] Resolving Expressions of Logical Plan -- `resolve` Internal Method

[source, scala]
----
resolve(e: Expression, q: LogicalPlan): Expression
----

`resolve` resolves the input expression per type:

. `UnresolvedAttribute` expressions

. `UnresolvedExtractValue` expressions

. All other expressions

NOTE: `resolve` is used exclusively when `ResolveReferences` is requested to <<apply, resolve reference expressions in a logical query plan>>.

=== [[apply]] Resolving Reference Expressions In Logical Query Plan (Applying ResolveReferences to Logical Plan) -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

NOTE: `apply` is part of catalyst/Rule.md#apply[Rule Contract] to apply a rule to a spark-sql-LogicalPlan.md[logical plan].

`apply` resolves the following logical operators:

* Project.md[Project] logical operator with a `Star` expression to...FIXME

* Aggregate.md[Aggregate] logical operator with a `Star` expression to...FIXME

* `ScriptTransformation` logical operator with a `Star` expression to...FIXME

* Generate.md[Generate] logical operator with a `Star` expression to...FIXME

* Join.md[Join] logical operator with `duplicateResolved`...FIXME

* Intersect.md[Intersect] logical operator with `duplicateResolved`...FIXME

* Except.md[Except] logical operator with `duplicateResolved`...FIXME

* Sort.md[Sort] logical operator unresolved with child operators resolved...FIXME

* Generate.md[Generate] logical operator resolved...FIXME

* Generate.md[Generate] logical operator unresolved...FIXME

In the end, `apply` <<resolve, resolves>> the expressions of the input logical operator.

`apply` skips logical operators that:

* Use `UnresolvedDeserializer` expressions

* Have child operators spark-sql-LogicalPlan.md#childrenResolved[unresolved]

=== [[buildExpandedProjectList]] Expanding Star Expressions -- `buildExpandedProjectList` Internal Method

[source, scala]
----
buildExpandedProjectList(
  exprs: Seq[NamedExpression],
  child: LogicalPlan): Seq[NamedExpression]
----

`buildExpandedProjectList` expands (_converts_) expressions/Star.md[Star] expressions in the input expressions/NamedExpression.md[named expressions] recursively (down the expression tree) per expression:

* For a `Star` expression, `buildExpandedProjectList` requests it to expressions/Star.md#expand[expand] given the input `child` logical plan

* For a `UnresolvedAlias` expression with a `Star` child expression, `buildExpandedProjectList` requests it to expressions/Star.md#expand[expand] given the input `child` logical plan (similarly to a `Star` expression alone in the above case)

* For `exprs` with `Star` expressions down the expression tree, `buildExpandedProjectList` <<expandStarExpression, expandStarExpression>> passing the input `exprs` and `child`

NOTE: `buildExpandedProjectList` is used when `ResolveReferences` is requested to <<apply, resolve reference expressions>> (in `Project` and `Aggregate` operators with `Star` expressions).

=== [[expandStarExpression]] `expandStarExpression` Method

[source, scala]
----
expandStarExpression(expr: Expression, child: LogicalPlan): Expression
----

`expandStarExpression` expands (_transforms_) the following expressions in the input `expr` expressions/Expression.md[expression]:

1. For spark-sql-Expression-UnresolvedFunction.md[UnresolvedFunction] expressions with expressions/Star.md[Star] child expressions, `expandStarExpression` requests the `Star` expressions to expressions/Star.md#expand[expand] given the input `child` logical plan and the [resolver](../Analyzer.md#resolver).
+
```
// Using Catalyst DSL to create a logical plan with a function with Star child expression
import org.apache.spark.sql.catalyst.dsl.plans._
val t1 = table("t1")

import org.apache.spark.sql.catalyst.dsl.expressions._
val f1 = 'f1.function(star())

val plan = t1.select(f1)
scala> println(plan.numberedTreeString)
00 'Project [unresolvedalias('f1(*), None)]
01 +- 'UnresolvedRelation `t1`

// CAUTION: FIXME How to demo that the plan gets resolved using ResolveReferences.expandStarExpression?
```

* For <<spark-sql-Expression-CreateNamedStruct.md#, CreateNamedStruct>> expressions with expressions/Star.md[Star] child expressions among the values, `expandStarExpression`...FIXME

* For spark-sql-Expression-CreateArray.md[CreateArray] expressions with expressions/Star.md[Star] child expressions, `expandStarExpression`...FIXME

* For spark-sql-Expression-Murmur3Hash.md[Murmur3Hash] expressions with expressions/Star.md[Star] child expressions, `expandStarExpression`...FIXME

For any other uses of expressions/Star.md[Star] expressions, `expandStarExpression` fails analysis with a `AnalysisException`:

```
Invalid usage of '*' in expression '[exprName]'
```

NOTE: `expandStarExpression` is used exclusively when `ResolveReferences` is requested to <<buildExpandedProjectList, expand Star expressions>> (in `Project` and `Aggregate` operators).

=== [[dedupRight]] `dedupRight` Internal Method

[source, scala]
----
dedupRight(left: LogicalPlan, right: LogicalPlan): LogicalPlan
----

`dedupRight`...FIXME

NOTE: `dedupRight` is used when...FIXME

=== [[dedupOuterReferencesInSubquery]] `dedupOuterReferencesInSubquery` Internal Method

[source, scala]
----
dedupOuterReferencesInSubquery(
  plan: LogicalPlan,
  attrMap: AttributeMap[Attribute]): LogicalPlan
----

`dedupOuterReferencesInSubquery`...FIXME

NOTE: `dedupOuterReferencesInSubquery` is used when...FIXME
