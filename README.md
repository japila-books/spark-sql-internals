# The Internals of Spark SQL Online Book

[![Deploying to GitHub Pages](https://github.com/japila-books/spark-sql-internals/actions/workflows/deploying-to-github-pages.yml/badge.svg)](https://github.com/japila-books/spark-sql-internals/actions/workflows/deploying-to-github-pages.yml)

The project contains the sources of [The Internals of Spark SQL](https://books.japila.pl/spark-sql-internals/) online book.

## Local Preview

Use [just](https://just.systems/) to start [Zensical](https://zensical.org/)'s live-reload server (requires [uv](https://docs.astral.sh/uv/)):

```shell
just serve
```

Extra arguments are passed through to `zensical serve` (e.g., `just serve --open`).

Run `just` alone to list all available recipes.
