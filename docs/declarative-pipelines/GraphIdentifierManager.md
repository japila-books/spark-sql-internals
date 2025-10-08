---
title: GraphIdentifierManager
---

# GraphIdentifierManager Utility

## parseAndQualifyInputIdentifier { #parseAndQualifyInputIdentifier }

```scala
parseAndQualifyInputIdentifier(
  context: FlowAnalysisContext,
  rawInputName: String): DatasetIdentifier
```

`parseAndQualifyInputIdentifier`...FIXME

---

`parseAndQualifyInputIdentifier` is used when:

* `FlowAnalysis` is requested to [readBatchInput](#readBatchInput) and [readStreamInput](#readStreamInput)

### resolveDatasetReadInsideQueryDefinition { #resolveDatasetReadInsideQueryDefinition }

```scala
resolveDatasetReadInsideQueryDefinition(
  context: FlowAnalysisContext,
  rawInputName: String): DatasetIdentifier
```

`resolveDatasetReadInsideQueryDefinition`...FIXME
