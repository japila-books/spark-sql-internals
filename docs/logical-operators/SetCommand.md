---
title: SetCommand
---

# SetCommand Leaf Logical Command

`SetCommand` is a [leaf logical runnable command](LeafRunnableCommand.md) that represents the following SQL statements:

```sql
SET configKey (= .*?)?
SET .*?
SET configKey = configValue
SET .*? = configValue
SET TIME ZONE INTERVAL ...
SET TIME ZONE [ text | LOCAL ]
SET TIME ZONE .*?
```

## Creating Instance

`SetCommand` takes the following to be created:

* <span id="kv"> Key-value pair (optional)

`SetCommand` is created when:

* `SparkSqlAstBuilder` is requested to parse [visitSetConfiguration](../sql/SparkSqlAstBuilder.md#visitSetConfiguration), [visitSetQuotedConfiguration](../sql/SparkSqlAstBuilder.md#visitSetQuotedConfiguration), [visitSetTimeZone](../sql/SparkSqlAstBuilder.md#visitSetTimeZone) SQL statements
