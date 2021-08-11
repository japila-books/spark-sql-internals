# ExplainUtils

## <span id="processPlan"> processPlan

```scala
processPlan[T <: QueryPlan[T]](
  plan: => QueryPlan[T],
  append: String => Unit): Unit
```

`processPlan`...FIXME

`processPlan` is used when:

* `QueryExecution` is requested to [simpleString](QueryExecution.md#simpleString) (with `formatted` enabled)

### <span id="processPlanSkippingSubqueries"> processPlanSkippingSubqueries

```scala
processPlanSkippingSubqueries[T <: QueryPlan[T]](
  plan: => QueryPlan[T],
  append: String => Unit,
  startOperatorID: Int): Int
```

`processPlanSkippingSubqueries`...FIXME
