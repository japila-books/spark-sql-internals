# JDBCOptions

`JDBCOptions` is the class with the options of the [JDBC](index.md) data source.

## <span id="JDBC_URL"><span id="url"> url

(**required**) A JDBC URL to use to connect to a database

## <span id="JDBC_TABLE_NAME"><span id="dbtable"> dbtable

## <span id="JDBC_QUERY_STRING"><span id="query"> query

## <span id="JDBC_DRIVER_CLASS"><span id="driver"> driver

## <span id="JDBC_PARTITION_COLUMN"><span id="partitionColumn"> partitionColumn

The name of the column used to partition dataset (using a `JDBCPartitioningInfo`)

When defined, the other partitioned-reading properties should also be defined:

* [lowerBound](#lowerBound)
* [upperBound](#upperBound)
* [numPartitions](#numPartitions)

Cannot be used with [query](#query) option

When undefined, the other partitioned-reading properties should not be defined:

* [lowerBound](#lowerBound)
* [upperBound](#upperBound)

Used when:

* `DataFrameReader` is requested to [jdbc](../../DataFrameReader.md#jdbc)

## <span id="JDBC_LOWER_BOUND"><span id="lowerBound"> lowerBound

## <span id="JDBC_UPPER_BOUND"><span id="upperBound"> upperBound

The upper bound of a [partitionColumn](#partitionColumn) for reading

Required when the other properties are defined:

* [partitionColumn](#partitionColumn)
* [lowerBound](#lowerBound)
* [numPartitions](#numPartitions)

Used when:

* `DataFrameReader` is requested to [jdbc](../../DataFrameReader.md#jdbc)

## <span id="JDBC_NUM_PARTITIONS"><span id="numPartitions"> numPartitions

## <span id="JDBC_QUERY_TIMEOUT"><span id="queryTimeout"> queryTimeout

## <span id="JDBC_BATCH_FETCH_SIZE"><span id="fetchsize"> fetchsize

## <span id="JDBC_TRUNCATE"><span id="truncate"> truncate

## <span id="JDBC_CASCADE_TRUNCATE"><span id="cascadeTruncate"> cascadeTruncate

## <span id="JDBC_CREATE_TABLE_OPTIONS"><span id="createTableOptions"> createTableOptions

## <span id="JDBC_CREATE_TABLE_COLUMN_TYPES"><span id="createTableColumnTypes"> createTableColumnTypes

## <span id="JDBC_CUSTOM_DATAFRAME_COLUMN_TYPES"><span id="customSchema"> customSchema

## <span id="JDBC_BATCH_INSERT_SIZE"><span id="batchsize"> batchsize

## <span id="JDBC_TXN_ISOLATION_LEVEL"><span id="isolationLevel"> isolationLevel

## <span id="JDBC_SESSION_INIT_STATEMENT"><span id="sessionInitStatement"> sessionInitStatement

## <span id="JDBC_KEYTAB"><span id="keytab"> keytab

## <span id="JDBC_PRINCIPAL"><span id="principal"> principal

## <span id="JDBC_PUSHDOWN_AGGREGATE"><span id="pushDownAggregate"> pushDownAggregate

## <span id="JDBC_PUSHDOWN_PREDICATE"><span id="pushDownPredicate"> pushDownPredicate

## <span id="JDBC_REFRESH_KRB5_CONFIG"><span id="refreshKrb5Config"> refreshKrb5Config

## <span id="JDBC_TABLE_COMMENT"><span id="tableComment"> tableComment

## Creating Instance

`JDBCOptions` takes the following to be created:

* <span id="url"> URL
* <span id="table"> Table (corresponds to the [dbtable](#dbtable) option)
* <span id="parameters"> Configuration Parameters

## Review Me

! batchsize
! `1000`
! [[batchsize]]

The minimum value is `1`

Used exclusively when `JdbcRelationProvider` is requested to [write the rows of a structured query (a DataFrame) to a table](JdbcRelationProvider.md#createRelation-CreatableRelationProvider) through `JdbcUtils` helper object and its <<spark-sql-JdbcUtils.md#saveTable, saveTable>>.

! createTableColumnTypes
!
! [[createTableColumnTypes]]

Used exclusively when `JdbcRelationProvider` is requested to [write the rows of a structured query (a DataFrame) to a table](JdbcRelationProvider.md#createRelation-CreatableRelationProvider) through `JdbcUtils` helper object and its <<spark-sql-JdbcUtils.md#createTable, createTable>>.

! `createTableOptions`
! Empty string
! [[createTableOptions]]

Used exclusively when `JdbcRelationProvider` is requested to [write the rows of a structured query (a DataFrame) to a table](JdbcRelationProvider.md#createRelation-CreatableRelationProvider) through `JdbcUtils` helper object and its <<spark-sql-JdbcUtils.md#createTable, createTable>>.

! `customSchema`
! (undefined)
a! [[customSchema]] Specifies the custom data types of the read schema (that is used at [load time](../../DataFrameReader.md#jdbc))

`customSchema` is a comma-separated list of field definitions with column names and their [DataType](../../types/DataType.md)s in a canonical SQL representation, e.g. `id DECIMAL(38, 0), name STRING`.

`customSchema` defines the data types of the columns that will override the data types inferred from the table schema and follows the following pattern:

```text
colTypeList
    : colType (',' colType)*
    ;

colType
    : identifier dataType (COMMENT STRING)?
    ;

dataType
    : complex=ARRAY '<' dataType '>'                            #complexDataType
    | complex=MAP '<' dataType ',' dataType '>'                 #complexDataType
    | complex=STRUCT ('<' complexColTypeList? '>' | NEQ)        #complexDataType
    | identifier ('(' INTEGER_VALUE (',' INTEGER_VALUE)* ')')?  #primitiveDataType
    ;
```

Used exclusively when `JDBCRelation` is requested for the <<datasources/jdbc/JDBCRelation.md#schema, schema>>.

! `dbtable`
!
a! [[dbtable]] (*required*)

Used when:

* `JDBCRDD` is requested to [resolveTable](JDBCRDD.md#resolveTable) (when `JDBCRelation` is requested for the <<datasources/jdbc/JDBCRelation.md#schema, schema>>) and <<datasources/jdbc/JDBCRelation.md#compute, compute a partition>>

* `JDBCRelation` is requested to <<datasources/jdbc/JDBCRelation.md#insert, insert or overwrite data>> and for the <<datasources/jdbc/JDBCRelation.md#toString, human-friendly text representation>>

* `JdbcRelationProvider` is requested to [write the rows of a structured query (a DataFrame) to a table](JdbcRelationProvider.md#createRelation-CreatableRelationProvider)

* `JdbcUtils` is requested to <<spark-sql-JdbcUtils.md#tableExists, tableExists>>, <<spark-sql-JdbcUtils.md#truncateTable, truncateTable>>, <<spark-sql-JdbcUtils.md#getSchemaOption, getSchemaOption>>, <<spark-sql-JdbcUtils.md#saveTable, saveTable>> and <<spark-sql-JdbcUtils.md#createTable, createTable>>

* `JDBCOptions` is <<creating-instance, created>> (with the input parameters for the <<url, url>> and <<dbtable, dbtable>> options)

* `DataFrameReader` is requested to [load data from external table using JDBC data source](../../DataFrameReader.md#jdbc) (using `DataFrameReader.jdbc` method with the input parameters for the <<url, url>> and <<dbtable, dbtable>> options)

! `driver`
!
a! [[driver]][[driverClass]] (*recommended*) Class name of the JDBC driver to use

Used exclusively when `JDBCOptions` is <<creating-instance, created>>. When the `driver` option is defined, the JDBC driver class will get registered with Java's https://docs.oracle.com/javase/8/docs/api/java/sql/DriverManager.html[java.sql.DriverManager].

NOTE: `driver` takes precedence over the class name of the driver for the <<url, url>> option.

After the JDBC driver class was registered, the driver class is used exclusively when `JdbcUtils` helper object is requested to <<spark-sql-JdbcUtils.md#createConnectionFactory, createConnectionFactory>>.

! `fetchsize`
! `0`
! [[fetchsize]] Hint to the JDBC driver as to the number of rows that should be fetched from the database when more rows are needed for `ResultSet` objects generated by a `Statement`

The minimum value is `0` (which tells the JDBC driver to do the estimates)

Used exclusively when `JDBCRDD` is requested to [compute a partition](JDBCRDD.md#compute).

! `isolationLevel`
! `READ_UNCOMMITTED`
a! [[isolationLevel]] One of the following:

* NONE
* READ_UNCOMMITTED
* READ_COMMITTED
* REPEATABLE_READ
* SERIALIZABLE

Used exclusively when `JdbcUtils` is requested to <<spark-sql-JdbcUtils.md#saveTable, saveTable>>.

! `lowerBound`
!
! [[lowerBound]] Lower bound of partition column

Used exclusively when `JdbcRelationProvider` is requested to [create a BaseRelation](JdbcRelationProvider.md#createRelation-RelationProvider) for reading

! `numPartitions`
!
a! [[numPartitions]] Number of partitions to use for loading or saving data

Used when:

* `JdbcRelationProvider` is requested to [loading data from a table using JDBC](JdbcRelationProvider.md#createRelation-RelationProvider)

* `JdbcUtils` is requested to <<spark-sql-JdbcUtils.md#saveTable, saveTable>>

! `truncate`
! `false`
! [[truncate]][[isTruncate]] (used only for writing) Enables table truncation

Used exclusively when `JdbcRelationProvider` is requested to [write the rows of a structured query (a DataFrame) to a table](JdbcRelationProvider.md#createRelation-CreatableRelationProvider)

! `sessionInitStatement`
!
! [[sessionInitStatement]] A generic SQL statement (or PL/SQL block) executed before reading a table/query

Used exclusively when `JDBCRDD` is requested to [compute a partition](JDBCRDD.md#compute).
|===
