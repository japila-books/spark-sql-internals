# ArrayType

`ArrayType` is a [DataType](DataType.md).

## Creating Instance

`ArrayType` takes the following to be created:

* <span id="elementType"> [DataType](DataType.md) of the elements
* <span id="containsNull"> `containsNull` flag

## <span id="defaultSize"> defaultSize

```scala
defaultSize: Int
```

`defaultSize` is part of the [DataType](DataType.md#defaultSize) abstraction.

`defaultSize` is the [defaultSize](DataType.md#defaultSize) of the [elementType](#elementType).

## <span id="jsonValue"> jsonValue

```scala
jsonValue: JValue
```

`jsonValue` is part of the [DataType](DataType.md#jsonValue) abstraction.

`jsonValue`...FIXME

## <span id="simpleString"> Simple Representation

```scala
simpleString: String
```

`simpleString` is part of the [DataType](DataType.md#simpleString) abstraction.

`simpleString` is the following:

```text
array<[elementType]>
```

## <span id="catalogString"> Catalog Representation

```scala
catalogString: String
```

`catalogString` is part of the [DataType](DataType.md#catalogString) abstraction.

`catalogString` is the following:

```text
array<[elementType]>
```

## <span id="sql"> SQL Representation

```scala
sql: String
```

`sql` is part of the [DataType](DataType.md#sql) abstraction.

`sql` is the following:

```text
ARRAY<[elementType]>
```
