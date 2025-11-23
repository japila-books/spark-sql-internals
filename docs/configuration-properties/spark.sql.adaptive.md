---
title: spark.sql.adaptive
---

# spark.sql.adaptive Configuration Properties

**spark.sql.adaptive** is a family of the [Configuration Properties](./index.md) of [Adaptive Query Execution](../adaptive-query-execution/index.md).

## advisoryPartitionSizeInBytes { #spark.sql.adaptive.advisoryPartitionSizeInBytes }

**spark.sql.adaptive.advisoryPartitionSizeInBytes**

The advisory size in bytes of the shuffle partition during adaptive optimization (when [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) is enabled).
It takes effect when Spark coalesces small shuffle partitions or splits skewed shuffle partition.

Default: `64MB`

Fallback Property: `spark.sql.adaptive.shuffle.targetPostShuffleInputSize`

Use [SQLConf.ADVISORY_PARTITION_SIZE_IN_BYTES](../SQLConf.md#ADVISORY_PARTITION_SIZE_IN_BYTES) to reference the name.

## autoBroadcastJoinThreshold { #spark.sql.adaptive.autoBroadcastJoinThreshold }

**spark.sql.adaptive.autoBroadcastJoinThreshold**

The maximum size (in bytes) of a table to be broadcast when performing a join. `-1` turns broadcasting off. The default value is same as [spark.sql.autoBroadcastJoinThreshold](#spark.sql.autoBroadcastJoinThreshold).

Used only in [Adaptive Query Execution](../adaptive-query-execution/index.md)

Default: (undefined)

Available as [SQLConf.ADAPTIVE_AUTO_BROADCASTJOIN_THRESHOLD](../SQLConf.md#ADAPTIVE_AUTO_BROADCASTJOIN_THRESHOLD) value.

## coalescePartitions.enabled { #spark.sql.adaptive.coalescePartitions.enabled }

**spark.sql.adaptive.coalescePartitions.enabled**

Controls coalescing shuffle partitions

When `true` and [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) is enabled, Spark will coalesce contiguous shuffle partitions according to the target size (specified by [spark.sql.adaptive.advisoryPartitionSizeInBytes](#spark.sql.adaptive.advisoryPartitionSizeInBytes)), to avoid too many small tasks.

Default: `true`

Use [SQLConf.coalesceShufflePartitionsEnabled](../SQLConf.md#coalesceShufflePartitionsEnabled) method to access the current value.

## coalescePartitions.minPartitionSize { #spark.sql.adaptive.coalescePartitions.minPartitionSize }

**spark.sql.adaptive.coalescePartitions.minPartitionSize**

The minimum size (in bytes unless specified) of shuffle partitions after coalescing. This is useful when the adaptively calculated target size is too small during partition coalescing

Default: `1MB`

Use [SQLConf.coalesceShufflePartitionsEnabled](../SQLConf.md#coalesceShufflePartitionsEnabled) method to access the current value.

## <span id="COALESCE_PARTITIONS_MIN_PARTITION_SIZE"><span id="COALESCE_PARTITIONS_MIN_PARTITION_NUM"> coalescePartitions.minPartitionSize { #spark.sql.adaptive.coalescePartitions.minPartitionSize }

**spark.sql.adaptive.coalescePartitions.minPartitionSize**

The minimum size (in bytes) of shuffle partitions after coalescing.

Useful when the adaptively calculated target size is too small during partition coalescing.

Default: `(undefined)`

Must be positive

Used when:

* [CoalesceShufflePartitions](../physical-optimizations/CoalesceShufflePartitions.md) adaptive physical optimization is executed

## coalescePartitions.initialPartitionNum { #spark.sql.adaptive.coalescePartitions.initialPartitionNum }

**spark.sql.adaptive.coalescePartitions.initialPartitionNum**

The initial number of shuffle partitions before coalescing.

By default it equals to [spark.sql.shuffle.partitions](#spark.sql.shuffle.partitions).
If not set, the default value is the default parallelism of the Spark cluster.
This configuration only has an effect when [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) and [spark.sql.adaptive.coalescePartitions.enabled](#spark.sql.adaptive.coalescePartitions.enabled) are both enabled.

Default: `(undefined)`

## coalescePartitions.parallelismFirst { #spark.sql.adaptive.coalescePartitions.parallelismFirst }

**spark.sql.adaptive.coalescePartitions.parallelismFirst**

When `true`, Spark does not respect the target size specified by [spark.sql.adaptive.advisoryPartitionSizeInBytes](#spark.sql.adaptive.advisoryPartitionSizeInBytes) when coalescing contiguous shuffle partitions, but adaptively calculate the target size according to the default parallelism of the Spark cluster. The calculated size is usually smaller than the configured target size. This is to maximize the parallelism and avoid performance regression when enabling adaptive query execution. It's recommended to set this config to `false` and respect the configured target size.

Default: `true`

Use [SQLConf.coalesceShufflePartitionsEnabled](../SQLConf.md#coalesceShufflePartitionsEnabled) method to access the current value.

## customCostEvaluatorClass { #spark.sql.adaptive.customCostEvaluatorClass }

**spark.sql.adaptive.customCostEvaluatorClass**

The fully-qualified class name of the [CostEvaluator](../adaptive-query-execution/CostEvaluator.md) in [Adaptive Query Execution](../adaptive-query-execution/index.md)

Default: [SimpleCostEvaluator](../adaptive-query-execution/SimpleCostEvaluator.md)

Use [SQLConf.ADAPTIVE_CUSTOM_COST_EVALUATOR_CLASS](../SQLConf.md#ADAPTIVE_CUSTOM_COST_EVALUATOR_CLASS) method to access the property (in a type-safe way).

Used when:

* `AdaptiveSparkPlanExec` physical operator is requested for the [AQE cost evaluator](../physical-operators/AdaptiveSparkPlanExec.md#costEvaluator)

## enabled { #spark.sql.adaptive.enabled }

**spark.sql.adaptive.enabled**

Enables [Adaptive Query Execution](../adaptive-query-execution/index.md)

Default: `true`

Use [SQLConf.adaptiveExecutionEnabled](../SQLConf.md#adaptiveExecutionEnabled) method to access the current value.

## fetchShuffleBlocksInBatch { #spark.sql.adaptive.fetchShuffleBlocksInBatch }

**spark.sql.adaptive.fetchShuffleBlocksInBatch**

**(internal)** Whether to fetch the contiguous shuffle blocks in batch. Instead of fetching blocks one by one, fetching contiguous shuffle blocks for the same map task in batch can reduce IO and improve performance. Note, multiple contiguous blocks exist in single "fetch request only happen when [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) and [spark.sql.adaptive.coalescePartitions.enabled](#spark.sql.adaptive.coalescePartitions.enabled) are both enabled. This feature also depends on a relocatable serializer, the concatenation support codec in use and the new version shuffle fetch protocol.

Default: `true`

Use [SQLConf.fetchShuffleBlocksInBatch](../SQLConf.md#fetchShuffleBlocksInBatch) method to access the current value.

## forceApply { #spark.sql.adaptive.forceApply }

**spark.sql.adaptive.forceApply**

**(internal)** When `true` (together with [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) enabled), Spark will [force apply adaptive query execution for all supported queries](../physical-optimizations/InsertAdaptiveSparkPlan.md#shouldApplyAQE).

Default: `false`

Use [SQLConf.ADAPTIVE_EXECUTION_FORCE_APPLY](../SQLConf.md#ADAPTIVE_EXECUTION_FORCE_APPLY) method to access the property (in a type-safe way).

## forceOptimizeSkewedJoin { #spark.sql.adaptive.forceOptimizeSkewedJoin }

**spark.sql.adaptive.forceOptimizeSkewedJoin**

Enables [OptimizeSkewedJoin](../physical-optimizations/OptimizeSkewedJoin.md) physical optimization to be executed even if it introduces extra shuffle

Default: `false`

Requires [spark.sql.adaptive.skewJoin.enabled](#spark.sql.adaptive.skewJoin.enabled) to be enabled

Use [SQLConf.ADAPTIVE_FORCE_OPTIMIZE_SKEWED_JOIN](../SQLConf.md#ADAPTIVE_FORCE_OPTIMIZE_SKEWED_JOIN) to access the property (in a type-safe way).

Used when:

* `AdaptiveSparkPlanExec` physical operator is requested for the [AQE cost evaluator](../physical-operators/AdaptiveSparkPlanExec.md#costEvaluator) (and creates a [SimpleCostEvaluator](../physical-operators/AdaptiveSparkPlanExec.md#costEvaluator))
* [OptimizeSkewedJoin](../physical-optimizations/OptimizeSkewedJoin.md) physical optimization is executed

## localShuffleReader.enabled { #spark.sql.adaptive.localShuffleReader.enabled }

**spark.sql.adaptive.localShuffleReader.enabled**

When `true` (and [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) is `true`), Spark SQL tries to use local shuffle reader to read the shuffle data when the shuffle partitioning is not needed, for example, after converting sort-merge join to broadcast-hash join.

Default: `true`

Use [SQLConf.LOCAL_SHUFFLE_READER_ENABLED](../SQLConf.md#LOCAL_SHUFFLE_READER_ENABLED) to access the property (in a type-safe way)

## logLevel { #spark.sql.adaptive.logLevel }

**spark.sql.adaptive.logLevel**

**(internal)** Log level for adaptive execution logging of plan changes. The value can be `TRACE`, `DEBUG`, `INFO`, `WARN` or `ERROR`.

Default: `DEBUG`

Use [SQLConf.adaptiveExecutionLogLevel](../SQLConf.md#adaptiveExecutionLogLevel) for the current value

## maxShuffledHashJoinLocalMapThreshold { #spark.sql.adaptive.maxShuffledHashJoinLocalMapThreshold }

**spark.sql.adaptive.maxShuffledHashJoinLocalMapThreshold**

The maximum size (in bytes) per partition that can be allowed to build local hash map. If this value is not smaller than [spark.sql.adaptive.advisoryPartitionSizeInBytes](#spark.sql.adaptive.advisoryPartitionSizeInBytes) and all the partition size are not larger than this config, join selection prefer to use shuffled hash join instead of sort merge join regardless of the value of [spark.sql.join.preferSortMergeJoin](#spark.sql.join.preferSortMergeJoin).

Default: `0`

Available as [SQLConf.ADAPTIVE_MAX_SHUFFLE_HASH_JOIN_LOCAL_MAP_THRESHOLD](../SQLConf.md#ADAPTIVE_MAX_SHUFFLE_HASH_JOIN_LOCAL_MAP_THRESHOLD)

## nonEmptyPartitionRatioForBroadcastJoin { #spark.sql.adaptive.nonEmptyPartitionRatioForBroadcastJoin }

**spark.sql.adaptive.nonEmptyPartitionRatioForBroadcastJoin**

**(internal)** A relation with a non-empty partition ratio (the number of non-empty partitions to all partitions) lower than this config will not be considered as the build side of a broadcast-hash join in [Adaptive Query Execution](../adaptive-query-execution/index.md) regardless of the size.

Effective with [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) `true`

Default: `0.2`

Use [SQLConf.nonEmptyPartitionRatioForBroadcastJoin](../SQLConf.md#nonEmptyPartitionRatioForBroadcastJoin) method to access the current value.

## <span id="ADAPTIVE_OPTIMIZER_EXCLUDED_RULES"> optimizer.excludedRules { #spark.sql.adaptive.optimizer.excludedRules }

**spark.sql.adaptive.optimizer.excludedRules**

A comma-separated list of rules (names) to be disabled (_excluded_) in the [AQE Logical Optimizer](../adaptive-query-execution/AQEOptimizer.md)

Default: undefined

Use [SQLConf.ADAPTIVE_OPTIMIZER_EXCLUDED_RULES](../SQLConf.md#ADAPTIVE_OPTIMIZER_EXCLUDED_RULES) to reference the property.

Used when:

* `AQEOptimizer` is requested for the [batches](../adaptive-query-execution/AQEOptimizer.md#batches)

## optimizeSkewsInRebalancePartitions.enabled { #spark.sql.adaptive.optimizeSkewsInRebalancePartitions.enabled }

When `true` and [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) is `true`, Spark SQL will optimize the skewed shuffle partitions in RebalancePartitions and split them to smaller ones according to the target size (specified by [spark.sql.adaptive.advisoryPartitionSizeInBytes](#spark.sql.adaptive.advisoryPartitionSizeInBytes)), to avoid data skew

Default: `true`

Use [SQLConf.ADAPTIVE_OPTIMIZE_SKEWS_IN_REBALANCE_PARTITIONS_ENABLED](../SQLConf.md#ADAPTIVE_OPTIMIZE_SKEWS_IN_REBALANCE_PARTITIONS_ENABLED) method to access the property (in a type-safe way)

## skewJoin.enabled { #spark.sql.adaptive.skewJoin.enabled }

**spark.sql.adaptive.skewJoin.enabled**

When `true` and [spark.sql.adaptive.enabled](#spark.sql.adaptive.enabled) is enabled, Spark dynamically handles skew in sort-merge join by splitting (and replicating if needed) skewed partitions.

Default: `true`

Use [SQLConf.SKEW_JOIN_ENABLED](../SQLConf.md#SKEW_JOIN_ENABLED) to reference the property.

## skewJoin.skewedPartitionFactor { #spark.sql.adaptive.skewJoin.skewedPartitionFactor }

**spark.sql.adaptive.skewJoin.skewedPartitionFactor**

A partition is considered skewed if its size is larger than this factor multiplying the median partition size and also larger than [spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes](#spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes).

Default: `5`

## skewJoin.skewedPartitionThresholdInBytes { #spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes }

**spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes**

A partition is considered skewed if its size in bytes is larger than this threshold and also larger than [spark.sql.adaptive.skewJoin.skewedPartitionFactor](#spark.sql.adaptive.skewJoin.skewedPartitionFactor) multiplying the median partition size. Ideally this config should be set larger than [spark.sql.adaptive.advisoryPartitionSizeInBytes](#spark.sql.adaptive.advisoryPartitionSizeInBytes).

Default: `256MB`
