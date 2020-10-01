# DataSourceRegister &mdash; Registering Data Source Format

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

=== Data Source Format Discovery -- Registering Data Source By Short Name (Alias)

CAUTION: FIXME Describe how Java's ++https://docs.oracle.com/javase/8/docs/api/java/util/ServiceLoader.html#load-java.lang.Class-java.lang.ClassLoader-++[ServiceLoader] works to find all spark-sql-DataSourceRegister.md[DataSourceRegister] provider classes on the CLASSPATH.

Any `DataSourceRegister` has to register itself in `META-INF/services/org.apache.spark.sql.sources.DataSourceRegister` file to...FIXME
