# View

`View` is an [extension](#contract) of the [GraphElement](GraphElement.md) abstraction for [dataflow graph elements](#implementations) that represent [persisted](PersistedView.md) and [temporary views](TemporaryView.md) in a declarative pipeline.

## Contract

### Comment { #comment }

```scala
comment: Option[String]
```

Used when:

* `PipelinesHandler` is requested to [define an output](PipelinesHandler.md#defineOutput)
* `SqlGraphRegistrationContext` is requested to [process the SQL queries](SqlGraphRegistrationContext.md#processSqlQuery):
    * `CREATE VIEW`
    * `CREATE TEMPORARY VIEW`

### Properties { #properties }

```scala
properties: Map[String, String]
```

Used when:

* `PipelinesHandler` is requested to [define an output](PipelinesHandler.md#defineOutput)
* `SqlGraphRegistrationContext` is requested to [process the SQL queries](SqlGraphRegistrationContext.md#processSqlQuery):
    * `CREATE VIEW`
    * `CREATE TEMPORARY VIEW`
* `DatasetManager` is requested to [materialize a view](DatasetManager.md#materializeView)

### SQL Text { #sqlText }

```scala
sqlText: Option[String]
```

Used when:

* `PipelinesHandler` is requested to [define an output](PipelinesHandler.md#defineOutput)
* `SqlGraphRegistrationContext` is requested to [process the SQL queries](SqlGraphRegistrationContext.md#processSqlQuery):
    * `CREATE VIEW`
    * `CREATE TEMPORARY VIEW`

## Implementations

* [PersistedView](PersistedView.md)
* [TemporaryView](TemporaryView.md)
