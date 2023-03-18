# V2SessionCatalog

`V2SessionCatalog` is the [default session catalog](connector/catalog/CatalogManager.md#defaultSessionCatalog) of [CatalogManager](connector/catalog/CatalogManager.md).

`V2SessionCatalog` is a [TableCatalog](connector/catalog/TableCatalog.md) and a [SupportsNamespaces](connector/catalog/SupportsNamespaces.md).

## Creating Instance

`V2SessionCatalog` takes the following to be created:

* <span id="catalog"> [SessionCatalog](SessionCatalog.md)
* <span id="conf"> [SQLConf](SQLConf.md)

`V2SessionCatalog` is created when `BaseSessionStateBuilder` is requested for [one](BaseSessionStateBuilder.md#v2SessionCatalog).

## <span id="defaultNamespace"> Default Namespace

```scala
defaultNamespace: Array[String]
```

The default namespace of `V2SessionCatalog` is **default**.

`defaultNamespace` is part of the [CatalogPlugin](connector/catalog/CatalogPlugin.md#defaultNamespace) abstraction.

## Name

??? note "Signature"

    ```scala
    name: String
    ```

    `name` is part of the [CatalogPlugin](connector/catalog/CatalogPlugin.md#name) abstraction.

The name of `V2SessionCatalog` is [spark_catalog](connector/catalog/CatalogManager.md#SESSION_CATALOG_NAME).

## <span id="loadTable"> Loading Table

??? note "Signature"

    ```scala
    loadTable(
      ident: Identifier): Table
    ```

    `loadTable` is part of the [TableCatalog](connector/catalog/TableCatalog.md#loadTable) abstraction.

`loadTable` creates a [V1Table](connector/V1Table.md) for a [table metadata](SessionCatalog.md#getTableMetadata) (from the [SessionCatalog](#catalog)).

## <span id="loadFunction"> Loading Function

??? note "Signature"

    ```scala
    loadFunction(
      ident: Identifier): UnboundFunction
    ```

    `loadFunction` is part of the [FunctionCatalog](connector/catalog/FunctionCatalog.md#loadFunction) abstraction.

`loadFunction`...FIXME

## <span id="createTable"> Creating Table

??? note "Signature"

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
