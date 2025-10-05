# GraphElementTypeUtils

## getDatasetTypeForMaterializedViewOrStreamingTable { #getDatasetTypeForMaterializedViewOrStreamingTable }

```scala
getDatasetTypeForMaterializedViewOrStreamingTable(
  flowsToTable: Seq[ResolvedFlow]): DatasetType
```

`getDatasetTypeForMaterializedViewOrStreamingTable`...FIXME

---

`getDatasetTypeForMaterializedViewOrStreamingTable` is used when:

* `GraphValidations` is requested to [validateUserSpecifiedSchemas](GraphValidations.md#validateUserSpecifiedSchemas)
* `SchemaInferenceUtils` is requested to [inferSchemaFromFlows](SchemaInferenceUtils.md#inferSchemaFromFlows)
