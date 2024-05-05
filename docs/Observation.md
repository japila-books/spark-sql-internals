# Observation

`Observation` is used to simplify observing named metrics in batch queries using [Dataset.observe](dataset/index.md#observe).

```scala
val observation = Observation("name")
val observed = ds.observe(observation, max($"id").as("max_id"))
observed.count()
val metrics = observation.get
```

```scala
// Observe row count (rows) and highest id (maxid) in the Dataset while writing it
val observation = Observation("my_metrics")
val observed_ds = ds.observe(observation, count(lit(1)).as("rows"), max($"id").as("maxid"))
observed_ds.write.parquet("ds.parquet")
val metrics = observation.get
```

!!! note "[SPARK-34806][SQL] Add Observation helper for Dataset.observe"
    `Observation` was added in 3.3.1 ([this commit](https://github.com/apache/spark/commit/4e9c1b8ba0b7ef44d62475835f424ec705e6f21e)).

## Creating Instance

`Observation` takes the following to be created:

* <span id="name"> Name (default: random UUID)

`Observation` is created using [apply](#apply) factories.

## <span id="apply"> Creating Observation

```scala
apply(): Observation
apply(name: String): Observation
```

`apply` creates a [Observation](#creating-instance).
