# DefaultCachedBatchSerializer

`DefaultCachedBatchSerializer` is a [SimpleMetricsCachedBatchSerializer](SimpleMetricsCachedBatchSerializer.md).

## <span id="supportsColumnarInput"> supportsColumnarInput

??? note "Signature"

    ```scala
    supportsColumnarInput(
      schema: Seq[Attribute]): Boolean
    ```

    `supportsColumnarInput` is part of the [CachedBatchSerializer](CachedBatchSerializer.md#supportsColumnarInput) abstraction.

`supportsColumnarInput` is `false`.

## <span id="supportsColumnarOutput"> supportsColumnarOutput

??? note "Signature"

    ```scala
    supportsColumnarOutput(
      schema: StructType): Boolean
    ```

    `supportsColumnarOutput` is part of the [CachedBatchSerializer](CachedBatchSerializer.md#supportsColumnarOutput) abstraction.

`supportsColumnarOutput` is `true` when all the [fields](../types/StructType.md#fields) of the given [schema](../types/StructType.md) are of the following types:

* `BooleanType`
* `ByteType`
* `DoubleType`
* `FloatType`
* `IntegerType`
* `LongType`
* `ShortType`
