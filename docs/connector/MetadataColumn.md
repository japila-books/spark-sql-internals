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

## <span id="MetadataColumnsHelper"> MetadataColumnsHelper

`MetadataColumn`s can be converted (_implicitly_) to [StructType](../StructType.md)s or [AttributeReference](../expressions/AttributeReference.md)s using [MetadataColumnsHelper](MetadataColumnsHelper.md) implicit class.
