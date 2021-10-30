# DataSourceRegister

`DataSourceRegister` is an [abstraction](#contract) of data sources to be available under [shortName](#shortName) alias (so it can be [looked up](DataSource.md#lookupDataSource) by the alias not a fully-qualified class name)

## Contract

### <span id="shortName"> Short Name

```scala
shortName(): String
```

Short name (_alias_) of the data source

Used when:

* `DataSource` utility is used to [lookup a data source](DataSource.md#lookupDataSource)

## Data Source Discovery

`DataSourceRegister` should register itself in `META-INF/services/org.apache.spark.sql.sources.DataSourceRegister` file for Java's [ServiceLoader]({{ java.api }}/java/util/ServiceLoader.html#load(java.lang.Class,java.lang.ClassLoader)) to discover the service.
