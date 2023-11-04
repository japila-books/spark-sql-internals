# MetadataAttribute

`MetadataAttribute` is an `AttributeReference` with [__metadata_col](index.md#METADATA_COL_ATTR_KEY) internal metadata.

## Creating Metadata AttributeReference { #apply }

```scala
apply(
  name: String,
  dataType: DataType,
  nullable: Boolean = true): AttributeReference
```

`apply` creates an `AttributeReference` with [__metadata_col](index.md#METADATA_COL_ATTR_KEY) metadata (and `true` value).

## Destructuring Metadata AttributeReference { #unapply }

```scala
unapply(
  attr: AttributeReference): Option[AttributeReference]
```

`unapply` returns the given `AttributeReference` if contains [__metadata_col](index.md#METADATA_COL_ATTR_KEY) metadata key with `true` value. Otherwise, `unapply` returns `None` (an undefined value).

---

`unapply` is used when:

* `FileSourceMetadataAttribute` is requested to [destructure an AttributeReference](../metadata-columns/FileSourceMetadataAttribute.md#unapply)
* `ReplaceData` is requested for the [dataInput](../logical-operators/ReplaceData.md#dataInput)

## isValid { #isValid }

```scala
isValid(
  metadata: Metadata): Boolean
```

`isValid` holds `true` when the given [Metadata](../types/Metadata.md) contains the [__metadata_col](index.md#METADATA_COL_ATTR_KEY) entry.

---

`isValid` is used when:

* `RewriteMergeIntoTable` logical rule is requested to `buildWriteDeltaMergeRowsPlan`
* `RewriteUpdateTable` logical rule is requested to `buildReplaceDataUpdateProjection` and `buildDeletesAndInserts`
* `MetadataAttribute` is requested to [unapply](#unapply)
* `FileSourceMetadataAttribute` is requested to [isValid](../metadata-columns/FileSourceMetadataAttribute.md#isValid)
* `MetadataColumnHelper` is requested to [isMetadataCol](../metadata-columns/MetadataColumnHelper.md#isMetadataCol)
