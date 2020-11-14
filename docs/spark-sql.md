# Spark SQL

## Structured Data Processing with Relational Queries on Massive Scale

Like Apache Spark in general, **Spark SQL** in particular is all about distributed in-memory computations on massive scale.

!!! quote "[Spark SQL: Relational Data Processing in Spark](http://people.csail.mit.edu/matei/papers/2015/sigmod_spark_sql.pdf) paper on Spark SQL"
    Spark SQL is a new module in Apache Spark that integrates relational processing with Spark's functional programming API.

    Spark SQL lets Spark programmers leverage the benefits of relational processing (e.g., declarative
    queries and optimized storage), and lets SQL users call complex analytics libraries in Spark (e.g., machine learning).

The primary difference between the computation models of Spark SQL and Spark Core is the relational framework for ingesting, querying and persisting (semi)structured data using **structured queries** (aka **relational queries**) that can be expressed in _good ol'_ **SQL** (with many features of HiveQL) and the high-level SQL-like functional declarative [Dataset API](Dataset.md) (_Structured Query DSL_).

!!! note
    Semi- and structured data are collections of records that can be described using [schema](spark-sql-schema.md) with column names, their types and whether a column can be null or not (_nullability_).

Whichever query interface you use to describe a structured query, i.e. SQL or Query DSL, the query becomes a [Dataset](Dataset.md) (with a mandatory [Encoder](spark-sql-Encoder.md)).

!!! quote "[Shark, Spark SQL, Hive on Spark, and the future of SQL on Apache Spark](https://databricks.com/blog/2014/07/01/shark-spark-sql-hive-on-spark-and-the-future-of-sql-on-spark.html)"
    For **SQL users**, Spark SQL provides state-of-the-art SQL performance and maintains compatibility with Shark/Hive. In particular, like Shark, Spark SQL supports all existing Hive data formats, user-defined functions (UDF), and the Hive metastore.

    For **Spark users**, Spark SQL becomes the narrow-waist for manipulating (semi-) structured data as well as ingesting data from sources that provide schema, such as JSON, Parquet, Hive, or EDWs. It truly unifies SQL and sophisticated analysis, allowing users to mix and match SQL and more imperative programming APIs for advanced analytics.

    For **open source hackers**, Spark SQL proposes a novel, elegant way of building query planners. It is incredibly easy to add new optimizations under this framework.

A `Dataset` is a programming interface to the [structured query execution pipeline](QueryExecution.md) with [transformations and actions](spark-sql-dataset-operators.md) (as in the good old days of RDD API in Spark Core).

Internally, a structured query is a [Catalyst tree](catalyst/index.md) of (logical and physical) [relational operators](catalyst/QueryPlan.md) and [expressions](expressions/Expression.md).

