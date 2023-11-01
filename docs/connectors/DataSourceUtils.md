# DataSourceUtils

## checkFieldNames { #checkFieldNames }

```scala
checkFieldNames(
  format: FileFormat,
  schema: StructType): Unit
```

??? warning "Procedure"
    `checkFieldNames` is a procedure (returns `Unit`) so _what happens inside stays inside_ (paraphrasing the [former advertising slogan of Las Vegas, Nevada](https://idioms.thefreedictionary.com/what+happens+in+Vegas+stays+in+Vegas)).

`checkFieldNames`...FIXME

---

`checkFieldNames` is used when:

* `DDLUtils` is requested to [checkDataColNames](DDLUtils.md#checkDataColNames)
* `FileFormatWriter` is requested to [write data out](FileFormatWriter.md#write)
