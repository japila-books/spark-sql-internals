# SerializeFromObjectExec Unary Physical Operator

`SerializeFromObjectExec` is a [unary physical operator](UnaryExecNode.md) that supports [Java code generation](CodegenSupport.md).

`SerializeFromObjectExec` supports Java code generation with the <<doProduce, doProduce>>, <<doConsume, doConsume>> and <<inputRDDs, inputRDDs>> methods.

`SerializeFromObjectExec` is a <<spark-sql-ObjectConsumerExec.md#, ObjectConsumerExec>>.

`SerializeFromObjectExec` is <<creating-instance, created>> exclusively when [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed.

[[inputRDDs]]
[[outputPartitioning]]
`SerializeFromObjectExec` uses the <<child, child>> physical operator when requested for the [input RDDs](CodegenSupport.md#inputRDDs) and the <<SparkPlan.md#outputPartitioning, outputPartitioning>>.

[[output]]
`SerializeFromObjectExec` uses the <<serializer, serializer>> for the <<catalyst/QueryPlan.md#output, output schema attributes>>.

=== [[creating-instance]] Creating SerializeFromObjectExec Instance

`SerializeFromObjectExec` takes the following when created:

* [[serializer]] Serializer (as `Seq[NamedExpression]`)
* [[child]] Child <<SparkPlan.md#, physical operator>> (that supports [Java code generation](CodegenSupport.md))

=== [[doConsume]] Generating Java Source Code for Consume Path in Whole-Stage Code Generation -- `doConsume` Method

[source, scala]
----
doConsume(ctx: CodegenContext, input: Seq[ExprCode], row: ExprCode): String
----

`doConsume`...FIXME

`doConsume` is part of the [CodegenSupport](CodegenSupport.md#doConsume) abstraction.

=== [[doProduce]] Generating Java Source Code for Produce Path in Whole-Stage Code Generation -- `doProduce` Method

[source, scala]
----
doProduce(ctx: CodegenContext): String
----

`doProduce`...FIXME

`doProduce` is part of the [CodegenSupport](CodegenSupport.md#doProduce) abstraction.

=== [[doExecute]] Executing Physical Operator (Generating RDD[InternalRow]) -- `doExecute` Method

[source, scala]
----
doExecute(): RDD[InternalRow]
----

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute` requests the <<child, child>> physical operator to <<SparkPlan.md#execute, execute>> (that triggers physical query planning and generates an `RDD[InternalRow]`) and transforms it by executing the following function on internal rows per partition with index (using `RDD.mapPartitionsWithIndexInternal` that creates another RDD):

. Creates an [UnsafeProjection](../expressions/UnsafeProjection.md#create) for the <<serializer, serializer>>

. Requests the `UnsafeProjection` to [initialize](../expressions/Projection.md#initialize) (for the partition index)

. Executes the `UnsafeProjection` on all internal binary rows in the partition

NOTE: `doExecute` (by `RDD.mapPartitionsWithIndexInternal`) adds a new `MapPartitionsRDD` to the RDD lineage. Use `RDD.toDebugString` to see the additional `MapPartitionsRDD`.
