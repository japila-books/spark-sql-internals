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

### transformMapPartitions { #transformMapPartitions }

```scala
transformMapPartitions(
  rel: proto.MapPartitions): LogicalPlan
```

`transformMapPartitions`...FIXME

## transformPythonUDF { #transformPythonUDF }

```scala
transformPythonUDF(
  fun: proto.CommonInlineUserDefinedFunction): PythonUDF
```

`transformPythonUDF` creates a [PythonUDF](../expressions/PythonUDF.md) (based on the given `fun` and [transformPythonFunction](#transformPythonFunction)).

---

`transformPythonUDF` is used when:

* `SparkConnectPlanner` is requested to [transformMapPartitions](#transformMapPartitions), [transformGroupMap](#transformGroupMap), [transformCoGroupMap](#transformCoGroupMap), [transformCommonInlineUserDefinedFunction](#transformCommonInlineUserDefinedFunction)

## transformPythonFunction { #transformPythonFunction }

```scala
transformPythonFunction(
  fun: proto.PythonUDF): SimplePythonFunction
```

`transformPythonFunction`...FIXME

---

`transformPythonFunction` is used when:

* `SparkConnectPlanner` is requested to [transformPythonUDF](#transformPythonUDF) and [handleRegisterPythonUDF](#handleRegisterPythonUDF)
