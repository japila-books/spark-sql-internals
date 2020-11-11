# NoopWriteBuilder

`NoopWriteBuilder` is a [WriteBuilder](../../connector/WriteBuilder.md) with [SupportsTruncate](../../connector/SupportsTruncate.md) and `SupportsStreamingUpdate`.

## <span id="truncate"> truncate

```scala
truncate(): WriteBuilder
```

`truncate` simply returns this `NoopWriteBuilder`.

`truncate` is part of the [SupportsTruncate](../../connector/SupportsTruncate.md#truncate) abstraction.

## <span id="update"> update

```scala
update(): WriteBuilder
```

`update` simply returns this `NoopWriteBuilder`.

`update` is part of the `SupportsStreamingUpdate` abstraction.

## <span id="buildForBatch"> buildForBatch

```scala
buildForBatch(): BatchWrite
```

`buildForBatch` gives a [NoopBatchWrite](NoopBatchWrite.md).

`buildForBatch` is part of the [WriteBuilder](../../connector/WriteBuilder.md#buildForBatch) abstraction.

## <span id="buildForStreaming"> buildForStreaming

```scala
buildForStreaming(): StreamingWrite
```

`buildForStreaming` gives a [NoopStreamingWrite](NoopStreamingWrite.md).

`buildForStreaming` is part of the [WriteBuilder](../../connector/WriteBuilder.md#buildForStreaming) abstraction.
