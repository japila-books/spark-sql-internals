---
hide:
  - toc
---

# Time Travel

**Time Travel** allows SQL queries to use an optional [version or timestamp](../sql/AstBuilder.md#withTimeTravel) in table identifiers:

* `FOR? (SYSTEM_VERSION | VERSION) AS OF version`
* `FOR? (SYSTEM_TIME | TIMESTAMP) AS OF timestamp`

[RelationTimeTravel](../logical-operators/RelationTimeTravel.md) logical operator is used to represent time-travel table specification in a logical query plan.

At [resolution phase](../QueryExecution.md#analyzed), a session [CatalogPlugin](../connector/catalog/CatalogPlugin.md) is requested to [load a versioned table](../connector/catalog/CatalogV2Util.md#loadTable).

## Versioned Tables Unsupported

[TableCatalog](../connector/catalog/TableCatalog.md) throws a `NoSuchTableException` exception when requested to [look up a versioned table](../connector/catalog/TableCatalog.md#getTable).

```text
org.apache.spark.sql.AnalysisException: [UNSUPPORTED_FEATURE.TIME_TRAVEL] The feature is not supported: Time travel on the relation: `spark_catalog`.`default`.`time_travel_demo`.
  at org.apache.spark.sql.errors.QueryCompilationErrors$.timeTravelUnsupportedError(QueryCompilationErrors.scala:3285)
  at org.apache.spark.sql.execution.datasources.v2.V2SessionCatalog.failTimeTravel(V2SessionCatalog.scala:95)
  at org.apache.spark.sql.execution.datasources.v2.V2SessionCatalog.loadTable(V2SessionCatalog.scala:87)
  at org.apache.spark.sql.connector.catalog.CatalogV2Util$.getTable(CatalogV2Util.scala:350)
  at org.apache.spark.sql.connector.catalog.CatalogV2Util$.loadTable(CatalogV2Util.scala:336)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$ResolveRelations$.$anonfun$resolveRelation$3(Analyzer.scala:1268)
```

The decision how to load a versioned table is left to custom [TableCatalog](../connector/catalog/TableCatalog.md#implementations)s (e.g. [Delta Lake]({{ book.delta }}/DeltaCatalog)).

```text
scala> println(io.delta.VERSION)
3.0.0

scala> sql("create table time_travel_demo (id long) using delta")

scala> sql("select * from time_travel_demo version as of 0").show()
+---+
| id|
+---+
+---+
```

## Temporary Views Unsupported

Time travel is not supported on temporary views (as enforced by [ResolveRelations](../logical-analysis-rules/ResolveRelations.md#resolveTempView) logical analysis rule).
