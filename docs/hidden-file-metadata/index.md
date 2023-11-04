# Hidden File Metadata

**Hidden File Metadata** allows users to query the metadata of the input files for all file formats, expose them as built-in hidden columns meaning users can only see them when they explicitly reference them (e.g. file path, file name).

[MetadataAttribute](MetadataAttribute.md) is an `AttributeReference` with [__metadata_col](#METADATA_COL_ATTR_KEY) internal metadata.

Hidden File Metadata was introduced in [Spark SQL 3.3.0]({{ spark.jira }}/SPARK-37273).

!!! note "Metadata Columns"
    Hidden File Metadata is a subset of [Metadata Columns](../metadata-columns/index.md) supporting exclusively [file-based connectors](../connectors/FileTable.md).

## \_\_metadata_col Internal Metadata { #METADATA_COL_ATTR_KEY }

`__metadata_col` is the name of an internal [metadata](#metadata) (key).

`__metadata_col` is associated with the [name](../expressions/NamedExpression.md#name) of an [Attribute](../expressions/Attribute.md) when [markAsQualifiedAccessOnly](../metadata-columns/MetadataColumnHelper.md#markAsQualifiedAccessOnly).

`__metadata_col` is removed when [removing internal metadata](../metadata-columns/FileSourceMetadataAttribute.md#removeInternalMetadata).

`__metadata_col` is used when:

* `MetadataAttribute` is requested to [isValid](MetadataAttribute.md#isValid)
* `MetadataAttributeWithLogicalName` is requested to `unapply`
