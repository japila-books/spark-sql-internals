# MetadataBuilder

`MetadataBuilder` is used to describe how to [create a Metadata](#build) (using _Fluent API_).

??? note "Fluent API"
    Learn more about [Fluent interface](https://en.wikipedia.org/wiki/Fluent_interface) design pattern in Wikipedia, the free encyclopedia.

```scala
import org.apache.spark.sql.types.MetadataBuilder

val newMetadata = new MetadataBuilder()
  .withMetadata(attr.metadata)
  .putNull("__is_duplicate")
  .build()
```

## Creating Metadata { #build }

```scala
build(): Metadata
```

`build` creates a [Metadata](Metadata.md) (for the internal [map](#map)).

## withMetadata { #withMetadata }

```scala
withMetadata(
  metadata: Metadata): this.type
```

`withMetadata` adds the [map](Metadata.md#map) of the given [Metadata](Metadata.md) to the internal [map](#map).

In the end, `withMetadata` returns this `MetadataBuilder`.

---

`withMetadata` is used when:

* `FileSourceConstantMetadataStructField` is requested for `metadata`
* `FileSourceGeneratedMetadataStructField` is requested for `metadata`
* `FileSourceMetadataAttribute` is requested for `metadata` and `removeInternalMetadata`
* `MetadataColumnHelper` is requested to [markAsAllowAnyAccess](../metadata-columns/MetadataColumnHelper.md#markAsAllowAnyAccess) and [markAsQualifiedAccessOnly](../metadata-columns/MetadataColumnHelper.md#markAsQualifiedAccessOnly)
* [ResolveDefaultColumns](../logical-analysis-rules/ResolveDefaultColumns.md) logical resolution rule is executed (to [constantFoldCurrentDefaultsToExistDefaults](../logical-analysis-rules/ResolveDefaultColumns.md#constantFoldCurrentDefaultsToExistDefaults))
* `StructField` is requested to [remove](StructField.md#clearCurrentDefaultValue) or [update the CURRENT_DEFAULT metadata attribute](StructField.md#withCurrentDefaultValue), and [update EXISTS_DEFAULT metadata attribute](StructField.md#withExistenceDefaultValue)
* _others_
