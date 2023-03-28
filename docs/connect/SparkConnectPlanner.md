# SparkConnectPlanner

## Creating Instance

`SparkConnectPlanner` takes the following to be created:

* <span id="session"> [SparkSession](../SparkSession.md)

`SparkConnectPlanner` is created when:

* `SparkConnectAnalyzeHandler` is requested to [process a request](SparkConnectAnalyzeHandler.md#process)
* `SparkConnectStreamHandler` is requested to [handlePlan](SparkConnectStreamHandler.md#handlePlan) and [handleCommand](SparkConnectStreamHandler.md#handleCommand)

## transformRelation { #transformRelation }

```scala
transformRelation(
  rel: proto.Relation): LogicalPlan
```

`transformRelation`...FIXME

---

`transformRelation` is used when:

* `SparkConnectAnalyzeHandler` is requested to [process a request](SparkConnectAnalyzeHandler.md#process)
* `SparkConnectStreamHandler` is requested to [handlePlan](SparkConnectStreamHandler.md#handlePlan)

### transformRelationPlugin { #transformRelationPlugin }

```scala
transformRelationPlugin(
  extension: ProtoAny): LogicalPlan
```

`transformRelationPlugin`...FIXME
