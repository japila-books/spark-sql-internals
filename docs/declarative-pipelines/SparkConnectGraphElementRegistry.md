# SparkConnectGraphElementRegistry

`SparkConnectGraphElementRegistry` is a [GraphElementRegistry](GraphElementRegistry.md).

`SparkConnectGraphElementRegistry` acts as a communication bridge between Spark Declarative Pipelines' Python execution environment and Spark Connect Server (with [PipelinesHandler](PipelinesHandler.md)).

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

`register_dataset` requests this [SparkConnectClient](#spark) to [execute](#execute_command) a `PipelineCommand.DefineDataset` command.

!!! note "PipelinesHandler"
    `DefineDataset` commands are handled by [PipelinesHandler](PipelinesHandler.md#defineDataset) on Spark Connect Server.

## register_flow { #register_flow }

??? note "GraphElementRegistry"

    ```py
    register_flow(
        self,
        flow: Flow
    ) -> None
    ```

    `register_flow` is part of the [GraphElementRegistry](GraphElementRegistry.md#register_flow) abstraction.

`register_flow` requests this [SparkConnectClient](#spark) to [execute](#execute_command) a `PipelineCommand.DefineFlow` command.

!!! note "PipelinesHandler"
    `DefineFlow` commands are handled by [PipelinesHandler](PipelinesHandler.md#defineFlow) on Spark Connect Server.
