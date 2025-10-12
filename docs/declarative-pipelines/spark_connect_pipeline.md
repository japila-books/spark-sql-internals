---
title: spark_connect_pipeline
---

# spark_connect_pipeline PySpark Module

## create_dataflow_graph { #create_dataflow_graph }

```py
create_dataflow_graph(
    spark: SparkSession,
    default_catalog: Optional[str],
    default_database: Optional[str],
    sql_conf: Optional[Mapping[str, str]],
) -> str
```

`create_dataflow_graph`...FIXME

---

`create_dataflow_graph` is used when:

* FIXME

## start_run { #start_run }

```py
start_run(
    spark: SparkSession,
    dataflow_graph_id: str,
    full_refresh: Optional[Sequence[str]],
    full_refresh_all: bool,
    refresh: Optional[Sequence[str]],
    dry: bool,
    storage: str,
) -> Iterator[Dict[str, Any]]
```

`start_run`...FIXME

---

`start_run` is used when:

* FIXME

## handle_pipeline_events { #handle_pipeline_events }

```py
handle_pipeline_events(
    iter: Iterator[Dict[str, Any]]
) -> None
```

`handle_pipeline_events`...FIXME

---

`handle_pipeline_events` is used when:

* FIXME
