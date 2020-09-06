# Columnar Processing

**New in 3.0.0**

**Columnar Processing** (_Columnar Execution_) introduces the following main abstractions:

* [ColumnarRule](../ColumnarRule.md)
* [ApplyColumnarRulesAndInsertTransitions](../physical-optimizations/ApplyColumnarRulesAndInsertTransitions.md) physical optimization

!!! note "Whole-Stage Java Code Generation"
    Columnar Processing is similar and a kind of "opposite" at the same time to [Whole-Stage Java Code Generation](../spark-sql-whole-stage-codegen.md) (which is row-based). It is assumed that if a [plan supports columnar execution](../physical-operators/SparkPlan.md#supportsColumnar), it can't support whole-stage-codegen at the same time (see the [comment in the source code](https://github.com/apache/spark/blob/fd308ade52672840ca4d2afdb655e9b97cb12b28/sql/core/src/main/scala/org/apache/spark/sql/execution/WholeStageCodegenExec.scala#L900-L901)).

Columnar Processing was introduced to Apache Spark 3.0.0 as [SPARK-27396](https://issues.apache.org/jira/browse/SPARK-27396).

## References

### Articles

* [[DISCUSS] Spark Columnar Processing](http://apache-spark-developers-list.1001551.n3.nabble.com/DISCUSS-Spark-Columnar-Processing-td26830.html)
