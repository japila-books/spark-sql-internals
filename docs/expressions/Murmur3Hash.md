# Murmur3Hash

`Murmur3Hash` is a [HashExpression](HashExpression.md) to calculate the hash code (integer) of the given [child expressions](#children).

## Creating Instance

`Murmur3Hash` takes the following to be created:

* <span id="children"> Child [Expression](Expression.md)s
* <span id="seed"> Seed (default: `42`)

`Murmur3Hash` is created when:

* `HashPartitioning` is requested for the [partitionId expression](HashPartitioning.md#partitionIdExpression)
* [hash](../functions/index.md#hash) standard and SQL functions are used

## Demo

```scala
val data = Seq[Option[Int]](Some(0), None, None, None, Some(4), None)
  .toDF
  .withColumn("hash", hash('value))
```

```text
scala> data.show
+-----+----------+
|value|      hash|
+-----+----------+
|    0| 933211791|
| null|        42|
| null|        42|
| null|        42|
|    4|-397064898|
| null|        42|
+-----+----------+
```

```text
scala> data.printSchema
root
 |-- value: integer (nullable = true)
 |-- hash: integer (nullable = false)
```

```scala
val defaultSeed = 42

val nonEmptyPartitions = data
  .repartition(numPartitions = defaultSeed, partitionExprs = 'value)
  .mapPartitions { it: Iterator[org.apache.spark.sql.Row] =>
    import org.apache.spark.TaskContext
    val ns = it.map(_.get(0)).mkString(",")
    Iterator((TaskContext.getPartitionId, ns))
  }
  .as[(Long, String)]
  .collect
  .filterNot { case (pid, ns) => ns.isEmpty }

nonEmptyPartitions.foreach { case (pid, ns) => printf("%2s: %s%n", pid, ns) }
```

```text
 0: null,null,null,null
25: 0
32: 4
```
