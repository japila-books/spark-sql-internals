# QueryPlan &mdash; Structured Query Plan

`QueryPlan` is an [extension](#contract) of the [TreeNode](TreeNode.md) abstraction for [query plans](#implementations) in [Catalyst Framework](index.md).

`QueryPlan` is used to build a tree of relational operators of a structured query.
`QueryPlan` is a tree of (logical or physical) operators that have a tree of expressions.

`QueryPlan` has an [output attributes](#output), [expressions](../expressions/Expression.md) and a [schema](#schema).

`QueryPlan` has [statePrefix](#statePrefix) that is used when displaying a plan with `!` to indicate an invalid plan, and `'` to indicate an unresolved plan.

A `QueryPlan` is **invalid** if there are [missing input attributes](#missingInput) and `children` subnodes are non-empty.

A `QueryPlan` is **unresolved** if the column names have not been verified and column types have not been looked up in the [Catalog](../spark-sql-Catalog.md).

## Contract

### <span id="output"> Output Attributes

```scala
output: Seq[Attribute]
```

Output [attribute](../expressions/Attribute.md) expressions

```text
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
```

!!! tip
    You can build a [StructType](../spark-sql-StructType.md) from `output` collection of attributes using `toStructType` method (that is available through the implicit class `AttributeSeq`).

    ```text
    scala> q.queryExecution.analyzed.output.toStructType
    res5: org.apache.spark.sql.types.StructType = StructType(StructField(id,LongType,false))
    ```

## Implementations

* <span id="AnalysisHelper"> AnalysisHelper
* <span id="LogicalPlan"> [LogicalPlan](../logical-operators/LogicalPlan.md)
* <span id="SparkPlan"> [SparkPlan](../physical-operators/SparkPlan.md)

## <span id="expressions"> Expressions

```scala
expressions: Seq[Expression]
```

`expressions` is all of the [expressions](../expressions/Expression.md) present in this query plan operator.

## <span id="references"> references AttributeSet

```scala
references: AttributeSet
```

`references` is a `AttributeSet` of all attributes that appear in [expressions](#expressions) of this operator.

## <span id="transformExpressions"> Transforming Expressions

```scala
transformExpressions(
  rule: PartialFunction[Expression, Expression]): this.type
```

`transformExpressions` executes [transformExpressionsDown](#transformExpressionsDown) with the input rule.

`transformExpressions` is used when...FIXME

## <span id="transformExpressionsDown"> Transforming Expressions (Down The Tree)

```scala
transformExpressionsDown(
  rule: PartialFunction[Expression, Expression]): this.type
```

`transformExpressionsDown` [applies the given rule](#mapExpressions) to each expression in the query operator.

`transformExpressionsDown` is used when...FIXME

## <span id="outputSet"> Output Schema Attribute Set

```scala
outputSet: AttributeSet
```

`outputSet` simply returns an `AttributeSet` for the [output attributes](#output).

`outputSet` is used when...FIXME

## <span id="missingInput"> Missing Input Attributes

```scala
missingInput: AttributeSet
```

`missingInput` are [attributes](../expressions/Attribute.md) that are referenced in expressions but not provided by this node's children (as `inputSet`) and are not produced by this node (as `producedAttributes`).

## <span id="schema"> Output Schema

You can request the schema of a `QueryPlan` using `schema` that builds [StructType](../spark-sql-StructType.md) from the [output attributes](#output).

```text
// the query
val dataset = spark.range(3)

scala> dataset.queryExecution.analyzed.schema
res6: org.apache.spark.sql.types.StructType = StructType(StructField(id,LongType,false))
```

## <span id="simpleString"> Simple (Basic) Description with State Prefix

```scala
simpleString: String
```

`simpleString` adds a [state prefix](#statePrefix) to the node's [simple text description](TreeNode.md#simpleString).

`simpleString` is part of the [TreeNode](TreeNode.md#simpleString) abstraction.

## <span id="statePrefix"> State Prefix

```scala
statePrefix: String
```

Internally, `statePrefix` gives `!` (exclamation mark) when the node is invalid, i.e. [missingInput](#missingInput) is not empty, and the node is a [parent node](TreeNode.md#children). Otherwise, `statePrefix` gives an empty string.

`statePrefix` is used when `QueryPlan` is requested for the [simple text node description](#simpleString).

## <span id="verboseString"> Simple (Basic) Description with State Prefix

```scala
verboseString: String
```

`verboseString` simply returns the [simple (basic) description with state prefix](#simpleString).

`verboseString` is part of the [TreeNode](TreeNode.md#verboseString) abstraction.

## <span id="innerChildren"> innerChildren

```scala
innerChildren: Seq[QueryPlan[_]]
```

`innerChildren` simply returns the [subqueries](#subqueries).

`innerChildren` is part of the [TreeNode](TreeNode.md#innerChildren) abstraction.

## <span id="subqueries"> subqueries

```scala
subqueries: Seq[PlanType]
```

`subqueries`...FIXME

`subqueries` is used when...FIXME
