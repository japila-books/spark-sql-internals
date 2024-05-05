---
title: ProjectExec
---

# ProjectExec Unary Physical Operator

`ProjectExec` is a [unary physical operator](UnaryExecNode.md) with support for [Java code generation](CodegenSupport.md) that represents [Project](../logical-operators/Project.md) logical operator at execution.

## Creating Instance

`ProjectExec` takes the following to be created:

* <span id="projectList"> [NamedExpression](../expressions/NamedExpression.md)s
* <span id="child"> Child [Physical Operator](SparkPlan.md)

`ProjectExec` is created when:

* [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed (to plan [Project](../logical-operators/Project.md) logical operator)
* `SparkPlanner` is requested to [pruneFilterProject](../SparkPlanner.md#pruneFilterProject)
* [DataSourceStrategy](../execution-planning-strategies/DataSourceStrategy.md) execution planning strategy is [executed](../execution-planning-strategies/DataSourceStrategy.md#pruneFilterProjectRaw)
* [FileSourceStrategy](../execution-planning-strategies/FileSourceStrategy.md) execution planning strategy is executed
* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed
* `FileFormatWriter` is requested to [write](../files/FileFormatWriter.md#write)

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute` requests the [child physical plan](#child) to [execute](SparkPlan.md#execute) and [mapPartitionsWithIndexInternal](#doExecute-mapPartitionsWithIndexInternal).

### <span id="doExecute-mapPartitionsWithIndexInternal"> mapPartitionsWithIndexInternal

`doExecute` uses `RDD.mapPartitionsWithIndexInternal`.

```scala
mapPartitionsWithIndexInternal[U](
  f: (Int, Iterator[T]) => Iterator[U],
  preservesPartitioning: Boolean = false)
```

`doExecute` creates an [UnsafeProjection](../expressions/UnsafeProjection.md#create) for the [named expressions](#projectList) and (the [output](../catalyst/QueryPlan.md#output) of) the [child](#child) physical operator.

`doExecute` requests the `UnsafeProjection` to [initialize](../expressions/Projection.md#initialize) and maps over the internal rows (of a partition) using the projection.

## <span id="output"> Output Attributes

```scala
output: Seq[Attribute]
```

`output` is part of the [QueryPlan](../catalyst/QueryPlan.md#output) abstraction.

`output` is the [NamedExpression](#projectList)s converted to [Attribute](../expressions/NamedExpression.md#toAttribute)s.
