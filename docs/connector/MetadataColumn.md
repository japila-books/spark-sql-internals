# MetadataColumn

`MetadataColumn` is an [abstraction](#contract) of [metadata columns](../new-and-noteworthy/metadata-columns.md) that can expose additional metadata about a row.

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

### <span id="name"> Name

```java
String name()
```

Used when:

* `MetadataColumnsHelper` implicit class is requested to [asStruct](MetadataColumnsHelper.md#asStruct)
* `DataSourceV2Relation` is requested for the [metadata columns](../logical-operators/DataSourceV2Relation.md#metadataOutput)
* `DescribeTableExec` is requested to [addMetadataColumns](../physical-operators/DescribeTableExec.md#addMetadataColumns)

### <span id="transform"> transform

```java
Transform transform()
```

[Transform](Transform.md) to produce values for this metadata column from data rows

Default: `null`

## <span id="MetadataColumnsHelper"> MetadataColumnsHelper

`MetadataColumn`s can be converted (_implicitly_) to [StructType](../types/StructType.md)s or [AttributeReference](../expressions/AttributeReference.md)s using [MetadataColumnsHelper](MetadataColumnsHelper.md) implicit class.
