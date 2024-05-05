---
title: Generate
---

# Generate Unary Logical Operator

`Generate` is a [unary logical operator](LogicalPlan.md#UnaryNode) that represents the following high-level operators in [logical query plans](LogicalPlan.md) (_among other use cases_):

* [LATERAL VIEW](../sql/AstBuilder.md#withGenerate) in `SELECT` or `FROM` clauses in SQL
* [Dataset.explode](../dataset/index.md#explode) (_deprecated_)
* [Generator](../expressions/Generator.md) or `GeneratorOuter` expressions (by [ExtractGenerator](../Analyzer.md#ExtractGenerator) logical evaluation rule)

## Creating Instance

`Generate` takes the following to be created:

* <span id="generator"> [Generator](../expressions/Generator.md)
* <span id="unrequiredChildIndex"> Unrequired Child Index (`Seq[Int]`)
* <span id="outer"> `outer` flag
* <span id="qualifier"> Qualifier
* <span id="generatorOutput"> Generator Output [Attribute](../expressions/Attribute.md)s
* <span id="child"> Child [Logical Operator](LogicalPlan.md)

`Generate` is created when:

* `GeneratorBuilder` is requested to `build` (a `Generate` logical operator)
* `TableFunctionRegistry` is requested to [generator](../TableFunctionRegistry.md#generator)
* [RewriteExceptAll](../logical-optimizations/RewriteExceptAll.md) logical optimization is executed (on [Except](Except.md) logical operator with [isAll](Except.md#isAll) enabled)
* `RewriteIntersectAll` logical optimization is executed (on `Intersect` logical operator with `isAll` enabled)
* `AstBuilder` is requested to [withGenerate](../sql/AstBuilder.md#withGenerate)
* [Dataset.explode](../dataset/index.md#explode) (_deprecated_) is used
* `UserDefinedPythonTableFunction` ([PySpark]({{ book.pyspark }})) is requested to `builder`

## Catalyst DSL

```scala
generate(
  generator: Generator,
  unrequiredChildIndex: Seq[Int] = Nil,
  outer: Boolean = false,
  alias: Option[String] = None,
  outputNames: Seq[String] = Nil): LogicalPlan
```

[Catalyst DSL](../catalyst-dsl/index.md) defines [generate](../catalyst-dsl/DslLogicalPlan.md#generate) operator to create a `Generate` logical operator.

```text
import org.apache.spark.sql.catalyst.plans.logical._
import org.apache.spark.sql.types._
val lr = LocalRelation('key.int, 'values.array(StringType))

// JsonTuple generator
import org.apache.spark.sql.catalyst.expressions.JsonTuple
import org.apache.spark.sql.catalyst.dsl.expressions._
import org.apache.spark.sql.catalyst.expressions.Expression
val children: Seq[Expression] = Seq("e")
val json_tuple = JsonTuple(children)

import org.apache.spark.sql.catalyst.dsl.plans._  // <-- gives generate
val plan = lr.generate(
  generator = json_tuple,
  join = true,
  outer = true,
  alias = Some("alias"),
  outputNames = Seq.empty)
scala> println(plan.numberedTreeString)
00 'Generate json_tuple(e), true, true, alias
01 +- LocalRelation <empty>, [key#0, values#1]
```

## Node Patterns { #nodePatterns }

??? note "TreeNode"

    ```scala
    nodePatterns: Seq[TreePattern]
    ```

    `nodePatterns` is part of the [TreeNode](../catalyst/TreeNode.md#nodePatterns) abstraction.

`nodePatterns` is a single [GENERATE](../catalyst/TreePattern.md#GENERATE).

## Execution Planning

`Generate` logical operator is resolved to [GenerateExec](../physical-operators/GenerateExec.md) unary physical operator in [BasicOperators](../execution-planning-strategies/BasicOperators.md#Generate) execution planning strategy.
