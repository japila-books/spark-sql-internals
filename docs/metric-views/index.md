# Metric Views :material-new-box:{ title="New in 4.2.0" }

[Apache Spark 4.2.0](https://issues.apache.org/jira/browse/SPARK-54119) introduces support for **metric views** which are views with measures and dimensions.

Per the [SPIP](https://docs.google.com/document/d/1xVTLijvDTJ90lZ_ujwzf9HvBJgWg0mY6cYM44Fcghl0/edit?tab=t.0#heading=h.5fdy0uyv19hp), Spark users can define business metrics (e.g., "active users", "revenue", or "revenue per customer") once and then ask for those metrics by dimension (date, country, product).

Metric views are created using [CREATE VIEW WITH METRICS](../sql/SparkSqlAstBuilder.md#visitCreateMetricView) SQL statement.

```sql
CREATE OR REPLACE VIEW metric_view
WITH METRICS
LANGUAGE YAML
AS $$
version: 0.1

source: SELECT * FROM range(5)
$$
```

Metric views use dimensions and measures for proper aggregation semantics.

## How Metric Views Was Tested

```console
build/sbt "catalyst/testOnly org.apache.spark.sql.metricview.serde.MetricViewFactorySuite"
```

```text
[info] MetricViewFactorySuite:
[info] - fromYAML - parse basic metric view with asset source (282 milliseconds)
[info] - fromYAML - parse metric view with SQL source (74 milliseconds)
[info] - fromYAML - parse metric view with filter clause (5 milliseconds)
[info] - fromYAML - parse metric view with multiple dimensions and measures (8 milliseconds)
[info] - fromYAML - invalid YAML version (2 milliseconds)
[info] - fromYAML - malformed YAML (2 milliseconds)
[info] - toYAML - serialize basic metric view (17 milliseconds)
[info] - toYAML - serialize metric view with SQL source (3 milliseconds)
[info] - toYAML - serialize metric view with filter clause (7 milliseconds)
[info] - roundtrip - fromYAML and toYAML preserve data (9 milliseconds)
[info] - roundtrip - SQL source preservation (9 milliseconds)
[info] - column ordinals are preserved (3 milliseconds)
[info] - column metadata extraction (4 milliseconds)
[info] - empty source validation (3 milliseconds)
[info] - complex SQL expressions in measures (2 milliseconds)
[info] - special characters in column names and expressions (3 milliseconds)
[info] Run completed in 977 milliseconds.
[info] Total number of tests run: 16
[info] Suites: completed 1, aborted 0
[info] Tests: succeeded 16, failed 0, canceled 0, ignored 0, pending 0
[info] All tests passed.
```

## Learn More

1. [Introducing Apache Spark 4.2](https://www.databricks.com/blog/introducing-apache-spark-42)
1. [Why do we need Unity Catalog Metric Views?](https://medium.com/@cheegodchang/why-do-we-need-unity-catalog-metric-views-455ce259519e?sharedUserId=jaceklaskowski)