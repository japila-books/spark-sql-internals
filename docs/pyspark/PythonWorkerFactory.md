# PythonWorkerFactory

`PythonWorkerFactory` is...FIXME

## Creating Instance

`PythonWorkerFactory` takes the following to be created:

* <span id="pythonExec"> [Python Executable](PythonFunction.md#pythonExec)
* <span id="envVars"> Environment Variables (`Map[String, String]`)

`PythonWorkerFactory` is created when `SparkEnv` is requested to `createPythonWorker` (when `BasePythonRunner` is requested to [compute a partition](BasePythonRunner.md#compute)).

## <span id="useDaemon"> useDaemon Flag

`PythonWorkerFactory` uses `useDaemon` internal flag that is the value of [spark.python.use.daemon](configuration-properties.md#PYTHON_USE_DAEMON) configuration property to decide whether to use lighter [daemon](#createThroughDaemon) or [non-daemon](#createSimpleWorker) workers.

`useDaemon` flag is used when `PythonWorkerFactory` requested to [create](#create), [stop](#stopWorker) or [release](#releaseWorker) a worker and [stop a daemon module](#stopDaemon).

## <span id="daemonModule"> Python Daemon Module

`PythonWorkerFactory` uses [spark.python.daemon.module](configuration-properties.md#PYTHON_DAEMON_MODULE) configuration property to define the **Python Daemon Module**.

The Python Daemon Module is used when `PythonWorkerFactory` is requested to [create and start a daemon module](#startDaemon).

## <span id="workerModule"> Python Worker Module

`PythonWorkerFactory` uses [spark.python.worker.module](configuration-properties.md#PYTHON_WORKER_MODULE) configuration property to specify the **Python Worker Module**.

The Python Worker Module is used when `PythonWorkerFactory` is requested to [create and start a worker](#createSimpleWorker).

## <span id="create"> Creating Python Worker

```scala
create(): Socket
```

`create`...FIXME

`create` is used when `SparkEnv` is requested to `createPythonWorker`.

## <span id="createThroughDaemon"> Creating Daemon Worker

```scala
createThroughDaemon(): Socket
```

`createThroughDaemon`...FIXME

`createThroughDaemon` is used when `PythonWorkerFactory` is requested to [create a Python worker](#create) (with [useDaemon](#useDaemon) flag enabled).

### <span id="startDaemon"> Starting Python Daemon Process

```scala
startDaemon(): Unit
```

`startDaemon`...FIXME

## <span id="createSimpleWorker"> Creating Simple Non-Daemon Worker

```scala
createSimpleWorker(): Socket
```

`createSimpleWorker`...FIXME

`createSimpleWorker` is used when `PythonWorkerFactory` is requested to [create a Python worker](#create) (with [useDaemon](#useDaemon) flag disabled).

## Logging

Enable `ALL` logging level for `org.apache.spark.api.python.PythonWorkerFactory` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.api.python.PythonWorkerFactory=ALL
```

Refer to [Logging](../spark-logging.md).
