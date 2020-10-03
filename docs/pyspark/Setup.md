# PySpark Setup

## Install IPython

Follow the steps as described in the [official documentation](https://ipython.readthedocs.io/en/stable/install/install.html).

```text
pip install ipython
```

## Start PySpark

```bash
export PYSPARK_DRIVER_PYTHON=ipython
./bin/pyspark
```

PySpark will print out the following while starting up:

```text
$ ./bin/pyspark
Python 3.8.5 (default, Jul 21 2020, 10:48:26)
Type 'copyright', 'credits' or 'license' for more information
IPython 7.18.1 -- An enhanced Interactive Python. Type '?' for help.
20/10/03 21:58:52 WARN Utils: Your hostname, japila-new.local resolves to a loopback address: 127.0.0.1; using 192.168.1.7 instead (on interface en0)
20/10/03 21:58:52 WARN Utils: Set SPARK_LOCAL_IP if you need to bind to another address
20/10/03 21:58:52 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /__ / .__/\_,_/_/ /_/\_\   version 3.0.1
      /_/

Using Python version 3.8.5 (default, Jul 21 2020 10:48:26)
SparkSession available as 'spark'.

In [1]:
```

Type `spark.version` to make sure that all is set up correctly.

```text
In [1]: spark.version
Out[1]: '3.0.1'
```
