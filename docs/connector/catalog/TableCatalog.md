# TableCatalog

`TableCatalog` is an [extension](#contract) of the [CatalogPlugin](CatalogPlugin.md) abstraction for [table catalogs](#implementations).

## Contract

### Alter Table { #alterTable }

```java
Table alterTable(
  Identifier ident,
  TableChange... changes)
```

Changes (_alters_) a table based on the given [TableChange](TableChange.md)s

Used when:

* [AlterTableExec](../../physical-operators/AlterTableExec.md) physical command is executed
* `DelegatingCatalogExtension` is requested to [alterTable](DelegatingCatalogExtension.md#alterTable)

### Create Table { #createTable }

```java
Table createTable(
  Identifier ident,
  Column[] columns,
  Transform[] partitions,
  Map<String, String> properties)
```

See:

* [V2SessionCatalog](../../V2SessionCatalog.md#createTable)

Used when the following commands are executed:

* `CreateTableExec`
* `ReplaceTableExec`
* [CreateTableAsSelectExec](../../physical-operators/CreateTableAsSelectExec.md)
* `ReplaceTableAsSelectExec`

### Drop Table { #dropTable }

```java
boolean dropTable(
  Identifier ident)
```

Used when the following commands are executed:

* `DropTableExec`
* `ReplaceTableExec`
* [CreateTableAsSelectExec](../../physical-operators/CreateTableAsSelectExec.md)
* `ReplaceTableAsSelectExec`

### List Tables { #listTables }

```java
Identifier[] listTables(
  String[] namespace)
```

Used when the following commands are executed:

* [DropNamespaceExec](../../physical-operators/DropNamespaceExec.md)
* [ShowTablesExec](../../physical-operators/ShowTablesExec.md)

### Load Table { #loadTable }

```java
Table loadTable(
  Identifier ident)
Table loadTable(
  Identifier ident,
  long timestamp)
Table loadTable(
  Identifier ident,
  String version)
```

Used when:

* `CatalogV2Util` is requested to [load a table](CatalogV2Util.md#getTable)
* `DataFrameReader` is requested to [load](../../DataFrameReader.md#load) (for [SupportsCatalogOptions](SupportsCatalogOptions.md) providers)
* `DataFrameWriter` is requested to [save](../../DataFrameWriter.md#save), [insertInto](../../DataFrameWriter.md#insertInto) and [saveAsTable](../../DataFrameWriter.md#saveAsTable)
* `DelegatingCatalogExtension` is requested to [loadTable](DelegatingCatalogExtension.md#loadTable)
* `TableCatalog` is requested to [tableExists](#tableExists)
* `V2SessionCatalog` is requested to [createTable](../../V2SessionCatalog.md#createTable), [alterTable](../../V2SessionCatalog.md#alterTable), [dropTable](../../V2SessionCatalog.md#dropTable), [renameTable](../../V2SessionCatalog.md#renameTable)

### Rename Table { #renameTable }

```java
void renameTable(
  Identifier oldIdent,
  Identifier newIdent)
```

Used when the following commands are executed:

* `RenameTableExec`

### Table Exists { #tableExists }

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
* [JDBCTableCatalog](../../jdbc/JDBCTableCatalog.md)
* [StagingTableCatalog](StagingTableCatalog.md)
* [V2SessionCatalog](../../V2SessionCatalog.md)
