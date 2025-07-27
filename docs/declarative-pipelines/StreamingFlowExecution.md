# StreamingFlowExecution

`StreamingFlowExecution` is an [extension](#contract) of the [FlowExecution](FlowExecution.md) abstraction for [streaming flow executions](#implementations) that process data statefully using [Spark Structured Streaming]({{ book.structured_streaming }}).

## Contract

### Execute Streaming Query { #startStream }

```scala
startStream(): StreamingQuery
```

See:

* [StreamingTableWrite](StreamingTableWrite.md#startStream)

Used when:

* `StreamingFlowExecution` is requested to [executeInternal](#executeInternal)

### Streaming Trigger { #trigger }

```scala
trigger: Trigger
```

See:

* [StreamingTableWrite](StreamingTableWrite.md#trigger)

Used when:

* `FlowPlanner` is requested to [plan a StreamingFlow](FlowPlanner.md#plan)
* `StreamingTableWrite` is requested to [execute the streaming query](StreamingTableWrite.md#startStream)

## Implementations

* [StreamingTableWrite](StreamingTableWrite.md)

## executeInternal { #executeInternal }

??? note "FlowExecution"

    ```scala
    executeInternal(): Future[Unit]
    ```

    `executeInternal` is part of the [FlowExecution](FlowExecution.md#executeInternal) abstraction.

`executeInternal` prints out the following INFO message to the logs:

```text
Starting [identifier] with checkpoint location [checkpointPath]"
```

`executeInternal` [starts the stream](#startStream) (with this [SparkSession](FlowExecution.md#spark) and [sqlConf](#sqlConf)).

In the end, `executeInternal` awaits termination of the `StreamingQuery`.

??? note "Final Method"
    `executeInternal` is a Scala **final method** and may not be overridden in [subclasses](#implementations).

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#final).
