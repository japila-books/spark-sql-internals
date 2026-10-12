# Source

`Source`  is an [abstraction](#contract) of the [sources](#implementations) of [metric views](MetricView.md#from).

## Contract

### SourceType { #sourceType }

```scala
sourceType: SourceType
```

Used when:

* `MetricView` is requested for the [properties of a metric view](MetricView.md#getProperties) (to define `metric_view.from.type` property)

## Implementations

??? note "Sealed Trait"
    `Source` is a Scala **sealed trait** which means that all of the implementations are in the same compilation unit (a single file).

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#sealed).

* [AssetSource](AssetSource.md)
* `SQLSource`
