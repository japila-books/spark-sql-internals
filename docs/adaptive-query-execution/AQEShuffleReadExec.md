# AQEShuffleReadExec Unary Physical Operator

`AQEShuffleReadExec` is a [unary physical operator](../physical-operators/UnaryExecNode.md).

## Creating Instance

`AQEShuffleReadExec` takes the following to be created:

* <span id="child"> Child [physical operator](../physical-operators/SparkPlan.md)
* <span id="partitionSpecs"> `ShufflePartitionSpec`s (requires at least one partition)

`AQEShuffleReadExec` is created when the following adaptive physical optimizations are executed:

* [CoalesceShufflePartitions](CoalesceShufflePartitions.md#updateShuffleReads)
* [OptimizeShuffleWithLocalRead](OptimizeShuffleWithLocalRead.md#createLocalRead)
* [OptimizeSkewedJoin](OptimizeSkewedJoin.md#tryOptimizeJoinChildren)
* [OptimizeSkewInRebalancePartitions](OptimizeSkewInRebalancePartitions.md#tryOptimizeSkewedPartitions)
