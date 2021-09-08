# AQEUtils

## <span id="getRequiredDistribution"> Getting Required Distribution

```scala
getRequiredDistribution(
  p: SparkPlan): Option[Distribution]
```

`getRequiredDistribution` determines the [Distribution](../physical-operators/Distribution.md) for the given [SparkPlan](../physical-operators/SparkPlan.md) (if there are any user-specified repartition hints):

* For [ShuffleExchangeExec](../physical-operators/ShuffleExchangeExec.md) physical operators with [HashPartitioning](../expressions/HashPartitioning.md) and [REPARTITION_BY_COL](ShuffleOrigin.md#REPARTITION_BY_COL) or [REPARTITION_BY_NUM](ShuffleOrigin.md#REPARTITION_BY_NUM) shuffle origins, `getRequiredDistribution` returns a [HashClusteredDistribution](../physical-operators/HashClusteredDistribution.md)

* For [FilterExec](../physical-operators/FilterExec.md), ([non-global](../physical-operators/SortExec.md#global)) [SortExec](../physical-operators/SortExec.md) and [CollectMetricsExec](../physical-operators/CollectMetricsExec.md) physical operators, `getRequiredDistribution` skips them and determines the required distribution using their child operator

* For [ProjectExec](../physical-operators/ProjectExec) physical operators, `getRequiredDistribution` finds a [HashClusteredDistribution](../physical-operators/HashClusteredDistribution.md) using the [child](../physical-operators/ProjectExec#child)

* For all other operators, `getRequiredDistribution` returns the [UnspecifiedDistribution](../physical-operators/UnspecifiedDistribution.md)

`getRequiredDistribution` is used when:

* `AdaptiveSparkPlanExec` physical operator is requested for the [required distribution](AdaptiveSparkPlanExec.md#requiredDistribution)
