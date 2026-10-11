# MetricView

## Creating Instance

`MetricView` takes the following to be created:

* <span id="version"> Version
* <span id="from"> `from` source
* <span id="where"> Optional `where` clause
* <span id="select"> `select` columns

`MetricView` is created when:

* `MetricViewBase` is requested to [toCanonical](MetricViewBase.md#toCanonical)

## getProperties { #getProperties }

```scala
getProperties: Map[String, String]
```

`getProperties`...FIXME

---

`getProperties` is used when:

* `CreateMetricViewCommand` is requested to [createMetricViewInSessionCatalog](CreateMetricViewCommand.md#createMetricViewInSessionCatalog)
* `DataSourceV2Strategy` execution planning strategy is requested to [plan a CreateMetricView for execution](../execution-planning-strategies/DataSourceV2Strategy.md#apply)
