---
subtitle: ⚠️ 4.1.0-SNAPSHOT
---

# Declarative Pipelines

**Spark Declarative Pipelines (SDP)** is a declarative framework for building ETL pipelines on Apache Spark using Python or SQL.

??? warning "Apache Spark 4.1.0-SNAPSHOT"
    Declarative Pipelines framework is only available in the development branch of Apache Spark 4.1.0-SNAPSHOT.

    Declarative Pipelines has not been released in any Spark version yet.

    ```console
    ❯ $SPARK_HOME/bin/pyspark --version
    Welcome to
         ____              __
        / __/__  ___ _____/ /__
       _\ \/ _ \/ _ `/ __/  '_/
      /___/ .__/\_,_/_/ /_/\_\   version 4.1.0-SNAPSHOT
         /_/

    Using Scala version 2.13.16, OpenJDK 64-Bit Server VM, 17.0.16
    Branch master
    Compiled by user jacek on 2025-08-04T11:30:08Z
    Revision 6ef9a9d340539fc870acca042bd036f33ea995c3
    Url https://github.com/apache/spark.git
    Type --help for more information.
    ```

Streaming flows are backed by streaming sources, and batch flows are backed by batch sources.

Declarative Pipelines uses [Python decorators](#python-decorators) to describe tables, views and flows, declaratively.

[DataflowGraph](DataflowGraph.md) is the core graph structure in Declarative Pipelines.

Once described, a pipeline can be [started](PipelineExecution.md#runPipeline) (on a [PipelineExecution](PipelineExecution.md)).

## Python Decorators for Datasets and Flows { #python-decorators }

Declarative Pipelines uses the following [Python decorators](https://peps.python.org/pep-0318/) to describe tables and views:

* [@sdp.materialized_view](#materialized_view) for materialized views
* [@sdp.table](#table) for streaming and batch tables

### pyspark.pipelines Python Module { #pyspark_pipelines }

`pyspark.pipelines` module (in `__init__.py`) imports `pyspark.pipelines.api` module to expose the following Python decorators to wildcard imports:

* [append_flow](#append_flow)
* [create_streaming_table](#create_streaming_table)
* [materialized_view](#materialized_view)
* [table](#table)
* [temporary_view](#temporary_view)

Use the following import in your Python code:

```py
from pyspark import pipelines as sdp
```

### @sdp.append_flow { #append_flow }

### @sdp.create_streaming_table { #create_streaming_table }

### @sdp.materialized_view { #materialized_view }

### @sdp.table { #table }

### @sdp.temporary_view { #temporary_view }

## Demo: Python API

In a terminal, start a Spark Connect Server.

```bash
./sbin/start-connect-server.sh
```

It will listen on port 15002.

??? note "Tip"
    Review the logs with `tail -f`.

Start a Spark Connect-enabled PySpark shell.

```bash
$SPARK_HOME/bin/pyspark --remote sc://localhost:15002
```

```py
from pyspark.pipelines.spark_connect_pipeline import create_dataflow_graph
dataflow_graph_id = create_dataflow_graph(
  spark,
  default_catalog=None,
  default_database=None,
  sql_conf=None,
)

# >>> print(dataflow_graph_id)
# 3cb66d5a-0621-4f15-9920-e99020e30e48
```

```py
from pyspark.pipelines.spark_connect_graph_element_registry import SparkConnectGraphElementRegistry
registry = SparkConnectGraphElementRegistry(spark, dataflow_graph_id)
```

```py
from pyspark import pipelines as sdp
```

```py
from pyspark.pipelines.graph_element_registry import graph_element_registration_context
with graph_element_registration_context(registry):
  sdp.create_streaming_table("demo_streaming_table")
```

You should see the following INFO message in the logs of the Spark Connect Server:

```text
INFO PipelinesHandler: Define pipelines dataset cmd received: define_dataset {
  dataflow_graph_id: "3cb66d5a-0621-4f15-9920-e99020e30e48"
  dataset_name: "demo_streaming_table"
  dataset_type: TABLE
}
```

## Demo: spark-pipelines CLI

```bash
uv init hello-spark-pipelines
```

```bash
cd hello-spark-pipelines
```

```console
❯ uv pip list
Using Python 3.12.11 environment at: /Users/jacek/.local/share/uv/python/cpython-3.12.11-macos-aarch64-none
Package Version
------- -------
pip     24.3.1
```

```bash
export SPARK_HOME=/Users/jacek/oss/spark
```

```bash
uv add --editable $SPARK_HOME/python/packaging/client
```

```console
❯ uv pip list
Package                  Version     Editable project location
------------------------ ----------- ----------------------------------------------
googleapis-common-protos 1.70.0
grpcio                   1.74.0
grpcio-status            1.74.0
numpy                    2.3.2
pandas                   2.3.1
protobuf                 6.31.1
pyarrow                  21.0.0
pyspark-client           4.1.0.dev0  /Users/jacek/oss/spark/python/packaging/client
python-dateutil          2.9.0.post0
pytz                     2025.2
pyyaml                   6.0.2
six                      1.17.0
tzdata                   2025.2
```

Activate (_source_) the virtual environment (that `uv` helped us create).
It will bring all the necessary PySpark modules that have not been released yet and are only available in the source format only.

```bash
source .venv/bin/activate
```

```console
❯ $SPARK_HOME/bin/spark-pipelines --help
usage: cli.py [-h] {run,dry-run,init} ...

