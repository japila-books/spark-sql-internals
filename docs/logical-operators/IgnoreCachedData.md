# IgnoreCachedData Logical Operators

`IgnoreCachedData` is a marker interface for [logical operators](LogicalPlan.md) that should be skipped (_ignored_) by [CacheManager](../CacheManager.md) (while [replacing segments of a logical query with cached data](../CacheManager.md#useCachedData)).

## Implementations

* [ClearCacheCommand](ClearCacheCommand.md)
* `ResetCommand`
