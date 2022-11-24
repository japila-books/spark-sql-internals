# CatalogColumnStat

## Creating Instance

`CatalogColumnStat` takes the following to be created:

* <span id="distinctCount"> Distinct Count (number of distinct values)
* <span id="min"> Minimum Value
* <span id="max"> Maximum Value
* <span id="nullCount"> Null Count (number of `null` values)
* <span id="avgLen"> Average length of the values (for fixed-length types, this should be a constant)
* <span id="maxLen"> Maximum length of the values (for fixed-length types, this should be a constant)
* <span id="histogram"> `Histogram`
* <span id="version"> 2

!!! note
    `CatalogColumnStat` uses the same input parameters as [ColumnStat](ColumnStat.md).

`CatalogColumnStat` is created when:

* `CatalogColumnStat` is requested to [fromMap](#fromMap)
* `ColumnStat` is requested to [toCatalogColumnStat](ColumnStat.md#toCatalogColumnStat)

## <span id="fromMap"> fromMap

```scala
fromMap(
  table: String,
  colName: String,
  map: Map[String, String]): Option[CatalogColumnStat]
```

`fromMap` creates a [CatalogColumnStat](#creating-instance) using the given `map` (with the `colName`-prefixed keys).

---

`fromMap` is used when:

* `HiveExternalCatalog` is requested to [statsFromProperties](../hive/HiveExternalCatalog.md#statsFromProperties)

## <span id="toPlanStat"> toPlanStat

```scala
toPlanStat(
  colName: String,
  dataType: DataType): ColumnStat
```

`toPlanStat` converts this `CatalogColumnStat` to a [ColumnStat](ColumnStat.md).

---

`toPlanStat` is used when:

* `CatalogStatistics` is requested to [toPlanStats](../CatalogStatistics.md#toPlanStats)
