# The Internals of Spark SQL

The project contains the sources of [The Internals of Spark SQL](https://the-internals-of-spark-sql.readthedocs.io/) online book.

## Tools

The project is based on or uses the following tools:

* [Apache Spark](https://spark.apache.org/) with [Spark SQL](http://spark.apache.org/sql/)

* [MkDocs](https://www.mkdocs.org/) which strives for being _a fast, simple and downright gorgeous static site generator that's geared towards building project documentation_

* [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme

* [Read the Docs](https://readthedocs.org/) for deploying the online book

* [Atom editor](https://atom.io/)

* [Docker](https://www.docker.com/) to [run the Material for MkDocs](https://squidfunk.github.io/mkdocs-material/getting-started/#with-docker-recommended) (with plugins and extensions)

## Previewing Book

Simply use the [official Docker image](https://squidfunk.github.io/mkdocs-material/getting-started/#with-docker-recommended) to get up and running with the above tools.

Start `mkdocs serve` in the project root (the folder with [mkdocs.yml](mkdocs.yml)) as follows:

```
$ docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material
```

Consult the [MkDocs documentation](https://www.mkdocs.org/#getting-started) to get started and learn how to [build the project](https://www.mkdocs.org/#building-the-site).

```
$ docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material --help
Usage: mkdocs [OPTIONS] COMMAND [ARGS]...

  MkDocs - Project documentation with Markdown.

Options:
  -V, --version  Show the version and exit.
  -q, --quiet    Silence warnings
  -v, --verbose  Enable verbose output
  -h, --help     Show this message and exit.

Commands:
  build      Build the MkDocs documentation
  gh-deploy  Deploy your documentation to GitHub Pages
  new        Create a new MkDocs project
  serve      Run the builtin development server
```

Use `mkdocs build --clean` to remove any stale files.

## No Sphinx?! Why?

Read [Giving up on Read the Docs, reStructuredText and Sphinx](https://medium.com/@jaceklaskowski/giving-up-on-read-the-docs-restructuredtext-and-sphinx-674961804641).
