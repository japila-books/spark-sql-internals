# Dataset API &mdash; Typed Transformations

**Typed transformations** are part of the Dataset API for transforming a `Dataset` with an [Encoder](Encoder.md) (except the [RowEncoder](RowEncoder.md)).

NOTE: Typed transformations are the methods in the `Dataset` Scala class that are grouped in `typedrel` group name, i.e. `@group typedrel`.

=== [[as]] Enforcing Type -- `as` Typed Transformation

[source, scala]
----
as[U: Encoder]: Dataset[U]
----

`as[T]` allows for converting from a weakly-typed `Dataset` of [Rows](Row.md) to `Dataset[T]` with `T` being a domain class (that can enforce a stronger schema).

```text
// Create DataFrame of pairs
val df = Seq("hello", "world!").zipWithIndex.map(_.swap).toDF("id", "token")

scala> df.printSchema
root
 |-- id: integer (nullable = false)
 |-- token: string (nullable = true)

scala> val ds = df.as[(Int, String)]
ds: org.apache.spark.sql.Dataset[(Int, String)] = [id: int, token: string]

// It's more helpful to have a case class for the conversion
final case class MyRecord(id: Int, token: String)

scala> val myRecords = df.as[MyRecord]
myRecords: org.apache.spark.sql.Dataset[MyRecord] = [id: int, token: string]
```

=== [[coalesce]] Repartitioning Dataset with Shuffle Disabled -- `coalesce` Typed Transformation

[source, scala]
----
coalesce(numPartitions: Int): Dataset[T]
----

`coalesce` operator repartitions the `Dataset` to exactly `numPartitions` partitions.

