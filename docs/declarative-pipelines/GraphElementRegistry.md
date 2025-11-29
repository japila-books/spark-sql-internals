# GraphElementRegistry

`GraphElementRegistry` is an [abstraction](#contract) of [graph element registries](#implementations):

* [Output](#register_output)s
* [Flow](#register_flow)s

Graph elements can be defined in Python and [SQL](#register_sql).

## Contract

### Register Output { #register_output }

```py
register_output(
    self,
    output: Output,
) -> None
```

Registers the given [Output](Output.md)

See:

* [SparkConnectGraphElementRegistry](SparkConnectGraphElementRegistry.md#register_output)

Used for the following:

* [dp.create_sink](./index.md#create_sink)
* [@dp.create_streaming_table](./index.md#create_streaming_table)
* [@dp.table](./index.md#table)
* [@dp.materialized_view](./index.md#materialized_view)
* [@dp.temporary_view](./index.md#temporary_view)

### Register Flow { #register_flow }

```py
register_flow(
    self,
    flow: Flow,
) -> None
```

Registers the given [Flow](Flow.md)

See:

* [SparkConnectGraphElementRegistry](SparkConnectGraphElementRegistry.md#register_flow)

Used for the following:

* [@dp.append_flow](./index.md#append_flow)
* [@dp.table](./index.md#table)
* [@dp.materialized_view](./index.md#materialized_view)
* [@dp.temporary_view](./index.md#temporary_view)

### Register SQL File { #register_sql }

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

* Pipelines CLI is requested to [register graph element definitions (from SQL files)](#register_definitions)

## Implementations

* [SparkConnectGraphElementRegistry](SparkConnectGraphElementRegistry.md)
