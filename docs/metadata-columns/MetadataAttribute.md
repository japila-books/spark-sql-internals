# MetadataAttribute

## Creating Metadata AttributeReference { #apply }

```scala
apply(
  name: String,
  dataType: DataType,
  nullable: Boolean = true): AttributeReference
```

`apply` creates an `AttributeReference` with [__metadata_col](#METADATA_COL_ATTR_KEY) metadata (and `true` value).

## Destructuring Metadata AttributeReference { #unapply }

```scala
unapply(
  attr: AttributeReference): Option[AttributeReference]
```

`unapply` returns the given `AttributeReference` if contains [__metadata_col](#METADATA_COL_ATTR_KEY) metadata key with `true` value. Otherwise, `unapply` returns `None` (an undefined value).

---

`unapply` is used when:

* `FileSourceMetadataAttribute` is requested to [destructure an AttributeReference](FileSourceMetadataAttribute.md#unapply)
* `ReplaceData` is requested for the [dataInput](../logical-operators/ReplaceData.md#dataInput)
