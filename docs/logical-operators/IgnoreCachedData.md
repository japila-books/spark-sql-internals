# IgnoreCachedData Logical Operators

`IgnoreCachedData` is a marker interface for [logical operators](LogicalPlan.md) that are not interested in cached data in [CacheManager](../CacheManager.md) (so they should be skipped while [replacing segments of a logical query with cached data](../CacheManager.md#useCachedData)).

## Implementations

* [ClearCacheCommand](ClearCacheCommand.md)
* `ResetCommand`
