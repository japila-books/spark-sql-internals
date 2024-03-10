# AggregatedDialect

`AggregatedDialect` is a [JdbcDialect](JdbcDialect.md).

## Creating Instance

`AggregatedDialect` takes the following to be created:

* <span id="dialects"> [JdbcDialect](JdbcDialect.md)s

`AggregatedDialect` is created when:

* `JdbcDialects` is requested for the [dialect](JdbcDialects.md#get) to handle a given URL (and there are two or more dialects)

## getTableExistsQuery { #getTableExistsQuery }

??? note "JdbcDialect"

    ```scala
    getTableExistsQuery(
      table: String): String
    ```

    `getTableExistsQuery` is part of the [JdbcDialect](JdbcDialect.md#getTableExistsQuery) abstraction.

`getTableExistsQuery` requests the first dialect (in the [dialects](#dialects)) to [getTableExistsQuery](JdbcDialect.md#getTableExistsQuery).
