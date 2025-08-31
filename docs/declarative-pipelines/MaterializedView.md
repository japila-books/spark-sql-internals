# MaterializedView

`MaterializedView` is a `Table` that represents a materialized view in a pipeline dataflow graph.

`MaterializedView` is created using [@materialized_view](#materialized_view) decorator.

`MaterializedView` is a Python class.

## materialized_view

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

`materialized_view` uses `query_function` for the parameters unless they are specified explicitly.

`materialized_view` uses the name of the decorated function as the name of the materialized view unless specified explicitly.

`materialized_view` makes sure that [GraphElementRegistry](GraphElementRegistry.md) has been set (using `graph_element_registration_context` context manager).

??? note "Demo"

    ```py
    from pyspark.pipelines.graph_element_registry import (
        graph_element_registration_context,
        get_active_graph_element_registry,
    )
    from pyspark.pipelines.spark_connect_graph_element_registry import (
        SparkConnectGraphElementRegistry,
    )

    dataflow_graph_id = "demo_dataflow_graph_id"
    registry = SparkConnectGraphElementRegistry(spark, dataflow_graph_id)
    with graph_element_registration_context(registry):
        graph_registry = get_active_graph_element_registry()
        assert graph_registry == registry
    ```

`materialized_view` creates a new `MaterializedView` and requests the `GraphElementRegistry` to [register_dataset](GraphElementRegistry.md#register_dataset) it.

`materialized_view` creates a new `Flow` and requests the `GraphElementRegistry` to [register_flow](GraphElementRegistry.md#register_flow) it.
