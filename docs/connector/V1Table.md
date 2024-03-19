# V1Table

`V1Table` is a [Table](Table.md) that acts as an adapter to expose [v1 table metadata](#v1Table) ([CatalogTable](../CatalogTable.md)).

## Creating Instance

`V1Table` takes the following to be created:

* <span id="v1Table"> [v1 Table Metadata](../CatalogTable.md)

`V1Table` is created when:

* `V2SessionCatalog` is requested to [load a table](../V2SessionCatalog.md#loadTable)

## String Representation { #toString }

`toString` is the following string (with the [name](#name)):

```text
V1Table([name])
```
