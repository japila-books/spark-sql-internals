# MetricViewHelper

## analyzeMetricViewText { #analyzeMetricViewText }

```scala
analyzeMetricViewText(
  session: SparkSession,
  nameParts: Seq[String],
  viewText: String): (LogicalPlan, MetricView)
```

`analyzeMetricViewText`...FIXME

---

`analyzeMetricViewText` is used when:

* `CreateMetricViewCommand` is requested to [createMetricViewInSessionCatalog](CreateMetricViewCommand.md#createMetricViewInSessionCatalog)
* `DataSourceV2Strategy` is requested to [plan a CreateMetricView unary logical operator](../execution-planning-strategies/DataSourceV2Strategy.md#apply)
