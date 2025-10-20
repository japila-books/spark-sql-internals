# SinkImpl

`SinkImpl` is a [Sink](Sink.md).

## Creating Instance

`SinkImpl` takes the following to be created:

* <span id="identifier"> [TableIdentifier](GraphElement.md#identifier)
* <span id="format"> [Format](Sink.md#format)
* <span id="options"> [Options](Sink.md#options)
* <span id="origin"> [QueryOrigin](GraphElement.md#origin)

`SinkImpl` is created when:

* `PipelinesHandler` is requested to [defineOutput](PipelinesHandler.md#defineOutput)
