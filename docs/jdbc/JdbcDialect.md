---
tags:
  - DeveloperApi
---

# JdbcDialect

`JdbcDialect` is an [abstraction](#contract) of [JDBC dialects](#implementations) that [can handle a specific JDBC URL](#canHandle) and all the necessary type-related conversions to properly load a data from a JDBC table into a `DataFrame`.

`JdbcDialect` is a `Serializable` ([Java]({{ java.api }}/java/io/Serializable.html)).

`JdbcDialect` is a `DeveloperApi`.

## Contract

### canHandle { #canHandle }

```scala
canHandle(
  url : String): Boolean
```

Checks out whether the dialect can handle the given JDBC URL

Used when:

* `JdbcDialects` is requested for the [dialect](JdbcDialects.md#get) to handle a given URL

## Implementations

* [AggregatedDialect](AggregatedDialect.md)
* _others_

## getTableExistsQuery { #getTableExistsQuery }

```scala
getTableExistsQuery(
  table: String): String
```

`getTableExistsQuery` is the following SQL statement (to be used to find out if the [table](#table) exists):

```text
SELECT 1 FROM [table] WHERE 1=0
```

---

`getTableExistsQuery` is used when:

* `JdbcUtils` is requested to [tableExists](JdbcUtils.md#tableExists)
* `AggregatedDialect` is requested to [getTableExistsQuery](AggregatedDialect.md#getTableExistsQuery)
