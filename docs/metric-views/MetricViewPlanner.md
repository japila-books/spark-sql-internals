# MetricViewPlanner

## planRead { #planRead }

```scala
planRead(
  metadata: CatalogTable,
  yaml: String,
  sqlParser: ParserInterface,
  expectedSchema: StructType): MetricViewPlaceholder
```

`planRead` [creates a MetricView](#parseYAML) (from the given `yaml` text).

In the end, `planRead` returns a `MetricViewPlaceholder`.

---

`planRead` is used when:

* `SessionCatalog` is requested to [parse a metric view definition](../SessionCatalog.md#parseMetricViewDefinition)

## planWrite { #planWrite }

```scala
planWrite(
  metadata: CatalogTable,
  yaml: String,
  sqlParser: ParserInterface): (MetricViewPlaceholder, MetricView)
```

`planWrite` [creates a MetricView](#parseYAML) (from the given `yaml` text).

In the end, `planWrite` returns a `MetricViewPlaceholder` with `isCreate` flag enabled (to differentiate `planWrite` from [planRead](#planRead)) and the `MetricView`.

---

`planWrite` is used when:

* `MetricViewHelper` is requested to [analyzeMetricViewText](MetricViewHelper.md#analyzeMetricViewText)

## Create MetricView from YAML Definition File { #parseYAML }

```scala
parseYAML(
  yaml: String,
  sqlParser: ParserInterface): (MetricView, LogicalPlan)
```

`parseYAML` [creates a MetricView from YAML definition](MetricViewFactory.md#fromYAML).

---

`parseYAML` is used when:

* `MetricViewPlanner` is requested to [planRead](#planRead) and [planWrite](#planWrite)
