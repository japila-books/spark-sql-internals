# Spark Connect

[Apache Spark 3.4](https://issues.apache.org/jira/browse/SPARK-39375) introduces **Spark Connect** module for a client-server interface for Apache Spark for remote connectivity to Spark clusters (using the DataFrame API and unresolved logical plans as the protocol based on [gRPC Java]({{ grpc.docs }})).

The [Spark Connect server](SparkConnectServer.md) can be started using `sbin/start-connect-server.sh` shell script.

```console
$ ./sbin/start-connect-server.sh
starting org.apache.spark.sql.connect.service.SparkConnectServer, logging to...

$ tail -1 logs/spark-jacek-org.apache.spark.sql.connect.service.SparkConnectServer-1-Jaceks-Mac-mini.local.out
... Spark Connect server started.
```

Use Spark Connect for interactive analysis:

```bash
./bin/pyspark --remote "sc://localhost"
```

And you will notice that the PySpark shell welcome message tells you that you have connected to Spark using Spark Connect:

```python
Client connected to the Spark Connect server at localhost
```

 Check the Spark session type:

```python
SparkSession available as 'spark'.
>>> type(spark)
<class 'pyspark.sql.connect.session.SparkSession'>
```

Now you can run PySpark code in the shell to see Spark Connect in action:

```python
>>> columns = ["id","name"]
>>> data = [(1,"Sarah"),(2,"Maria")]
>>> df = spark.createDataFrame(data).toDF(*columns)
>>> df.show()
+---+-----+
| id| name|
+---+-----+
|  1|Sarah|
|  2|Maria|
+---+-----+
```
