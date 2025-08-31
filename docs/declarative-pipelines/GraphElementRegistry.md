# GraphElementRegistry

`GraphElementRegistry` is an [abstraction](#contract) of [graph element registries](#implementations).

## Contract

### register_dataset { #register_dataset }

```py
register_dataset(
    self,
    dataset: Dataset,
) -> None
```

See:

* [SparkConnectGraphElementRegistry](SparkConnectGraphElementRegistry.md#register_dataset)

Used when:

* [@create_streaming_table](./index.md#create_streaming_table), [@table](./index.md#table), [@materialized_view](./index.md#materialized_view), [@temporary_view](./index.md#temporary_view) decorators are used

### register_flow { #register_flow }

```py
register_flow(
    self,
    flow: Flow,
) -> None
```

See:

* [SparkConnectGraphElementRegistry](SparkConnectGraphElementRegistry.md#register_flow)

Used when:

* [@append_flow](./index.md#append_flow), [@table](./index.md#table), [@materialized_view](./index.md#materialized_view), [@temporary_view](./index.md#temporary_view) decorators are used

### register_sql { #register_sql }

```py
register_sql(
    self,
    sql_text: str,
    file_path: Path,
) -> None
```

See:

* [SparkConnectGraphElementRegistry](SparkConnectGraphElementRegistry.md#register_sql)

Used when:

* `pyspark.pipelines.cli` is requested to [register_definitions](#register_definitions)

## Implementations

* [SparkConnectGraphElementRegistry](SparkConnectGraphElementRegistry.md)
