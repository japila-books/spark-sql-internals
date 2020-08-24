title: BytesToBytesMap

# BytesToBytesMap Append-Only Hash Map

`BytesToBytesMap` is...FIXME

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

`safeLookup` is used when `BytesToBytesMap` does <<lookup, lookup>> and `UnsafeHashedRelation` for looking up a single [value](physical-operators/UnsafeHashedRelation.md#getValue) or [values](physical-operators/UnsafeHashedRelation.md#get) by key.
