# Metadata Columns

Spark 3.1.1 ([SPARK-31255](https://issues.apache.org/jira/browse/SPARK-31255)) introduced support for [MetadataColumn](../connector/catalog/MetadataColumn.md)s for additional metadata of a row.

`MetadataColumn`s can be defined for [Table](../connector/Table.md)s with [SupportsMetadataColumns](../connector/SupportsMetadataColumns.md).

Use [DESCRIBE TABLE EXTENDED](../sql/AstBuilder.md#visitDescribeRelation) SQL command to display the metadata columns of a table.

## Logical Operators

Logical operators propagate metadata columns using [metadataOutput](../logical-operators/LogicalPlan.md#metadataOutput).

[ExposesMetadataColumns](../logical-operators/ExposesMetadataColumns.md) logical operators can generate metadata columns.

## <span id="DataSourceV2Relation"> DataSourceV2Relation

`MetadataColumn`s are disregarded (_filtered out_) from the [metadataOutput](../logical-operators/LogicalPlan.md#metadataOutput) in [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md) leaf logical operator when in name-conflict with output columns.

## \_\_qualified_access_only { #QUALIFIED_ACCESS_ONLY }

`__qualified_access_only` special metadata attribute is used as a marker for qualified-access-only restriction.
