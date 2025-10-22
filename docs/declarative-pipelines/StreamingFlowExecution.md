# StreamingFlowExecution

`StreamingFlowExecution` is an [extension](#contract) of the [FlowExecution](FlowExecution.md) abstraction for [streaming flow executions](#implementations) that process data statefully using [Spark Structured Streaming]({{ book.structured_streaming }}).

## Contract (Subset)

### Checkpoint Location { #checkpointPath }

```scala
checkpointPath: String
```

Used when:

* `StreamingTableWrite` is requested to [start a streaming query](StreamingTableWrite.md#startStream)

### Start Streaming Query { #startStream }

```scala
startStream(): StreamingQuery
```

See:

* [SinkWrite](SinkWrite.md#startStream)
* [StreamingTableWrite](StreamingTableWrite.md#startStream)

Used when:

* `StreamingFlowExecution` is requested to [executeInternal](#executeInternal)

### Streaming Trigger { #trigger }

```scala
trigger: Trigger
```

`Trigger` ([Structured Streaming]({{ book.structured_streaming }}/Trigger))

See:

* [SinkWrite](SinkWrite.md#trigger)
* [StreamingTableWrite](StreamingTableWrite.md#trigger)

Used when:

* `FlowPlanner` is requested to [plan a StreamingFlow](FlowPlanner.md#plan)
* `StreamingTableWrite` is requested to [execute the streaming query](StreamingTableWrite.md#startStream)

## Implementations

* [SinkWrite](SinkWrite.md)
* [StreamingTableWrite](StreamingTableWrite.md)

## executeInternal { #executeInternal }

??? note "FlowExecution"

    ```scala
    executeInternal(): Future[Unit]
    ```

    `executeInternal` is part of the [FlowExecution](FlowExecution.md#executeInternal) abstraction.

`executeInternal` prints out the following INFO message to the logs:

```text
Starting [identifier] with checkpoint location [checkpointPath]
```

`executeInternal` [starts the stream](#startStream) (with this [SparkSession](FlowExecution.md#spark) and [sqlConf](#sqlConf)).

In the end, `executeInternal` awaits termination of the `StreamingQuery`.

??? note "Final Method"
    `executeInternal` is a Scala **final method** and may not be overridden in [subclasses](#implementations).

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#final).
