# Sink

`Sink` is an [extension](#contract) of the [GraphElement](GraphElement.md) and [Output](Output.md) abstractions for [pipeline sinks](#implementations) that can define their [write format](#format) and [options](#options).

## Contract

### Format { #format }

```scala
format: String
```

Used when:

* `PipelinesHandler` is requested to [define a sink (output)](PipelinesHandler.md#defineOutput)
* `SinkWrite` is requested to [start a stream](SinkWrite.md#startStream)

### Options { #options }

```scala
options: Map[String, String]
```

Used when:

* `PipelinesHandler` is requested to [define a sink (output)](PipelinesHandler.md#defineOutput)
* `SinkWrite` is requested to [start a stream](SinkWrite.md#startStream)

## Implementations

* [SinkImpl](SinkImpl.md)
