# MetadataColumn

`MetadataColumn` is an [abstraction](#contract) of [metadata columns](#implementations) that can expose additional metadata about a row.

Use [DESCRIBE TABLE EXTENDED](../sql/AstBuilder.md#visitDescribeRelation) SQL command to display the metadata columns of a table.

## Contract

### <span id="comment"> comment

```java
String comment()
```

Documentation of this metadata column

Default: `null`

### <span id="dataType"> dataType

```java
DataType dataType()
```

### <span id="isNullable"> isNullable

```java
boolean isNullable()
```

Default: `true`

### <span id="name"> name

```java
String name()
```

### <span id="transform"> transform

```java
Transform transform()
```

Produces this metadata column from data rows

Default: `null`

## <span id="SupportsMetadataColumns"> SupportsMetadataColumns

`MetadataColumn`s are supported by [Table](Table.md)s with [SupportsMetadataColumns](SupportsMetadataColumns.md).

## <span id="MetadataColumnsHelper"> MetadataColumnsHelper

`MetadataColumn`s can be converted (_implicitly_) to [StructType](../StructType.md)s or [AttributeReference](../expressions/AttributeReference.md)s using [MetadataColumnsHelper](MetadataColumnsHelper.md) implicit class.

## <span id="DataSourceV2Relation"> DataSourceV2Relation

`MetadataColumn`s are disregarded (_filtered out_) from the [metadataOutput](../logical-operators/LogicalPlan.md#metadataOutput) in [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md) leaf logical operator when in name-conflict with output columns.
