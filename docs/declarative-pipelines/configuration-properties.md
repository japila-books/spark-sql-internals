# Configuration Properties

**Configuration properties** (aka **settings**) for [Spark Declarative Pipelines](index.md).

## <span id="PIPELINES_EVENT_QUEUE_CAPACITY"> event.queue.capacity { #spark.sql.pipelines.event.queue.capacity }

**spark.sql.pipelines.event.queue.capacity**

Capacity of the event queue of a pipelined execution. When the queue is full, non-terminal `PipelineEvent`s will be dropped.

Default: `1000`

Use [SQLConf.PIPELINES_EVENT_QUEUE_CAPACITY](../SQLConf.md#PIPELINES_EVENT_QUEUE_CAPACITY) to reference it

Used when:

* `PipelineEventSender` is [created](PipelineEventSender.md#queueCapacity)
