# MetricViewPlanner

## planRead { #planRead }

```scala
planRead(
  metadata: CatalogTable,
  yaml: String,
  sqlParser: ParserInterface,
  expectedSchema: StructType): MetricViewPlaceholder
```

`planRead`...FIXME

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

`planWrite`...FIXME

---

`planWrite` is used when:

* `MetricViewHelper` is requested to [analyzeMetricViewText](MetricViewHelper.md#analyzeMetricViewText)

## parseYAML { #parseYAML }

```scala
parseYAML(
  yaml: String,
  sqlParser: ParserInterface): (MetricView, LogicalPlan)
```

`parseYAML`...FIXME

---

`parseYAML` is used when:

* `MetricViewPlanner` is requested to [planRead](#planRead) and [planWrite](#planWrite)
