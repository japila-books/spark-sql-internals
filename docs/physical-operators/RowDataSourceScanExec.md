# RowDataSourceScanExec Leaf Physical Operator

`RowDataSourceScanExec` is a [DataSourceScanExec](DataSourceScanExec.md) (and so indirectly a [leaf physical operator](LeafExecNode.md)) for scanning data from a [BaseRelation](#relation).

`RowDataSourceScanExec` is a [InputRDDCodegen](InputRDDCodegen.md).

## <span id="metrics"> Performance Metrics

Key             | Name (in web UI)        | Description
----------------|-------------------------|---------
 numOutputRows  | number of output rows   | Number of output rows

## Creating Instance

`RowDataSourceScanExec` takes the following to be created:

* <span id="output"> Output Schema ([Attribute](../expressions/Attribute.md)s)
* <span id="requiredSchema"> Required Schema ([StructType](../StructType.md))
* <span id="filters"> [Data Source Filter Predicate](../Filter.md)s
* <span id="handledFilters"> Handled [Data Source Filter Predicate](../Filter.md)s
* <span id="rdd"> `RDD[InternalRow]`
* <span id="relation"> [BaseRelation](../BaseRelation.md)
* <span id="tableIdentifier"> Optional `TableIdentifier`

`RowDataSourceScanExec` is created when:

* [DataSourceStrategy](../execution-planning-strategies/DataSourceStrategy.md) execution planning strategy is executed (for [LogicalRelation](../logical-operators/LogicalRelation.md) logical operators)

## <span id="metadata"> Metadata

```scala
metadata: Map[String, String]
```

`metadata` is part of the [DataSourceScanExec](DataSourceScanExec.md#metadata) abstraction.

`metadata` marks the [filter predicates](#filters) that are included in the [handled filters predicates](#handledFilters) with `*` (star).

!!! note
    Filter predicates with `*` (star) are to denote filters that are pushed down to a relation (aka _data source_).

In the end, `metadata` creates the following mapping:

* **ReadSchema** with the [required schema](#requiredSchema) converted to [catalog representation](../StructType.md#catalogString)
* **PushedFilters** with the marked and unmarked [filter predicates](#filters)

## <span id="doExecute"> Executing Physical Operator

```scala
doExecute(): RDD[InternalRow]
```

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute`...FIXME

## <span id="createUnsafeProjection"> createUnsafeProjection

```scala
createUnsafeProjection: Boolean
```

`createUnsafeProjection` is part of the [InputRDDCodegen](InputRDDCodegen.md#createUnsafeProjection) abstraction.

`createUnsafeProjection` is `true`.

## <span id="inputRDD"> Input RDD

```scala
inputRDD: RDD[InternalRow]
```

`inputRDD` is part of the [InputRDDCodegen](InputRDDCodegen.md#inputRDD) abstraction.

`inputRDD` is the [RDD](#rdd).
