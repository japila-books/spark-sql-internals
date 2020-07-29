title: Coalesce

# Coalesce Expression

`Coalesce` is a expressions/Expression.md[Catalyst expression] to represent spark-sql-functions.md#coalesce[coalesce] standard function or SQL's spark-sql-FunctionRegistry.md#expressions[coalesce] function in structured queries.

[[creating-instance]]
[[children]]
When created, `Coalesce` takes expressions/Expression.md[Catalyst expressions] (as the children).

[source, scala]
----
import org.apache.spark.sql.catalyst.expressions.Coalesce

// Use Catalyst DSL
import org.apache.spark.sql.catalyst.dsl.expressions._

import org.apache.spark.sql.functions.lit
val coalesceExpr = Coalesce(children = Seq(lit(null).expr % 1, lit(null).expr, 1d))
scala> println(coalesceExpr.numberedTreeString)
00 coalesce((null % 1), null, 1.0)
01 :- (null % 1)
02 :  :- null
03 :  +- 1
04 :- null
05 +- 1.0
----

CAUTION: FIXME Describe FunctionArgumentConversion and Coalesce

Spark Optimizer uses spark-sql-Optimizer-NullPropagation.md[NullPropagation] logical optimization to remove `null` literals (in the <<children, children>> expressions). That could result in a static evaluation that gives `null` value if all <<children, children>> expressions are `null` literals.

[source, scala]
----
// FIXME
// Demo Coalesce with nulls only
// Demo Coalesce with null and non-null expressions that are optimized to one expression (in NullPropagation)
// Demo Coalesce with non-null expressions after NullPropagation optimization
----

`Coalesce` is also <<creating-instance, created>> when:

* `Analyzer` is requested to spark-sql-Analyzer.md#commonNaturalJoinProcessing[commonNaturalJoinProcessing] for `FullOuter` join type

* `RewriteDistinctAggregates` logical optimization is requested to `rewrite`

* `ExtractEquiJoinKeys` Scala extractor is requested to spark-sql-ExtractEquiJoinKeys.md#unapply[destructure a logical plan]

* `ColumnStat` is requested to spark-sql-ColumnStat.md#statExprs[statExprs]

* `IfNull` expression is created

* `Nvl` expression is created

* Whenever `Cast` expression is used in Catalyst expressions (e.g. `Average`, `Sum`)