Pipelines CLI

positional arguments:
  {run,dry-run,init}
    run               Run a pipeline. If no refresh options specified, a
                      default incremental update is performed.
    dry-run           Launch a run that just validates the graph and checks
                      for errors.
    init              Generate a sample pipeline project, including a spec
                      file and example definitions.

options:
  -h, --help          show this help message and exit
```

```bash
$SPARK_HOME/bin/spark-pipelines dry-run
```

??? note "Output"
    ```console
    Traceback (most recent call last):
      File "/Users/jacek/oss/spark/python/pyspark/pipelines/cli.py", line 382, in <module>
        main()
      File "/Users/jacek/oss/spark/python/pyspark/pipelines/cli.py", line 358, in main
        spec_path = find_pipeline_spec(Path.cwd())
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      File "/Users/jacek/oss/spark/python/pyspark/pipelines/cli.py", line 101, in find_pipeline_spec
        raise PySparkException(
    pyspark.errors.exceptions.base.PySparkException: [PIPELINE_SPEC_FILE_NOT_FOUND] No pipeline.yaml or pipeline.yml file provided in arguments or found in directory `/` or readable ancestor directories.
    ```

Create a demo double `hello-spark-pipelines` pipelines project with a sample `pipeline.yml` and sample transformations (in Python and in SQL).

```bash
$SPARK_HOME/bin/spark-pipelines init --name hello-spark-pipelines && \
mv hello-spark-pipelines/* . && \
rm -rf hello-spark-pipelines
```

```console
❯ cat pipeline.yml

name: hello-spark-pipelines
definitions:
  - glob:
      include: transformations/**/*.py
  - glob:
      include: transformations/**/*.sql
```

```console
❯ tree transformations
transformations
├── example_python_materialized_view.py
└── example_sql_materialized_view.sql

1 directory, 2 files
```

```bash
$SPARK_HOME/bin/spark-pipelines dry-run
```

??? note "Output"
    ```text
    2025-08-03 15:17:08: Loading pipeline spec from /private/tmp/hello-spark-pipelines/pipeline.yml...
    2025-08-03 15:17:08: Creating Spark session...
    ...
    2025-08-03 15:17:10: Creating dataflow graph...
    2025-08-03 15:17:10: Registering graph elements...
    2025-08-03 15:17:10: Loading definitions. Root directory: '/private/tmp/hello-spark-pipelines'.
    2025-08-03 15:17:10: Found 1 files matching glob 'transformations/**/*.py'
    2025-08-03 15:17:10: Importing /private/tmp/hello-spark-pipelines/transformations/example_python_materialized_view.py...
    2025-08-03 15:17:11: Found 1 files matching glob 'transformations/**/*.sql'
    2025-08-03 15:17:11: Registering SQL file /private/tmp/hello-spark-pipelines/transformations/example_sql_materialized_view.sql...
    2025-08-03 15:17:11: Starting run...
    2025-08-03 13:17:11: Run is COMPLETED.
    ```

```bash
$SPARK_HOME/bin/spark-pipelines run
```

??? note "Output"
    ```console
    2025-08-03 15:17:58: Creating dataflow graph...
    2025-08-03 15:17:58: Registering graph elements...
    2025-08-03 15:17:58: Loading definitions. Root directory: '/private/tmp/hello-spark-pipelines'.
    2025-08-03 15:17:58: Found 1 files matching glob 'transformations/**/*.py'
    2025-08-03 15:17:58: Importing /private/tmp/hello-spark-pipelines/transformations/example_python_materialized_view.py...
    2025-08-03 15:17:58: Found 1 files matching glob 'transformations/**/*.sql'
    2025-08-03 15:17:58: Registering SQL file /private/tmp/hello-spark-pipelines/transformations/example_sql_materialized_view.sql...
    2025-08-03 15:17:58: Starting run...
    2025-08-03 13:17:59: Flow spark_catalog.default.example_python_materialized_view is QUEUED.
    2025-08-03 13:17:59: Flow spark_catalog.default.example_sql_materialized_view is QUEUED.
    2025-08-03 13:17:59: Flow spark_catalog.default.example_python_materialized_view is PLANNING.
    2025-08-03 13:17:59: Flow spark_catalog.default.example_python_materialized_view is STARTING.
    2025-08-03 13:17:59: Flow spark_catalog.default.example_python_materialized_view is RUNNING.
    2025-08-03 13:18:00: Flow spark_catalog.default.example_python_materialized_view has COMPLETED.
    2025-08-03 13:18:01: Flow spark_catalog.default.example_sql_materialized_view is PLANNING.
    2025-08-03 13:18:01: Flow spark_catalog.default.example_sql_materialized_view is STARTING.
    2025-08-03 13:18:01: Flow spark_catalog.default.example_sql_materialized_view is RUNNING.
    2025-08-03 13:18:01: Flow spark_catalog.default.example_sql_materialized_view has COMPLETED.
    2025-08-03 13:18:03: Run is COMPLETED.
    ```

```console
❯ tree spark-warehouse
spark-warehouse
├── example_python_materialized_view
│   ├── _SUCCESS
│   └── part-00000-75bc5b01-aea2-4d05-a71c-5c04937981bc-c000.snappy.parquet
└── example_sql_materialized_view
    ├── _SUCCESS
    └── part-00000-e1d0d33c-5d9e-43c3-a87d-f5f772d32942-c000.snappy.parquet

3 directories, 4 files
```

## Spark Connect Only { #spark-connect }

Declarative Pipelines currently only supports Spark Connect.

```console
$ ./bin/spark-pipelines --conf spark.api.mode=xxx
...
25/08/03 12:33:57 INFO SparkPipelines: --spark.api.mode must be 'connect'. Declarative Pipelines currently only supports Spark Connect.
Exception in thread "main" org.apache.spark.SparkUserAppException: User application exited with 1
 at org.apache.spark.deploy.SparkPipelines$$anon$1.handle(SparkPipelines.scala:73)
 at org.apache.spark.launcher.SparkSubmitOptionParser.parse(SparkSubmitOptionParser.java:169)
 at org.apache.spark.deploy.SparkPipelines$$anon$1.<init>(SparkPipelines.scala:58)
 at org.apache.spark.deploy.SparkPipelines$.splitArgs(SparkPipelines.scala:57)
 at org.apache.spark.deploy.SparkPipelines$.constructSparkSubmitArgs(SparkPipelines.scala:43)
 at org.apache.spark.deploy.SparkPipelines$.main(SparkPipelines.scala:37)
 at org.apache.spark.deploy.SparkPipelines.main(SparkPipelines.scala)
```

## spark-pipelines Shell Script { #spark-pipelines }

`spark-pipelines` shell script is used to launch [org.apache.spark.deploy.SparkPipelines](SparkPipelines.md).

## Dataset Types

Declarative Pipelines supports the following dataset types:

* **Materialized Views** (datasets) that are published to a catalog
* **Table** that are published to a catalog
* **Views** that are not published to a catalog

## Demo: Scala API

### Step 1. Register Dataflow Graph

[DataflowGraphRegistry](DataflowGraphRegistry.md#createDataflowGraph)

```scala
import org.apache.spark.sql.connect.pipelines.DataflowGraphRegistry

val graphId = DataflowGraphRegistry.createDataflowGraph(
  defaultCatalog=spark.catalog.currentCatalog(),
  defaultDatabase=spark.catalog.currentDatabase,
  defaultSqlConf=Map.empty)
```

### Step 2. Look Up Dataflow Graph

[DataflowGraphRegistry](DataflowGraphRegistry.md#getDataflowGraphOrThrow)

```scala
import org.apache.spark.sql.pipelines.graph.GraphRegistrationContext

val graphCtx: GraphRegistrationContext =
  DataflowGraphRegistry.getDataflowGraphOrThrow(dataflowGraphId=graphId)
```

### Step 3. Create DataflowGraph

[GraphRegistrationContext](GraphRegistrationContext.md#toDataflowGraph)

```scala
import org.apache.spark.sql.pipelines.graph.DataflowGraph

val sdp: DataflowGraph = graphCtx.toDataflowGraph
```

### Step 4. Create Update Context

[PipelineUpdateContextImpl](PipelineUpdateContextImpl.md)

```scala
import org.apache.spark.sql.pipelines.graph.{ PipelineUpdateContext, PipelineUpdateContextImpl }
import org.apache.spark.sql.pipelines.logging.PipelineEvent

val swallowEventsCallback: PipelineEvent => Unit = _ => ()

val updateCtx: PipelineUpdateContext =
  new PipelineUpdateContextImpl(unresolvedGraph=sdp, eventCallback=swallowEventsCallback)
```

### Step 5. Start Pipeline

[PipelineExecution](PipelineExecution.md#runPipeline)

```scala
updateCtx.pipelineExecution.runPipeline()
```

## Learning Resources

1. [Spark Declarative Pipelines Programming Guide](https://github.com/apache/spark/blob/master/docs/declarative-pipelines-programming-guide.md)
