# Configuration Properties

## <span id="spark.python.use.daemon"><span id="PYTHON_USE_DAEMON"> spark.python.use.daemon

Because forking processes from Java is expensive, we prefer to launch a single Python daemon, `pyspark/daemon.py` (by default) and tell it to fork new workers for our tasks. This daemon currently only works on UNIX-based systems now because it uses signals for child management, so we can also fall back to launching workers, `pyspark/worker.py` (by default) directly.

Default: `true` (always disabled on Windows)

Used when [PythonWorkerFactory](PythonWorkerFactory.md#useDaemon) is created

## <span id="spark.python.daemon.module"><span id="PYTHON_DAEMON_MODULE"> spark.python.daemon.module

Default: `pyspark.daemon`

Used when [PythonWorkerFactory](PythonWorkerFactory.md#daemonModule) is created

## <span id="spark.python.worker.module"><span id="PYTHON_WORKER_MODULE"> spark.python.worker.module

Default: (undefined)

Used when [PythonWorkerFactory](PythonWorkerFactory.md#workerModule) is created
