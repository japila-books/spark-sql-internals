title: Star

# Star Expression Contract

`Star` is a <<contract, contract>> of expressions/Expression.md#LeafExpression[leaf] and spark-sql-Expression-NamedExpression.md[named expressions] that...FIXME

[[contract]]
[source, scala]
----
package org.apache.spark.sql.catalyst.analysis

abstract class Star extends LeafExpression with NamedExpression {
  // only required methods that have no implementation
  def expand(input: LogicalPlan, resolver: Resolver): Seq[NamedExpression]
}
----

.Star Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| `expand`
a| [[expand]] Used exclusively when `ResolveReferences` logical resolution rule is requested to expand `Star` expressions in the following logical operators:

* [ScriptTransformation](../logical-analysis-rules/ResolveReferences.md#apply)

* [Project and Aggregate](../logical-analysis-rules/ResolveReferences.md#buildExpandedProjectList)

|===

[[implementations]]
.Stars
[cols="1,2",options="header",width="100%"]
|===
| Star
| Description

| [[ResolvedStar]] spark-sql-Expression-ResolvedStar.md[ResolvedStar]
|

| [[UnresolvedRegex]] spark-sql-Expression-UnresolvedRegex.md[UnresolvedRegex]
|

| [[UnresolvedStar]] spark-sql-Expression-UnresolvedStar.md[UnresolvedStar]
|
|===
