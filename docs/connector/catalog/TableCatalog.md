# TableCatalog

`TableCatalog` is an [extension](#contract) of the [CatalogPlugin](CatalogPlugin.md) abstraction for [table catalogs](#implementations).

## Contract

### <span id="alterTable"> alterTable

```java
Table alterTable(
  Identifier ident,
  TableChange... changes)
```

Used when the following commands are executed:

* [AlterTableExec](../../physical-operators/AlterTableExec.md)

### <span id="createTable"> createTable

```java
Table createTable(
  Identifier ident,
  StructType schema,
  Transform[] partitions,
  Map<String, String> properties)
```

Used when the following commands are executed:

* [CreateTableExec](../../physical-operators/CreateTableExec.md)
* [ReplaceTableExec](../../physical-operators/ReplaceTableExec.md)
* [CreateTableAsSelectExec](../../physical-operators/CreateTableAsSelectExec.md)
* [ReplaceTableAsSelectExec](../../physical-operators/ReplaceTableAsSelectExec.md)

### <span id="dropTable"> dropTable

```java
boolean dropTable(
  Identifier ident)
```

Used when the following commands are executed:

* [DropTableExec](../../physical-operators/DropTableExec.md)
* [ReplaceTableExec](../../physical-operators/ReplaceTableExec.md)
* [CreateTableAsSelectExec](../../physical-operators/CreateTableAsSelectExec.md)
* [ReplaceTableAsSelectExec](../../physical-operators/ReplaceTableAsSelectExec.md)

### <span id="invalidateTable"> invalidateTable

```java
void invalidateTable(
  Identifier ident)
```

Used when the following commands are executed:

* [RefreshTableExec](../../physical-operators/RefreshTableExec.md)
* [RenameTableExec](../../physical-operators/RenameTableExec.md)

### <span id="listTables"> listTables

```java
Identifier[] listTables(
  String[] namespace)
```

Used when the following commands are executed:

* [DropNamespaceExec](../../physical-operators/DropNamespaceExec.md)
* [ShowTablesExec](../../physical-operators/ShowTablesExec.md)

### <span id="loadTable"> loadTable

```java
Table loadTable(
  Identifier ident)
```

Used when:

* `DataFrameReader` is requested to [load](../../DataFrameReader.md#load) (for [SupportsCatalogOptions](SupportsCatalogOptions.md) providers)

* `DataFrameWriter` is requested to [save](../../spark-sql-DataFrameWriter.md#save), [insertInto](../../spark-sql-DataFrameWriter.md#insertInto) and [saveAsTable](../../spark-sql-DataFrameWriter.md#saveAsTable)

* `V2SessionCatalog` is requested to [createTable](../../V2SessionCatalog.md#createTable), [alterTable](../../V2SessionCatalog.md#alterTable), [dropTable](../../V2SessionCatalog.md#dropTable), [renameTable](../../V2SessionCatalog.md#renameTable)

* `TableCatalog` is requested to [tableExists](#tableExists)

* `CatalogV2Util` is requested to [loadTable](CatalogV2Util.md#loadTable)

### <span id="renameTable"> renameTable

```java
void renameTable(
  Identifier oldIdent,
  Identifier newIdent)
```

Used when the following commands are executed:

* [RenameTableExec](../../physical-operators/RenameTableExec.md)

### <span id="tableExists"> tableExists

```java
boolean tableExists(
  Identifier ident)
```

Used when:

* The following commands are executed:
  * [AtomicCreateTableAsSelectExec](../../physical-operators/AtomicCreateTableAsSelectExec.md)
  * [AtomicReplaceTableAsSelectExec](../../physical-operators/AtomicReplaceTableAsSelectExec.md)
  * [AtomicReplaceTableExec](../../physical-operators/AtomicReplaceTableExec.md)
  * [CreateTableAsSelectExec](../../physical-operators/CreateTableAsSelectExec.md)
  * [CreateTableExec](../../physical-operators/CreateTableExec.md)
  * [DropTableExec](../../physical-operators/DropTableExec.md)
  * [ReplaceTableAsSelectExec](../../physical-operators/ReplaceTableAsSelectExec.md)
  * [ReplaceTableExec](../../physical-operators/ReplaceTableExec.md)

* `V2SessionCatalog` is requested to [renameTable](../../V2SessionCatalog.md#renameTable)

## Implementations

* [CatalogExtension](CatalogExtension.md)
* [StagingTableCatalog](StagingTableCatalog.md)
* [V2SessionCatalog](../../V2SessionCatalog.md)
