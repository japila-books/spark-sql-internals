# Basic Aggregation

**Basic Aggregation** calculates aggregates over a group of rows in a [Dataset](../Dataset.md) using [aggregate operators](#aggregate-operators) (possibly with [aggregate functions](../spark-sql-functions.md#aggregate-functions)).

## Aggregate Operators

### <span id="agg"> agg

Aggregates over (_applies an aggregate function on_) a subset of or the entire `Dataset` (i.e., considering the entire data set as one group)

Creates a [RelationalGroupedDataset](RelationalGroupedDataset.md)

!!! note
    `Dataset.agg` is simply a shortcut for `Dataset.groupBy().agg`.

### <span id="groupBy"> groupBy

Groups the rows in a `Dataset` by columns (as [Column expressions](../Column.md) or names).

Creates a [RelationalGroupedDataset](RelationalGroupedDataset.md)

Used for **untyped aggregates** using `DataFrame`s. Grouping is described using [column expressions](../Column.md) or column names.

Internally, `groupBy` resolves column names and [creates a RelationalGroupedDataset](RelationalGroupedDataset.md#creating-instance) (with [groupType](RelationalGroupedDataset.md#groupType) as `GroupByType`).

### <span id="groupByKey"> groupByKey

Groups records (of type `T`) by the input `func` and creates a [KeyValueGroupedDataset](KeyValueGroupedDataset.md) to apply aggregation to.

Used for **typed aggregates** using `Dataset`s with records grouped by a key-defining discriminator function

```scala
import org.apache.spark.sql.expressions.scalalang._
val q = dataset
  .groupByKey(_.productId).
  .agg(typed.sum[Token](_.score))
  .toDF("productId", "sum")
  .orderBy('productId)
```

```scala
spark
  .readStream
  .format("rate")
  .load
  .as[(Timestamp, Long)]
  .groupByKey { case (ts, v) => v % 2 }
  .agg()
  .writeStream
  .format("console")
  .trigger(Trigger.ProcessingTime(5.seconds))
  .outputMode("complete")
  .start
```
