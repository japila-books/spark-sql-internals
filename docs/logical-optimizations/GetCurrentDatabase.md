# GetCurrentDatabase Logical Optimization

`GetCurrentDatabase` is a [base logical optimization](../Optimizer.md#batches) that <<apply, gives the current database>> for `current_database` SQL function.

`GetCurrentDatabase` is part of the [Finish Analysis](../Optimizer.md#GetCurrentDatabase) once-executed batch in the standard batches of the [Logical Optimizer](../Optimizer.md).

`GetCurrentDatabase` is simply a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.md#, logical plans>>, i.e. `Rule[LogicalPlan]`.

```text
val q = sql("SELECT current_database() AS db")
val analyzedPlan = q.queryExecution.analyzed

scala> println(analyzedPlan.numberedTreeString)
00 Project [current_database() AS db#22]
01 +- OneRowRelation

import org.apache.spark.sql.catalyst.optimizer.GetCurrentDatabase

val afterGetCurrentDatabase = GetCurrentDatabase(spark.sessionState.catalog)(analyzedPlan)
scala> println(afterGetCurrentDatabase.numberedTreeString)
00 Project [default AS db#22]
01 +- OneRowRelation
```

!!! note
    `GetCurrentDatabase` corresponds to SQL's `current_database()` function.

    You can access the current database in Scala using

    ```text
    scala> val database = spark.catalog.currentDatabase
    database: String = default
    ```

## <span id="apply"> Executing Rule

```scala
apply(plan: LogicalPlan): LogicalPlan
```

`apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
