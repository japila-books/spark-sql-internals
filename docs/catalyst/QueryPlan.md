# QueryPlan &mdash; Structured Query Plan

`QueryPlan` is an [extension](#contract) of the [TreeNode](TreeNode.md) abstraction for [query plans](#implementations) in [Catalyst Framework](index.md).

`QueryPlan` is used to build a tree of relational operators of a structured query.
`QueryPlan` is a tree of (logical or physical) operators that have a tree of expressions.

`QueryPlan` has an [output attributes](#output), [expressions](../expressions/Expression.md) and a [schema](#schema).

`QueryPlan` has [statePrefix](#statePrefix) that is used when displaying a plan with `!` to indicate an invalid plan, and `'` to indicate an unresolved plan.

A `QueryPlan` is **invalid** if there are [missing input attributes](#missingInput) and `children` subnodes are non-empty.

A `QueryPlan` is **unresolved** if the column names have not been verified and column types have not been looked up in the [Catalog](../Catalog.md).

## Contract

### <span id="output"> Output (Schema) Attributes

```scala
output: Seq[Attribute]
```

Output [Attribute](../expressions/Attribute.md)s

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
    You can build a [StructType](../types/StructType.md) from `output` attributes using [toStructType](../expressions/AttributeSeq.md#toStructType).

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

## <span id="references"> Expression References

```scala
references: AttributeSet
```

??? note "Lazy Value"
    `references` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`references` is an `AttributeSet` of all the [Attribute](../expressions/Attribute.md)s that are referenced by the [expressions](#expressions) of this operator (except the [produced attributes](#producedAttributes)).

---

`references` is used when:

* `QueryPlan` is requested for the [missing input attributes](#missingInput), to [transformUpWithNewOutput](#transformUpWithNewOutput)
* `CodegenSupport` is requested for the [used input attributes](../physical-operators/CodegenSupport.md#usedInputs)
* _others_ (less interesting?)

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

You can request the schema of a `QueryPlan` using `schema` that builds [StructType](../types/StructType.md) from the [output attributes](#output).

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

## <span id="simpleStringWithNodeId"> simpleStringWithNodeId

```scala
simpleStringWithNodeId(): String
```

`simpleStringWithNodeId` is part of the [TreeNode](TreeNode.md#simpleStringWithNodeId) abstraction.

`simpleStringWithNodeId` [finds the operatorId tag](TreeNode.md#getTagValue) or defaults to `unknown`.

`simpleStringWithNodeId` uses the [nodeName](TreeNode.md#nodeName) to return the following text:

```text
[nodeName] ([operatorId])
```

## <span id="append"> append

```scala
append[T <: QueryPlan[T]](
  plan: => QueryPlan[T],
  append: String => Unit,
  verbose: Boolean,
  addSuffix: Boolean,
  maxFields: Int = SQLConf.get.maxToStringFields,
  printOperatorId: Boolean = false): Unit
```

`append`...FIXME

`append` is used when:

* `QueryExecution` is requested to [simpleString](../QueryExecution.md#simpleString), [writePlans](../QueryExecution.md#writePlans) and [stringWithStats](../QueryExecution.md#stringWithStats)
* `ExplainUtils` utility is requested to `processPlanSkippingSubqueries`

## <span id="verboseStringWithOperatorId"> Detailed Description (with Operator Id)

```scala
verboseStringWithOperatorId(): String
```

`verboseStringWithOperatorId` returns the following text (with [spark.sql.debug.maxToStringFields](../configuration-properties.md#spark.sql.debug.maxToStringFields) configuration property for the number of arguments to this node, if there are any, and the [formatted node name](#formattedNodeName)):

```text
[formattedNodeName]
Arguments: [argumentString]
```

`verboseStringWithOperatorId` is used when:

* `QueryExecution` is requested for [simple description](../QueryExecution.md#simpleString) (and `ExplainUtils` utility is requested to `processPlanSkippingSubqueries`)

## <span id="formattedNodeName"> Formatted Node Name

```scala
formattedNodeName: String
```

`formattedNodeName`...FIXME

`formattedNodeName` is used when:

* `QueryPlan` is requested for [verboseStringWithOperatorId](#verboseStringWithOperatorId)

## <span id="transformAllExpressionsWithPruning"> transformAllExpressionsWithPruning

```scala
transformAllExpressionsWithPruning(
  cond: TreePatternBits => Boolean,
  ruleId: RuleId = UnknownRuleId)(
  rule: PartialFunction[Expression, Expression]): this.type
```

`transformAllExpressionsWithPruning`...FIXME

---

`transformAllExpressionsWithPruning` is used when:

* `QueryPlan` is requested for [transformAllExpressions](#transformAllExpressions) and [normalizeExpressions](#normalizeExpressions)
* `AnalysisHelper` is requested to `transformAllExpressionsWithPruning`
* `PlanSubqueries` physical optimization is [executed](../physical-optimizations/PlanSubqueries.md#apply)
* `PlanDynamicPruningFilters` physical optimization is [executed](../physical-optimizations/PlanDynamicPruningFilters.md#apply)
* `PlanAdaptiveDynamicPruningFilters` physical optimization is [executed](../physical-optimizations/PlanAdaptiveDynamicPruningFilters.md#apply)
* `PlanAdaptiveSubqueries` physical optimization is [executed](../physical-optimizations/PlanAdaptiveSubqueries.md#apply)
* `ReuseAdaptiveSubquery` physical optimization is [executed](../physical-optimizations/ReuseAdaptiveSubquery.md#apply)

## <span id="producedAttributes"> Produced Attributes

```scala
producedAttributes: AttributeSet
```

`producedAttributes` is empty (and can be overriden by [implementations](#implementations)).

---

`producedAttributes` is used when:

* `NestedColumnAliasing` is requested to `unapply` (destructure a logical operator)
* `QueryPlan` is requested for the [references](#references)
