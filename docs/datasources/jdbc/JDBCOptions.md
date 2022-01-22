# JDBCOptions

`JDBCOptions` is the options of the [JDBC](index.md) data source.

## <span id="JDBC_BATCH_INSERT_SIZE"><span id="batchsize"> batchsize

## <span id="JDBC_CASCADE_TRUNCATE"><span id="cascadeTruncate"> cascadeTruncate

## <span id="JDBC_CREATE_TABLE_COLUMN_TYPES"><span id="createTableColumnTypes"> createTableColumnTypes

## <span id="JDBC_CREATE_TABLE_OPTIONS"><span id="createTableOptions"> createTableOptions

## <span id="JDBC_CUSTOM_DATAFRAME_COLUMN_TYPES"><span id="customSchema"> customSchema

## <span id="JDBC_TABLE_NAME"><span id="dbtable"> dbtable

## <span id="JDBC_DRIVER_CLASS"><span id="driver"> driver

## <span id="JDBC_BATCH_FETCH_SIZE"><span id="fetchsize"> fetchsize

## <span id="JDBC_TXN_ISOLATION_LEVEL"><span id="isolationLevel"> isolationLevel

## <span id="JDBC_KEYTAB"><span id="keytab"> keytab

## <span id="JDBC_LOWER_BOUND"><span id="lowerBound"> lowerBound

(only for reading) The lower bound of the [partitionColumn](#partitionColumn)

Must be smaller than the [upperBound](#upperBound)

Required with the [partitionColumn](#partitionColumn) defined

Used when:

* `DataFrameReader` is requested to [jdbc](../../DataFrameReader.md#jdbc) (and `JDBCRelation` utility is used to [determine partitions](JDBCRelation.md#columnPartition))

## <span id="JDBC_NUM_PARTITIONS"><span id="numPartitions"> numPartitions

The number of partitions for loading or saving data

Required with the [partitionColumn](#partitionColumn) defined

Only used when the difference between [upperBound](#upperBound) and [lowerBound](#lowerBound) is greater than or equal to this `numPartitions` option. [JDBCRelation](JDBCRelation.md#logging) prints out the following WARN message to the logs when it happens:

```text
The number of partitions is reduced because the specified number of partitions is less
than the difference between upper bound and lower bound.
Updated number of partitions: [difference];
Input number of partitions: [numPartitions];
Lower bound: [lowerBound];
Upper bound: [upperBound].
```

!!! tip
    Enable `INFO` logging level of the [JDBCRelation](JDBCRelation.md#logging) logger to see what happens under the covers.

Used when:

* `DataFrameReader` is requested to [jdbc](../../DataFrameReader.md#jdbc) (and `JDBCRelation` utility is used to [determine partitions](JDBCRelation.md#columnPartition))
* `JdbcUtils` is requested to `saveTable`

## <span id="JDBC_PARTITION_COLUMN"><span id="partitionColumn"> partitionColumn

The name of the column used to partition dataset (using a `JDBCPartitioningInfo`). The type of the column should be one of the following (or an `AnalysisException` is thrown):

* [DateType](../../types/AtomicType.md#DateType)
* [TimestampType](../../types/AtomicType.md#TimestampType)
* [NumericType](../../types/AtomicType.md#NumericType)

When specified, the other partitioned-reading properties are required:

* [lowerBound](#lowerBound)
* [upperBound](#upperBound)
* [numPartitions](#numPartitions)

Cannot be used with [query](#query) option

When undefined, the other partitioned-reading properties should not be defined:

* [lowerBound](#lowerBound)
* [upperBound](#upperBound)

Used when:

* `DataFrameReader` is requested to [jdbc](../../DataFrameReader.md#jdbc)

## <span id="JDBC_PRINCIPAL"><span id="principal"> principal

## <span id="JDBC_PUSHDOWN_AGGREGATE"><span id="pushDownAggregate"> pushDownAggregate

## <span id="JDBC_PUSHDOWN_PREDICATE"><span id="pushDownPredicate"> pushDownPredicate

## <span id="JDBC_QUERY_STRING"><span id="query"> query

## <span id="JDBC_QUERY_TIMEOUT"><span id="queryTimeout"> queryTimeout

## <span id="JDBC_REFRESH_KRB5_CONFIG"><span id="refreshKrb5Config"> refreshKrb5Config

## <span id="JDBC_SESSION_INIT_STATEMENT"><span id="sessionInitStatement"> sessionInitStatement

## <span id="JDBC_TABLE_COMMENT"><span id="tableComment"> tableComment

## <span id="JDBC_TRUNCATE"><span id="truncate"> truncate

## <span id="JDBC_UPPER_BOUND"><span id="upperBound"> upperBound

(only for reading) The upper bound of the [partitionColumn](#partitionColumn)

Required when the other properties are defined:

* [partitionColumn](#partitionColumn)
* [lowerBound](#lowerBound)
* [numPartitions](#numPartitions)

Must be larger than the [lowerBound](#lowerBound)

Used when:

* `DataFrameReader` is requested to [jdbc](../../DataFrameReader.md#jdbc) (and `JDBCRelation` utility is used to [determine partitions](JDBCRelation.md#columnPartition))

## <span id="JDBC_URL"><span id="url"> url

(**required**) A JDBC URL to use to connect to a database

## Creating Instance

`JDBCOptions` takes the following to be created:

* <span id="url"> URL
* <span id="table"> Table (corresponds to the [dbtable](#dbtable) option)
* <span id="parameters"> Configuration Parameters
