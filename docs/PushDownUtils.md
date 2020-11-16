# PushDownUtils Utility

## <span id="pushFilters"> pushFilters

```scala
pushFilters(
  scanBuilder: ScanBuilder,
  filters: Seq[Expression]): (Seq[sources.Filter], Seq[Expression])
```

`pushFilters`...FIXME

`pushFilters` is used when [V2ScanRelationPushDown](logical-optimizations/V2ScanRelationPushDown.md) logical optimization is executed.
