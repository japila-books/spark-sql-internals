# UnspecifiedDistribution

`UnspecifiedDistribution` is a [Distribution](Distribution.md).

[[requiredNumPartitions]]
`UnspecifiedDistribution` specifies `None` for the Distribution.md#requiredNumPartitions[required number of partitions].

!!! note
    `None` for the required number of partitions indicates to use any number of partitions (possibly [spark.sql.shuffle.partitions](../configuration-properties.md#spark.sql.shuffle.partitions) configuration property).
