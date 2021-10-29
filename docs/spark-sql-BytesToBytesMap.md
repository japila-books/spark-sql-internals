# BytesToBytesMap Append-Only Hash Map

* Low space overhead,
* Good memory locality, esp. for scans.

=== [[lookup]] `lookup` Method

[source, java]
----
Location lookup(Object keyBase, long keyOffset, int keyLength)
Location lookup(Object keyBase, long keyOffset, int keyLength, int hash)
----

CAUTION: FIXME

=== [[safeLookup]] `safeLookup` Method

[source, java]
----
void safeLookup(Object keyBase, long keyOffset, int keyLength, Location loc, int hash)
----

`safeLookup`...FIXME

`safeLookup` is used when `BytesToBytesMap` does <<lookup, lookup>> and `UnsafeHashedRelation` for looking up a single `value` or `values` by key.
