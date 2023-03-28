# SparkConnectService

`SparkConnectService` is a `BindableService` ([gRPC]({{ grpc.api }}/io/grpc/BindableService.html)).

## Creating Instance

`SparkConnectService` takes the following to be created:

* <span id="debug"> `debug` flag

`SparkConnectService` is created when:

* `SparkConnectService` is requested to [startGRPCService](#startGRPCService)

## start

```scala
start(): Unit
```

`start` [startGRPCService](#startGRPCService).

---

`start` is used when:

* [SimpleSparkConnectService](SimpleSparkConnectService.md) standalone application is started
* `SparkConnectPlugin` is requested to [init](SparkConnectPlugin.md#init)
* [SparkConnectServer](SparkConnectServer.md) standalone application is started

### startGRPCService { #startGRPCService }

```scala
startGRPCService(): Unit
```

`startGRPCService` reads the values of the following configuration properties:

Configuration Property | Default Value
-----------------------|--------------
 `spark.connect.grpc.debug.enabled` | `true`
 `spark.connect.grpc.binding.port` | `15002`

`startGRPCService` builds a `NettyServerBuilder` with the `spark.connect.grpc.binding.port` and a [SparkConnectService](SparkConnectService.md).

`startGRPCService` [registers interceptors](SparkConnectInterceptorRegistry.md#chainInterceptors).

`startGRPCService` [builds the server](#server) and starts it.
