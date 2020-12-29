# DataSourceRegister

[[shortName]]
`DataSourceRegister` is a <<contract, contract>> to register a [DataSource](DataSource.md) provider under `shortName` alias (so it can be [looked up](DataSource.md#lookupDataSource) by the alias not its fully-qualified class name).

[[contract]]
[source, scala]
----
package org.apache.spark.sql.sources

trait DataSourceRegister {
  def shortName(): String
}
----

## Data Source Format Discovery -- Registering Data Source By Short Name (Alias)

!!! important
    FIXME Describe how Java's [ServiceLoader]({{ java.api }}/java/util/ServiceLoader.html#load-java.lang.Class-java.lang.ClassLoader-) works to find all [DataSourceRegister](DataSourceRegister.md) provider classes on the CLASSPATH.

Any `DataSourceRegister` has to register itself in `META-INF/services/org.apache.spark.sql.sources.DataSourceRegister` file to...FIXME
