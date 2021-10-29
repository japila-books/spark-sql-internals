# TableCatalog

`TableCatalog` is an [extension](#contract) of the [CatalogPlugin](CatalogPlugin.md) abstraction for [table catalogs](#implementations).

## Contract

### <span id="alterTable"> alterTable

```java
Table alterTable(
  Identifier ident,
  TableChange... changes)
```

[TableChange](TableChange.md)s to alter a table

Used when:

* [AlterTableExec](../../physical-operators/AlterTableExec.md) physical command is executed

### <span id="createTable"> createTable

```java
Table createTable(
  Identifier ident,
  StructType schema,
  Transform[] partitions,
  Map<String, String> properties)
```

Used when the following commands are executed:

* `CreateTableExec`
* `ReplaceTableExec`
* [CreateTableAsSelectExec](../../physical-operators/CreateTableAsSelectExec.md)
* `ReplaceTableAsSelectExec`

### <span id="dropTable"> dropTable

```java
boolean dropTable(
  Identifier ident)
```

Used when the following commands are executed:

* `DropTableExec`
* `ReplaceTableExec`
* [CreateTableAsSelectExec](../../physical-operators/CreateTableAsSelectExec.md)
* `ReplaceTableAsSelectExec`

### <span id="listTables"> Listing Tables

```java
Identifier[] listTables(
  String[] namespace)
```

Used when the following commands are executed:

* [DropNamespaceExec](../../physical-operators/DropNamespaceExec.md)
* [ShowTablesExec](../../physical-operators/ShowTablesExec.md)

### <span id="loadTable"> Loading Table

```java
Table loadTable(
  Identifier ident)
```

Used when:

* `CatalogV2Util` is requested to [load a table](CatalogV2Util.md#loadTable)
* `DataFrameReader` is requested to [load](../../DataFrameReader.md#load) (for [SupportsCatalogOptions](SupportsCatalogOptions.md) providers)
* `DataFrameWriter` is requested to [save](../../DataFrameWriter.md#save), [insertInto](../../DataFrameWriter.md#insertInto) and [saveAsTable](../../DataFrameWriter.md#saveAsTable)
* `DelegatingCatalogExtension` is requested to [loadTable](DelegatingCatalogExtension.md#loadTable)
* `TableCatalog` is requested to [tableExists](#tableExists)
* `V2SessionCatalog` is requested to [createTable](../../V2SessionCatalog.md#createTable), [alterTable](../../V2SessionCatalog.md#alterTable), [dropTable](../../V2SessionCatalog.md#dropTable), [renameTable](../../V2SessionCatalog.md#renameTable)

### <span id="renameTable"> renameTable

```java
void renameTable(
  Identifier oldIdent,
  Identifier newIdent)
```

Used when the following commands are executed:

* `RenameTableExec`

### <span id="tableExists"> tableExists

```java
boolean tableExists(
  Identifier ident)
```

Used when:

* The following commands are executed:
  * `AtomicCreateTableAsSelectExec`
  * `AtomicReplaceTableAsSelectExec`
  * `AtomicReplaceTableExec`
  * [CreateTableAsSelectExec](../../physical-operators/CreateTableAsSelectExec.md)
  * `CreateTableExec`
  * `DropTableExec`
  * `ReplaceTableAsSelectExec`
  * `ReplaceTableExec`

* `V2SessionCatalog` is requested to [renameTable](../../V2SessionCatalog.md#renameTable)

## Implementations

* [CatalogExtension](CatalogExtension.md)
* [StagingTableCatalog](StagingTableCatalog.md)
* [V2SessionCatalog](../../V2SessionCatalog.md)
