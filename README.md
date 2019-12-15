# Running fully isolated PySpark application in YARN

This example project shows how to submit a PySpark application with complex dependencies
and code structure to a YARN cluster **without** manually installing stuff on the
workers. This is very useful when you want to share a cluster across different teams but
don't want to each team globally installing their own set of potentially conflicting
dependencies. At the same time you don't want to restrict the teams to a single set of
available packages.

The only requirement is that `spark-submit` is in your `PATH` and you already can call
it to send regular Spark scripts to YARN in `cluster` deploy mode.

## Overview

We'll use Miniconda and `conda-pack` to fully package an environment with dependencies
in a `build/environment.tar.gz` file and send to YARN using the `--archives` option.
This archive will be decompressed and symlinked to a relative `./environment` folder.

The `spark.yarn.appMasterEnv.PYSPARK_PYTHON` Spark configuration param allow us to
set the `PYSPARK_PYTHON` variable on the cluster driver/workers to instruct Spark to
use our packaged `./environment/bin/python` for Python stuff.

We'll use the same strategy to push custom Python modules. Everything we need is
packaged to `build/app.zip` and made available in a relative `./app` folder. A
top-level `run.py` file is the entrypoint to the Spark application.


## Tutorial

1. Install [Miniconda](https://docs.conda.io/en/latest/miniconda.html) if you need.
   [Follow the instructions](https://conda.io/projects/conda/en/latest/user-guide/install/index.html).

2. Create a new environment from the provided `environment.yaml` file

   ```
   $ cd conda_pyspark
   $ conda env create -n conda_pyspark -f environment.yml
   $ conda activate conda_pyspark
   ```

3. Run `./pack.sh` to create a `build/environment.tar.gz` file. During day to day
   development, you only need to call this if you change your dependencies.

4. Run `./submit.sh` to submit the application to the cluster.
   * This script packs the application files to the `app.zip`, so edit as needed.

