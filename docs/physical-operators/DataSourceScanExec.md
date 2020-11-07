# DataSourceScanExec -- Leaf Physical Operators to Scan Over BaseRelation

`DataSourceScanExec` is the <<contract, contract>> of <<implementations, leaf physical operators>> that represent scans over <<relation, BaseRelation>>.

NOTE: There are two <<implementations, DataSourceScanExecs>>, i.e. <<FileSourceScanExec, FileSourceScanExec>> and <<RowDataSourceScanExec, RowDataSourceScanExec>>, with a scan over data in [HadoopFsRelation](../HadoopFsRelation.md) and generic [BaseRelation](../spark-sql-BaseRelation.md) relations, respectively.

`DataSourceScanExec` supports [Java code generation](CodegenSupport.md) (aka _codegen_)

[[contract]]
[source, scala]
----
package org.apache.spark.sql.execution

trait DataSourceScanExec extends LeafExecNode with CodegenSupport {
  // only required vals and methods that have no implementation
  // the others follow
  def metadata: Map[String, String]
  val relation: BaseRelation
  val tableIdentifier: Option[TableIdentifier]
}
----

.(Subset of) DataSourceScanExec Contract
[cols="1,2",options="header",width="100%"]
|===
| Property
| Description

| `metadata`
| [[metadata]] Metadata (as a collection of key-value pairs) that describes the scan when requested for the <<simpleString, simple text representation>>.

| `relation`
| [[relation]] spark-sql-BaseRelation.md[BaseRelation] that is used in the <<nodeName, node name>> and...FIXME

| `tableIdentifier`
| [[tableIdentifier]] Optional `TableIdentifier`
|===

NOTE: The prefix for variable names for `DataSourceScanExec` operators in a [generated Java source code](CodegenSupport.md#variablePrefix) is **scan**.

[[nodeNamePrefix]]
The default *node name prefix* is an empty string (that is used in the <<simpleString, simple node description>>).

[[nodeName]]
`DataSourceScanExec` uses the <<relation, BaseRelation>> and the <<tableIdentifier, TableIdentifier>> as the *node name* in the following format:

```
Scan [relation] [tableIdentifier]
```

[[implementations]]
.DataSourceScanExecs
[width="100%",cols="1,2",options="header"]
|===
| DataSourceScanExec
| Description

| FileSourceScanExec.md[FileSourceScanExec]
| [[FileSourceScanExec]]

| RowDataSourceScanExec.md[RowDataSourceScanExec]
| [[RowDataSourceScanExec]]
|===

=== [[simpleString]] Simple (Basic) Text Node Description (in Query Plan Tree) -- `simpleString` Method

[source, scala]
----
simpleString: String
----

NOTE: `simpleString` is part of catalyst/QueryPlan.md#simpleString[QueryPlan Contract] to give the simple text description of a `TreeNode` in a query plan tree.

`simpleString` creates a text representation of every key-value entry in the <<metadata, metadata>>...FIXME

Internally, `simpleString` sorts the <<metadata, metadata>> and concatenate the keys and the values (separated by the `: `). While doing so, `simpleString` <<redact, redacts sensitive information>> in every value and abbreviates it to the first 100 characters.

`simpleString` uses Spark Core's `Utils` to `truncatedString`.

In the end, `simpleString` returns a text representation that is made up of the <<nodeNamePrefix, nodeNamePrefix>>, the <<nodeName, nodeName>>, the catalyst/QueryPlan.md#output[output] (schema attributes) and the <<metadata, metadata>> and is of the following format:

```
[nodeNamePrefix][nodeName][[output]][metadata]
```

[source, scala]
----
val scanExec = basicDataSourceScanExec
scala> println(scanExec.simpleString)
Scan $line143.$read$$iw$$iw$$iw$$iw$$iw$$iw$$iw$$iw$$anon$1@57d94b26 [] PushedFilters: [], ReadSchema: struct<>

def basicDataSourceScanExec = {
  import org.apache.spark.sql.catalyst.expressions.AttributeReference
  val output = Seq.empty[AttributeReference]
  val requiredColumnsIndex = output.indices
  import org.apache.spark.sql.sources.Filter
  val filters, handledFilters = Set.empty[Filter]
  import org.apache.spark.sql.catalyst.InternalRow
  import org.apache.spark.sql.catalyst.expressions.UnsafeRow
  val row: InternalRow = new UnsafeRow(0)
  val rdd: RDD[InternalRow] = sc.parallelize(row :: Nil)

  import org.apache.spark.sql.sources.{BaseRelation, TableScan}
  val baseRelation: BaseRelation = new BaseRelation with TableScan {
    import org.apache.spark.sql.SQLContext
    val sqlContext: SQLContext = spark.sqlContext

    import org.apache.spark.sql.types.StructType
    val schema: StructType = new StructType()

    import org.apache.spark.rdd.RDD
    import org.apache.spark.sql.Row
    def buildScan(): RDD[Row] = ???
  }

  val tableIdentifier = None
  import org.apache.spark.sql.execution.RowDataSourceScanExec
  RowDataSourceScanExec(
    output, requiredColumnsIndex, filters, handledFilters, rdd, baseRelation, tableIdentifier)
}
----

=== [[verboseString]] `verboseString` Method

[source, scala]
----
verboseString: String
----

NOTE: `verboseString` is part of catalyst/QueryPlan.md#verboseString[QueryPlan Contract] to...FIXME.

`verboseString` simply returns the <<redact, redacted sensitive information>> in catalyst/QueryPlan.md#verboseString[verboseString] (of the parent `QueryPlan`).

## <span id="treeString"> Text Representation of All Nodes in Tree

```scala
treeString(
  verbose: Boolean,
  addSuffix: Boolean): String
```

`treeString` simply returns the <<redact, redacted sensitive information>> in the [text representation of all nodes (in query plan tree)](../catalyst/TreeNode.md#treeString) (of the parent `TreeNode`).

`treeString` is part of the [TreeNode](../catalyst/TreeNode.md#treeString) abstraction.

=== [[redact]] Redacting Sensitive Information -- `redact` Internal Method

[source, scala]
----
redact(text: String): String
----

`redact`...FIXME

NOTE: `redact` is used when `DataSourceScanExec` is requested for the <<simpleString, simple>>, <<verboseString, verbose>> and <<treeString, tree>> text representations.
