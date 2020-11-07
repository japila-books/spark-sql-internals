# FilterExec Unary Physical Operator

`FilterExec` is a [unary physical operator](UnaryExecNode.md) that represents [Filter](../logical-operators/Filter.md) and [TypedFilter](../logical-operators/TypedFilter.md) unary logical operators at execution time.

`FilterExec` supports [Java code generation](CodegenSupport.md) (aka _codegen_) as follows:

* <<usedInputs, usedInputs>> is an empty `AttributeSet` (to defer evaluation of attribute expressions until they are actually used, i.e. in the [generated Java source code for consume path](CodegenSupport.md#consume))

* Uses whatever the <<child, child>> physical operator uses for the [input RDDs](CodegenSupport.md#inputRDDs)

* Generates a Java source code for the <<doProduce, produce>> and <<doConsume, consume>> paths in whole-stage code generation

`FilterExec` is <<creating-instance, created>> when:

* [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed (and plans [Filter](../execution-planning-strategies/BasicOperators.md#Filter) and [TypedFilter](../execution-planning-strategies/BasicOperators.md#TypedFilter) unary logical operators

* hive/HiveTableScans.md[HiveTableScans] execution planning strategy is executed (and plans hive/HiveTableRelation.md[HiveTableRelation] leaf logical operators and requests `SparkPlanner` to [pruneFilterProject](../SparkPlanner.md#pruneFilterProject))

* [InMemoryScans](../execution-planning-strategies/InMemoryScans.md) execution planning strategy is executed (and plans [InMemoryRelation](../logical-operators/InMemoryRelation.md) leaf logical operators and requests `SparkPlanner` to [pruneFilterProject](../SparkPlanner.md#pruneFilterProject))

* `DataSourceStrategy` execution planning strategy is requested to [create a RowDataSourceScanExec physical operator (possibly under FilterExec and ProjectExec operators)](../execution-planning-strategies/DataSourceStrategy.md#pruneFilterProjectRaw)

* [FileSourceStrategy](../execution-planning-strategies/FileSourceStrategy.md) execution planning strategy is executed (on <<LogicalRelation.md#, LogicalRelations>> with a [HadoopFsRelation](../HadoopFsRelation.md))

* [ExtractPythonUDFs](../physical-optimizations/ExtractPythonUDFs.md) physical optimization is executed

## <span id="metrics"> Performance Metrics

[cols="1,2,2",options="header",width="100%"]
|===
| Key
| Name (in web UI)
| Description

| `numOutputRows`
| number of output rows
| [[numOutputRows]]
|===

.FilterExec in web UI (Details for Query)
image::images/spark-sql-FilterExec-webui-details-for-query.png[align="center"]

[[inputRDDs]]
[[outputOrdering]]
[[outputPartitioning]]
`FilterExec` uses whatever the <<child, child>> physical operator uses for the [input RDDs](CodegenSupport.md#inputRDDs), the [outputOrdering](SparkPlan.md#outputOrdering) and the [outputPartitioning](SparkPlan.md#outputPartitioning).

`FilterExec` uses the spark-sql-PredicateHelper.md[PredicateHelper] for...FIXME

[[internal-registries]]
.FilterExec's Internal Properties (e.g. Registries, Counters and Flags)
[cols="1,2",options="header",width="100%"]
|===
| Name
| Description

| `notNullAttributes`
| [[notNullAttributes]] FIXME

Used when...FIXME

| `notNullPreds`
| [[notNullPreds]] FIXME

Used when...FIXME

| `otherPreds`
| [[otherPreds]] FIXME

Used when...FIXME
|===

=== [[creating-instance]] Creating FilterExec Instance

`FilterExec` takes the following when created:

* [[condition]] <<expressions/Expression.md#, Catalyst expression>> for the filter condition
* [[child]] Child <<SparkPlan.md#, physical operator>>

`FilterExec` initializes the <<internal-registries, internal registries and counters>>.

=== [[isNullIntolerant]] `isNullIntolerant` Internal Method

[source, scala]
----
isNullIntolerant(expr: Expression): Boolean
----

`isNullIntolerant`...FIXME

NOTE: `isNullIntolerant` is used when...FIXME

=== [[doConsume]] Generating Java Source Code for Consume Path in Whole-Stage Code Generation -- `doConsume` Method

[source, scala]
----
doConsume(ctx: CodegenContext, input: Seq[ExprCode], row: ExprCode): String
----

`doConsume` creates a new [metric term](CodegenSupport.md#metricTerm) for the <<numOutputRows, numOutputRows>> metric.

`doConsume`...FIXME

In the end, `doConsume` uses [consume](CodegenSupport.md#consume) and _FIXME_ to generate a Java source code (as a plain text) inside a `do {...} while(false);` code block.

`doConsume` is part of the [CodegenSupport](CodegenSupport.md#doConsume) abstraction.

==== [[doConsume-genPredicate]] `genPredicate` Internal Method

[source, scala]
----
genPredicate(c: Expression, in: Seq[ExprCode], attrs: Seq[Attribute]): String
----

NOTE: `genPredicate` is an internal method of <<doConsume, doConsume>>.

`genPredicate`...FIXME

=== [[doExecute]] Executing Physical Operator (Generating RDD[InternalRow]) -- `doExecute` Method

[source, scala]
----
doExecute(): RDD[InternalRow]
----

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute` executes the <<child, child>> physical operator and creates a new `MapPartitionsRDD` that does the filtering.

[source, scala]
----
// DEMO Show the RDD lineage with the new MapPartitionsRDD after FilterExec
----

Internally, `doExecute` takes the <<numOutputRows, numOutputRows>> metric.

In the end, `doExecute` requests the <<child, child>> physical operator to <<SparkPlan.md#execute, execute>> (that triggers physical query planning and generates an `RDD[InternalRow]`) and transforms it by executing the following function on internal rows per partition with index (using `RDD.mapPartitionsWithIndexInternal` that creates another RDD):

. Creates a partition filter as a new <<SparkPlan.md#newPredicate, GenPredicate>> (for the <<condition, filter condition>> expression and the <<catalyst/QueryPlan.md#output, output schema>> of the <<child, child>> physical operator)

. Requests the generated partition filter `Predicate` to `initialize` (with `0` partition index)

. Filters out elements from the partition iterator (`Iterator[InternalRow]`) by requesting the generated partition filter `Predicate` to evaluate for every `InternalRow`
.. Increments the <<numOutputRows, numOutputRows>> metric for positive evaluations (i.e. that returned `true`)

NOTE: `doExecute` (by `RDD.mapPartitionsWithIndexInternal`) adds a new `MapPartitionsRDD` to the RDD lineage. Use `RDD.toDebugString` to see the additional `MapPartitionsRDD`.
