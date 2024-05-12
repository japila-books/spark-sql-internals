---
title: MetadataColumnHelper
---

# MetadataColumnHelper Implicit Class

`MetadataColumnHelper` is a Scala implicit class of [Attribute](#attr) class.

## Creating Instance

`MetadataColumnHelper` takes the following to be created:

* <span id="attr"> [Attribute](../expressions/Attribute.md)

## isMetadataCol { #isMetadataCol }

```scala
isMetadataCol: Boolean
```

`isMetadataCol` takes the [Metadata](../expressions/NamedExpression.md#metadata) of the [Attribute](#attr) and checks if there is the [__metadata_col](../connector/DataSourceV2Implicits.md#METADATA_COL_ATTR_KEY) key with `true` value.

`isMetadataCol` is used when:

* [AddMetadataColumns](../logical-analysis-rules/AddMetadataColumns.md) logical resolution rule is executed

## markAsQualifiedAccessOnly { #markAsQualifiedAccessOnly }

```scala
markAsQualifiedAccessOnly(): Attribute
```

`markAsQualifiedAccessOnly` propagates hidden columns by adding the following entries to the metadata of this [Attribute](#attr):

Metadata Key | Value
-------------|------
 [__metadata_col](#METADATA_COL_ATTR_KEY) | The [name](../expressions/Attribute.md#name) of this [Attribute](#attr)
 [__qualified_access_only](index.md#QUALIFIED_ACCESS_ONLY) | `true`

---

`markAsQualifiedAccessOnly` is used when:

* `Analyzer` is requested to [commonNaturalJoinProcessing](../Analyzer.md#commonNaturalJoinProcessing)

## markAsAllowAnyAccess { #markAsAllowAnyAccess }

```scala
markAsAllowAnyAccess(): Attribute
```

Only with [qualifiedAccessOnly](#qualifiedAccessOnly) enabled, `markAsAllowAnyAccess` removes [__qualified_access_only](index.md#QUALIFIED_ACCESS_ONLY) metadata key from this [Attribute](#attr).

Otherwise, `markAsAllowAnyAccess` does nothing (a _noop_) and returns this [Attribute](#attr) intact.

---

`markAsAllowAnyAccess` is used when:

* [AddMetadataColumns](../logical-analysis-rules/AddMetadataColumns.md) logical resolution rule is executed (to [addMetadataCol](../logical-analysis-rules/AddMetadataColumns.md#addMetadataCol))
* `UnresolvedStar` expression is requested to [expand](../expressions/UnresolvedStar.md#expand)
* _others_
