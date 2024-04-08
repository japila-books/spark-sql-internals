# ArrayFilter Expression

`ArrayFilter` is a [ArrayBasedSimpleHigherOrderFunction](ArrayBasedSimpleHigherOrderFunction.md) with [CodegenFallback](CodegenFallback.md).

## Creating Instance

`ArrayFilter` takes the following to be created:

* <span id="argument"> Argument [Expression](Expression.md)
* <span id="function"> Function [Expression](Expression.md)

`ArrayFilter` is created for the following functions:

* [filter](../standard-functions//index.md#filter) standard function (Scala)
* [filter](../FunctionRegistry.md#expressions) function (SQL)

## Demo

### Scala

```scala
import org.apache.spark.sql.Column
val even: (Column => Column) = x => x % 2 === 1
val filter_collect = filter(collect_set("id") as "ids", even) as "evens"
```

```scala
val q = spark.range(5).groupBy($"id" % 2 as "gid").agg(filter_collect)
```

```text
scala> q.show
+---+------+
|gid| evens|
+---+------+
|  0|    []|
|  1|[1, 3]|
+---+------+
```

### SQL

```scala
spark.range(5).createOrReplaceTempView("nums")
```

```scala
val q = sql("""
SELECT id % 2 gid, filter(collect_set(id), x -> x % 2 == 1) evens
FROM nums
GROUP BY id % 2
""")
```

```text
scala> q.show
+---+------+
|gid| evens|
+---+------+
|  0|    []|
|  1|[1, 3]|
+---+------+
```
