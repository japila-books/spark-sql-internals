# Default Columns :material-new-box:{ title="New in 3.4.0" }

[Apache Spark 3.4](https://issues.apache.org/jira/browse/SPARK-38334) introduces support for `DEFAULT` columns in the following SQL statements:

* `ALTER TABLE ADD (COLUMN | COLUMNS)`
* `ALTER TABLE REPLACE COLUMNS`
* `CREATE TABLE`
* `(CREATE OR)? REPLACE TABLE`

**Default Columns** are columns defined with `DEFAULT` clause.

```antlr
defaultExpression
    : DEFAULT expression
    ;

colDefinitionOption
    : NOT NULL
    | defaultExpression
    | generationExpression
    | commentSpec
    ;

createOrReplaceTableColType
    : colName dataType colDefinitionOption*
    ;

qualifiedColTypeWithPosition
    : multipartIdentifier dataType (NOT NULL)? defaultExpression? commentSpec? colPosition?
    ;
```

Default Columns are enabled using [spark.sql.defaultColumn.enabled](../configuration-properties.md#spark.sql.defaultColumn.enabled) configuration property.

With DEFAULT columns, `INSERT`, `UPDATE`, `MERGE` statements can reference the value using the `DEFAULT` keyword.

```sql
CREATE TABLE T(a INT, b INT NOT NULL);

-- The default default is NULL
INSERT INTO T VALUES (DEFAULT, 0);
INSERT INTO T(b)  VALUES (1);
SELECT * FROM T;
(NULL, 0)
(NULL, 1)

-- Adding a default to a table with rows, sets the values for the
-- existing rows (exist default) and new rows (current default).
ALTER TABLE T ADD COLUMN c INT DEFAULT 5;
INSERT INTO T VALUES (1, 2, DEFAULT);
SELECT * FROM T;
(NULL, 0, 5)
(NULL, 1, 5)
(1, 2, 5)
```

Default Columns uses the following configuration properties:

* [spark.sql.defaultColumn.allowedProviders](../configuration-properties.md#spark.sql.defaultColumn.allowedProviders)
* [spark.sql.defaultColumn.useNullsForMissingDefaultValues](../configuration-properties.md#spark.sql.defaultColumn.useNullsForMissingDefaultValues)
* [spark.sql.jsonGenerator.writeNullIfWithDefaultValue](../configuration-properties.md#spark.sql.jsonGenerator.writeNullIfWithDefaultValue)

Default Columns are resolved using [ResolveDefaultColumns](../logical-analysis-rules/ResolveDefaultColumns.md) logical resolution rule.
