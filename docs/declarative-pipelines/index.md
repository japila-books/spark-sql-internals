---
subtitle: ⚠️ 4.1.0-SNAPSHOT
---

# Spark Declarative Pipelines

**Spark Declarative Pipelines (SDP)** is a declarative framework for building data processing (ETL) pipelines on Apache Spark in [Python](#python) and [SQL](#sql) languages.

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

A Declarative Pipelines project is defined and configured in a [pipeline specification file](#pipeline-specification-file).

A Declarative Pipelines project can be executed with [spark-pipelines](#spark-pipelines) shell script.

Declarative Pipelines uses [Python decorators](#python-decorators) to describe tables, views and flows, declaratively.

The definitions of tables, views and flows are registered in [DataflowGraphRegistry](DataflowGraphRegistry.md) (with [GraphRegistrationContext](GraphRegistrationContext.md)s by graph IDs). A `GraphRegistrationContext` is [converted into a DataflowGraph](GraphRegistrationContext.md#toDataflowGraph) when `PipelinesHandler` is requested to [start a pipeline run](PipelinesHandler.md#startRun) (when [spark-pipelines](#spark-pipelines) script is launched with `run` or `dry-run` command).

Streaming flows are backed by streaming sources, and batch flows are backed by batch sources.

[DataflowGraph](DataflowGraph.md) is the core graph structure in Declarative Pipelines.

Once described, a pipeline can be [started](PipelineExecution.md#runPipeline) (on a [PipelineExecution](PipelineExecution.md)).

## Pipeline Specification File

The heart of a Declarative Pipelines project is a **pipeline specification file** (in YAML format).

In the pipeline specification file, Declarative Pipelines developers specify files (`libraries`) with tables, views and flows (transformations) definitions in [Python](#python) and [SQL](#sql). A SDP project can use both languages simultaneously.

The following fields are supported:

Field Name | Description
-|-
 `name` (required) | &nbsp;
 `storage` (required) | The root storage location of pipeline metadata (e.g., checkpoints for streaming flows).<br>[SPARK-53751 Explicit Checkpoint Location]({{ spark.jira }}/SPARK-53751)
 `catalog` | The default catalog to register datasets into.<br>Unless specified, [PipelinesHandler](PipelinesHandler.md#createDataflowGraph) falls back to the current catalog.
 `database` | The default database to register datasets into<br>Unless specified, [PipelinesHandler](PipelinesHandler.md#createDataflowGraph) falls back to the current database.
 `schema` | Alias of `database`. Used unless `database` is defined
 `configuration` | SparkSession configs<br>Spark Pipelines runtime uses the configs to build a new `SparkSession` when `run`.<br>[spark.sql.connect.serverStacktrace.enabled]({{ book.spark_connect }}/configuration-properties/#spark.sql.connect.serverStacktrace.enabled) is hardcoded to be always `false`.
 `libraries` | `glob`s of `include`s with transformations in [SQL](#sql) and [Python](#python-decorators)

??? info
    Pipeline spec is resolved in `pyspark/pipelines/cli.py::unpack_pipeline_spec`.

```yaml
name: hello-spark-pipelines
catalog: default_catalog
schema: default
storage: storage-root
configuration:
  spark.key1: value1
libraries:
  - glob:
      include: transformations/**
```

## Spark Pipelines CLI { #spark-pipelines }

`spark-pipelines` shell script is the **Spark Pipelines CLI** (that launches [org.apache.spark.deploy.SparkPipelines](SparkPipelines.md) behind the scenes).

## Dataset Types

Declarative Pipelines supports the following dataset types:

* **Materialized views** that are published to a catalog.
* **Table** that are published to a catalog.
* [Streaming tables](#streaming-tables)
* **Views** that are not published to a catalog.

### Streaming Tables

**Streaming tables** are tables whose content is produced by one or more streaming flows.

Streaming tables can be created with the following:

* [@dp.create_streaming_table](#create_streaming_table) or [CREATE STREAMING TABLE](../sql/SparkSqlAstBuilder.md/#visitCreatePipelineDataset) (with no flows that can be defined later with [@dp.append_flow](#append_flow) or [CREATE FLOW AS INSERT INTO BY NAME](../sql/SparkSqlAstBuilder.md/#visitCreatePipelineInsertIntoFlow))
* [CREATE STREAMING TABLE ... AS](../sql/SparkSqlAstBuilder.md/#visitCreatePipelineDataset)

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

## Python

### Python Import Alias Convention

As of this [Commit 6ab0df9]({{ spark.commit }}/6ab0df9287c5a9ce49769612c2bb0a1daab83bee), the convention to alias the import of Declarative Pipelines in Python is `dp` (from `sdp`).

```python
from pyspark import pipelines as dp
```

### pyspark.pipelines Python Module { #pyspark_pipelines }

`pyspark.pipelines` module (in `__init__.py`) imports `pyspark.pipelines.api` module to expose the following Python decorators to wildcard imports:

* [append_flow](#append_flow)
* [create_sink](#create_sink)
* [create_streaming_table](#create_streaming_table)
* [materialized_view](#materialized_view)
* [table](#table)
* [temporary_view](#temporary_view)

Use the following import in your Python code:

```py
from pyspark import pipelines as dp
```

### Python Decorators

Declarative Pipelines uses the following [Python decorators](https://peps.python.org/pep-0318/) to describe tables and views:

* [@dp.append_flow](#append_flow) for append-only flows
* [@dp.create_streaming_table](#create_streaming_table) for streaming tables
* [@dp.materialized_view](#materialized_view) for materialized views (with supporting flows)
* [@dp.table](#table) for streaming and batch tables (with supporting flows)
* [@dp.temporary_view](#temporary_view) for temporary views (with supporting flows)

### @dp.append_flow { #append_flow }

```py
append_flow(
  *,
  target: str,
  name: Optional[str] = None,
  spark_conf: Optional[Dict[str, str]] = None,
) -> Callable[[QueryFunction], None]
```

[Registers](GraphElementRegistry.md#register_flow) an append [Flow](Flow.md) in the active [GraphElementRegistry](GraphElementRegistry.md).

`target` is the name of the dataset (_destination_) this flow writes to.

### dp.create_sink { #create_sink }

```py
create_sink(
  name: str,
  format: str,
  options: Optional[Dict[str, str]] = None,
) -> None
```

[Registers](GraphElementRegistry.md#register_output) a [Sink](Sink.md) output in the active [GraphElementRegistry](GraphElementRegistry.md).

!!! warning "Not Python Decorator"
    Unlike the others, `create_sink` is not a Python decorator.

### @dp.create_streaming_table { #create_streaming_table }

```py
create_streaming_table(
    name: str,
    *,
    comment: Optional[str] = None,
    table_properties: Optional[Dict[str, str]] = None,
    partition_cols: Optional[List[str]] = None,
    cluster_by: Optional[List[str]] = None,
    schema: Optional[Union[StructType, str]] = None,
    format: Optional[str] = None,
) -> None
```

[Registers](GraphElementRegistry.md#register_output) a `StreamingTable` dataset in the active [GraphElementRegistry](GraphElementRegistry.md).

### @dp.materialized_view { #materialized_view }

```py
materialized_view(
  query_function: Optional[QueryFunction] = None,
  *,
  name: Optional[str] = None,
  comment: Optional[str] = None,
  spark_conf: Optional[Dict[str, str]] = None,
  table_properties: Optional[Dict[str, str]] = None,
  partition_cols: Optional[List[str]] = None,
  schema: Optional[Union[StructType, str]] = None,
  format: Optional[str] = None,
) -> Union[Callable[[QueryFunction], None], None]
```

[Registers](GraphElementRegistry.md#register_output) a [MaterializedView](MaterializedView.md) dataset with an accompanying [Flow](GraphElementRegistry.md#register_flow) in the active [GraphElementRegistry](GraphElementRegistry.md).

### @dp.table { #table }

```py
table(
  query_function: Optional[QueryFunction] = None,
  *,
  name: Optional[str] = None,
  comment: Optional[str] = None,
  spark_conf: Optional[Dict[str, str]] = None,
  table_properties: Optional[Dict[str, str]] = None,
  partition_cols: Optional[List[str]] = None,
  schema: Optional[Union[StructType, str]] = None,
  format: Optional[str] = None,
) -> Union[Callable[[QueryFunction], None], None]
```

[Registers](GraphElementRegistry.md#register_output) a `StreamingTable` dataset with an accompanying [Flow](GraphElementRegistry.md#register_flow) in the active [GraphElementRegistry](GraphElementRegistry.md).

### @dp.temporary_view { #temporary_view }

```py
temporary_view(
  query_function: Optional[QueryFunction] = None,
  *,
  name: Optional[str] = None,
  comment: Optional[str] = None,
  spark_conf: Optional[Dict[str, str]] = None,
) -> Union[Callable[[QueryFunction], None], None]
```

[Registers](GraphElementRegistry.md#register_output) a `TemporaryView` dataset with an accompanying [Flow](GraphElementRegistry.md#register_flow) in the active [GraphElementRegistry](GraphElementRegistry.md).

## SQL

Spark Declarative Pipelines supports SQL language to define data processing pipelines.

Pipelines elements are defined in SQL files included as `libraries` in a [pipelines specification file](#pipeline-specification-file).

[SqlGraphRegistrationContext](SqlGraphRegistrationContext.md) is used on Spark Connect Server to handle SQL statements (from SQL definitions files and [Python decorators](#python-decorators)).

Supported SQL statements:

* [CREATE FLOW AS INSERT INTO BY NAME](../sql/SparkSqlAstBuilder.md#visitCreatePipelineInsertIntoFlow)
* [CREATE MATERIALIZED VIEW ... AS](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset)
* [CREATE STREAMING TABLE](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset)
* [CREATE STREAMING TABLE ... AS](../sql/SparkSqlAstBuilder.md#visitCreatePipelineDataset)
* [CREATE (PERSISTED) VIEW](../sql/SparkSqlAstBuilder.md#visitCreateView)
* [CREATE TEMPORARY VIEW](../sql/SparkSqlAstBuilder.md#visitCreateView)
* [SET](../logical-operators/SetCommand.md)
* [SET CATALOG](../logical-operators/SetCatalogCommand.md)
* [USE NAMESPACE](../logical-operators/SetNamespaceCommand.md)

A streaming table can be defined without a query, as streaming tables' data can be backed by standalone flows.
During a pipeline execution, it is validated that a streaming table has at least one standalone flow writing to the table, if no query is specified in the create statement itself.

## Demo: Create Virtual Environment for Python Client

```shell
uv init hello-spark-pipelines && cd hello-spark-pipelines
```

```shell
export SPARK_HOME=/Users/jacek/oss/spark
```

```shell
uv add --editable $SPARK_HOME/python/packaging/client
```

```shell
uv tree --depth 2
```

=== "Output"

    ```text
    Resolved 15 packages in 3ms
    hello-spark-pipelines v0.1.0
    └── pyspark-client v4.2.0.dev0
        ├── googleapis-common-protos v1.72.0
        ├── grpcio v1.76.0
        ├── grpcio-status v1.76.0
        ├── numpy v2.3.4
        ├── pandas v2.3.3
        ├── pyarrow v22.0.0
        └── pyyaml v6.0.3
    ```

```shell
uv pip list
```

=== "Output"

    ```text
    Package                  Version     Editable project location
    ------------------------ ----------- ----------------------------------------------
    googleapis-common-protos 1.72.0
    grpcio                   1.76.0
    grpcio-status            1.76.0
    numpy                    2.3.4
    pandas                   2.3.3
    protobuf                 6.33.0
    pyarrow                  22.0.0
    pyspark-client           4.2.0.dev0  /Users/jacek/oss/spark/python/packaging/client
    python-dateutil          2.9.0.post0
    pytz                     2025.2
    pyyaml                   6.0.3
    six                      1.17.0
    typing-extensions        4.15.0
    tzdata                   2025.2
    ```

Activate (_source_) the virtual environment (that `uv` helped us create).

```shell
source .venv/bin/activate
```

This activation brings all the necessary Spark Declarative Pipelines' Python dependencies (that are only available in the source format only) for non-`uv` tools and CLI, incl. [Spark Pipelines CLI](#spark-pipelines) itself.

```shell
$SPARK_HOME/bin/spark-pipelines --help
```

!!! note ""

    ```text
    usage: cli.py [-h] {run,dry-run,init} ...

    Pipelines CLI

    positional arguments:
      {run,dry-run,init}
        run               Run a pipeline. If no refresh options specified, a
                          default incremental update is performed.
        dry-run           Launch a run that just validates the graph and checks
                          for errors.
        init              Generate a sample pipeline project, with a spec file and
                          example transformations.

    options:
      -h, --help          show this help message and exit
    ```

??? note "macOS and PYSPARK_PYTHON"
    On macOS, you may want to define `PYSPARK_PYTHON` environment variable to point at Python >= 3.10.

    ```shell
    export PYSPARK_PYTHON=python3.14
    ```

## Demo: Python API

??? warning "Activate Virtual Environment"
    Follow [Demo: Create Virtual Environment for Python Client](#demo-create-virtual-environment-for-python-client) before getting started with this demo.

In a terminal, start a Spark Connect Server.

```shell
./sbin/start-connect-server.sh
```

It will listen on port 15002.

??? note "Monitor Logs"
    
    ```shell
    tail -f logs/*org.apache.spark.sql.connect.service.SparkConnectServer*.out
    ```

Start a Spark Connect-enabled PySpark shell.

```shell
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
from pyspark import pipelines as dp
```

```py
from pyspark.pipelines.graph_element_registry import graph_element_registration_context
with graph_element_registration_context(registry):
  dp.create_streaming_table("demo_streaming_table")
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

!!! warning "Activate Virtual Environment"
    Follow [Demo: Create Virtual Environment for Python Client](#demo-create-virtual-environment-for-python-client) before getting started with this demo.

### 1️⃣ Display Pipelines Help

Run `spark-pipelines --help` to learn the options.

```shell
$SPARK_HOME/bin/spark-pipelines --help
```

!!! note ""

    ```text
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

### 2️⃣ Create Pipelines Demo Project

You've only created an empty Python project so far (using `uv`).

Create a demo double `hello-spark-pipelines` pipelines project with a sample `pipeline.yml` and sample transformations (in Python and in SQL).

```shell
$SPARK_HOME/bin/spark-pipelines init --name hello-spark-pipelines && \
mv hello-spark-pipelines/* . && \
rm -rf hello-spark-pipelines
```

```shell
cat pipeline.yml
```

!!! note ""

    ```text

    name: hello-spark-pipelines
    storage: storage-root
    libraries:
      - glob:
          include: transformations/**
    ```

```shell
tree transformations
```

!!! note ""

    ```text
    transformations
    ├── example_python_materialized_view.py
    └── example_sql_materialized_view.sql

    1 directory, 2 files
    ```

!!! warning "Spark Connect Server should be down"
    `spark-pipelines dry-run` starts its own Spark Connect Server at 15002 port (unless started with `--remote` option).

    Shut down Spark Connect Server if you started it already.

    ```shell
    $SPARK_HOME/sbin/stop-connect-server.sh
    ```

!!! info "`--remote` option"
    Use `--remote` option to connect to a standalone Spark Connect Server.

    ```shell
    $SPARK_HOME/bin/spark-pipelines --remote sc://localhost dry-run
    ```

### 3️⃣ Dry Run Pipelines Project

```shell
$SPARK_HOME/bin/spark-pipelines dry-run
```

!!! note ""

    ```text
    2025-11-08 18:01:45: Creating dataflow graph...
    2025-11-08 18:01:45: Registering graph elements...
    2025-11-08 18:01:45: Loading definitions. Root directory: '/Users/jacek/sandbox/hello-spark-pipelines'.
    2025-11-08 18:01:45: Found 2 files matching glob 'transformations/**/*'
    2025-11-08 18:01:45: Importing /Users/jacek/sandbox/hello-spark-pipelines/transformations/example_python_materialized_view.py...
    2025-11-08 18:01:45: Registering SQL file /Users/jacek/sandbox/hello-spark-pipelines/transformations/example_sql_materialized_view.sql...
    2025-11-08 18:01:45: Starting run...
    2025-11-08 17:01:45: Run is COMPLETED.
    ```

### 4️⃣ Run Pipelines Project

Run the pipeline.

```shell
$SPARK_HOME/bin/spark-pipelines run
```

!!! note ""

    ```text
    2025-11-08 18:02:35: Creating dataflow graph...
    2025-11-08 18:02:35: Registering graph elements...
    2025-11-08 18:02:35: Loading definitions. Root directory: '/Users/jacek/sandbox/hello-spark-pipelines'.
    2025-11-08 18:02:35: Found 2 files matching glob 'transformations/**/*'
    2025-11-08 18:02:35: Importing /Users/jacek/sandbox/hello-spark-pipelines/transformations/example_python_materialized_view.py...
    2025-11-08 18:02:35: Registering SQL file /Users/jacek/sandbox/hello-spark-pipelines/transformations/example_sql_materialized_view.sql...
    2025-11-08 18:02:35: Starting run...
    2025-11-08 17:02:35: Flow spark_catalog.default.example_python_materialized_view is QUEUED.
    2025-11-08 17:02:35: Flow spark_catalog.default.example_sql_materialized_view is QUEUED.
    2025-11-08 17:02:35: Flow spark_catalog.default.example_python_materialized_view is PLANNING.
    2025-11-08 17:02:35: Flow spark_catalog.default.example_python_materialized_view is STARTING.
    2025-11-08 17:02:35: Flow spark_catalog.default.example_python_materialized_view is RUNNING.
    2025-11-08 17:02:37: Flow spark_catalog.default.example_python_materialized_view has COMPLETED.
    2025-11-08 17:02:37: Flow spark_catalog.default.example_sql_materialized_view is PLANNING.
    2025-11-08 17:02:37: Flow spark_catalog.default.example_sql_materialized_view is STARTING.
    2025-11-08 17:02:37: Flow spark_catalog.default.example_sql_materialized_view is RUNNING.
    2025-11-08 17:02:38: Flow spark_catalog.default.example_sql_materialized_view has COMPLETED.
    2025-11-08 17:02:39: Run is COMPLETED.
    ```

```shell
tree spark-warehouse
```

!!! note ""

    ```text
    spark-warehouse
    ├── example_python_materialized_view
    │   ├── _SUCCESS
    │   └── part-00000-25786a51-3973-4839-9220-f2411cf9725f-c000.snappy.parquet
    └── example_sql_materialized_view
        ├── _SUCCESS
        └── part-00000-7c8dcf19-8b55-4683-9895-b23ed752e71a-c000.snappy.parquet

    3 directories, 4 files
    ```

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

val dp: DataflowGraph = graphCtx.toDataflowGraph
```

### Step 4. Create Update Context

[PipelineUpdateContextImpl](PipelineUpdateContextImpl.md)

```scala
import org.apache.spark.sql.pipelines.graph.{ PipelineUpdateContext, PipelineUpdateContextImpl }
import org.apache.spark.sql.pipelines.logging.PipelineEvent

val swallowEventsCallback: PipelineEvent => Unit = _ => ()

val updateCtx: PipelineUpdateContext =
  new PipelineUpdateContextImpl(unresolvedGraph=dp, eventCallback=swallowEventsCallback)
```

### Step 5. Start Pipeline

[PipelineExecution](PipelineExecution.md#runPipeline)

```scala
updateCtx.pipelineExecution.runPipeline()
```

## Learning Resources

1. [Spark Declarative Pipelines Programming Guide](https://github.com/apache/spark/blob/master/docs/declarative-pipelines-programming-guide.md)
