# PipelineEventSender

`PipelineEventSender` is used by [PipelinesHandler](PipelinesHandler.md) to [send pipelines execution progress events back to a Spark Connect client asynchronously](#sendEvent).

`PipelineEventSender` uses [spark.sql.pipelines.event.queue.capacity](./configuration-properties.md#PIPELINES_EVENT_QUEUE_CAPACITY) configuration property to control the depth of the event queue.

## Creating Instance

`PipelineEventSender` takes the following to be created:

* <span id="responseObserver"> `StreamObserver[ExecutePlanResponse]`
* <span id="sessionHolder"> `SessionHolder`

`PipelineEventSender` is created when:

* `PipelinesHandler` is requested to [start a pipeline run](PipelinesHandler.md#startRun)

## queueCapacity { #queueCapacity }

`queueCapacity` is the value of [spark.sql.pipelines.event.queue.capacity](./configuration-properties.md#PIPELINES_EVENT_QUEUE_CAPACITY) configuration property.

Used when:

* `PipelineEventSender` is requested to [shouldEnqueueEvent](#shouldEnqueueEvent)

## Send Pipeline Execution Progress Event { #sendEvent }

```scala
sendEvent(
  event: PipelineEvent): Unit
```

`sendEvent`...FIXME

---

`sendEvent` is used when:

* `PipelinesHandler` is requested to [start a pipeline run](PipelinesHandler.md#startRun)

### shouldEnqueueEvent { #shouldEnqueueEvent }

```scala
shouldEnqueueEvent(
  event: PipelineEvent): Boolean
```

`shouldEnqueueEvent`...FIXME
