# State

## Reset State of All Flows { #reset }

```scala
reset(
  resolvedGraph: DataflowGraph,
  env: PipelineUpdateContext): Seq[Input]
reset(
  flow: ResolvedFlow,
  env: PipelineUpdateContext,
  graph: DataflowGraph): Unit // (1)!
```

1. A private method

`reset` [finds ResolvedFlows to reset](#findElementsToReset) in the given [DataflowGraph](DataflowGraph.md) (and the [PipelineUpdateContext](PipelineUpdateContext.md)).

!!! info
    `reset` handles [ResolvedFlow](ResolvedFlow.md)s only.

`reset` prints out the following INFO message to the logs:

```text
Clearing out state for flow [displayName]
```

`reset` creates a [FlowSystemMetadata](FlowSystemMetadata.md).

For no [checkpoint directory](FlowSystemMetadata.md#latestCheckpointLocationOpt) available for the [ResolvedFlow](ResolvedFlow.md), `reset` prints out the following INFO message to the logs and exits.

```text
Skipping resetting flow [identifier]
since its destination not been previously materialized
and we can't find the checkpoint location.
```

Otherwise, when there is a [checkpoint directory](FlowSystemMetadata.md#latestCheckpointLocationOpt) available, `reset` creates a new checkpoint directory (by incrementing the checkpoint number) and prints out the following INFO message to the logs:

```text
Created new checkpoint for stream [displayName] at [checkpoint_path].
```

---

`reset` is used when:

* `PipelineExecution` is requested to [run a pipeline update](PipelineExecution.md#startPipeline) (with full-refresh update)
