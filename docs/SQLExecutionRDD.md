# SQLExecutionRDD

`SQLExecutionRDD` is an `RDD[InternalRow]` to wrap the parent [RDD](#sqlRDD) and make sure that the SQL configuration properties are always propagated to executors (even when `rdd` or [QueryExecution.toRdd](QueryExecution.md#toRdd) are used).

!!! tip
    Review [SPARK-28939]({{ spark.jira }}/SPARK-28939) to learn when and why `SQLExecutionRDD` would be used outside a tracked SQL operation (and with no `spark.sql.execution.id` defined).

## Creating Instance

`SQLExecutionRDD` takes the following to be created:

* [RDD[InternalRow]](#sqlRDD)
* <span id="conf"> [SQLConf](SQLConf.md)

While being created, `SQLExecutionRDD` initializes a [sqlConfigs](#sqlConfigs) internal registry.

`SQLExecutionRDD` is created when:

* `QueryExecution` is requested to [toRdd](QueryExecution.md#toRdd)

## <span id="sqlRDD"> SQL RDD

`SQLExecutionRDD` is given an `RDD[InternalRow]` when [created](#creating-instance).

The `RDD[InternalRow]` is the [executedPlan](QueryExecution.md#executedPlan) requested to [execute](physical-operators/SparkPlan.md#execute).

## <span id="sqlConfigs"> sqlConfigs

`SQLExecutionRDD` requests the given [SQLConf](#conf) for [all the configuration properties that have been set](SQLConf.md#getAllConfs) when [created](#creating-instance).

??? note "Lazy Value"
    `sqlConfigs` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

## <span id="compute"> Computing Partition

```scala
compute(
  split: Partition,
  context: TaskContext): Iterator[InternalRow]
```

`compute` looks up the [spark.sql.execution.id](SQLExecution.md#spark.sql.execution.id) local property in the given `TaskContext` ([Apache Spark]({{ book.spark_core }}/scheduler/TaskContext)).

If not defined (`null`), `compute` sets the [sqlConfigs](#sqlConfigs) as thread-local properties to requests the [sqlRDD](#sqlRDD) for `iterator` (execute the `sqlRDD`). Otherwise, if in the context of a tracked SQL operation (and the `spark.sql.execution.id` is defined), `compute` simply requests the parent [sqlRDD](#sqlRDD) for `iterator`.

`compute` is part of the `RDD` ([Apache Spark]({{ book.spark_core }}/rdd/RDD#compute)) abstraction.
