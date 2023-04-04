---
title: MetadataColumnsHelper
---

# MetadataColumnsHelper Implicit Class

`MetadataColumnsHelper` is a Scala implicit class for [Array[MetadataColumn]](#metadata).

## Creating Instance

`MetadataColumnsHelper` takes the following to be created:

* <span id="metadata"> [MetadataColumn](../connector/catalog/MetadataColumn.md)s

## <span id="asStruct"> asStruct

```scala
asStruct: StructType
```

`asStruct` creates a [StructType](../types/StructType.md) for the [MetadataColumns](#metadata).

`asStruct` is used when:

* FIXME
