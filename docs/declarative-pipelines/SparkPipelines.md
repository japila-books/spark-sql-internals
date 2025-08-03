---
title: SparkPipelines
---

# SparkPipelines &mdash; Spark Pipelines CLI

`SparkPipelines` is a standalone application that can be executed using [spark-pipelines](./index.md#spark-pipelines) shell script.

`SparkPipelines` is a Scala "launchpad" to execute [python/pyspark/pipelines/cli.py](#pyspark-pipelines-cli) Python script (through [SparkSubmit]({{ book.spark_core }}/tools/spark-submit/SparkSubmit/)).

## PySpark Pipelines CLI

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
