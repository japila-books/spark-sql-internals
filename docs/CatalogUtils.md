# CatalogUtils

## <span id="normalizeBucketSpec"> Normalizing BucketSpec

```scala
normalizeBucketSpec(
  tableName: String,
  tableCols: Seq[String],
  bucketSpec: BucketSpec,
  resolver: Resolver): BucketSpec
```

`normalizeBucketSpec`...FIXME

---

`normalizeBucketSpec` is used when:

* [PreprocessTableCreation](logical-analysis-rules/PreprocessTableCreation.md) logical analysis rule is executed (on a bucketed table while appending data to a [CreateTable](logical-operators/CreateTable.md))
