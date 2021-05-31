# MetadataColumnHelper Implicit Class

`MetadataColumnHelper` is a Scala implicit class for [Attribute](#attr).

## Creating Instance

`MetadataColumnHelper` takes the following to be created:

* <span id="attr"> [Attribute](../expressions/Attribute.md)

## <span id="isMetadataCol"> isMetadataCol

```scala
isMetadataCol: Boolean
```

`isMetadataCol` takes the [Metadata](../expressions/NamedExpression.md#metadata) of the [Attribute](#attr) and checks if there is the [__metadata_col](DataSourceV2Implicits.md#METADATA_COL_ATTR_KEY) key with `true` value.

`isMetadataCol` is used when:

* [AddMetadataColumns](../logical-analysis-rules/AddMetadataColumns.md) logical resolution rule is executed
