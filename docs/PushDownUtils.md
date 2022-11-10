# PushDownUtils

## <span id="pruneColumns"> pruneColumns

```scala
pruneColumns(
  scanBuilder: ScanBuilder,
  relation: DataSourceV2Relation,
  projects: Seq[NamedExpression],
  filters: Seq[Expression]): (Scan, Seq[AttributeReference])
```

`pruneColumns`...FIXME

---

`pruneColumns` is used when:

* [GroupBasedRowLevelOperationScanPlanning](logical-optimizations/GroupBasedRowLevelOperationScanPlanning.md) logical optimization is executed (to transform [ReplaceData](logical-operators/ReplaceData.md) logical operators over [DataSourceV2Relation](logical-operators/DataSourceV2Relation.md)s)
* [V2ScanRelationPushDown](logical-optimizations/V2ScanRelationPushDown.md) logical optimization is executed (to [pruneColumns](logical-optimizations/V2ScanRelationPushDown.md#pruneColumns) of `ScanBuilderHolder`s)

## <span id="pushFilters"> pushFilters

```scala
pushFilters(
  scanBuilder: ScanBuilder,
  filters: Seq[Expression]): (Either[Seq[sources.Filter], Seq[Predicate]], Seq[Expression])
```

`pushFilters`...FIXME

---

`pushFilters` is used when:

* [GroupBasedRowLevelOperationScanPlanning](logical-optimizations/GroupBasedRowLevelOperationScanPlanning.md) logical optimization is executed (to [pushFilters](logical-optimizations/GroupBasedRowLevelOperationScanPlanning.md#pushFilters))
* [V2ScanRelationPushDown](logical-optimizations/V2ScanRelationPushDown.md) logical optimization is executed (to [pushDownFilters](logical-optimizations/V2ScanRelationPushDown.md#pushDownFilters) to `ScanBuilderHolder`s)
