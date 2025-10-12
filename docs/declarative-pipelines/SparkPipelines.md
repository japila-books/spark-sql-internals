---
title: SparkPipelines
subtitle: Spark Pipelines CLI
---

# SparkPipelines &mdash; Spark Pipelines CLI

`SparkPipelines` is a standalone application that is executed using [spark-pipelines](./index.md#spark-pipelines) shell script.

`SparkPipelines` is a Scala "launchpad" to execute [pyspark/pipelines/cli.py](#pyspark-pipelines-cli) Python script (through [SparkSubmit]({{ book.spark_core }}/tools/spark-submit/SparkSubmit/)).

## cli.py { #pyspark-pipelines-cli }

`pyspark/pipelines/cli.py` is the heart of the Spark Pipelines CLI (launched using [spark-pipelines](./index.md#spark-pipelines) shell script).

As a Python script, `cli.py` can simply import Python libraries (to trigger their execution) whereas SQL libraries are left untouched and sent over the wire to a Spark Connect server ([PipelinesHandler](PipelinesHandler.md)) for execution.

The Pipelines CLI supports the following commands:

* [dry-run](#dry-run)
* [init](#init)
* [run](#run)

=== "uv run"

    ```console
    $ pwd
    /Users/jacek/oss/spark/python

    $ PYTHONPATH=. uv run \
        --with grpcio-status \
        --with grpcio \
        --with pyarrow \
        --with pandas \
        --with pyspark \
        python pyspark/pipelines/cli.py
    ...
    usage: cli.py [-h] {run,dry-run,init} ...
    cli.py: error: the following arguments are required: command
    ```

### dry-run

Launch a run that just validates the graph and checks for errors

Option | Description | Default
-|-|-
 `--spec` | Path to the pipeline spec | (undefined)

### init

Generate a sample pipeline project, including a spec file and example definitions

Option | Description | Default | Required
-|-|-|:-:
 `--name` | Name of the project. A directory with this name will be created underneath the current directory | (undefined) | ✅

```console
$ ./bin/spark-pipelines init --name hello-pipelines
Pipeline project 'hello-pipelines' created successfully. To run your pipeline:
cd 'hello-pipelines'
spark-pipelines run
```

### run

Run a pipeline. If no `--refresh` option specified, a default incremental update is performed.

Option | Description | Default
-|-|-
 `--spec` | Path to the pipeline spec | (undefined)
 `--full-refresh` | List of datasets to reset and recompute (comma-separated) | (empty)
 `--full-refresh-all` | Perform a full graph reset and recompute | (undefined)
 `--refresh` | List of datasets to update (comma-separated) | (empty)

When executed, `run` prints out the following log message:

```text
Loading pipeline spec from [spec_path]...
```

`run` loads a pipeline spec.

`run` prints out the following log message:

```text
Creating Spark session...
```

`run` creates a Spark session with the configurations from the pipeline spec.

`run` prints out the following log message:

```text
Creating dataflow graph...
```

`run` sends a `CreateDataflowGraph` command for execution in the Spark Connect server.

!!! note "Spark Connect Server and Command Execution"
    `CreateDataflowGraph` is handled by [PipelinesHandler](PipelinesHandler.md#createDataflowGraph) on the Spark Connect Server.

`run` prints out the following log message:

```text
Dataflow graph created (ID: [dataflow_graph_id]).
```

`run` prints out the following log message:

```text
Registering graph elements...
```

`run` creates a [SparkConnectGraphElementRegistry](SparkConnectGraphElementRegistry.md) and `register_definitions`.

`run` prints out the following log message:

```text
Starting run (dry=[dry], full_refresh=[full_refresh], full_refresh_all=[full_refresh_all], refresh=[refresh])...
```

`run` sends a `StartRun` command for execution in the Spark Connect Server.

!!! note "StartRun Command and PipelinesHandler"
    `StartRun` command is handled by [PipelinesHandler](PipelinesHandler.md#startRun) on the Spark Connect Server.

In the end, `run` keeps printing out pipeline events from the Spark Connect server.
