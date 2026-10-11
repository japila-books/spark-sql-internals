# MetricViewBase

`MetricViewBase` is an [abstraction](#contract) of [metric views](#implementations).

## Contract (Subset)

### Version { #version }

```scala
version: String
```

Version of this [metric view](./index.md)

Used when:

* `MetricViewFactory` is requested to [serialize a MetricView (to YAML)](MetricViewFactory.md#toYAML)

## Implementations

* [MetricViewV01](MetricViewV01.md)

## toCanonical { #toCanonical }

```scala
toCanonical: MetricView
```

`toCanonical`...FIXME

---

`toCanonical` is used when:

* `MetricViewFactory` is requested to [fromYAML](MetricViewFactory.md#fromYAML)
