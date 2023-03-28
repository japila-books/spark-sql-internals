---
title: SparkConnectServer
---

# SparkConnectServer Standalone Application

`SparkConnectServer` is a standalone application to [start a Spark Connect server](#main) from command line.

`SparkConnectServer` can be started using `sbin/start-connect-server.sh` shell script.

`SparkConnectServer` can be stopped using `sbin/stop-connect-server.sh` shell script.

## Launching Application { #main }

```scala
main(
  args: Array[String]): Unit
```

`main` prints out the following INFO message to the logs:

```text
Starting Spark session.
```

`main` creates a [SparkSession](../SparkSession.md).

`main` [starts a SparkConnectService](SparkConnectService.md#start).

`main` prints out the following INFO message to the logs:

```text
Spark Connect server started.
```

In the end, `main` is paused until the [SparkConnectService](SparkConnectService.md#server) is terminated.
