# SystemMetadata

## getLatestCheckpointDir { #getLatestCheckpointDir }

```scala
getLatestCheckpointDir(
  rootDir: Path,
  createNewCheckpointDir: Boolean = false): String
```

`getLatestCheckpointDir`...FIXME

---

`getLatestCheckpointDir` is used when:

* `FlowSystemMetadata` is requested to [get the latest checkpoint location](FlowSystemMetadata.md#latestCheckpointLocation) and [get the latest checkpoint location if available](#latestCheckpointLocationOpt)
