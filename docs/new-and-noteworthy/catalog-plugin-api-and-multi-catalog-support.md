# Catalog Plugin API and Multi-Catalog Support

**New in 3.0.0**

Main abstractions:

* [CatalogManager](../connector/catalog/CatalogManager.md)
* [CatalogPlugin](../connector/catalog/CatalogPlugin.md)
* [USE NAMESPACE](../sql/AstBuilder.md#visitUse) SQL statement
* [SHOW CURRENT NAMESPACE](../sql/AstBuilder.md#visitShowCurrentNamespace) SQL statement

## Example

```sql
SHOW NAMESPACES;

SHOW CURRENT NAMESPACE;

CREATE NAMESPACE IF NOT EXISTS my_ns;

USE NAMESPACE my_ns;

SHOW CURRENT NAMESPACE;
```

## References

### Articles

* [SPIP: Identifiers for multi-catalog support](https://issues.apache.org/jira/browse/SPARK-27066)
* [SPIP: Catalog API for table metadata](https://issues.apache.org/jira/browse/SPARK-27067)

### Videos

* [Improving Apache Spark’s Reliability with DataSourceV2](https://youtu.be/rH_iCMuBCII) by Ryan Blue, Netflix
