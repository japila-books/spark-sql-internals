---
title: Except
---

# Except Logical Operator

`Except` is a `SetOperation` binary logical operator that represents the following high-level operators (in a logical plan):

* `EXCEPT [ DISTINCT | ALL ]` and `MINUS [ DISTINCT | ALL ]` SQL statements (cf. [AstBuilder](../sql/AstBuilder.md#visitSetOperation))
* [Dataset.except](../dataset/index.md#except) and [Dataset.exceptAll](../dataset/index.md#exceptAll)

## Creating Instance

`Except` takes the following to be created:

* <span id="left"> Left [logical operator](LogicalPlan.md)
* <span id="right"> Right [logical operator](LogicalPlan.md)
* <span id="isAll"> `isAll` flag for `DISTINCT` (`false`) or `ALL` (`true`)

`Except` is created when:

* `AstBuilder` is requested to [visit a SetOperation](../sql/AstBuilder.md#visitSetOperation) (`EXCEPT` and `MINUS` operators)
* [Dataset.except](../dataset/index.md#except) and [Dataset.exceptAll](../dataset/index.md#exceptAll) operators are used
* Catalyst DSL's [except](../catalyst-dsl/DslLogicalPlan.md#except) operator is used

## Logical Optimization

`Except` is supposed to be resolved (_optimized_) to other logical commands at logical optimization phase (i.e. `Except` should not be part of a logical plan after logical optimization).

[BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy throws an `IllegalStateException` if conversions did not happen.

Target Logical Operators | Optimization Rules and Demos
-------------------------|-----------------------------
Left-Anti [Join](Join.md) | `Except` (DISTINCT) in [ReplaceExceptWithAntiJoin](../logical-optimizations/ReplaceExceptWithAntiJoin.md) logical optimization rule<p>Demo: [Except Operator Replaced with Left-Anti Join](#demo-left-anti-join)
`Filter` | `Except` (DISTINCT) in [ReplaceExceptWithFilter](../logical-optimizations/ReplaceExceptWithFilter.md) logical optimization rule<p>Demo: [Except Operator Replaced with Filter Operator](#demo-except-filter)
`Union`, [Aggregate](Aggregate.md) and [Generate](Generate.md) | `Except` (ALL) in [RewriteExceptAll](../logical-optimizations/RewriteExceptAll.md) logical optimization rule<p>Demo: [Except (All) Operator Replaced with Union, Aggregate and Generate Operators](#demo-except-all)

## Catalyst DSL

```scala
except(
  otherPlan: LogicalPlan,
  isAll: Boolean): LogicalPlan
```

[Catalyst DSL](../catalyst-dsl/index.md) defines [except](../catalyst-dsl/index.md#except) extension method to create an `Except` logical operator (e.g. for testing or Spark SQL internals exploration).

```text
import org.apache.spark.sql.catalyst.dsl.plans._
val plan = table("a").except(table("b"), isAll = false)
scala> println(plan.numberedTreeString)
00 'Except false
01 :- 'UnresolvedRelation `a`
02 +- 'UnresolvedRelation `b`

import org.apache.spark.sql.catalyst.plans.logical.Except
val op = plan.p(0)
assert(op.isInstanceOf[Except])
```

## Except Only on Relations with Same Number of Columns { #CheckAnalysis }

`Except` logical operator can only be performed on [tables with the same number of columns](../CheckAnalysis.md#checkAnalysis).

```text
scala> left.except(right)
org.apache.spark.sql.AnalysisException: Except can only be performed on tables with the same number of columns, but the first table has 3 columns and the second table has 4 columns;;
'Except false
:- SubqueryAlias `default`.`except_left`
:  +- Relation[id#16,name#17,triple#18] parquet
+- SubqueryAlias `default`.`except_right`
   +- Relation[id#181,name#182,triple#183,extra_column#184] parquet

  at org.apache.spark.sql.catalyst.analysis.CheckAnalysis.failAnalysis(CheckAnalysis.scala:43)
  at org.apache.spark.sql.catalyst.analysis.CheckAnalysis.failAnalysis$(CheckAnalysis.scala:42)
  at org.apache.spark.sql.catalyst.analysis.Analyzer.failAnalysis(Analyzer.scala:95)
  at org.apache.spark.sql.catalyst.analysis.CheckAnalysis.$anonfun$checkAnalysis$16(CheckAnalysis.scala:288)
  ...
```

## Demo

### Except Operator Replaced with Left-Anti Join { #demo-left-anti-join }

```text
Seq((0, "zero", "000"), (1, "one", "111"))
  .toDF("id", "name", "triple")
  .write
  .saveAsTable("except_left")
val left = spark.table("except_left")

// The number of rows differ
Seq((1, "one", "111"))
  .toDF("id", "name", "triple")
  .write
  .mode("overwrite")
  .saveAsTable("except_right")
val right = spark.table("except_right")

val q = left.except(right)

// SELECT a1, a2 FROM Tab1 EXCEPT SELECT b1, b2 FROM Tab2
// ==>  SELECT DISTINCT a1, a2 FROM Tab1 LEFT ANTI JOIN Tab2 ON a1<=>b1 AND a2<=>b2

// Note the use of <=> null-safe comparison operator
scala> println(q.queryExecution.optimizedPlan.numberedTreeString)
00 Aggregate [id#16, name#17, triple#18], [id#16, name#17, triple#18]
01 +- Join LeftAnti, (((id#16 <=> id#209) && (name#17 <=> name#210)) && (triple#18 <=> triple#211))
02    :- Relation[id#16,name#17,triple#18] parquet
03    +- Relation[id#209,name#210,triple#211] parquet
```

### Except Operator Replaced with Filter Operator { #demo-except-filter }

```text
Seq((0, "zero", "000"), (1, "one", "111"))
  .toDF("id", "name", "triple")
  .write
  .saveAsTable("except_left")
val t1 = spark.table("except_left")

val left = t1.where(length($"name") > 3)
val right = t1.where($"id" > 0)

// SELECT a1, a2 FROM Tab1 WHERE a2 = 12 EXCEPT SELECT a1, a2 FROM Tab1 WHERE a1 = 5
val q = left.except(right)

scala> println(q.queryExecution.optimizedPlan.numberedTreeString)
00 Aggregate [id#16, name#17, triple#18], [id#16, name#17, triple#18]
01 +- Filter ((length(name#17) = 3) && NOT coalesce((id#16 = 0), false))
02    +- Relation[id#16,name#17,triple#18] parquet
```

### Except (All) Operator Replaced with Union, Aggregate and Generate Operators { #demo-except-all }

```text
Seq((0, "zero", "000"), (1, "one", "111"))
  .toDF("id", "name", "triple")
  .write
  .saveAsTable("except_left")
val left = spark.table("except_left")

// The number of rows differ
Seq((1, "one", "111"))
  .toDF("id", "name", "triple")
  .write
  .mode("overwrite")
  .saveAsTable("except_right")
val right = spark.table("except_right")

// SELECT c1 FROM ut1 EXCEPT ALL SELECT c1 FROM ut2
val q = left.exceptAll(right)

scala> println(q.queryExecution.optimizedPlan.numberedTreeString)
00 Project [id#16, name#17, triple#18]
01 +- Generate replicaterows(sum#227L, id#16, name#17, triple#18), [3], false, [id#16, name#17, triple#18]
02    +- Filter (isnotnull(sum#227L) && (sum#227L > 0))
03       +- Aggregate [id#16, name#17, triple#18], [id#16, name#17, triple#18, sum(vcol#224L) AS sum#227L]
04          +- Union
05             :- Project [1 AS vcol#224L, id#16, name#17, triple#18]
06             :  +- Relation[id#16,name#17,triple#18] parquet
07             +- Project [-1 AS vcol#225L, id#209, name#210, triple#211]
08                +- Relation[id#209,name#210,triple#211] parquet
```
