# DDLUtils

## checkTableColumns { #checkTableColumns }

```scala
checkTableColumns(
  table: CatalogTable): Unit
checkTableColumns(
  table: CatalogTable,
  schema: StructType): Unit
```

??? warning "Procedure"
    `checkTableColumns` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

`checkTableColumns`...FIXME

---

`checkTableColumns` is used when:

* [AlterTableAddColumnsCommand](../logical-operators/AlterTableAddColumnsCommand.md) is executed
* [RelationConversions](../hive/RelationConversions.md) logical evaluation rule is executed (for hive tables)
* [InsertIntoHiveDirCommand](../hive/InsertIntoHiveDirCommand.md) is executed (for hive tables)
* [PreprocessTableCreation](../logical-analysis-rules/PreprocessTableCreation.md) is executed (for [CreateTable](../logical-operators/CreateTable.md) logical operator)

## checkDataColNames { #checkDataColNames }

```scala
checkDataColNames(
  provider: String,
  schema: StructType): Unit
```

??? warning "Procedure"
    `checkDataColNames` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

`checkDataColNames`...FIXME
