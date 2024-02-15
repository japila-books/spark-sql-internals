---
title: CreateTempViewUsing
---

# CreateTempViewUsing Logical Command

`CreateTempViewUsing` is a [LeafRunnableCommand](LeafRunnableCommand.md) that represents the following SQL statement at execution:

```sql
CREATE (OR REPLACE)? GLOBAL? TEMPORARY VIEW
  tableIdentifier ('(' colTypeList ')')?
  USING multipartIdentifier
  (OPTIONS propertyList)?
```

## Creating Instance

`CreateTempViewUsing` takes the following to be created:

* <span id="tableIdent"> `TableIdentifier`
* <span id="userSpecifiedSchema"> User-Specified Schema
* <span id="replace"> `replace` flag
* <span id="global"> `global` flag
* <span id="provider"> Provider Name
* <span id="options"> Options

`CreateTempViewUsing` is created when:

* `SparkSqlAstBuilder` is requested to parse [CREATE TEMPORARY TABLE USING](../sql/SparkSqlAstBuilder.md#visitCreateTable) (_deprecated_) and [CREATE TEMPORARY VIEW](../sql/SparkSqlAstBuilder.md#visitCreateTempViewUsing) statements
