# SparkConnectGraphElementRegistry

`SparkConnectGraphElementRegistry` is a [GraphElementRegistry](GraphElementRegistry.md).

`SparkConnectGraphElementRegistry` acts as a communication bridge between Spark Declarative Pipelines' Python execution environment and Spark Connect Server (with [PipelinesHandler](PipelinesHandler.md)).

## Creating Instance

`SparkConnectGraphElementRegistry` takes the following to be created:

* <span id="spark"> `SparkSession` (`SparkConnectClient`)
* <span id="dataflow_graph_id"> Dataflow Graph ID

`SparkConnectGraphElementRegistry` is created when:

* `pyspark.pipelines.cli` is requested to [run](#run)

## Register Flow { #register_flow }

??? note "GraphElementRegistry"

    ```py
    register_flow(
        self,
        flow: Flow
    ) -> None
    ```

    `register_flow` is part of the [GraphElementRegistry](GraphElementRegistry.md#register_flow) abstraction.

`register_flow` requests this [SparkConnectClient](#spark) to [execute](#execute_command) a `PipelineCommand.DefineFlow` command.

??? note "PipelinesHandler on Spark Connect Server"
    `DefineFlow` commands are handled by [PipelinesHandler](PipelinesHandler.md#DEFINE_FLOW) on Spark Connect Server.

## Register Output { #register_output }

??? note "GraphElementRegistry"

    ```py
    register_output(
        self,
        output: Output
    ) -> None
    ```

    `register_output` is part of the [GraphElementRegistry](GraphElementRegistry.md#register_output) abstraction.

`register_output` requests this [SparkConnectClient](#spark) to [execute](#execute_command) a `DefineOutput` pipeline command.

??? note "PipelinesHandler on Spark Connect Server"
    `DefineOutput` command is handled by [PipelinesHandler](PipelinesHandler.md#DEFINE_OUTPUT) on Spark Connect Server.
