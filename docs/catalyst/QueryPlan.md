# QueryPlan -- Structured Query Plan

`QueryPlan` is part of [Catalyst](index.md) to build a [tree of relational operators](TreeNode.md) of a structured query.

Scala-specific, `QueryPlan` is an abstract class that is the base class of link:spark-sql-LogicalPlan.adoc[LogicalPlan] and link:SparkPlan.md[SparkPlan] (for logical and physical plans, respectively).

A `QueryPlan` has an <<output, output>> attributes (that serves as the base for the schema), a collection of link:expressions/Expression.md[expressions] and a <<schema, schema>>.

`QueryPlan` has <<statePrefix, statePrefix>> that is used when displaying a plan with `!` to indicate an invalid plan, and `'` to indicate an unresolved plan.

A `QueryPlan` is *invalid* if there are <<missingInput, missing input attributes>> and `children` subnodes are non-empty.

A `QueryPlan` is *unresolved* if the column names have not been verified and column types have not been looked up in the link:spark-sql-Catalog.adoc[Catalog].

[[expressions]]
A `QueryPlan` has zero, one or more link:expressions/Expression.md[Catalyst expressions].

NOTE: `QueryPlan` is a tree of operators that have a tree of expressions.

[[references]]
`QueryPlan` has `references` property that is the attributes that appear in <<expressions, expressions>> from this operator.

=== [[contract]] QueryPlan Contract

[source, scala]
----
abstract class QueryPlan[T] extends TreeNode[T] {
  def output: Seq[Attribute]
  def validConstraints: Set[Expression]
  // FIXME
}
----

.QueryPlan Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| [[validConstraints]] `validConstraints`
|

| <<output, output>>
| link:spark-sql-Expression-Attribute.adoc[Attribute] expressions
|===

=== [[transformExpressions]] Transforming Expressions -- `transformExpressions` Method

[source, scala]
----
transformExpressions(rule: PartialFunction[Expression, Expression]): this.type
----

`transformExpressions` simply executes <<transformExpressionsDown, transformExpressionsDown>> with the input rule.

NOTE: `transformExpressions` is used when...FIXME

=== [[transformExpressionsDown]] Transforming Expressions -- `transformExpressionsDown` Method

[source, scala]
----
transformExpressionsDown(rule: PartialFunction[Expression, Expression]): this.type
----

`transformExpressionsDown` <<mapExpressions, applies the rule>> to each expression in the query operator.

NOTE: `transformExpressionsDown` is used when...FIXME

=== [[mapExpressions]] Applying Transformation Function to Each Expression in Query Operator -- `mapExpressions` Method

[source, scala]
----
mapExpressions(f: Expression => Expression): this.type
----

`mapExpressions`...FIXME

NOTE: `mapExpressions` is used when...FIXME

=== [[outputSet]] Output Schema Attribute Set -- `outputSet` Property

[source, scala]
----
outputSet: AttributeSet
----

`outputSet` simply returns an `AttributeSet` for the <<output, output schema attributes>>.

NOTE: `outputSet` is used when...FIXME

=== [[producedAttributes]] `producedAttributes` Property

CAUTION: FIXME

=== [[missingInput]] Missing Input Attributes -- `missingInput` Property

[source, scala]
----
def missingInput: AttributeSet
----

`missingInput` are link:spark-sql-Expression-Attribute.adoc[attributes] that are referenced in expressions but not provided by this node's children (as `inputSet`) and are not produced by this node (as `producedAttributes`).

=== [[schema]] Output Schema -- `schema` Property

You can request the schema of a `QueryPlan` using `schema` that builds link:spark-sql-StructType.adoc[StructType] from the <<output, output attributes>>.

[source, scala]
----
// the query
val dataset = spark.range(3)

scala> dataset.queryExecution.analyzed.schema
res6: org.apache.spark.sql.types.StructType = StructType(StructField(id,LongType,false))
----

=== [[output]] Output Schema Attributes -- `output` Property

[source, scala]
----
output: Seq[Attribute]
----

`output` is a collection of link:spark-sql-Expression-Attribute.adoc[Catalyst attribute expressions] that represent the result of a projection in a query that is later used to build the output link:spark-sql-schema.adoc[schema].

NOTE: `output` property is also called *output schema* or *result schema*.

[source, scala]
----
val q = spark.range(3)

scala> q.queryExecution.analyzed.output
res0: Seq[org.apache.spark.sql.catalyst.expressions.Attribute] = List(id#0L)

scala> q.queryExecution.withCachedData.output
res1: Seq[org.apache.spark.sql.catalyst.expressions.Attribute] = List(id#0L)

scala> q.queryExecution.optimizedPlan.output
res2: Seq[org.apache.spark.sql.catalyst.expressions.Attribute] = List(id#0L)

scala> q.queryExecution.sparkPlan.output
res3: Seq[org.apache.spark.sql.catalyst.expressions.Attribute] = List(id#0L)

scala> q.queryExecution.executedPlan.output
res4: Seq[org.apache.spark.sql.catalyst.expressions.Attribute] = List(id#0L)
----

[TIP]
====
You can build a link:spark-sql-StructType.adoc[StructType] from `output` collection of attributes using `toStructType` method (that is available through the implicit class `AttributeSeq`).

[source, scala]
----
scala> q.queryExecution.analyzed.output.toStructType
res5: org.apache.spark.sql.types.StructType = StructType(StructField(id,LongType,false))
----
====

## <span id="simpleString"> Simple (Basic) Description with State Prefix

```scala
simpleString: String
```

`simpleString` adds a <<statePrefix, state prefix>> to the node's [simple text description](TreeNode.md#simpleString).

`simpleString` is part of the [TreeNode](TreeNode.md#simpleString) abstraction.

=== [[statePrefix]] State Prefix -- `statePrefix` Method

[source, scala]
----
statePrefix: String
----

Internally, `statePrefix` gives `!` (exclamation mark) when the node is invalid, i.e. <<missingInput, missingInput>> is not empty, and the node is a [parent node](TreeNode.md#children). Otherwise, `statePrefix` gives an empty string.

NOTE: `statePrefix` is used exclusively when `QueryPlan` is requested for the <<simpleString, simple text node description>>.

=== [[transformAllExpressions]] Transforming All Expressions -- `transformAllExpressions` Method

[source, scala]
----
transformAllExpressions(rule: PartialFunction[Expression, Expression]): this.type
----

`transformAllExpressions`...FIXME

NOTE: `transformAllExpressions` is used when...FIXME

## <span id="verboseString"> Simple (Basic) Description with State Prefix

```scala
verboseString: String
```

`verboseString` simply returns the <<simpleString, simple (basic) description with state prefix>>.

`verboseString` is part of the [TreeNode](TreeNode.md#verboseString) abstraction.

## <span id="innerChildren"> innerChildren

```scala
innerChildren: Seq[QueryPlan[_]]
```

`innerChildren` simply returns the <<subqueries, subqueries>>.

`innerChildren` is part of the [TreeNode](TreeNode.md#innerChildren) abstraction.

=== [[subqueries]] `subqueries` Method

[source, scala]
----
subqueries: Seq[PlanType]
----

`subqueries`...FIXME

NOTE: `subqueries` is used when...FIXME

=== [[doCanonicalize]] Canonicalizing Query Plan -- `doCanonicalize` Method

[source, scala]
----
doCanonicalize(): PlanType
----

`doCanonicalize`...FIXME

NOTE: `doCanonicalize` is used when...FIXME
