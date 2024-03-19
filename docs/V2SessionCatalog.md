# V2SessionCatalog

`V2SessionCatalog` is a [TableCatalog](connector/catalog/TableCatalog.md) that makes the good ol' [SessionCatalog](SessionCatalog.md) available in the modern [Catalog Plugin API](connector/catalog/index.md)-based infrastructure.

`V2SessionCatalog` is known under the name of [spark_catalog](#name).

`V2SessionCatalog` is a [SupportsNamespaces](connector/catalog/SupportsNamespaces.md).

`V2SessionCatalog` is the [default session catalog](connector/catalog/CatalogManager.md#defaultSessionCatalog) of [CatalogManager](connector/catalog/CatalogManager.md).

## Creating Instance

`V2SessionCatalog` takes the following to be created:

* <span id="catalog"> [SessionCatalog](SessionCatalog.md)
* <span id="conf"> [SQLConf](SQLConf.md)

`V2SessionCatalog` is created when:

* `BaseSessionStateBuilder` is requested for [one](BaseSessionStateBuilder.md#v2SessionCatalog)

## capabilities { #capabilities }

??? note "TableCatalog"

    ```scala
    capabilities(): Set[TableCatalogCapability]
    ```

    `capabilities` is part of the [TableCatalog](connector/catalog/TableCatalog.md#capabilities) abstraction.

`capabilities` is [SUPPORT_COLUMN_DEFAULT_VALUE](connector/catalog/TableCatalogCapability.md#SUPPORT_COLUMN_DEFAULT_VALUE).

## Default Namespace { #defaultNamespace }

??? note "CatalogPlugin"

    ```scala
    defaultNamespace: Array[String]
    ```

    `defaultNamespace` is part of the [CatalogPlugin](connector/catalog/CatalogPlugin.md#defaultNamespace) abstraction.

`defaultNamespace` is **default**.

## Name

??? note "CatalogPlugin"

    ```scala
    name: String
    ```

    `name` is part of the [CatalogPlugin](connector/catalog/CatalogPlugin.md#name) abstraction.

The name of `V2SessionCatalog` is [spark_catalog](connector/catalog/CatalogManager.md#SESSION_CATALOG_NAME).

## Loading Table { #loadTable }

??? note "TableCatalog"

    ```scala
    loadTable(
      ident: Identifier): Table
    ```

    `loadTable` is part of the [TableCatalog](connector/catalog/TableCatalog.md#loadTable) abstraction.

`loadTable` creates a [V1Table](connector/V1Table.md) for a [table metadata](SessionCatalog.md#getTableMetadata) (from the [SessionCatalog](#catalog)).

## Loading Function { #loadFunction }

??? note "FunctionCatalog"

    ```scala
    loadFunction(
      ident: Identifier): UnboundFunction
    ```

    `loadFunction` is part of the [FunctionCatalog](connector/catalog/FunctionCatalog.md#loadFunction) abstraction.

`loadFunction`...FIXME

## Creating Table { #createTable }

??? note "FunctionCatalog"

    ```scala
    createTable(
      ident: Identifier,
      columns: Array[Column],
      partitions: Array[Transform],
      properties: Map[String, String]): Table
    createTable(
      ident: Identifier,
      schema: StructType,
      partitions: Array[Transform],
      properties: util.Map[String, String]): Table // (1)!
    ```

    1. Deprecated

    `createTable` is part of the [FunctionCatalog](connector/catalog/FunctionCatalog.md#createTable) abstraction.

`createTable` creates a [CatalogTable](CatalogTable.md) and requests the [SessionCatalog](#catalog) to [createTable](SessionCatalog.md#createTable) (with `ignoreIfExists` flag disabled so when the table already exists a `TableAlreadyExistsException` is reported).

In the end, `createTable` [loads the table](#loadTable).
