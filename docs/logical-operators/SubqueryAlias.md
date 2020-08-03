title: SubqueryAlias

# SubqueryAlias Unary Logical Operator

`SubqueryAlias` is a <<spark-sql-LogicalPlan.md#UnaryNode, unary logical operator>> that represents an *aliased subquery* (i.e. the <<child, child>> logical query plan with the <<alias, alias>> in the <<output, output schema>>).

`SubqueryAlias` is <<creating-instance, created>> when:

* `AstBuilder` is requested to parse a <<spark-sql-AstBuilder.md#visitNamedQuery, named>> or <<spark-sql-AstBuilder.md#visitAliasedQuery, aliased>> query, <<spark-sql-AstBuilder.md#aliasPlan, aliased query plan>> and <<spark-sql-AstBuilder.md#mayApplyAliasPlan, mayApplyAliasPlan>> in a SQL statement

* <<spark-sql-dataset-operators.md#as, Dataset.as>> operator is used

* `SessionCatalog` is requested to <<spark-sql-SessionCatalog.md#lookupRelation, find a table or view in catalogs>>

* `RewriteCorrelatedScalarSubquery` logical optimization is requested to <<spark-sql-Optimizer-RewriteCorrelatedScalarSubquery.md#constructLeftJoins, constructLeftJoins>> (when <<spark-sql-Optimizer-RewriteCorrelatedScalarSubquery.md#apply, applied>> to <<spark-sql-LogicalPlan-Aggregate.md#, Aggregate>>, <<spark-sql-LogicalPlan-Project.md#, Project>> or <<spark-sql-LogicalPlan-Filter.md#, Filter>> logical operators with correlated scalar subqueries)

[[doCanonicalize]]
`SubqueryAlias` simply requests the <<child, child logical operator>> for the <<catalyst/QueryPlan.md#doCanonicalize, canonicalized version>>.

[[output]]
When requested for <<catalyst/QueryPlan.md#output, output schema attributes>>, `SubqueryAlias` requests the <<child, child>> logical operator for them and adds the <<alias, alias>> as a <<spark-sql-Expression-Attribute.md#withQualifier, qualifier>>.

NOTE: <<spark-sql-Optimizer-EliminateSubqueryAliases.md#, EliminateSubqueryAliases>> logical optimization eliminates (removes) `SubqueryAlias` operators from a logical query plan.

NOTE: <<spark-sql-Optimizer-RewriteCorrelatedScalarSubquery.md#, RewriteCorrelatedScalarSubquery>> logical optimization rewrites correlated scalar subqueries with `SubqueryAlias` operators.

=== [[catalyst-dsl]][[subquery]][[as]] Catalyst DSL -- `subquery` And `as` Operators

[source, scala]
----
as(alias: String): LogicalPlan
subquery(alias: Symbol): LogicalPlan
----

<<spark-sql-catalyst-dsl.md#subquery, subquery>> and <<spark-sql-catalyst-dsl.md#as, as>> operators in spark-sql-catalyst-dsl.md[Catalyst DSL] create a <<creating-instance, SubqueryAlias>> logical operator, e.g. for testing or Spark SQL internals exploration.

[source, scala]
----
import org.apache.spark.sql.catalyst.dsl.plans._
val t1 = table("t1")

val plan = t1.subquery('a)
scala> println(plan.numberedTreeString)
00 'SubqueryAlias a
01 +- 'UnresolvedRelation `t1`

val plan = t1.as("a")
scala> println(plan.numberedTreeString)
00 'SubqueryAlias a
01 +- 'UnresolvedRelation `t1`
----

=== [[creating-instance]] Creating SubqueryAlias Instance

`SubqueryAlias` takes the following when created:

* [[alias]] Alias
* [[child]] Child <<spark-sql-LogicalPlan.md#, logical plan>>
