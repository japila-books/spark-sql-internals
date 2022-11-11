# {{ book.title }}

## Structured Data Processing with Relational Queries on Massive Scale

**Spark SQL** allows expressing distributed in-memory computations using [relational operators](logical-operators/index.md).

Spark SQL is a relational framework for ingesting, querying and persisting (semi)structured data using **structured queries** (aka **relational queries**) that can be expressed in _good ol'_ **SQL** (incl. HiveQL) and the high-level SQL-like functional declarative [Dataset API](Dataset.md) (_Structured Query DSL_).

!!! note
    Semi- and structured data are collections of records that can be described using [schema](types/index.md) with column names, their types and whether a column can be null or not (_nullability_).

Spark SQL comes with a uniform and pluggable interface for data access in distributed storage systems and formats (e.g. Hadoop DFS, [Hive](hive/index.md), [Parquet](datasources/parquet/index.md), [Avro](datasources/avro/index.md), [Apache Kafka](kafka/index.md)) using [DataFrameReader](DataFrameReader.md) and [DataFrameWriter](DataFrameWriter.md) APIs.

Spark SQL allows you to execute SQL-like queries on large volume of data that can live in Hadoop HDFS or Hadoop-compatible file systems like S3. It can access data from different data sources - files or tables.

Whichever query interface you use to describe a structured query, i.e. SQL or Query DSL, the query becomes a [Dataset](Dataset.md) (with a mandatory [Encoder](Encoder.md)).

!!! quote "[Shark, Spark SQL, Hive on Spark, and the future of SQL on Apache Spark](https://databricks.com/blog/2014/07/01/shark-spark-sql-hive-on-spark-and-the-future-of-sql-on-spark.html)"
    For **SQL users**, Spark SQL provides state-of-the-art SQL performance and maintains compatibility with Shark/Hive. In particular, like Shark, Spark SQL supports all existing Hive data formats, user-defined functions (UDF), and the Hive metastore.

    For **Spark users**, Spark SQL becomes the narrow-waist for manipulating (semi-) structured data as well as ingesting data from sources that provide schema, such as JSON, Parquet, Hive, or EDWs. It truly unifies SQL and sophisticated analysis, allowing users to mix and match SQL and more imperative programming APIs for advanced analytics.

    For **open source hackers**, Spark SQL proposes a novel, elegant way of building query planners. It is incredibly easy to add new optimizations under this framework.

## Dataset Data Structure

The main data abstraction of Spark SQL is [Dataset](Dataset.md) that represents a **structured data** (records with a known schema). This structured data representation `Dataset` enables [compact binary representation](tungsten/index.md) using compressed columnar format that is stored in managed objects outside JVM's heap. It is supposed to speed computations up by reducing memory usage and GCs.

`Dataset` is a programming interface to the [structured query execution pipeline](QueryExecution.md) with [transformations and actions](spark-sql-dataset-operators.md) (as in the good old days of RDD API in Spark Core).

Internally, a structured query is a [Catalyst tree](catalyst/index.md) of (logical and physical) [relational operators](catalyst/QueryPlan.md) and [expressions](expressions/Expression.md).

## Spark SQL - High-Level Interface

Spark SQL is _de facto_ the primary and feature-rich interface to Spark's underlying in-memory distributed platform (hiding Spark Core's RDDs behind higher-level abstractions that allow for [logical](SparkOptimizer.md#batches) and [physical](SparkPlanner.md#strategies) query optimization strategies even without your consent).

In other words, Spark SQL's `Dataset` API describes a distributed computation that will eventually be converted to an [RDD](QueryExecution.md#toRdd) for execution.

Under the covers, structured queries are automatically compiled into corresponding RDD operations.

Spark SQL supports structured queries in **batch** and **streaming** modes (with the latter as a separate module of Spark SQL called **Spark Structured Streaming**).

Spark SQL supports loading datasets from various data sources including tables in Apache Hive. With Hive support enabled, you can load datasets from existing Apache Hive deployments and save them back to Hive tables if needed.

## Query Optimizations

Spark SQL offers performance query optimizations using [Catalyst Optimizer](catalyst/Optimizer.md), [Whole-Stage Codegen](whole-stage-code-generation/index.md) and [Tungsten execution engine](tungsten/index.md).

Quoting [Apache Drill](https://drill.apache.org/) which applies to Spark SQL perfectly:

> A SQL query engine for relational and NoSQL databases with direct queries on self-describing and semi-structured data in files, e.g. JSON or Parquet, and HBase tables without needing to specify metadata definitions in a centralized store.

Spark SQL supports [predicate pushdown](logical-optimizations/PushDownPredicate.md) to optimize query performance and can also [generate optimized code at runtime](catalyst/Optimizer.md).

## Hint Framework

As of Spark SQL 2.2, structured queries can be further optimized using [Hint Framework](new-and-noteworthy/hint-framework.md).

## Spark SQL Paper

Quoting [Spark SQL: Relational Data Processing in Spark](http://people.csail.mit.edu/matei/papers/2015/sigmod_spark_sql.pdf) paper on Spark SQL:

> Spark SQL is a new module in Apache Spark that integrates relational processing with Spark's functional programming API.

> Spark SQL lets Spark programmers leverage the benefits of relational processing (e.g., declarative
queries and optimized storage), and lets SQL users call complex analytics libraries in Spark (e.g., machine learning).

## Further Reading and Watching

* [Spark SQL](http://spark.apache.org/sql/) home page
* (video) [Spark's Role in the Big Data Ecosystem - Matei Zaharia](https://youtu.be/e-Ys-2uVxM0?t=6m44s)
* [Introducing Apache Spark 2.0](https://databricks.com/blog/2016/07/26/introducing-apache-spark-2-0.html)
