---
status: new
---

# Spark Connect :material-new-box:{ title="New in 3.4.0" }

[Apache Spark 3.4](https://issues.apache.org/jira/browse/SPARK-39375) introduces **Spark Connect** module for a client-server interface for Apache Spark for remote connectivity to Spark clusters (using the DataFrame API and unresolved logical plans as the protocol based on [gRPC Java]({{ grpc.docs }})).

The [Spark Connect server](SparkConnectServer.md) can be started using `sbin/start-connect-server.sh` shell script.

```console
$ ./sbin/start-connect-server.sh
starting org.apache.spark.sql.connect.service.SparkConnectServer, logging to...

$ tail -1 logs/spark-jacek-org.apache.spark.sql.connect.service.SparkConnectServer-1-Jaceks-Mac-mini.local.out
... Spark Connect server started.
```
