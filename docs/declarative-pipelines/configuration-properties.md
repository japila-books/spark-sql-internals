# Configuration Properties

**spark.sql.pipelines** is a family of the [Configuration Properties](../configuration-properties/index.md) for [Spark Declarative Pipelines](./index.md).

## execution.streamstate.pollingInterval { #spark.sql.pipelines.execution.streamstate.pollingInterval }

**spark.sql.pipelines.execution.streamstate.pollingInterval**

(internal) How often (in seconds) the stream state is polled for changes.
This is used to check if the stream has failed and needs to be restarted.

Default: `1`

Use [SQLConf.PIPELINES_STREAM_STATE_POLLING_INTERVAL](../SQLConf.md#PIPELINES_STREAM_STATE_POLLING_INTERVAL) to reference the name.

Use [SQLConf.streamStatePollingInterval](../SQLConf.md#streamStatePollingInterval) method to access the current value.

Used when:

* `TriggeredGraphExecution` is requested to [topologicalExecution](../declarative-pipelines/TriggeredGraphExecution.md#topologicalExecution)

## execution.watchdog.minRetryTime { #spark.sql.pipelines.execution.watchdog.minRetryTime }

**spark.sql.pipelines.execution.watchdog.minRetryTime**

(internal) Initial duration (in seconds) between the time when we notice a flow has failed and when we try to restart the flow.
The interval between flow restarts doubles with every stream failure up to the maximum value set in [spark.sql.pipelines.execution.watchdog.maxRetryTime](#spark.sql.pipelines.execution.watchdog.maxRetryTime).

Default: `5` (seconds)

Must be at least 1 second

Use [SQLConf.PIPELINES_WATCHDOG_MIN_RETRY_TIME_IN_SECONDS](../SQLConf.md#PIPELINES_WATCHDOG_MIN_RETRY_TIME_IN_SECONDS) to reference the name.

Use [SQLConf.watchdogMinRetryTimeInSeconds](../SQLConf.md#watchdogMinRetryTimeInSeconds) method to access the current value.

Used when:

* `TriggeredGraphExecution` is requested to [backoffStrategy](../declarative-pipelines/TriggeredGraphExecution.md#backoffStrategy)

## execution.watchdog.maxRetryTime { #spark.sql.pipelines.execution.watchdog.maxRetryTime }

**spark.sql.pipelines.execution.watchdog.maxRetryTime**

(internal) Maximum time interval (in seconds) at which flows will be restarted

Default: `3600` (seconds)

Must be greater than or equal to [spark.sql.pipelines.execution.watchdog.minRetryTime](#spark.sql.pipelines.execution.watchdog.minRetryTime)

Use [SQLConf.PIPELINES_WATCHDOG_MAX_RETRY_TIME_IN_SECONDS](../SQLConf.md#PIPELINES_WATCHDOG_MAX_RETRY_TIME_IN_SECONDS) to reference the name.

Use [SQLConf.watchdogMaxRetryTimeInSeconds](../SQLConf.md#watchdogMaxRetryTimeInSeconds) method to access the current value.

Used when:

* `TriggeredGraphExecution` is requested to [backoffStrategy](../declarative-pipelines/TriggeredGraphExecution.md#backoffStrategy)

## execution.maxConcurrentFlows { #spark.sql.pipelines.execution.maxConcurrentFlows }

**spark.sql.pipelines.execution.maxConcurrentFlows**

(internal) Maximum number of flows to execute at once.
Used to tune performance for triggered pipelines.
Has no effect on continuous pipelines.

Default: `16`

Use [SQLConf.PIPELINES_MAX_CONCURRENT_FLOWS](../SQLConf.md#PIPELINES_MAX_CONCURRENT_FLOWS) to reference the name.

Use [SQLConf.maxConcurrentFlows](../SQLConf.md#maxConcurrentFlows) method to access the current value.

Used when:

* `TriggeredGraphExecution` is requested for the [concurrencyLimit](../declarative-pipelines/TriggeredGraphExecution.md#concurrencyLimit) and to [topologicalExecution](../declarative-pipelines/TriggeredGraphExecution.md#topologicalExecution)

## timeoutMsForTerminationJoinAndLock { #spark.sql.pipelines.timeoutMsForTerminationJoinAndLock }

**spark.sql.pipelines.timeoutMsForTerminationJoinAndLock**

(internal) Timeout (in ms) to grab a lock for stopping update - default is 1hr.

Default: `60 * 60 * 1000` (1 hour)

Must be at least 1 millisecond

Use [SQLConf.PIPELINES_TIMEOUT_MS_FOR_TERMINATION_JOIN_AND_LOCK](../SQLConf.md#PIPELINES_TIMEOUT_MS_FOR_TERMINATION_JOIN_AND_LOCK) to reference the name.

Use [SQLConf.timeoutMsForTerminationJoinAndLock](../SQLConf.md#timeoutMsForTerminationJoinAndLock) method to access the current value.

Used when:

* `GraphExecution` is requested to [stopThread](../declarative-pipelines/GraphExecution.md#stopThread)

## maxFlowRetryAttempts { #spark.sql.pipelines.maxFlowRetryAttempts }

**spark.sql.pipelines.maxFlowRetryAttempts**

Maximum number of times a flow can be retried.
Can be set at the [pipeline](../declarative-pipelines/PipelineUpdateContext.md#spark) or [flow](../declarative-pipelines/Flow.md#sqlConf) level

Default: `2`

Use [SQLConf.PIPELINES_MAX_FLOW_RETRY_ATTEMPTS](../SQLConf.md#PIPELINES_MAX_FLOW_RETRY_ATTEMPTS) to reference the name.

Use [SQLConf.maxFlowRetryAttempts](../SQLConf.md#maxFlowRetryAttempts) method to access the current value.

Used when:

* `GraphExecution` is requested to [maxRetryAttemptsForFlow](../declarative-pipelines/GraphExecution.md#maxRetryAttemptsForFlow)

## event.queue.capacity { #spark.sql.pipelines.event.queue.capacity }

**spark.sql.pipelines.event.queue.capacity**

(internal) Capacity of the event queue used in pipelined execution.
When the queue is full, non-terminal `FlowProgressEvent`s will be dropped.

Default: `1000`

Must be positive

Use [SQLConf.PIPELINES_EVENT_QUEUE_CAPACITY](../SQLConf.md#PIPELINES_EVENT_QUEUE_CAPACITY) to reference the name.

Used when:

* `PipelineEventSender` is [created](PipelineEventSender.md#queueCapacity)
