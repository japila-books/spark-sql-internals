---
title: Operators
---

# Dataset API &mdash; Dataset Operators

Dataset API is a [set of operators](#methods) with typed and untyped transformations, and actions to work with a structured query (as a [Dataset](Dataset.md)) as a whole.

## <span id="methods"><span id="operators"> Dataset Operators (Transformations and Actions)

### explain { #explain }

```scala
// Uses simple mode
explain(): Unit
// Uses extended or simple mode
explain(
  extended: Boolean): Unit
explain(
  mode: String): Unit
```

[explain](dataset-basic-actions.md#explain)

A basic action to display the logical and physical plans of the `Dataset`, i.e. displays the logical and physical plans (with optional cost and codegen summaries) to the standard output

<!---
## Review Me

[cols="1,3",options="header",width="100%"]
|===
| Operator
| Description

| [agg](dataset-untyped-transformations.md#agg)
a| [[agg]]

[source, scala]
----
agg(aggExpr: (String, String), aggExprs: (String, String)*): DataFrame
agg(expr: Column, exprs: Column*): DataFrame
agg(exprs: Map[String, String]): DataFrame
----

An untyped transformation

| <<dataset-typed-transformations.md#alias, alias>>
a| [[alias]]

[source, scala]
----
alias(alias: String): Dataset[T]
alias(alias: Symbol): Dataset[T]
----

A typed transformation that is a mere synonym of <<as-alias, as>>.

| [apply](dataset-untyped-transformations.md#apply)
a| [[apply]]

[source, scala]
----
apply(colName: String): Column
----

An untyped transformation to select a column based on the column name (i.e. maps a `Dataset` onto a `Column`)

| <<dataset-typed-transformations.md#as-alias, as>>
a| [[as-alias]]

[source, scala]
----
as(alias: String): Dataset[T]
as(alias: Symbol): Dataset[T]
----

A typed transformation

| <<dataset-typed-transformations.md#as-type, as>>
a| [[as-type]]

[source, scala]
----
as[U : Encoder]: Dataset[U]
----

A typed transformation to enforce a type, i.e. marking the records in the `Dataset` as of a given data type (_data type conversion_). `as` simply changes the view of the data that is passed into typed operations (e.g. <<map, map>>) and does not eagerly project away any columns that are not present in the specified class.

| <<dataset-basic-actions.md#cache, cache>>
a| [[cache]]

[source, scala]
----
cache(): this.type
----

A basic action that is a mere synonym of <<persist, persist>>.

| <<dataset-basic-actions.md#checkpoint, checkpoint>>
a| [[checkpoint]]

[source, scala]
----
checkpoint(): Dataset[T]
checkpoint(eager: Boolean): Dataset[T]
----

A basic action to checkpoint the `Dataset` in a reliable way (using a reliable HDFS-compliant file system, e.g. Hadoop HDFS or Amazon S3)

| <<dataset-typed-transformations.md#coalesce, coalesce>>
a| [[coalesce]]

[source, scala]
----
coalesce(numPartitions: Int): Dataset[T]
----

A typed transformation to repartition a Dataset

| [col](dataset-untyped-transformations.md#col)
a| [[col]]

[source, scala]
----
col(colName: String): Column
----

An untyped transformation to create a column (reference) based on the column name

| <<spark-sql-Dataset-actions.md#collect, collect>>
a| [[collect]]

[source, scala]
----
collect(): Array[T]
----

An action

| [colRegex](dataset-untyped-transformations.md#colRegex)
a| [[colRegex]]

[source, scala]
----
colRegex(colName: String): Column
----

An untyped transformation to create a column (reference) based on the column name specified as a regex

| <<dataset-basic-actions.md#columns, columns>>
a| [[columns]]

[source, scala]
----
columns: Array[String]
----

A basic action

| <<spark-sql-Dataset-actions.md#count, count>>
a| [[count]]

[source, scala]
----
count(): Long
----

An action to count the number of rows

| <<dataset-basic-actions.md#createGlobalTempView, createGlobalTempView>>
a| [[createGlobalTempView]]

[source, scala]
----
createGlobalTempView(viewName: String): Unit
----

A basic action

| <<dataset-basic-actions.md#createOrReplaceGlobalTempView, createOrReplaceGlobalTempView>>
a| [[createOrReplaceGlobalTempView]]

[source, scala]
----
createOrReplaceGlobalTempView(viewName: String): Unit
----

A basic action

| <<dataset-basic-actions.md#createOrReplaceTempView, createOrReplaceTempView>>
a| [[createOrReplaceTempView]]

[source, scala]
----
createOrReplaceTempView(viewName: String): Unit
----

A basic action

| <<dataset-basic-actions.md#createTempView, createTempView>>
a| [[createTempView]]

[source, scala]
----
createTempView(viewName: String): Unit
----

A basic action

| [crossJoin](dataset-untyped-transformations.md#crossJoin)
a| [[crossJoin]]

[source, scala]
----
crossJoin(right: Dataset[_]): DataFrame
----

An untyped transformation

| [cube](dataset-untyped-transformations.md#cube)
a| [[cube]]

[source, scala]
----
cube(cols: Column*): RelationalGroupedDataset
cube(col1: String, cols: String*): RelationalGroupedDataset
----

An untyped transformation

| <<spark-sql-Dataset-actions.md#describe, describe>>
a| [[describe]]

[source, scala]
----
describe(cols: String*): DataFrame
----

An action

| <<dataset-typed-transformations.md#distinct, distinct>>
a| [[distinct]]

[source, scala]
----
distinct(): Dataset[T]
----

A typed transformation that is a mere synonym of <<dropDuplicates, dropDuplicates>> (with all the columns of the `Dataset`)

| [drop](dataset-untyped-transformations.md#drop)
a| [[drop]]

[source, scala]
----
drop(colName: String): DataFrame
drop(colNames: String*): DataFrame
drop(col: Column): DataFrame
----

An untyped transformation

| <<dataset-typed-transformations.md#dropDuplicates, dropDuplicates>>
a| [[dropDuplicates]]

[source, scala]
----
dropDuplicates(): Dataset[T]
dropDuplicates(colNames: Array[String]): Dataset[T]
dropDuplicates(colNames: Seq[String]): Dataset[T]
dropDuplicates(col1: String, cols: String*): Dataset[T]
----

A typed transformation

| <<dataset-basic-actions.md#dtypes, dtypes>>
a| [[dtypes]]

[source, scala]
----
dtypes: Array[(String, String)]
----

A basic action

| <<dataset-typed-transformations.md#except, except>>
a| [[except]]

[source, scala]
----
except(
  other: Dataset[T]): Dataset[T]
----

A typed transformation

| <<dataset-typed-transformations.md#exceptAll, exceptAll>>
a| [[exceptAll]]

[source, scala]
----
exceptAll(
  other: Dataset[T]): Dataset[T]
----

(*New in 2.4.0*) A typed transformation

| <<dataset-typed-transformations.md#filter, filter>>
a| [[filter]]

[source, scala]
----
filter(condition: Column): Dataset[T]
filter(conditionExpr: String): Dataset[T]
filter(func: T => Boolean): Dataset[T]
----

A typed transformation

| <<spark-sql-Dataset-actions.md#first, first>>
a| [[first]]

[source, scala]
----
first(): T
----

An action that is a mere synonym of <<head, head>>

| <<dataset-typed-transformations.md#flatMap, flatMap>>
a| [[flatMap]]

[source, scala]
----
flatMap[U : Encoder](func: T => TraversableOnce[U]): Dataset[U]
----

A typed transformation

| <<spark-sql-Dataset-actions.md#foreach, foreach>>
a| [[foreach]]

[source, scala]
----
foreach(f: T => Unit): Unit
----

An action

| <<spark-sql-Dataset-actions.md#foreachPartition, foreachPartition>>
a| [[foreachPartition]]

[source, scala]
----
foreachPartition(f: Iterator[T] => Unit): Unit
----

An action

| [groupBy](dataset-untyped-transformations.md#groupBy)
a| [[groupBy]]

[source, scala]
----
groupBy(cols: Column*): RelationalGroupedDataset
groupBy(col1: String, cols: String*): RelationalGroupedDataset
----

An untyped transformation

| <<dataset-typed-transformations.md#groupByKey, groupByKey>>
a| [[groupByKey]]

[source, scala]
----
groupByKey[K: Encoder](func: T => K): KeyValueGroupedDataset[K, T]
----

A typed transformation

| <<spark-sql-Dataset-actions.md#head, head>>
a| [[head]]

[source, scala]
----
head(): T // <1>
head(n: Int): Array[T]
----
<1> Uses `1` for `n`

An action

| <<dataset-basic-actions.md#hint, hint>>
a| [[hint]]

[source, scala]
----
hint(name: String, parameters: Any*): Dataset[T]
----

A basic action to specify a hint (and optional parameters)

| <<dataset-basic-actions.md#inputFiles, inputFiles>>
a| [[inputFiles]]

[source, scala]
----
inputFiles: Array[String]
----

A basic action

| <<dataset-typed-transformations.md#intersect, intersect>>
a| [[intersect]]

[source, scala]
----
intersect(other: Dataset[T]): Dataset[T]
----

A typed transformation

| <<dataset-typed-transformations.md#intersectAll, intersectAll>>
a| [[intersectAll]]

[source, scala]
----
intersectAll(other: Dataset[T]): Dataset[T]
----

(*New in 2.4.0*) A typed transformation

| <<dataset-basic-actions.md#isEmpty, isEmpty>>
a| [[isEmpty]]

[source, scala]
----
isEmpty: Boolean
----

(*New in 2.4.0*) A basic action

| <<dataset-basic-actions.md#isLocal, isLocal>>
a| [[isLocal]]

[source, scala]
----
isLocal: Boolean
----

A basic action

| isStreaming
a| [[isStreaming]]

[source, scala]
----
isStreaming: Boolean
----

| [join](dataset-untyped-transformations.md#join)
a| [[join]]

[source, scala]
----
join(right: Dataset[_]): DataFrame
join(right: Dataset[_], usingColumn: String): DataFrame
join(right: Dataset[_], usingColumns: Seq[String]): DataFrame
join(right: Dataset[_], usingColumns: Seq[String], joinType: String): DataFrame
join(right: Dataset[_], joinExprs: Column): DataFrame
join(right: Dataset[_], joinExprs: Column, joinType: String): DataFrame
----

An untyped transformation

| <<dataset-typed-transformations.md#joinWith, joinWith>>
a| [[joinWith]]

[source, scala]
----
joinWith[U](other: Dataset[U], condition: Column): Dataset[(T, U)]
joinWith[U](other: Dataset[U], condition: Column, joinType: String): Dataset[(T, U)]
----

A typed transformation

| <<dataset-typed-transformations.md#limit, limit>>
a| [[limit]]

[source, scala]
----
limit(n: Int): Dataset[T]
----

A typed transformation

| <<dataset-basic-actions.md#localCheckpoint, localCheckpoint>>
a| [[localCheckpoint]]

[source, scala]
----
localCheckpoint(): Dataset[T]
localCheckpoint(eager: Boolean): Dataset[T]
----

A basic action to checkpoint the `Dataset` locally on executors (and therefore unreliably)

| <<dataset-typed-transformations.md#map, map>>
a| [[map]]

[source, scala]
----
map[U: Encoder](func: T => U): Dataset[U]
----

A typed transformation

| <<dataset-typed-transformations.md#mapPartitions, mapPartitions>>
a| [[mapPartitions]]

[source, scala]
----
mapPartitions[U : Encoder](func: Iterator[T] => Iterator[U]): Dataset[U]
----

A typed transformation

| [na](dataset-untyped-transformations.md#na)
a| [[na]]

[source, scala]
----
na: DataFrameNaFunctions
----

An untyped transformation

| <<dataset-typed-transformations.md#orderBy, orderBy>>
a| [[orderBy]]

[source, scala]
----
orderBy(sortExprs: Column*): Dataset[T]
orderBy(sortCol: String, sortCols: String*): Dataset[T]
----

A typed transformation

| <<dataset-basic-actions.md#persist, persist>>
a| [[persist]]

[source, scala]
----
persist(): this.type
persist(newLevel: StorageLevel): this.type
----

A basic action to persist the `Dataset`

NOTE: Although its category `persist` is not an action in the common sense that means executing _anything_ in a Spark cluster (i.e. execution on the driver or on executors). It acts only as a marker to perform Dataset persistence once an action is really executed.

| <<dataset-basic-actions.md#printSchema, printSchema>>
a| [[printSchema]]

[source, scala]
----
printSchema(): Unit
----

A basic action

| <<dataset-typed-transformations.md#randomSplit, randomSplit>>
a| [[randomSplit]]

[source, scala]
----
randomSplit(weights: Array[Double]): Array[Dataset[T]]
randomSplit(weights: Array[Double], seed: Long): Array[Dataset[T]]
----

A typed transformation to split a `Dataset` randomly into two `Datasets`

| <<dataset-basic-actions.md#rdd, rdd>>
a| [[rdd]]

[source, scala]
----
rdd: RDD[T]
----

A basic action

| <<spark-sql-Dataset-actions.md#reduce, reduce>>
a| [[reduce]]

[source, scala]
----
reduce(func: (T, T) => T): T
----

An action to reduce the records of the `Dataset` using the specified binary function.

| <<dataset-typed-transformations.md#repartition, repartition>>
a| [[repartition]]

[source, scala]
----
repartition(partitionExprs: Column*): Dataset[T]
repartition(numPartitions: Int): Dataset[T]
repartition(numPartitions: Int, partitionExprs: Column*): Dataset[T]
----

A typed transformation to repartition a Dataset

| <<dataset-typed-transformations.md#repartitionByRange, repartitionByRange>>
a| [[repartitionByRange]]

[source, scala]
----
repartitionByRange(partitionExprs: Column*): Dataset[T]
repartitionByRange(numPartitions: Int, partitionExprs: Column*): Dataset[T]
----

A typed transformation

| [rollup](dataset-untyped-transformations.md#rollup)
a| [[rollup]]

[source, scala]
----
rollup(cols: Column*): RelationalGroupedDataset
rollup(col1: String, cols: String*): RelationalGroupedDataset
----

An untyped transformation

| <<dataset-typed-transformations.md#sample, sample>>
a| [[sample]]

[source, scala]
----
sample(withReplacement: Boolean, fraction: Double): Dataset[T]
sample(withReplacement: Boolean, fraction: Double, seed: Long): Dataset[T]
sample(fraction: Double): Dataset[T]
sample(fraction: Double, seed: Long): Dataset[T]
----

A typed transformation

| <<dataset-basic-actions.md#schema, schema>>
a| [[schema]]

[source, scala]
----
schema: StructType
----

A basic action

| [select](dataset-untyped-transformations.md#select)
a| [[select]]

[source, scala]
----
// Untyped transformations
select(cols: Column*): DataFrame
select(col: String, cols: String*): DataFrame

// Typed transformations
select[U1](c1: TypedColumn[T, U1]): Dataset[U1]
select[U1, U2](c1: TypedColumn[T, U1], c2: TypedColumn[T, U2]): Dataset[(U1, U2)]
select[U1, U2, U3](
  c1: TypedColumn[T, U1],
  c2: TypedColumn[T, U2],
  c3: TypedColumn[T, U3]): Dataset[(U1, U2, U3)]
select[U1, U2, U3, U4](
  c1: TypedColumn[T, U1],
  c2: TypedColumn[T, U2],
  c3: TypedColumn[T, U3],
  c4: TypedColumn[T, U4]): Dataset[(U1, U2, U3, U4)]
select[U1, U2, U3, U4, U5](
  c1: TypedColumn[T, U1],
  c2: TypedColumn[T, U2],
  c3: TypedColumn[T, U3],
  c4: TypedColumn[T, U4],
  c5: TypedColumn[T, U5]): Dataset[(U1, U2, U3, U4, U5)]
----

An (untyped and typed) transformation

| [selectExpr](dataset-untyped-transformations.md#selectExpr)
a| [[selectExpr]]

[source, scala]
----
selectExpr(exprs: String*): DataFrame
----

An untyped transformation

| <<spark-sql-Dataset-actions.md#show, show>>
a| [[show]]

[source, scala]
----
show(): Unit
show(truncate: Boolean): Unit
show(numRows: Int): Unit
show(numRows: Int, truncate: Boolean): Unit
show(numRows: Int, truncate: Int): Unit
show(numRows: Int, truncate: Int, vertical: Boolean): Unit
----

An action

| <<dataset-typed-transformations.md#sort, sort>>
a| [[sort]]

[source, scala]
----
sort(sortExprs: Column*): Dataset[T]
sort(sortCol: String, sortCols: String*): Dataset[T]
----

A typed transformation to sort elements globally (across partitions). Use <<sortWithinPartitions, sortWithinPartitions>> transformation for partition-local sort

| <<dataset-typed-transformations.md#sortWithinPartitions, sortWithinPartitions>>
a| [[sortWithinPartitions]]

[source, scala]
----
sortWithinPartitions(sortExprs: Column*): Dataset[T]
sortWithinPartitions(sortCol: String, sortCols: String*): Dataset[T]
----

A typed transformation to sort elements within partitions (aka _local sort_). Use <<sort, sort>> transformation for global sort (across partitions)

| [stat](dataset-untyped-transformations.md#stat)
a| [[stat]]

[source, scala]
----
stat: DataFrameStatFunctions
----

An untyped transformation

| <<dataset-basic-actions.md#storageLevel, storageLevel>>
a| [[storageLevel]]

[source, scala]
----
storageLevel: StorageLevel
----

A basic action

| <<spark-sql-Dataset-actions.md#summary, summary>>
a| [[summary]]

[source, scala]
----
summary(statistics: String*): DataFrame
----

An action to calculate statistics (e.g. `count`, `mean`, `stddev`, `min`, `max` and `25%`, `50%`, `75%` percentiles)

| <<spark-sql-Dataset-actions.md#take, take>>
a| [[take]]

[source, scala]
----
take(n: Int): Array[T]
----

An action to take the first records of a Dataset

| <<dataset-basic-actions.md#toDF, toDF>>
a| [[toDF]]

[source, scala]
----
toDF(): DataFrame
toDF(colNames: String*): DataFrame
----

A basic action to convert a Dataset to a DataFrame

| <<dataset-typed-transformations.md#toJSON, toJSON>>
a| [[toJSON]]

[source, scala]
----
toJSON: Dataset[String]
----

A typed transformation

| <<spark-sql-Dataset-actions.md#toLocalIterator, toLocalIterator>>
a| [[toLocalIterator]]

[source, scala]
----
toLocalIterator(): java.util.Iterator[T]
----

An action that returns an iterator with all rows in the `Dataset`. The iterator will consume as much memory as the largest partition in the `Dataset`.

| <<dataset-typed-transformations.md#transform, transform>>
a| [[transform]]

[source, scala]
----
transform[U](t: Dataset[T] => Dataset[U]): Dataset[U]
----

A typed transformation for chaining custom transformations

| <<dataset-typed-transformations.md#union, union>>
a| [[union]]

[source, scala]
----
union(other: Dataset[T]): Dataset[T]
----

A typed transformation

| <<dataset-typed-transformations.md#unionByName, unionByName>>
a| [[unionByName]]

[source, scala]
----
unionByName(other: Dataset[T]): Dataset[T]
----

A typed transformation

| <<dataset-basic-actions.md#unpersist, unpersist>>
a| [[unpersist]]

[source, scala]
----
unpersist(): this.type // <1>
unpersist(blocking: Boolean): this.type
----
<1> Uses `unpersist` with `blocking` disabled (`false`)

A basic action to unpersist the `Dataset`

| <<dataset-typed-transformations.md#where, where>>
a| [[where]]

[source, scala]
----
where(condition: Column): Dataset[T]
where(conditionExpr: String): Dataset[T]
----

A typed transformation

| [withColumn](dataset-untyped-transformations.md#withColumn)
a| [[withColumn]]

[source, scala]
----
withColumn(colName: String, col: Column): DataFrame
----

An untyped transformation

| [withColumnRenamed](dataset-untyped-transformations.md#withColumnRenamed)
a| [[withColumnRenamed]]

[source, scala]
----
withColumnRenamed(existingName: String, newName: String): DataFrame
----

An untyped transformation

| <<dataset-basic-actions.md#write, write>>
a| [[write]]

[source, scala]
----
write: DataFrameWriter[T]
----

A basic action that returns a [DataFrameWriter](DataFrameWriter.md) for saving the content of the (non-streaming) `Dataset` out to an external storage
|===
-->