When an action is executed on a `Dataset` (directly, e.g. spark-sql-dataset-operators.md#show[show] or spark-sql-dataset-operators.md#count[count], or indirectly, e.g. [save](DataFrameWriter.md#save) or [saveAsTable](DataFrameWriter.md#saveAsTable)) the structured query (behind `Dataset`) goes through the [execution stages](QueryExecution.md#execution-pipeline):

1. [Logical Analysis](QueryExecution.md#analyzed)
1. [Caching Replacement](QueryExecution.md#withCachedData)
1. [Logical Query Optimization](QueryExecution.md#optimizedPlan) (using [rule-based](SparkOptimizer.md) and spark-sql-cost-based-optimization.md[cost-based] optimizations)
1. [Physical Planning](QueryExecution.md#sparkPlan)
1. [Physical Optimization](QueryExecution.md#executedPlan) (e.g. [Whole-Stage Java Code Generation](whole-stage-code-generation/index.md) or [Adaptive Query Execution](new-and-noteworthy/adaptive-query-execution.md))
1. [Constructing the RDD of Internal Binary Rows](QueryExecution.md#toRdd) (that represents the structured query in terms of Spark Core's RDD API)

Spark SQL is _de facto_ the primary and feature-rich interface to Spark's underlying in-memory distributed platform (hiding Spark Core's RDDs behind higher-level abstractions that allow for [logical](SparkOptimizer.md#batches) and [physical](SparkPlanner.md#strategies) query optimization strategies even without your consent).

NOTE: You can find out more on the core of Apache Spark (aka _Spark Core_) in https://bit.ly/mastering-apache-spark[Mastering Apache Spark 2] gitbook.

In other words, Spark SQL's `Dataset` API describes a distributed computation that will eventually be converted to an [RDD](QueryExecution.md#toRdd) for execution.

NOTE: Under the covers, structured queries are automatically compiled into corresponding RDD operations.

Spark SQL supports structured queries in *batch* and *streaming* modes (with the latter as a separate module of Spark SQL called *Spark Structured Streaming*).

NOTE: You can find out more on Spark Structured Streaming in https://bit.ly/spark-structured-streaming[Spark Structured Streaming (Apache Spark 2.2+)] gitbook.

```text
// Define the schema using a case class
case class Person(name: String, age: Int)

// you could read people from a CSV file
// It's been a while since you saw RDDs, hasn't it?
// Excuse me for bringing you the old past.
import org.apache.spark.rdd.RDD
val peopleRDD: RDD[Person] = sc.parallelize(Seq(Person("Jacek", 10)))

// Convert RDD[Person] to Dataset[Person] and run a query

// Automatic schema inferrence from existing RDDs
scala> val people = peopleRDD.toDS
people: org.apache.spark.sql.Dataset[Person] = [name: string, age: int]

// Query for teenagers using Scala Query DSL
scala> val teenagers = people.where('age >= 10).where('age <= 19).select('name).as[String]
teenagers: org.apache.spark.sql.Dataset[String] = [name: string]

scala> teenagers.show
+-----+
| name|
+-----+
|Jacek|
+-----+

// You could however want to use good ol' SQL, couldn't you?

// 1. Register people Dataset as a temporary view in Catalog
people.createOrReplaceTempView("people")

// 2. Run SQL query
val teenagers = sql("SELECT * FROM people WHERE age >= 10 AND age <= 19")
scala> teenagers.show
+-----+---+
| name|age|
+-----+---+
|Jacek| 10|
+-----+---+
```

Spark SQL supports loading datasets from various data sources including tables in Apache Hive. With Hive support enabled, you can load datasets from existing Apache Hive deployments and save them back to Hive tables if needed.

```text
sql("CREATE OR REPLACE TEMPORARY VIEW v1 (key INT, value STRING) USING csv OPTIONS ('path'='people.csv', 'header'='true')")

// Queries are expressed in HiveQL
sql("FROM v1").show

scala> sql("desc EXTENDED v1").show(false)
+----------+---------+-------+
|col_name  |data_type|comment|
+----------+---------+-------+
|# col_name|data_type|comment|
|key       |int      |null   |
|value     |string   |null   |
+----------+---------+-------+
```

Like SQL and NoSQL databases, Spark SQL offers performance query optimizations using [rule-based logical query optimizer](catalyst/Optimizer.md) (aka *Catalyst Optimizer*), [whole-stage Java code generation](whole-stage-code-generation/index.md) (aka *Whole-Stage Codegen* that could often be better than your own custom hand-written code!) and spark-sql-tungsten.md[Tungsten execution engine] with its own [InternalRow](InternalRow.md).

As of Spark SQL 2.2, structured queries can be further optimized using [Hint Framework](new-and-noteworthy/hint-framework.md).

Spark SQL introduces a tabular data abstraction called Dataset.md[Dataset] (that was previously spark-sql-DataFrame.md[DataFrame]). ``Dataset`` data abstraction is designed to make processing large amount of structured tabular data on Spark infrastructure simpler and faster.

[NOTE]
====
Quoting https://drill.apache.org/[Apache Drill] which applies to Spark SQL perfectly:

> A SQL query engine for relational and NoSQL databases with direct queries on self-describing and semi-structured data in files, e.g. JSON or Parquet, and HBase tables without needing to specify metadata definitions in a centralized store.
====

The following snippet shows a *batch ETL pipeline* to process JSON files and saving their subset as CSVs.

```scala
spark.read
  .format("json")
  .load("input-json")
  .select("name", "score")
  .where($"score" > 15)
  .write
  .format("csv")
  .save("output-csv")
```

With Structured Streaming feature however, the above static batch query becomes dynamic and continuous paving the way for **continuous applications**.

As of Spark 2.0, the main data abstraction of Spark SQL is Dataset.md[Dataset]. It represents a *structured data* which are records with a known schema. This structured data representation `Dataset` enables spark-sql-tungsten.md[compact binary representation] using compressed columnar format that is stored in managed objects outside JVM's heap. It is supposed to speed computations up by reducing memory usage and GCs.

Spark SQL supports PushDownPredicate.md[predicate pushdown] to optimize performance of Dataset queries and can also [generate optimized code at runtime](catalyst/Optimizer.md).

Spark SQL comes with the different APIs to work with:

1. Dataset.md[Dataset API] (formerly spark-sql-DataFrame.md[DataFrame API]) with a strongly-typed LINQ-like Query DSL that Scala programmers will likely find very appealing to use.
2. spark-structured-streaming.md[Structured Streaming API (aka Streaming Datasets)] for continuous incremental execution of structured queries.
3. Non-programmers will likely use SQL as their query language through direct integration with Hive
4. JDBC/ODBC fans can use JDBC interface (through spark-sql-thrift-server.md[Thrift JDBC/ODBC Server]) and connect their tools to Spark's distributed query engine.

Spark SQL comes with a uniform interface for data access in distributed storage systems like Cassandra or HDFS (Hive, Parquet, JSON) using specialized [DataFrameReader](DataFrameReader.md) and [DataFrameWriter](DataFrameWriter.md) objects.

Spark SQL allows you to execute SQL-like queries on large volume of data that can live in Hadoop HDFS or Hadoop-compatible file systems like S3. It can access data from different data sources - files or tables.

Spark SQL defines the following types of functions:

* spark-sql-functions.md[standard functions] or spark-sql-udfs.md[User-Defined Functions (UDFs)] that take values from a single row as input to generate a single return value for every input row.
* spark-sql-basic-aggregation.md[basic aggregate functions] that operate on a group of rows and calculate a single return value per group.
* spark-sql-functions-windows.md[window aggregate functions] that operate on a group of rows and calculate a single return value for each row in a group.

There are two supported *catalog* implementations -- `in-memory` (default) and `hive` -- that you can set using StaticSQLConf.md#spark.sql.catalogImplementation[spark.sql.catalogImplementation] property.

From user@spark:

> If you already loaded csv data into a dataframe, why not register it as a table, and use Spark SQL
to find max/min or any other aggregates? SELECT MAX(column_name) FROM dftable_name ... seems natural.

> you're more comfortable with SQL, it might worth registering this DataFrame as a table and generating SQL query to it (generate a string with a series of min-max calls)

You can parse data from external data sources and let the _schema inferencer_ to deduct the schema.

```
// Example 1
val df = Seq(1 -> 2).toDF("i", "j")
val query = df.groupBy('i)
  .agg(max('j).as("aggOrdering"))
  .orderBy(sum('j))
  .as[(Int, Int)]
query.collect contains (1, 2) // true

// Example 2
val df = Seq((1, 1), (-1, 1)).toDF("key", "value")
df.createOrReplaceTempView("src")
scala> sql("SELECT IF(a > 0, a, 0) FROM (SELECT key a FROM src) temp").show
+-------------------+
|(IF((a > 0), a, 0))|
+-------------------+
|                  1|
|                  0|
+-------------------+
```

## Further Reading and Watching

* [Spark SQL](http://spark.apache.org/sql/) home page
* (video) [Spark's Role in the Big Data Ecosystem - Matei Zaharia](https://youtu.be/e-Ys-2uVxM0?t=6m44s)
* [Introducing Apache Spark 2.0](https://databricks.com/blog/2016/07/26/introducing-apache-spark-2-0.html)
