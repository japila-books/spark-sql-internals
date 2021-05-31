# DataSourceV2Implicits

`DataSourceV2Implicits` is a Scala object with the following Scala implicit classes:

* [MetadataColumnHelper](MetadataColumnHelper.md)
* [MetadataColumnsHelper](MetadataColumnsHelper.md)
* [OptionsHelper](OptionsHelper.md)
* [PartitionSpecsHelper](PartitionSpecsHelper.md)
* [TableHelper](TableHelper.md)

`DataSourceV2Implicits` is part of the `org.apache.spark.sql.execution.datasources.v2` package.

```scala
import org.apache.spark.sql.execution.datasources.v2.DataSourceV2Implicits
```

## <span id="METADATA_COL_ATTR_KEY"> __metadata_col

`DataSourceV2Implicits` defines `__metadata_col` key that is used by the implicit classes:

* [MetadataColumnsHelper](MetadataColumnsHelper.md) when requested to [asStruct](MetadataColumnsHelper.md#asStruct)
* [MetadataColumnHelper](MetadataColumnHelper.md) when requested to [isMetadataCol](MetadataColumnHelper.md#isMetadataCol)
