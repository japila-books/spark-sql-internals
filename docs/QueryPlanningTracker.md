# QueryPlanningTracker

`QueryPlanningTracker` is used to track structured query execution phases:

* <span id="PARSING"> **parsing** (when `SparkSession` is requested to [execute a SQL query](SparkSession.md#sql))
* <span id="ANALYSIS"> **analysis** (when `QueryExecution` is requested for an [analyzed query plan](QueryExecution.md#analyzed))
* <span id="OPTIMIZATION"> **optimization** (when `QueryExecution` is requested for an [optimized query plan](QueryExecution.md#optimizedPlan))
* <span id="PLANNING"> **planning** (when `QueryExecution` is requested for an [physical](QueryExecution.md#sparkPlan) and [executed](QueryExecution.md#executedPlan) query plans)

## Accessing QueryPlanningTracker

`QueryPlanningTracker` of a structured query is available using [QueryExecution](spark-sql-Dataset.md#queryExecution).

```text
val df_ops = spark.range(1000).selectExpr("count(*)")
val tracker = df_ops.queryExecution.tracker

// There are three execution phases tracked for structured queries using Dataset API
assert(tracker.phases.keySet == Set("analysis", "optimization", "planning"))
```

```text
val df_sql = sql("SELECT * FROM range(1000)")
val tracker = df_sql.queryExecution.tracker

// There are four execution phases tracked for structured queries using SQL
assert(tracker.phases.keySet == Set("parsing", "analysis", "optimization", "planning"))
```

## Creating Instance

`QueryPlanningTracker` takes no arguments to be created.

`QueryPlanningTracker` is created when:

* `SparkSession` is requested to [execute a SQL query](SparkSession.md#sql)

* `QueryExecution` is [created](QueryExecution.md#tracker)

## <span id="get"> Getting QueryPlanningTracker

```text
get: Option[QueryPlanningTracker]
```

`get` utility allows to access the `QueryPlanningTracker` bound to the current thread (using a thread local variable facility).

```text
import org.apache.spark.sql.catalyst.QueryPlanningTracker

scala> :type QueryPlanningTracker.get
Option[org.apache.spark.sql.catalyst.QueryPlanningTracker]
```

`get` is used when `RuleExecutor` is requested to [execute rules on a query plan](catalyst/RuleExecutor.md#execute)

## <span id="measurePhase"> Measuring Execution Phase

```text
measurePhase[T](
  phase: String)(f: => T): T
```

`measurePhase`...FIXME

`measurePhase` is used when:

* `SparkSession` is requested to [execute a SQL query](SparkSession.md#sql)

* `QueryExecution` is requested to [executePhase](QueryExecution.md#executePhase)

## <span id="phases"> Execution Phases Summaries

```scala
phases: Map[String, PhaseSummary]
```

`phases` gives [phasesMap](#phasesMap).

## <span id="phasesMap"> phasesMap Internal Registry

```scala
phasesMap: HashMap[String, PhaseSummary]
```

`phasesMap` is used as a registry of execution phase summaries when `QueryPlanningTracker` is requested to [measure phase](#measurePhase).

`phasesMap` is available using [phases](#phases) method.
