# SparkConnectGraphElementRegistry

`SparkConnectGraphElementRegistry` is a [GraphElementRegistry](GraphElementRegistry.md).

## Creating Instance

`SparkConnectGraphElementRegistry` takes the following to be created:

* <span id="spark"> `SparkSession` (`SparkConnectClient`)
* <span id="dataflow_graph_id"> Dataflow Graph ID

`SparkConnectGraphElementRegistry` is created when:

* `pyspark.pipelines.cli` is requested to [run](#run)

## register_dataset { #register_dataset }

??? note "GraphElementRegistry"

    ```py
    register_dataset(
        self,
        dataset: Dataset,
    ) -> None
    ```

    `register_dataset` is part of the [GraphElementRegistry](GraphElementRegistry.md#register_dataset) abstraction.

`register_dataset` makes sure that the given `Dataset` is either `MaterializedView`, `StreamingTable` or `TemporaryView`.

`register_dataset` requests this [SparkSession](#spark) to [execute](#execute_command) a `PipelineCommand.DefineDataset`.
