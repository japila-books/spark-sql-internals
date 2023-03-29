# Common Table Expressions

**Common Table Expressions** (_CTEs_) are defined using the [WITH](../sql/AstBuilder.md#withCTE) clause:

```text
WITH namedQuery (',' namedQuery)*

namedQuery
    : name (columnAliases)? AS? '(' query ')'
    ;
```

CTEs allow for _statement scoped views_ that a user can reference (possibly multiple times) within the scope of a SQL statement.

## References

* [Common Table Expression (CTE)](http://spark.apache.org/docs/latest/sql-ref-syntax-qry-select-cte.html) by the offical Spark documentation
* [Common table expression](https://en.wikipedia.org/wiki/Hierarchical_and_recursive_queries_in_SQL#Common_table_expression) by Wikipedia
* [with — Organize Complex Queries](https://modern-sql.com/feature/with)
