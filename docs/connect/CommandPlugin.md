# CommandPlugin

`CommandPlugin` is an [abstraction](#contract) of [command processors](#implementations) in [Spark Connect](./index.md) that can [process a command](#process).

## Contract

### Process Command { #process }

```scala
process(
  command: protobuf.Any,
  planner: SparkConnectPlanner): Option[Unit]
```

Used when:

* `SparkConnectPlanner` is requested to [handleCommandPlugin](SparkConnectPlanner.md#handleCommandPlugin)

## Implementations

!!! note
    No built-in implementations available.
