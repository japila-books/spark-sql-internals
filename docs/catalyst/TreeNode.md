# TreeNode &mdash; Node in Catalyst Tree

`TreeNode` is an [abstraction](#contract) of [named nodes](#implementations) in [Catalyst](index.md) with zero, one or more [children](#children).

## Contract

### <span id="children"> children

```scala
children: Seq[BaseType]
```

Zero, one or more **child nodes** of the node

### <span id="simpleStringWithNodeId"> simpleStringWithNodeId

```scala
simpleStringWithNodeId(): String
```

One-line description of this node with the node identifier

Used when:

* `TreeNode` is requested to [generateTreeString](#generateTreeString) (with node ID)

### <span id="verboseString"> verboseString

```scala
verboseString(
  maxFields: Int): String
```

One-line **verbose description**

Used when `TreeNode` is requested to [verboseStringWithSuffix](#verboseStringWithSuffix) and [generateTreeString](#generateTreeString) (with `verbose` flag enabled)

## Implementations

* <span id="Block"> Block
* <span id="Expression"> [Expression](../expressions/Expression.md)
* <span id="QueryPlan"> [QueryPlan](../catalyst/QueryPlan.md)

## <span id="simpleString"> Simple Node Description

```scala
simpleString: String
```

`simpleString` gives a simple one-line description of a `TreeNode`.

Internally, `simpleString` is the <<nodeName, nodeName>> followed by <<argString, argString>> separated by a single white space.

`simpleString` is used when `TreeNode` is requested for <<argString, argString>> (of child nodes) and <<generateTreeString, tree text representation>> (with `verbose` flag off).

## <span id="numberedTreeString"> Numbered Text Representation

```scala
numberedTreeString: String
```

`numberedTreeString` adds numbers to the <<treeString, text representation of all the nodes>>.

`numberedTreeString` is used primarily for interactive debugging using <<apply, apply>> and <<p, p>> methods.

## <span id="apply"> Getting n-th TreeNode in Tree (for Interactive Debugging)

```scala
apply(
  number: Int): TreeNode[_]
```

`apply` gives `number`-th tree node in a tree.

`apply` can be used for interactive debugging.

Internally, `apply` <<getNodeNumbered, gets the node>> at `number` position or `null`.

## <span id="p"> Getting n-th BaseType in Tree (for Interactive Debugging)

```scala
p(
  number: Int): BaseType
```

`p` gives `number`-th tree node in a tree as `BaseType` for interactive debugging.

!!! note
    `p` can be used for interactive debugging.

`BaseType` is the base type of a tree and in Spark SQL can be:

* [LogicalPlan](../logical-operators/LogicalPlan.md) for logical plan trees

* [SparkPlan](../physical-operators/SparkPlan.md) for physical plan trees

* [Expression](../expressions/Expression.md) for expression trees

## <span id="toString"> Text Representation

```scala
toString: String
```

`toString` simply returns the <<treeString, text representation of all nodes in the tree>>.

`toString` is part of Java's [java.lang.Object](https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html#toString--) for the string representation of an object, e.g. `TreeNode`.

## <span id="treeString"> Text Representation of All Nodes in Tree

```scala
treeString: String // (1)
treeString(
  verbose: Boolean,
  addSuffix: Boolean = false,
  maxFields: Int = SQLConf.get.maxToStringFields,
  printOperatorId: Boolean = false): String
treeString(
  append: String => Unit,
  verbose: Boolean,
  addSuffix: Boolean,
  maxFields: Int,
  printOperatorId: Boolean): Unit
```

1. `verbose` flag is enabled (`true`)

`treeString` gives the string representation of all the nodes in the `TreeNode`.

`printOperatorId` argument is `false` by default and seems turned on only when:

* `ExplainUtils` utility is used to `processPlanSkippingSubqueries`

### <span id="treeString-demo"> Demo

```text
import org.apache.spark.sql.{functions => f}
val q = spark.range(10).withColumn("rand", f.rand())
val executedPlan = q.queryExecution.executedPlan

val output = executedPlan.treeString(verbose = true)

scala> println(output)
*(1) Project [id#0L, rand(6790207094253656854) AS rand#2]
+- *(1) Range (0, 10, step=1, splits=8)
```

## <span id="verboseStringWithSuffix"> Verbose Description with Suffix

```scala
verboseStringWithSuffix: String
```

`verboseStringWithSuffix` simply returns <<verboseString, verbose description>>.

`verboseStringWithSuffix` is used when `TreeNode` is requested to <<generateTreeString, generateTreeString>> (with `verbose` and `addSuffix` flags enabled).

## <span id="generateTreeString"> Text Representation

```scala
generateTreeString(
  depth: Int,
  lastChildren: Seq[Boolean],
  append: String => Unit,
  verbose: Boolean,
  prefix: String = "",
  addSuffix: Boolean = false,
  maxFields: Int,
  printNodeId: Boolean,
  indent: Int = 0): Unit
```

`generateTreeString`...FIXME

`generateTreeString` is used when:

* `TreeNode` is requested for [text representation of all nodes in the tree](#treeString)
* [BaseSubqueryExec](../physical-operators/BaseSubqueryExec.md#generateTreeString), [InputAdapter](../physical-operators/InputAdapter.md#generateTreeString), [WholeStageCodegenExec](../physical-operators/WholeStageCodegenExec.md#generateTreeString), [AdaptiveSparkPlanExec](../adaptive-query-execution/AdaptiveSparkPlanExec.md#generateTreeString), [QueryStageExec](../adaptive-query-execution/QueryStageExec.md#generateTreeString) physical operators are requested to `generateTreeString`

## <span id="innerChildren"> Inner Child Nodes

```scala
innerChildren: Seq[TreeNode[_]]
```

`innerChildren` returns the inner nodes that should be shown as an inner nested tree of this node.

`innerChildren` simply returns an empty collection of `TreeNodes`.

`innerChildren` is used when `TreeNode` is requested to <<generateTreeString, generate the text representation of inner and regular child nodes>>, <<allChildren, allChildren>> and <<getNodeNumbered, getNodeNumbered>>.

## <span id="allChildren"> allChildren

```scala
allChildren: Set[TreeNode[_]]
```

NOTE: `allChildren` is a Scala lazy value which is computed once when accessed and cached afterwards.

`allChildren`...FIXME

`allChildren` is used when...FIXME

## <span id="foreach"> foreach

```scala
foreach(f: BaseType => Unit): Unit
```

`foreach` applies the input function `f` to itself (`this`) first and then (recursively) to the <<children, children>>.

## <span id="nodeName"> Node Name

```scala
nodeName: String
```

`nodeName` returns the name of the class with `Exec` suffix removed (that is used as a naming convention for the class name of [physical operators](../physical-operators/SparkPlan.md)).

`nodeName` is used when:

* `TreeNode` is requested for [simpleString](#simpleString) and [asCode](#asCode)

## Scala Definition

```scala
abstract class TreeNode[BaseType <: TreeNode[BaseType]] extends Product {
  self: BaseType =>
  // ...
}
```

`TreeNode` is a recursive data structure that can have one or many <<children, children>> that are again `TreeNodes`.

!!! tip
    Read up on `<:` type operator in Scala in [Upper Type Bounds](https://docs.scala-lang.org/tour/upper-type-bounds.html).

Scala-specific, `TreeNode` is an abstract class that is the <<implementations, base class>> of Catalyst <<expressions/Expression.md#, Expression>> and <<catalyst/QueryPlan.md#, QueryPlan>> abstract classes.

`TreeNode` therefore allows for building entire trees of `TreeNodes`, e.g. generic <<catalyst/QueryPlan.md#, query plans>> with concrete <<spark-sql-LogicalPlan.md#, logical>> and [physical](../physical-operators/SparkPlan.md) operators that both use <<expressions/Expression.md#, Catalyst expressions>> (which are `TreeNodes` again).

NOTE: Spark SQL uses `TreeNode` for <<catalyst/QueryPlan.md#, query plans>> and <<expressions/Expression.md#, Catalyst expressions>> that can further be used together to build more advanced trees, e.g. Catalyst expressions can have query plans as <<spark-sql-subqueries.md#, subquery expressions>>.

`TreeNode` can itself be a node in a tree or a collection of nodes, i.e. itself and the <<children, children>> nodes. Not only does `TreeNode` come with the <<methods, methods>> that you may have used in https://docs.scala-lang.org/overviews/collections/overview.html[Scala Collection API] (e.g. <<map, map>>, <<flatMap, flatMap>>, <<collect, collect>>, <<collectFirst, collectFirst>>, <<foreach, foreach>>), but also specialized ones for more advanced tree manipulation, e.g. <<mapChildren, mapChildren>>, <<transform, transform>>, <<transformDown, transformDown>>, <<transformUp, transformUp>>, <<foreachUp, foreachUp>>, <<numberedTreeString, numberedTreeString>>, <<p, p>>, <<asCode, asCode>>, <<prettyJson, prettyJson>>.

`TreeNode` abstract type is a fairly advanced Scala type definition (at least comparing to the other Scala types in Spark) so understanding its behaviour even outside Spark might be worthwhile by itself.

## <span id="treePatternBits"> treePatternBits

```scala
treePatternBits: BitSet
```

`treePatternBits` [getDefaultTreePatternBits](#getDefaultTreePatternBits).

??? note "Lazy Value"
    `treePatternBits` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

`treePatternBits` is part of the [TreePatternBits](TreePatternBits.md#treePatternBits) abstraction.

## <span id="getDefaultTreePatternBits"> getDefaultTreePatternBits

```scala
getDefaultTreePatternBits: BitSet
```

`getDefaultTreePatternBits`...FIXME

`getDefaultTreePatternBits` is used when:

* `PlanExpression` is requested for the [treePatternBits](../expressions/PlanExpression.md#treePatternBits)
* `QueryPlan` is requested for the [treePatternBits](QueryPlan.md#treePatternBits)
* `TreeNode` is requested for the [treePatternBits](#treePatternBits)

### <span id="nodePatterns"> Node Patterns

```scala
nodePatterns: Seq[TreePattern]
```

`nodePatterns` is empty by default (and is supposed to be overriden by the [implementations](#implementations)).

## <span id="tags"> Tags

```scala
tags: Map[TreeNodeTag[_], Any]
```

`TreeNode` can have a metadata assigned (as a mutable map of tags and their values).

`tags` can be [set](#setTagValue), [unset](#unsetTagValue) and [looked up](#getTagValue).

`tags` are [copied](#copyTagsFrom) (from another `TreeNode`) only when a `TreeNode` has none defined.

### <span id="copyTagsFrom"> Copying Tags

```scala
copyTagsFrom(
  other: BaseType): Unit
```

`copyTagsFrom` is used when:

* `ResolveRelations` logical resolution rule is requested to [lookupRelation](../logical-analysis-rules/ResolveRelations.md#lookupRelation)
* `ResolveReferences` logical resolution rule is requested to [collectConflictPlans](../logical-analysis-rules/ResolveReferences.md#collectConflictPlans)
* `OneRowRelation` leaf logical operator is requested to [makeCopy](../logical-operators/OneRowRelation.md#makeCopy)
* `TreeNode` is requested to [transformDown](#transformDown), [transformUp](#transformUp) and [makeCopy](#makeCopy)

### <span id="getTagValue"> Looking Up Tag

```scala
getTagValue[T](
  tag: TreeNodeTag[T]): Option[T]
```

### <span id="setTagValue"> Setting Tag

```scala
setTagValue[T](
  tag: TreeNodeTag[T], value: T): Unit
```

### <span id="unsetTagValue"> Unsetting Tag

```scala
unsetTagValue[T](
  tag: TreeNodeTag[T]): Unit
```

`unsetTagValue` is used when:

* `ExplainUtils` utility is used to `removeTags`
* `AdaptiveSparkPlanExec` leaf physical operator is requested to [cleanUpTempTags](../adaptive-query-execution/AdaptiveSparkPlanExec.md#cleanUpTempTags)
