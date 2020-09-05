title: ProjectExec

# ProjectExec Unary Physical Operator

`ProjectExec` is a [unary physical operator](UnaryExecNode.md) that...FIXME

`ProjectExec` supports [Java code generation](CodegenSupport.md) (aka _codegen_).

`ProjectExec` is <<creating-instance, created>> when:

* [InMemoryScans](../execution-planning-strategies/InMemoryScans.md) and [HiveTableScans](../hive/HiveTableScans.md) execution planning strategies are executed (and request `SparkPlanner` to [pruneFilterProject](../SparkPlanner.md#pruneFilterProject))

* [BasicOperators](../execution-planning-strategies/BasicOperators.md#Project) execution planning strategy is executed

* `DataSourceStrategy` execution planning strategy is requested to [creates a RowDataSourceScanExec](../execution-planning-strategies/DataSourceStrategy.md#pruneFilterProjectRaw)

* `FileSourceStrategy` execution planning strategy is requested to [plan a LogicalRelation with a HadoopFsRelation](../execution-planning-strategies/FileSourceStrategy.md#apply)

* [ExtractPythonUDFs](../physical-optimizations/ExtractPythonUDFs.md) physical optimization is executed

!!! note
    The following is the order of applying the above execution planning strategies to logical query plans when `SparkPlanner` or hive/HiveSessionStateBuilder.md#planner[Hive-specific SparkPlanner] are requested to catalyst/QueryPlanner.md#plan[plan a logical query plan into one or more physical query plans]:

    1. [HiveTableScans](../hive/HiveTableScans.md)
    1. [FileSourceStrategy](../execution-planning-strategies/FileSourceStrategy.md)
    1. [DataSourceStrategy](../execution-planning-strategies/DataSourceStrategy.md)
    1. [InMemoryScans](../execution-planning-strategies/InMemoryScans.md)
    1. [BasicOperators](../execution-planning-strategies/BasicOperators.md)

=== [[doExecute]] Executing Physical Operator (Generating RDD[InternalRow]) -- `doExecute` Method

[source, scala]
----
doExecute(): RDD[InternalRow]
----

NOTE: `doExecute` is part of <<SparkPlan.md#doExecute, SparkPlan Contract>> to generate the runtime representation of a structured query as a distributed computation over <<spark-sql-InternalRow.md#, internal binary rows>> on Apache Spark (i.e. `RDD[InternalRow]`).

`doExecute` requests the input <<child, child physical plan>> to SparkPlan.md#execute[produce an RDD of internal rows] and applies a <<doExecute-mapPartitionsWithIndexInternal, calculation over indexed partitions>> (using `RDD.mapPartitionsWithIndexInternal`).

.RDD.mapPartitionsWithIndexInternal
[source, scala]
----
mapPartitionsWithIndexInternal[U](
  f: (Int, Iterator[T]) => Iterator[U],
  preservesPartitioning: Boolean = false)
----

==== [[doExecute-mapPartitionsWithIndexInternal]] Inside `doExecute` (`RDD.mapPartitionsWithIndexInternal`)

Inside the function (that is part of `RDD.mapPartitionsWithIndexInternal`), `doExecute` creates an spark-sql-UnsafeProjection.md#create[UnsafeProjection] with the following:

. <<projectList, Named expressions>>

. catalyst/QueryPlan.md#output[Output] of the <<child, child>> physical operator as the input schema

. SparkPlan.md#subexpressionEliminationEnabled[subexpressionEliminationEnabled] flag

`doExecute` requests the `UnsafeProjection` to spark-sql-Projection.md#initialize[initialize] and maps over the internal rows (of a partition) using the projection.

=== [[creating-instance]] Creating ProjectExec Instance

`ProjectExec` takes the following when created:

* [[projectList]] spark-sql-Expression-NamedExpression.md[NamedExpressions] for the projection
* [[child]] Child SparkPlan.md[physical operator]

=== [[doConsume]] Generating Java Source Code for Consume Path in Whole-Stage Code Generation -- `doConsume` Method

[source, scala]
----
doConsume(ctx: CodegenContext, input: Seq[ExprCode], row: ExprCode): String
----

`doConsume`...FIXME

`doConsume` is part of the [CodegenSupport](CodegenSupport.md#doConsume) abstraction.
