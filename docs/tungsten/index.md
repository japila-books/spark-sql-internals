# Tungsten Execution Backend (Project Tungsten)

The goal of **Project Tungsten** is to improve Spark execution by optimizing Spark jobs for **CPU and memory efficiency** (as opposed to network and disk I/O which are considered fast enough).

Tungsten focuses on the hardware architecture of the platform Spark runs on (including but not limited to JVM, LLVM, GPU, NVRAM) by offering the following optimization features:

1. [Off-Heap Memory Management](#off-heap-memory-management) using binary in-memory data representation aka **Tungsten row format** and managing memory explicitly

1. [Cache Locality](#cache-locality) which is about cache-aware computations with cache-aware layout for high cache hit rates

1. [Whole-Stage Code Generation](#whole-stage-code-generation) (aka _CodeGen_)

Project Tungsten uses `sun.misc.unsafe` API for direct memory access to bypass the JVM in order to avoid garbage collection.

![RDD vs DataFrame Size in Memory in web UI](../images/spark-sql-tungsten-webui-storage.png)

## Off-Heap Memory Management

Project Tungsten aims at substantially reducing the usage of JVM objects (and therefore JVM garbage collection) by introducing its own off-heap binary memory management. Instead of working with Java objects, Tungsten uses `sun.misc.Unsafe` to manipulate raw memory.

Tungsten uses the compact storage format called [UnsafeRow](../UnsafeRow.md) for data representation that further reduces memory footprint.

Since [Datasets](../dataset/index.md) have known [schema](../types/index.md), Tungsten properly and in a more compact and efficient way lays out the objects on its own. That brings benefits similar to using extensions written in low-level and hardware-aware languages like C or assembler.

It is possible immediately with the data being already serialized (that further reduces or completely avoids serialization between JVM object representation and Spark's internal one).

## Cache Locality

Tungsten uses algorithms and *cache-aware data structures* that exploit the physical machine caches at different levels - L1, L2, L3.

## Whole-Stage Java Code Generation

Tungsten does code generation at compile time and generates JVM bytecode to access Tungsten-managed memory structures that gives a very fast access. It uses the [Janino compiler](http://www.janino.net) that is a super-small, super-fast Java compiler.

!!! NOTE
    The code generation was tracked under [SPARK-8159 Improve expression function coverage (Spark 1.5)](https://issues.apache.org/jira/browse/SPARK-8159).

## Further Reading and Watching

* [Project Tungsten: Bringing Spark Closer to Bare Metal](https://databricks.com/blog/2015/04/28/project-tungsten-bringing-spark-closer-to-bare-metal.html)

* (video) [From DataFrames to Tungsten: A Peek into Spark's Future](https://youtu.be/VbSar607HM0) by Reynold Xin (Databricks)

* (video) [Deep Dive into Project Tungsten: Bringing Spark Closer to Bare Metal](https://youtu.be/5ajs8EIPWGI) by Josh Rosen (Databricks)
