title: UnresolvedGenerator

# UnresolvedGenerator Expression

`UnresolvedGenerator` is a spark-sql-Expression-Generator.md[Generator] that represents an unresolved generator in a logical query plan.

`UnresolvedGenerator` is <<creating-instance, created>> exclusively when `AstBuilder` is requested to spark-sql-AstBuilder.md#withGenerate[withGenerate] (as part of Generate.md#generator[Generate] logical operator) for SQL's `LATERAL VIEW` (in `SELECT` or `FROM` clauses).

[source, scala]
----
// SQLs borrowed from https://cwiki.apache.org/confluence/display/Hive/LanguageManual+LateralView
val sqlText = """
  SELECT pageid, adid
  FROM pageAds LATERAL VIEW explode(adid_list) adTable AS adid
"""
// Register pageAds table
Seq(
  ("front_page", Array(1, 2, 3)),
  ("contact_page", Array(3, 4, 5)))
  .toDF("pageid", "adid_list")
  .createOrReplaceTempView("pageAds")
val query = sql(sqlText)
val logicalPlan = query.queryExecution.logical
scala> println(logicalPlan.numberedTreeString)
00 'Project ['pageid, 'adid]
01 +- 'Generate 'explode('adid_list), false, adtable, ['adid]
02    +- 'UnresolvedRelation `pageAds`

import org.apache.spark.sql.catalyst.plans.logical.Generate
val generator = logicalPlan.collectFirst { case g: Generate => g.generator }.get

scala> :type generator
org.apache.spark.sql.catalyst.expressions.Generator

import org.apache.spark.sql.catalyst.analysis.UnresolvedGenerator
scala> generator.isInstanceOf[UnresolvedGenerator]
res1: Boolean = true
----

[[resolved]]
`UnresolvedGenerator` can never be Expression.md#resolved[resolved] (and is replaced at <<analysis-phase, analysis phase>>).

[[Unevaluable]][[eval]][[doGenCode]]
Given `UnresolvedGenerator` can never be resolved it should not come as a surprise that it Expression.md#Unevaluable[cannot be evaluated] either (i.e. produce a value given an internal row). When requested to evaluate, `UnresolvedGenerator` simply reports a `UnsupportedOperationException`.

```
Cannot evaluate expression: [this]
```

[[analysis-phase]]
[NOTE]
====
`UnresolvedGenerator` is resolved to a concrete spark-sql-Expression-Generator.md[Generator] expression when [ResolveFunctions](../logical-analysis-rules/ResolveFunctions.md) logical resolution rule is executed.
====

NOTE: `UnresolvedGenerator` is similar to spark-sql-Expression-UnresolvedFunction.md[UnresolvedFunction] and differs mostly by the type (to make Spark development with Scala easier?)

=== [[creating-instance]] Creating UnresolvedGenerator Instance

`UnresolvedGenerator` takes the following when created:

* [[name]] `FunctionIdentifier`
* [[children]] Child Expression.md[expressions]
