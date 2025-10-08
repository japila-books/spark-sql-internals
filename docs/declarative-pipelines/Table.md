# Table

`Table` is a [TableInput](TableInput.md) and an [Output](Output.md).

## Load Data { #load }

??? note "Input"

    ```scala
    load(
      readOptions: InputReadOptions): DataFrame
    ```

    `load` is part of the [Input](Input.md#load) abstraction.

`load` is a "shortcut" to create a batch or a streaming `DataFrame` (based on the type of the given [InputReadOptions](InputReadOptions.md)).

For [StreamingReadOptions](InputReadOptions.md#StreamingReadOptions), `load` creates a `DataStreamReader` ([Spark Structured Streaming]({{ book.structured_streaming }}/DataStreamReader/)) to load a table (using `DataStreamReader.table` operator) with the given `StreamingReadOptions`.

For [BatchReadOptions](InputReadOptions.md#BatchReadOptions), `load` creates a [DataFrameReader](../DataFrameReader.md) to load a table (using `DataFrameReader.table` operator).
