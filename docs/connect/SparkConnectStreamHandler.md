# SparkConnectStreamHandler

## Creating Instance

`SparkConnectStreamHandler` takes the following to be created:

* <span id="responseObserver"> `StreamObserver` of `ExecutePlanResponse`s

`SparkConnectStreamHandler` is created when:

* `SparkConnectService` is requested to [handle executePlan request](SparkConnectService.md#executePlan)

## Handling ExecutePlanRequest { #handle }

```scala
handle(
  v: ExecutePlanRequest): Unit
```

`handle`...FIXME

### handlePlan { #handlePlan }

```scala
handlePlan(
  session: SparkSession,
  request: ExecutePlanRequest): Unit
```

`handlePlan`...FIXME