Internally, `coalesce` creates a `Repartition` logical operator with `shuffle` disabled (which is marked as `false` in the below ``explain``'s output).

[source, scala]
----
scala> spark.range(5).coalesce(1).explain(extended = true)
== Parsed Logical Plan ==
Repartition 1, false
+- Range (0, 5, step=1, splits=Some(8))

== Analyzed Logical Plan ==
id: bigint
Repartition 1, false
+- Range (0, 5, step=1, splits=Some(8))

== Optimized Logical Plan ==
Repartition 1, false
+- Range (0, 5, step=1, splits=Some(8))

== Physical Plan ==
Coalesce 1
+- *Range (0, 5, step=1, splits=Some(8))
----

=== [[flatMap]] Creating Zero or More Records -- `flatMap` Typed Transformation

[source, scala]
----
flatMap[U: Encoder](func: T => TraversableOnce[U]): Dataset[U]
----

`flatMap` returns a new `Dataset` (of type `U`) with all records (of type `T`) mapped over using the function `func` and then flattening the results.

NOTE: `flatMap` can create new records. It deprecated `explode`.

[source, scala]
----
final case class Sentence(id: Long, text: String)
val sentences = Seq(Sentence(0, "hello world"), Sentence(1, "witaj swiecie")).toDS

scala> sentences.flatMap(s => s.text.split("\\s+")).show
+-------+
|  value|
+-------+
|  hello|
|  world|
|  witaj|
|swiecie|
+-------+
----

Internally, `flatMap` calls <<mapPartitions, mapPartitions>> with the partitions `flatMap(ped)`.

=== [[randomSplit]] Randomly Split Dataset Into Two or More Datasets Per Weight -- `randomSplit` Typed Transformation

[source, scala]
----
randomSplit(weights: Array[Double]): Array[Dataset[T]]
randomSplit(weights: Array[Double], seed: Long): Array[Dataset[T]]
----

`randomSplit` randomly splits the `Dataset` per `weights`.

`weights` doubles should sum up to `1` and will be normalized if they do not.

You can define `seed` and if you don't, a random `seed` will be used.

NOTE: `randomSplit` is commonly used in Spark MLlib to split an input Dataset into two datasets for training and validation.

[source, scala]
----
val ds = spark.range(10)
scala> ds.randomSplit(Array[Double](2, 3)).foreach(_.show)
+---+
| id|
+---+
|  0|
|  1|
|  2|
+---+

+---+
| id|
+---+
|  3|
|  4|
|  5|
|  6|
|  7|
|  8|
|  9|
+---+
----

=== [[repartition]] Repartitioning Dataset (Shuffle Enabled) -- `repartition` Typed Transformation

[source, scala]
----
repartition(partitionExprs: Column*): Dataset[T]
repartition(numPartitions: Int): Dataset[T]
repartition(numPartitions: Int, partitionExprs: Column*): Dataset[T]
----

`repartition` operators repartition the `Dataset` to exactly `numPartitions` partitions or using `partitionExprs` expressions.

`repartition` creates a [Repartition](logical-operators/RepartitionOperation.md#Repartition) or [RepartitionByExpression](logical-operators/RepartitionOperation.md#RepartitionByExpression) logical operators with `shuffle` enabled (which is `true` in the below ``explain``'s output beside `Repartition`).

```text
scala> spark.range(5).repartition(1).explain(extended = true)
== Parsed Logical Plan ==
Repartition 1, true
+- Range (0, 5, step=1, splits=Some(8))

== Analyzed Logical Plan ==
id: bigint
Repartition 1, true
+- Range (0, 5, step=1, splits=Some(8))

== Optimized Logical Plan ==
Repartition 1, true
+- Range (0, 5, step=1, splits=Some(8))

== Physical Plan ==
Exchange RoundRobinPartitioning(1)
+- *Range (0, 5, step=1, splits=Some(8))
```

NOTE: `repartition` methods correspond to SQL's spark-sql-SparkSqlAstBuilder.md#withRepartitionByExpression[DISTRIBUTE BY or CLUSTER BY clauses].

=== [[repartitionByRange]] `repartitionByRange` Typed Transformation

[source, scala]
----
repartitionByRange(partitionExprs: Column*): Dataset[T] // <1>
repartitionByRange(numPartitions: Int, partitionExprs: Column*): Dataset[T]
----
<1> Uses [spark.sql.shuffle.partitions](configuration-properties.md#spark.sql.shuffle.partitions) configuration property for the number of partitions to use

`repartitionByRange` simply <<Dataset.md#withTypedPlan, creates a Dataset>> with a [RepartitionByExpression](logical-operators/RepartitionOperation.md#RepartitionByExpression) logical operator.

```text
val q = spark.range(10).repartitionByRange(numPartitions = 5, $"id")
scala> println(q.queryExecution.logical.numberedTreeString)
00 'RepartitionByExpression ['id ASC NULLS FIRST], 5
01 +- AnalysisBarrier
02       +- Range (0, 10, step=1, splits=Some(8))

scala> println(q.queryExecution.toRdd.getNumPartitions)
5

scala> println(q.queryExecution.toRdd.toDebugString)
(5) ShuffledRowRDD[18] at toRdd at <console>:26 []
 +-(8) MapPartitionsRDD[17] at toRdd at <console>:26 []
    |  MapPartitionsRDD[13] at toRdd at <console>:26 []
    |  MapPartitionsRDD[12] at toRdd at <console>:26 []
    |  ParallelCollectionRDD[11] at toRdd at <console>:26 []
```

`repartitionByRange` uses a `SortOrder` with the `Ascending` sort order, i.e. _ascending nulls first_, when no explicit sort order is specified.

---

`repartitionByRange` throws a `IllegalArgumentException` when no `partitionExprs` partition-by expression is specified.

```text
requirement failed: At least one partition-by expression must be specified.
```

=== [[sortWithinPartitions]] `sortWithinPartitions` Typed Transformation

[source, scala]
----
sortWithinPartitions(sortExprs: Column*): Dataset[T]
sortWithinPartitions(sortCol: String, sortCols: String*): Dataset[T]
----

`sortWithinPartitions` simply calls the internal <<Dataset.md#sortInternal, sortInternal>> method with the `global` flag disabled (`false`).

=== [[toJSON]] `toJSON` Typed Transformation

[source, scala]
----
toJSON: Dataset[String]
----

`toJSON` maps the content of `Dataset` to a `Dataset` of strings in JSON format.

```text
scala> val ds = Seq("hello", "world", "foo bar").toDS
ds: org.apache.spark.sql.Dataset[String] = [value: string]

scala> ds.toJSON.show
+-------------------+
|              value|
+-------------------+
|  {"value":"hello"}|
|  {"value":"world"}|
|{"value":"foo bar"}|
+-------------------+
```

---

Internally, `toJSON` grabs the `RDD[InternalRow]` (of the QueryExecution.md#toRdd[QueryExecution] of the `Dataset`) and spark-rdd-transformations.md#mapPartitions[maps the records (per RDD partition)] into JSON.

NOTE: `toJSON` uses Jackson's JSON parser -- https://github.com/FasterXML/jackson-module-scala[jackson-module-scala].

=== [[transform]] Transforming Datasets -- `transform` Typed Transformation

[source, scala]
----
transform[U](t: Dataset[T] => Dataset[U]): Dataset[U]
----

`transform` applies `t` function to the source `Dataset[T]` to produce a result `Dataset[U]`. It is for chaining custom transformations.

```text
val dataset = spark.range(5)

// Transformation t
import org.apache.spark.sql.Dataset
def withDoubled(longs: Dataset[java.lang.Long]) = longs.withColumn("doubled", 'id * 2)

scala> dataset.transform(withDoubled).show
+---+-------+
| id|doubled|
+---+-------+
|  0|      0|
|  1|      2|
|  2|      4|
|  3|      6|
|  4|      8|
+---+-------+
```

---

Internally, `transform` executes `t` function on the current `Dataset[T]`.

=== [[withWatermark]] Creating Streaming Dataset with EventTimeWatermark Logical Operator -- `withWatermark` Streaming Typed Transformation

[source, scala]
----
withWatermark(eventTime: String, delayThreshold: String): Dataset[T]
----

Internally, `withWatermark` creates a `Dataset` with `EventTimeWatermark` logical plan for Dataset.md#isStreaming[streaming Datasets].

NOTE: `withWatermark` uses `EliminateEventTimeWatermark` logical rule to eliminate `EventTimeWatermark` logical plan for non-streaming batch `Datasets`.

[source, scala]
----
// Create a batch dataset
val events = spark.range(0, 50, 10).
  withColumn("timestamp", from_unixtime(unix_timestamp - 'id)).
  select('timestamp, 'id as "count")
scala> events.show
+-------------------+-----+
|          timestamp|count|
+-------------------+-----+
|2017-06-25 21:21:14|    0|
|2017-06-25 21:21:04|   10|
|2017-06-25 21:20:54|   20|
|2017-06-25 21:20:44|   30|
|2017-06-25 21:20:34|   40|
+-------------------+-----+

// the dataset is a non-streaming batch one...
scala> events.isStreaming
res1: Boolean = false

// ...so EventTimeWatermark is not included in the logical plan
val watermarked = events.
  withWatermark(eventTime = "timestamp", delayThreshold = "20 seconds")
scala> println(watermarked.queryExecution.logical.numberedTreeString)
00 Project [timestamp#284, id#281L AS count#288L]
01 +- Project [id#281L, from_unixtime((unix_timestamp(current_timestamp(), yyyy-MM-dd HH:mm:ss, Some(America/Chicago)) - id#281L), yyyy-MM-dd HH:mm:ss, Some(America/Chicago)) AS timestamp#284]
02    +- Range (0, 50, step=10, splits=Some(8))

// Let's create a streaming Dataset
import org.apache.spark.sql.types.StructType
val schema = new StructType().
  add($"timestamp".timestamp).
  add($"count".long)
scala> schema.printTreeString
root
 |-- timestamp: timestamp (nullable = true)
 |-- count: long (nullable = true)

val events = spark.
  readStream.
  schema(schema).
  csv("events").
  withWatermark(eventTime = "timestamp", delayThreshold = "20 seconds")
scala> println(events.queryExecution.logical.numberedTreeString)
00 'EventTimeWatermark 'timestamp, interval 20 seconds
01 +- StreamingRelation DataSource(org.apache.spark.sql.SparkSession@75abcdd4,csv,List(),Some(StructType(StructField(timestamp,TimestampType,true), StructField(count,LongType,true))),List(),None,Map(path -> events),None), FileSource[events], [timestamp#329, count#330L]
----

[NOTE]
====
`delayThreshold` is parsed using `CalendarInterval.fromString` with *interval* formatted as described in expressions/TimeWindow.md[TimeWindow] unary expression.

```
0 years 0 months 1 week 0 days 0 hours 1 minute 20 seconds 0 milliseconds 0 microseconds
```
====

NOTE: `delayThreshold` must not be negative (and `milliseconds` and `months` should both be equal or greater than `0`).

NOTE: `withWatermark` is used when...FIXME
