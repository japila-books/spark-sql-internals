---
subtitle: ⚠️ 4.1.0-SNAPSHOT
---

# Declarative Pipelines

**Spark Declarative Pipelines (SDP)** is a declarative framework for building ETL pipelines on Apache Spark.

!!! danger
    Declarative Pipelines framework is only available in the development branch of Apache Spark 4.1.0-SNAPSHOT.

    Declarative Pipelines has not been released in any Spark version yet.

Streaming flows are backed by streaming sources, and batch flows are backed by batch sources.

Declarative Pipelines uses the following [Python decorators](https://peps.python.org/pep-0318/) to describe tables and views:

* `@sdp.materialized_view` for materialized views
* `@sdp.table` for streaming and batch tables

[DataflowGraph](DataflowGraph.md) is the core graph structure in Declarative Pipelines.

Once described, a pipeline can be [started](PipelineExecution.md#runPipeline) (on a [PipelineExecution](PipelineExecution.md)).

## Demo

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

val sdp: DataflowGraph = graphCtx.toDataflowGraph
```

### Step 4. Create Update Context

[PipelineUpdateContextImpl](PipelineUpdateContextImpl.md)

```scala
import org.apache.spark.sql.pipelines.graph.{ PipelineUpdateContext, PipelineUpdateContextImpl }
import org.apache.spark.sql.pipelines.logging.PipelineEvent

val swallowEventsCallback: PipelineEvent => Unit = _ => ()

val updateCtx: PipelineUpdateContext =
  new PipelineUpdateContextImpl(unresolvedGraph=sdp, eventCallback=swallowEventsCallback)
```

### Step 5. Start Pipeline

[PipelineExecution](PipelineExecution.md#runPipeline)

```scala
updateCtx.pipelineExecution.runPipeline()
```

## Dataset Types

Declarative Pipelines supports the following dataset types:

* **Materialized Views** (datasets) that are published to a catalog
* **Table** that are published to a catalog
* **Views** that are not published to a catalog

## Learning Resources

1. [Spark Declarative Pipelines Programming Guide](https://github.com/apache/spark/blob/master/docs/declarative-pipelines-programming-guide.md)
