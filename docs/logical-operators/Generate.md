title: Generate

# Generate Unary Logical Operator for Lateral Views

`Generate` is a spark-sql-LogicalPlan.md#UnaryNode[unary logical operator] that is <<creating-instance, created>> to represent the following (after a logical plan is spark-sql-LogicalPlan.md#analyzed[analyzed]):

* spark-sql-Expression-Generator.md[Generator] or `GeneratorOuter` expressions (by spark-sql-Analyzer.md#ExtractGenerator[ExtractGenerator] logical evaluation rule)

* SQL's spark-sql-AstBuilder.md#withGenerate[LATERAL VIEW] clause (in `SELECT` or `FROM` clauses)

[[resolved]]
`resolved` flag is...FIXME

NOTE: `resolved` is part of spark-sql-LogicalPlan.md#resolved[LogicalPlan Contract] to...FIXME.

[[producedAttributes]]
`producedAttributes`...FIXME

[[output]]
The catalyst/QueryPlan.md#output[output schema] of a `Generate` is...FIXME

!!! note
  `Generate` logical operator is resolved to spark-sql-SparkPlan-GenerateExec.md[GenerateExec] unary physical operator in [BasicOperators](../execution-planning-strategies/BasicOperators.md#Generate) execution planning strategy.

[TIP]
====
Use `generate` operator from spark-sql-catalyst-dsl.md[Catalyst DSL] to create a `Generate` logical operator, e.g. for testing or Spark SQL internals exploration.

[source, scala]
----
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
----
====

=== [[creating-instance]] Creating Generate Instance

`Generate` takes the following when created:

* [[generator]] spark-sql-Expression-Generator.md[Generator] expression
* [[join]] `join` flag...FIXME
* [[outer]] `outer` flag...FIXME
* [[qualifier]] Optional qualifier
* [[generatorOutput]] Output spark-sql-Expression-Attribute.md[attributes]
* [[child]] Child spark-sql-LogicalPlan.md[logical plan]

`Generate` initializes the <<internal-registries, internal registries and counters>>.
