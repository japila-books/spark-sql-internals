# JdbcUtils

## tableExists { #tableExists }

```scala
tableExists(
  conn: Connection,
  options: JdbcOptionsInWrite): Boolean
```

`tableExists`...FIXME

---

`tableExists` is used when:

* `JdbcRelationProvider` is requested to [create a relation](JdbcRelationProvider.md#createRelation)
* `JDBCTableCatalog` is requested to [tableExists](JDBCTableCatalog.md#tableExists)
